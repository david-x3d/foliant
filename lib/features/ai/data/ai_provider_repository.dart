import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/local/app_database.dart';

class AiProviderConfig {
  const AiProviderConfig({
    this.displayName = 'OpenAI-kompatibel',
    this.baseUrl = 'https://api.openai.com/v1',
    this.model = 'gpt-4o-mini',
    this.apiVersion = '',
    this.extraHeaders = '{}',
    this.orgId = '',
    this.projectId = '',
  });

  final String displayName;
  final String baseUrl;
  final String model;
  final String apiVersion;
  final String extraHeaders;
  final String orgId;
  final String projectId;

  AiProviderConfig copyWith({
    String? displayName,
    String? baseUrl,
    String? model,
    String? apiVersion,
    String? extraHeaders,
    String? orgId,
    String? projectId,
  }) => AiProviderConfig(
    displayName: displayName ?? this.displayName,
    baseUrl: baseUrl ?? this.baseUrl,
    model: model ?? this.model,
    apiVersion: apiVersion ?? this.apiVersion,
    extraHeaders: extraHeaders ?? this.extraHeaders,
    orgId: orgId ?? this.orgId,
    projectId: projectId ?? this.projectId,
  );
}

class AiProviderRepository {
  static const _secure = FlutterSecureStorage();
  static const _keyName = 'ai.apiKey';

  Future<AiProviderConfig> load() async {
    final p = await SharedPreferences.getInstance();
    return AiProviderConfig(
      displayName: p.getString('ai.displayName') ?? 'OpenAI-kompatibel',
      baseUrl: p.getString('ai.baseUrl') ?? 'https://api.openai.com/v1',
      model: p.getString('ai.model') ?? 'gpt-4o-mini',
      apiVersion: p.getString('ai.apiVersion') ?? '',
      extraHeaders: p.getString('ai.extraHeaders') ?? '{}',
      orgId: p.getString('ai.orgId') ?? '',
      projectId: p.getString('ai.projectId') ?? '',
    );
  }

  Future<void> save(AiProviderConfig config, {String? apiKey}) async {
    final p = await SharedPreferences.getInstance();
    await Future.wait([
      p.setString('ai.displayName', config.displayName),
      p.setString('ai.baseUrl', config.baseUrl),
      p.setString('ai.model', config.model),
      p.setString('ai.apiVersion', config.apiVersion),
      p.setString('ai.extraHeaders', config.extraHeaders),
      p.setString('ai.orgId', config.orgId),
      p.setString('ai.projectId', config.projectId),
    ]);
    if (apiKey != null) {
      if (apiKey.trim().isEmpty) {
        await _secure.delete(key: _keyName);
      } else {
        await _secure.write(key: _keyName, value: apiKey.trim());
      }
    }
  }

  Future<String?> readApiKey() => _secure.read(key: _keyName);
  Future<bool> hasApiKey() async => (await readApiKey())?.isNotEmpty == true;
}

class AiCallException implements Exception {
  const AiCallException(this.kind, this.message);
  final AiErrorKind kind;
  final String message;
  @override
  String toString() => message;
}

enum AiErrorKind {
  noKey,
  invalidKey,
  rateLimit,
  network,
  invalidResponse,
  unknown,
}

class AiClient {
  AiClient(this.repository, {Dio? dio}) : _dio = dio ?? Dio();

  final AiProviderRepository repository;
  final Dio _dio;

  Future<String> testConnection() async {
    final config = await repository.load();
    final response = await _chat(
      config: config,
      messages: const [
        {'role': 'system', 'content': 'Antworte nur mit dem Wort OK.'},
        {'role': 'user', 'content': 'Verbindungstest'},
      ],
      jsonMode: false,
      maxTokens: 8,
    );
    return response.trim();
  }

  Future<List<ImportPair>> extractPairs({
    required String text,
    required String sourceLang,
    required String targetLang,
    required String direction,
  }) async {
    final config = await repository.load();
    final content = await _chat(
      config: config,
      messages: [
        {
          'role': 'system',
          'content':
              '''Du extrahierst ausschlieÃŸlich Vokabelpaare aus vom Nutzer bereitgestelltem Text. Erfinde nichts. Wenn eine Ãœbersetzung fehlt und aus dem Text nicht sicher ableitbar ist, lasse das Item weg. Antworte als JSON exakt im Schema {"source_lang":"$sourceLang","target_lang":"$targetLang","direction":"$direction","items":[{"source":"...","target":"...","example_source":null,"example_target":null,"notes":null,"confidence":0.0}]}. confidence 0..1.''',
        },
        {'role': 'user', 'content': text},
      ],
      jsonMode: true,
      maxTokens: 1800,
    );
    try {
      final decoded = jsonDecode(content) as Map<String, dynamic>;
      final raw = (decoded['items'] as List<dynamic>? ?? const []);
      return raw
          .map((entry) {
            final item = entry as Map<String, dynamic>;
            return ImportPair(
              source: item['source']?.toString() ?? '',
              target: item['target']?.toString() ?? '',
              exampleSource: item['example_source']?.toString(),
              exampleTarget: item['example_target']?.toString(),
              notes: item['notes']?.toString(),
              confidence: (item['confidence'] as num?)?.toDouble() ?? .5,
            );
          })
          .where((item) => item.source.isNotEmpty && item.target.isNotEmpty)
          .toList();
    } catch (_) {
      throw const AiCallException(
        AiErrorKind.invalidResponse,
        'UngÃ¼ltige JSON-Antwort des Anbieters.',
      );
    }
  }

  Future<String> _chat({
    required AiProviderConfig config,
    required List<Map<String, String>> messages,
    required bool jsonMode,
    required int maxTokens,
  }) async {
    final key = await repository.readApiKey();
    if (key == null || key.isEmpty) {
      throw const AiCallException(
        AiErrorKind.noKey,
        'Kein API-Key gespeichert.',
      );
    }

    if (_isGoogleGemini(config)) {
      return _googleGeminiChat(
        config: config,
        key: key,
        messages: messages,
        jsonMode: jsonMode,
        maxTokens: maxTokens,
      );
    }

    final headers = <String, dynamic>{'Authorization': 'Bearer $key'};
    if (config.orgId.trim().isNotEmpty) {
      headers['OpenAI-Organization'] = config.orgId.trim();
    }
    if (config.projectId.trim().isNotEmpty) {
      headers['OpenAI-Project'] = config.projectId.trim();
    }
    if (config.apiVersion.trim().isNotEmpty) {
      headers['api-version'] = config.apiVersion.trim();
    }
    try {
      final extra = jsonDecode(
        config.extraHeaders.trim().isEmpty ? '{}' : config.extraHeaders,
      );
      if (extra is Map<String, dynamic>) headers.addAll(extra);
    } catch (_) {
      throw const AiCallException(
        AiErrorKind.invalidResponse,
        'Extra-Header mÃ¼ssen gÃ¼ltiges JSON sein.',
      );
    }

    final url =
        '${config.baseUrl.replaceAll(RegExp(r'/+$'), '')}/chat/completions';
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        url,
        options: Options(
          headers: headers,
          sendTimeout: const Duration(seconds: 25),
          receiveTimeout: const Duration(seconds: 45),
        ),
        data: {
          'model': config.model,
          'messages': messages,
          'max_tokens': maxTokens,
          if (jsonMode) 'response_format': {'type': 'json_object'},
        },
      );
      final data = response.data;
      final choices = data?['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) {
        throw const AiCallException(
          AiErrorKind.invalidResponse,
          'Leere Antwort des Anbieters.',
        );
      }
      final first = choices.first as Map<String, dynamic>;
      final message = first['message'] as Map<String, dynamic>?;
      final content = message?['content']?.toString();
      if (content == null || content.isEmpty) {
        throw const AiCallException(
          AiErrorKind.invalidResponse,
          'Antwort enthielt keinen Text.',
        );
      }
      return content;
    } on DioException catch (error) {
      final code = error.response?.statusCode;
      if (code == 401 || code == 403) {
        throw const AiCallException(
          AiErrorKind.invalidKey,
          'API-Key abgelehnt.',
        );
      }
      if (code == 429) {
        throw const AiCallException(
          AiErrorKind.rateLimit,
          'Rate Limit erreicht.',
        );
      }
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout) {
        throw const AiCallException(
          AiErrorKind.network,
          'Keine Verbindung zum Anbieter.',
        );
      }
      throw AiCallException(
        AiErrorKind.unknown,
        'API-Fehler${code == null ? '' : ' ($code)'}.',
      );
    }
  }
  bool _isGoogleGemini(AiProviderConfig config) {
    final base = config.baseUrl.toLowerCase();
    return base.contains('generativelanguage.googleapis.com');
  }

  Future<String> _googleGeminiChat({
    required AiProviderConfig config,
    required String key,
    required List<Map<String, String>> messages,
    required bool jsonMode,
    required int maxTokens,
  }) async {
    final base = config.baseUrl.replaceAll(RegExp(r'/+$'), '');
    final modelName = config.model.trim().replaceFirst(RegExp(r'^models/'), '');
    final url = '$base/models/$modelName:generateContent';

    final systemParts = messages
        .where((message) => message['role'] == 'system')
        .map((message) => {'text': message['content'] ?? ''})
        .toList();
    final contents = messages
        .where((message) => message['role'] != 'system')
        .map(
          (message) => {
            'role': message['role'] == 'assistant' ? 'model' : 'user',
            'parts': [
              {'text': message['content'] ?? ''},
            ],
          },
        )
        .toList();

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': key,
          },
          sendTimeout: const Duration(seconds: 25),
          receiveTimeout: const Duration(seconds: 45),
        ),
        data: {
          if (systemParts.isNotEmpty) 'systemInstruction': {'parts': systemParts},
          'contents': contents,
          'generationConfig': {
            'maxOutputTokens': maxTokens,
            if (jsonMode) 'responseMimeType': 'application/json',
          },
        },
      );
      final candidates = response.data?['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        throw const AiCallException(
          AiErrorKind.invalidResponse,
          'Leere Antwort von Google Gemini.',
        );
      }
      final first = candidates.first as Map<String, dynamic>;
      final content = first['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List<dynamic>?;
      final text = parts
          ?.whereType<Map<String, dynamic>>()
          .map((part) => part['text']?.toString() ?? '')
          .join()
          .trim();
      if (text == null || text.isEmpty) {
        throw const AiCallException(
          AiErrorKind.invalidResponse,
          'Google Gemini lieferte keinen Text.',
        );
      }
      return text;
    } on DioException catch (error) {
      final code = error.response?.statusCode;
      if (code == 400 || code == 401 || code == 403) {
        throw const AiCallException(
          AiErrorKind.invalidKey,
          'Google API-Key oder Anfrage wurde abgelehnt.',
        );
      }
      if (code == 429) {
        throw const AiCallException(
          AiErrorKind.rateLimit,
          'Google Gemini Rate Limit erreicht.',
        );
      }
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout) {
        throw const AiCallException(
          AiErrorKind.network,
          'Keine Verbindung zu Google Gemini.',
        );
      }
      throw AiCallException(
        AiErrorKind.unknown,
        'Google Gemini API-Fehler${code == null ? '' : ' ($code)'}.',
      );
    }
  }
}

