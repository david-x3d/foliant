import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foliant/features/ai/data/ai_provider_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeRepository extends AiProviderRepository {
  FakeRepository(this.config, {this.key = 'test-key'});
  final AiProviderConfig config;
  final String? key;
  @override
  Future<AiProviderConfig> load() async => config;
  @override
  Future<String?> readApiKey() async => key;
}

const gemini = AiProviderConfig(
  endpoint: AiEndpoint.gemini,
  baseUrl: 'https://generativelanguage.googleapis.com/v1beta',
  model: 'gemini-2.5-flash',
);

Map<String, dynamic> answer(String text, {String reason = 'STOP'}) => {
  'candidates': [
    {
      'finishReason': reason,
      'content': {
        'parts': [
          {'text': text},
        ],
      },
    },
  ],
};

AiClient clientFor(
  Object? response, {
  AiProviderConfig config = gemini,
  int status = 200,
  void Function(RequestOptions)? inspect,
}) {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        inspect?.call(options);
        if (status >= 400) {
          handler.reject(
            DioException(
              requestOptions: options,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: options,
                data: response,
                statusCode: status,
              ),
            ),
          );
        } else {
          handler.resolve(
            Response(
              requestOptions: options,
              data: response,
              statusCode: status,
            ),
          );
        }
      },
    ),
  );
  return AiClient(FakeRepository(config), dio: dio);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Gemini connection test has enough output budget and disables Flash thinking',
    () async {
      final client = clientFor(
        answer('OK'),
        inspect: (request) {
          expect(
            request.uri.path,
            '/v1beta/models/gemini-2.5-flash:generateContent',
          );
          expect(request.headers['x-goog-api-key'], 'test-key');
          expect(request.headers.containsKey('Authorization'), isFalse);
          expect(request.uri.hasQuery, isFalse);
          final data = request.data as Map<String, dynamic>;
          expect(
            data['generationConfig']['thinkingConfig']['thinkingBudget'],
            0,
          );
          expect(
            data['generationConfig']['maxOutputTokens'],
            greaterThanOrEqualTo(1024),
          );
          expect(data['systemInstruction']['parts'], isNotEmpty);
          expect(data['contents'][0]['role'], 'user');
        },
      );
      expect(await client.testConnection(), 'OK');
    },
  );

  test(
    'Gemini JSON import combines text parts and ignores thought summaries',
    () async {
      final client = clientFor(
        {
          'candidates': [
            {
              'finishReason': 'STOP',
              'content': {
                'parts': [
                  {'thought': true, 'text': 'This must not enter the JSON'},
                  {'text': '{"items":['},
                  {
                    'text':
                        '{"source":"apple","target":"Apfel","confidence":0.98}]}',
                  },
                ],
              },
            },
          ],
        },
        inspect: (request) {
          expect(
            request.data['generationConfig']['responseMimeType'],
            'application/json',
          );
        },
      );
      final pairs = await client.extractPairs(
        text: 'apple - Apfel',
        sourceLang: 'en',
        targetLang: 'de',
        direction: 'foreign_to_de',
      );
      expect(pairs.single.source, 'apple');
      expect(pairs.single.target, 'Apfel');
    },
  );

  test(
    'truncation is reported before attempting to import partial JSON',
    () async {
      await expectLater(
        clientFor(answer('{"items":[', reason: 'MAX_TOKENS')).extractPairs(
          text: 'apple - Apfel',
          sourceLang: 'en',
          targetLang: 'de',
          direction: 'foreign_to_de',
        ),
        throwsA(
          isA<AiCallException>().having(
            (e) => e.message,
            'message',
            contains('Antwortlimit'),
          ),
        ),
      );
    },
  );

  test('blocked prompt has an actionable error', () async {
    await expectLater(
      clientFor({
        'promptFeedback': {'blockReason': 'SAFETY'},
      }).testConnection(),
      throwsA(
        isA<AiCallException>().having(
          (e) => e.message,
          'message',
          contains('SAFETY'),
        ),
      ),
    );
  });

  for (final response in [
    <String, dynamic>{},
    {'candidates': []},
    {
      'candidates': [
        {'content': {}},
      ],
    },
    {
      'candidates': [
        {
          'content': {
            'parts': [
              {'thought': true, 'text': 'thinking'},
            ],
          },
        },
      ],
    },
    {'candidates': 'invalid'},
  ]) {
    test(
      'missing or malformed Gemini content is not a successful connection: $response',
      () async {
        await expectLater(
          clientFor(response).testConnection(),
          throwsA(
            isA<AiCallException>().having(
              (e) => e.kind,
              'kind',
              AiErrorKind.invalidResponse,
            ),
          ),
        );
      },
    );
  }

  for (final (code, kind) in [
    (400, AiErrorKind.invalidResponse),
    (401, AiErrorKind.invalidKey),
    (403, AiErrorKind.invalidKey),
    (404, AiErrorKind.invalidResponse),
    (429, AiErrorKind.rateLimit),
    (500, AiErrorKind.unknown),
  ]) {
    test(
      'HTTP $code is classified without leaking raw provider errors',
      () async {
        await expectLater(
          clientFor({'error': 'SECRET-KEY'}, status: code).testConnection(),
          throwsA(
            isA<AiCallException>()
                .having((e) => e.kind, 'kind', kind)
                .having(
                  (e) => e.message,
                  'message',
                  isNot(contains('SECRET-KEY')),
                ),
          ),
        );
      },
    );
  }

  test('receive timeout is a network error', () async {
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            handler.reject(
              DioException(
                requestOptions: request,
                type: DioExceptionType.receiveTimeout,
              ),
            );
          },
        ),
      );
    await expectLater(
      AiClient(FakeRepository(gemini), dio: dio).testConnection(),
      throwsA(
        isA<AiCallException>().having(
          (e) => e.kind,
          'kind',
          AiErrorKind.network,
        ),
      ),
    );
  });

  test('missing key does not send a request', () async {
    await expectLater(
      AiClient(FakeRepository(gemini, key: null)).testConnection(),
      throwsA(
        isA<AiCallException>().having((e) => e.kind, 'kind', AiErrorKind.noKey),
      ),
    );
  });

  test('base and full Gemini URLs use the configured model exactly once', () {
    for (final base in [
      'https://generativelanguage.googleapis.com',
      'https://generativelanguage.googleapis.com/v1beta/',
      'https://generativelanguage.googleapis.com/v1beta/models',
      'https://generativelanguage.googleapis.com/v1beta/models/old-model:generateContent',
    ]) {
      final config = AiProviderConfig(
        endpoint: AiEndpoint.gemini,
        baseUrl: base,
        model: 'models/gemini-2.5-flash',
      );
      expect(config.validationError, isNull);
      expect(
        config.requestUri.toString(),
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent',
      );
    }
  });

  test(
    'explicit OpenAI endpoint works on the Google compatibility URL',
    () async {
      const config = AiProviderConfig(
        baseUrl:
            'https://generativelanguage.googleapis.com/v1beta/openai/chat/completions/',
        model: 'gemini-2.5-flash',
      );
      final client = clientFor(
        {
          'choices': [
            {
              'message': {'content': 'OK'},
              'finish_reason': 'stop',
            },
          ],
        },
        config: config,
        inspect: (request) {
          expect(request.uri.path, '/v1beta/openai/chat/completions');
          expect(request.headers['Authorization'], 'Bearer test-key');
          expect(request.data['messages'], isNotEmpty);
        },
      );
      expect(await client.testConnection(), 'OK');
    },
  );

  test(
    'legacy Gemini settings migrate and roundtrip without replacing the key',
    () async {
      SharedPreferences.setMockInitialValues({
        'ai.baseUrl': gemini.baseUrl,
        'ai.model': gemini.model,
        'ai.extraHeaders': 'invalid legacy JSON',
      });
      final repository = AiProviderRepository();
      final loaded = await repository.load();
      expect(loaded.endpoint, AiEndpoint.gemini);
      await repository.save(loaded);
      expect((await repository.load()).model, gemini.model);
      expect(
        (await SharedPreferences.getInstance()).getString('ai.endpoint'),
        'gemini',
      );
    },
  );

  test(
    'invalid URLs and empty models are rejected before storage or networking',
    () {
      for (final url in [
        '',
        'not a URL',
        'file:///tmp/key',
        'https://host?key=secret',
        'https://user:secret@host',
      ]) {
        expect(AiProviderConfig(baseUrl: url).validationError, isNotNull);
      }
      expect(const AiProviderConfig(model: ' ').validationError, isNotNull);
    },
  );
}
