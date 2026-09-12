import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/local/app_database.dart';

enum AiEndpoint { openAi, gemini }

class AiProviderConfig {
  const AiProviderConfig({
    this.endpoint = AiEndpoint.openAi,
    this.baseUrl = 'https://api.openai.com/v1',
    this.model = 'gpt-4o-mini',
  });

  final AiEndpoint endpoint;
  final String baseUrl;
  final String model;

  String? get validationError {
    final uri = Uri.tryParse(baseUrl.trim());
    if (uri == null ||
        !['http', 'https'].contains(uri.scheme) ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      return 'Bitte eine gültige HTTP(S)-URL ohne Schlüssel oder URL-Parameter eingeben.';
    }
    final name = model.trim().replaceFirst(RegExp(r'^models/'), '');
    if (name.isEmpty) return 'Bitte ein Modell eingeben.';
    if (endpoint == AiEndpoint.gemini &&
        !RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(name)) {
      return 'Bitte eine gültige Gemini-Modell-ID eingeben.';
    }
    return null;
  }

  Uri get requestUri {
    final uri = Uri.parse(baseUrl.trim());
    var path = uri.path.replaceAll(RegExp(r'/+$'), '');
    if (endpoint == AiEndpoint.gemini) {
      // Accept base and full URLs; the model field remains authoritative.
      path = path.replaceFirst(
        RegExp(r'/models(?:/[^/]+:generateContent)?$'),
        '',
      );
      if (path.isEmpty) path = '/v1beta';
      final name = model.trim().replaceFirst(RegExp(r'^models/'), '');
      path = '$path/models/$name:generateContent';
    } else if (!path.endsWith('/chat/completions')) {
      path = '$path/chat/completions';
    }
    return uri.replace(path: path);
  }
}

class AiProviderRepository {
  static const _secure = FlutterSecureStorage();
  static const _keyName = 'ai.apiKey';

  Future<AiProviderConfig> load() async {
    final p = await SharedPreferences.getInstance();
    final baseUrl = p.getString('ai.baseUrl') ?? 'https://api.openai.com/v1';
    final savedEndpoint = p.getString('ai.endpoint');
    // Preserve Gemini configurations from 0.1.0 without asking for the key again.
    final nativeGemini =
        Uri.tryParse(baseUrl)?.host == 'generativelanguage.googleapis.com' &&
        !baseUrl.contains('/openai');
    return AiProviderConfig(
      endpoint:
          savedEndpoint == 'gemini' || (savedEndpoint == null && nativeGemini)
          ? AiEndpoint.gemini
          : AiEndpoint.openAi,
      baseUrl: baseUrl,
      model: p.getString('ai.model') ?? 'gpt-4o-mini',
    );
  }

  Future<void> save(AiProviderConfig config, {String? apiKey}) async {
    final error = config.validationError;
    if (error != null) {
      throw AiCallException(AiErrorKind.invalidResponse, error);
    }
    if (apiKey != null) {
      if (apiKey.trim().isEmpty) {
        await _secure.delete(key: _keyName);
      } else {
        await _secure.write(key: _keyName, value: apiKey.trim());
      }
    }
    final p = await SharedPreferences.getInstance();
    await Future.wait([
      p.setString('ai.endpoint', config.endpoint.name),
      p.setString('ai.baseUrl', config.baseUrl.trim()),
      p.setString('ai.model', config.model.trim()),
    ]);
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
  AiClient(this.repository, {Dio? dio})
    : _dio =
          dio ?? Dio(BaseOptions(connectTimeout: const Duration(seconds: 20)));

  final AiProviderRepository repository;
  final Dio _dio;

  Future<String> testConnection() async {
    return (await _chat(
      config: await repository.load(),
      messages: const [
        {'role': 'system', 'content': 'Antworte nur mit dem Wort OK.'},
        {'role': 'user', 'content': 'Verbindungstest'},
      ],
      jsonMode: false,
      maxTokens: 256,
    )).trim();
  }

  Future<List<ImportPair>> extractPairs({
    required String text,
    required String sourceLang,
    required String targetLang,
    required String direction,
  }) async {
    final content = await _chat(
      config: await repository.load(),
      messages: [
        {
          'role': 'system',
          'content':
              '''Du extrahierst ausschließlich Vokabelpaare aus vom Nutzer bereitgestelltem Text. Erfinde nichts. Wenn eine Übersetzung fehlt und aus dem Text nicht sicher ableitbar ist, lasse das Item weg. Antworte als JSON exakt im Schema {"source_lang":"$sourceLang","target_lang":"$targetLang","direction":"$direction","items":[{"source":"...","target":"...","example_source":null,"example_target":null,"notes":null,"confidence":0.0}]}. confidence 0..1.''',
        },
        {'role': 'user', 'content': text},
      ],
      jsonMode: true,
      maxTokens: 8192,
    );
    try {
      final decoded = jsonDecode(content) as Map<String, dynamic>;
      final raw = decoded['items'] as List<dynamic>;
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
        'Ungültige JSON-Antwort des Anbieters.',
      );
    }
  }

  Future<String> _chat({
    required AiProviderConfig config,
    required List<Map<String, String>> messages,
    required bool jsonMode,
    required int maxTokens,
  }) async {
    final validationError = config.validationError;
    if (validationError != null) {
      throw AiCallException(AiErrorKind.invalidResponse, validationError);
    }
    final key = await repository.readApiKey();
    if (key == null || key.trim().isEmpty) {
      throw const AiCallException(
        AiErrorKind.noKey,
        'Kein API-Schlüssel gespeichert.',
      );
    }
    final gemini = config.endpoint == AiEndpoint.gemini;
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        config.requestUri.toString(),
        options: Options(
          headers: gemini
              ? {'x-goog-api-key': key.trim()}
              : {'Authorization': 'Bearer ${key.trim()}'},
          contentType: Headers.jsonContentType,
          sendTimeout: const Duration(seconds: 25),
          receiveTimeout: const Duration(seconds: 90),
        ),
        data: gemini
            ? _geminiRequest(config, messages, jsonMode, maxTokens)
            : {
                'model': config.model.trim(),
                'messages': messages,
                'max_tokens': maxTokens,
                if (jsonMode) 'response_format': {'type': 'json_object'},
              },
      );
      return gemini ? _geminiText(response.data) : _openAiText(response.data);
    } on DioException catch (error) {
      throw _apiError(error, gemini: gemini);
    } on TypeError {
      throw const AiCallException(
        AiErrorKind.invalidResponse,
        'Unerwartetes Antwortformat des Anbieters.',
      );
    }
  }

  Map<String, dynamic> _geminiRequest(
    AiProviderConfig config,
    List<Map<String, String>> messages,
    bool jsonMode,
    int maxTokens,
  ) {
    final model = config.model.trim().replaceFirst(RegExp(r'^models/'), '');
    // Reasoning counts against maxOutputTokens. The old 8-token test exhausted
    // the budget before Gemini could return visible text. Keep headroom and
    // use model-specific thinking controls only on supported model families.
    final thinking = <String, dynamic>{
      if (model.startsWith('gemini-2.5-flash')) 'thinkingBudget': 0,
      if (model.startsWith('gemini-2.5-pro')) 'thinkingBudget': 128,
      if (model.startsWith('gemini-3'))
        'thinkingLevel': model.contains('flash-lite') ? 'minimal' : 'low',
    };
    final systemParts = messages
        .where((m) => m['role'] == 'system')
        .map((m) => {'text': m['content'] ?? ''})
        .toList();
    return {
      if (systemParts.isNotEmpty) 'systemInstruction': {'parts': systemParts},
      'contents': messages
          .where((m) => m['role'] != 'system')
          .map(
            (m) => {
              'role': m['role'] == 'assistant' ? 'model' : 'user',
              'parts': [
                {'text': m['content'] ?? ''},
              ],
            },
          )
          .toList(),
      'generationConfig': {
        'maxOutputTokens':
            maxTokens + (model.startsWith('gemini-3') ? 8192 : 1024),
        if (thinking.isNotEmpty) 'thinkingConfig': thinking,
        if (jsonMode) 'responseMimeType': 'application/json',
      },
    };
  }

  String _geminiText(Map<String, dynamic>? data) {
    final candidates = data?['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      final feedback = data?['promptFeedback'];
      final reason = feedback is Map ? feedback['blockReason'] : null;
      throw AiCallException(
        AiErrorKind.invalidResponse,
        reason == null
            ? 'Google Gemini hat keine Antwort geliefert. Bitte Modell prüfen.'
            : 'Google Gemini hat die Anfrage blockiert ($reason).',
      );
    }
    final first = candidates.first as Map<String, dynamic>;
    final reason = first['finishReason']?.toString();
    if (reason == 'MAX_TOKENS') {
      throw const AiCallException(
        AiErrorKind.invalidResponse,
        'Google Gemini hat das Antwortlimit erreicht. Bitte weniger Text auf einmal importieren oder ein Flash-Modell verwenden.',
      );
    }
    if (reason != null && reason != 'STOP') {
      throw AiCallException(
        AiErrorKind.invalidResponse,
        'Google Gemini hat die Antwort abgebrochen ($reason).',
      );
    }
    final content = first['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;
    final text = parts
        ?.whereType<Map<String, dynamic>>()
        .where((part) => part['thought'] != true)
        .map((part) => part['text'] as String? ?? '')
        .join()
        .trim();
    if (text == null || text.isEmpty) {
      throw const AiCallException(
        AiErrorKind.invalidResponse,
        'Google Gemini lieferte keinen Antworttext. Bitte Modell prüfen oder erneut versuchen.',
      );
    }
    return text;
  }

  String _openAiText(Map<String, dynamic>? data) {
    final choices = data?['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw const AiCallException(
        AiErrorKind.invalidResponse,
        'Leere Antwort des Anbieters.',
      );
    }
    final first = choices.first as Map<String, dynamic>;
    if (first['finish_reason'] == 'length') {
      throw const AiCallException(
        AiErrorKind.invalidResponse,
        'Antwortlimit erreicht. Bitte weniger Text auf einmal importieren.',
      );
    }
    final message = first['message'] as Map<String, dynamic>?;
    final content = (message?['content'] as String?)?.trim();
    if (content == null || content.isEmpty) {
      throw const AiCallException(
        AiErrorKind.invalidResponse,
        'Antwort enthielt keinen Text.',
      );
    }
    return content;
  }

  AiCallException _apiError(DioException error, {required bool gemini}) {
    final provider = gemini ? 'Google Gemini' : 'Der KI-Anbieter';
    final code = error.response?.statusCode;
    if (code == 401 || code == 403) {
      return const AiCallException(
        AiErrorKind.invalidKey,
        'API-Schlüssel abgelehnt.',
      );
    }
    if (code == 429) {
      return const AiCallException(
        AiErrorKind.rateLimit,
        'Rate Limit erreicht.',
      );
    }
    if (code == 400) {
      return AiCallException(
        AiErrorKind.invalidResponse,
        '$provider hat die Anfrage abgelehnt (400). Bitte URL, Modell und API-Schlüssel prüfen.',
      );
    }
    if (code == 404) {
      return AiCallException(
        AiErrorKind.invalidResponse,
        '$provider: Modell oder API-Endpunkt nicht gefunden (404). Bitte URL und Modell prüfen.',
      );
    }
    if ([
      DioExceptionType.connectionError,
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
    ].contains(error.type)) {
      return const AiCallException(
        AiErrorKind.network,
        'Verbindung fehlgeschlagen oder Zeitüberschreitung. Bitte erneut versuchen.',
      );
    }
    // Never echo raw provider errors, which may contain credentials or input.
    return AiCallException(
      AiErrorKind.unknown,
      '$provider: API-Fehler${code == null ? '' : ' ($code)'}.',
    );
  }
}
