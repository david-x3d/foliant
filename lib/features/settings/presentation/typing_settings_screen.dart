import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../application/settings_controller.dart';

class TypingSettingsScreen extends ConsumerWidget {
  const TypingSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTyping)),
      body: settings == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  l.settingsTypingShare,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, label: Text('0%')),
                    ButtonSegment(value: 50, label: Text('50%')),
                    ButtonSegment(value: 100, label: Text('100%')),
                  ],
                  selected: {settings.typingShare},
                  onSelectionChanged: (value) => ref
                      .read(settingsControllerProvider.notifier)
                      .setSettings((s) => s.copyWith(typingShare: value.first)),
                ),
                const SizedBox(height: 18),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: settings.strictCase,
                  title: Text(l.settingsStrictCase),
                  subtitle: const Text(
                    'Standard: tolerant. Für bewusstes Case-Training aktivieren.',
                  ),
                  onChanged: (value) => ref
                      .read(settingsControllerProvider.notifier)
                      .setSettings((s) => s.copyWith(strictCase: value)),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: settings.strictAccents,
                  title: Text(l.settingsAccentsStrict),
                  subtitle: const Text(
                    'Aus: Akzentfehler werden markiert, blockieren aber nicht sofort.',
                  ),
                  onChanged: (value) => ref
                      .read(settingsControllerProvider.notifier)
                      .setSettings((s) => s.copyWith(strictAccents: value)),
                ),
                const SizedBox(height: 20),
                Card(
                  child: const Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      'Beim Tippen sind Autocorrect und Vorschläge deaktiviert. Sonderzeichen werden passend zur Zielsprache angeboten.',
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
