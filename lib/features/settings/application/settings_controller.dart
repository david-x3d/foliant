import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../data/settings_repository.dart';

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, AppSettings>(
      SettingsController.new,
    );

class SettingsController extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() => ref.read(settingsRepositoryProvider).load();

  Future<void> setSettings(
    AppSettings Function(AppSettings current) transform,
  ) async {
    final current =
        state.value ?? await ref.read(settingsRepositoryProvider).load();
    final next = transform(current);
    state = AsyncData(next);
    await ref.read(settingsRepositoryProvider).save(next);
  }
}
