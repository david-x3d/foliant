import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/ai_provider_repository.dart';

final aiRepositoryProvider = Provider<AiProviderRepository>(
  (ref) => AiProviderRepository(),
);
final aiClientProvider = Provider<AiClient>(
  (ref) => AiClient(ref.watch(aiRepositoryProvider)),
);
