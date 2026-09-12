import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/languages.dart';
import '../../../core/widgets/expressive.dart';
import '../../../l10n/app_localizations.dart';
import '../application/settings_controller.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final async = ref.watch(settingsControllerProvider);
    final settings = async.value;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ExpressiveHero(
            title: l.settingsHeadline,
            subtitle: l.settingsGeneral,
          ),
          const SizedBox(height: 18),
          _SettingsTile(
            icon: Icons.auto_awesome_rounded,
            title: l.settingsAi,
            subtitle: 'Base URL · API-Key · Modell · Verbindungstest',
            onTap: () => context.push('/settings/ai'),
          ),
          _SettingsTile(
            icon: Icons.keyboard_alt_rounded,
            title: l.settingsTyping,
            subtitle: settings == null
                ? ''
                : '${settings.typingShare}% Tipp-Anteil',
            onTap: () => context.push('/settings/typing'),
          ),
          const SizedBox(height: 12),
          Text(
            l.settingsLanguages,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          if (settings != null) ...[
            DropdownButtonFormField<String>(
              initialValue:
                  supportedLearningLanguages.any(
                    (x) => x.code == settings.languageCode,
                  )
                  ? settings.languageCode
                  : 'en',
              decoration: const InputDecoration(labelText: 'Lernsprache'),
              items: supportedLearningLanguages
                  .map(
                    (lang) => DropdownMenuItem(
                      value: lang.code,
                      child: Text(lang.label),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(settingsControllerProvider.notifier)
                      .setSettings((s) => s.copyWith(languageCode: value));
                }
              },
            ),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'foreign_to_de',
                  label: Text(l.directionForeignToDe),
                ),
                ButtonSegment(
                  value: 'de_to_foreign',
                  label: Text(l.directionDeToForeign),
                ),
              ],
              selected: {settings.direction},
              onSelectionChanged: (selection) => ref
                  .read(settingsControllerProvider.notifier)
                  .setSettings((s) => s.copyWith(direction: selection.first)),
            ),
            const SizedBox(height: 20),
            Text(
              l.settingsAppearance,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SwitchListTile(
              value: settings.dynamicColor,
              onChanged: (value) => ref
                  .read(settingsControllerProvider.notifier)
                  .setSettings((s) => s.copyWith(dynamicColor: value)),
              title: Text(l.settingsDynamicColor),
              secondary: const Icon(Icons.palette_rounded),
            ),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'system', label: Text(l.themeSystem)),
                ButtonSegment(value: 'light', label: Text(l.themeLight)),
                ButtonSegment(value: 'dark', label: Text(l.themeDark)),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (selection) => ref
                  .read(settingsControllerProvider.notifier)
                  .setSettings((s) => s.copyWith(themeMode: selection.first)),
            ),
            const SizedBox(height: 20),
          ],
          _SettingsTile(
            icon: Icons.import_export_rounded,
            title: l.settingsExport,
            subtitle: 'Komplette Sets als JSON sichern oder wieder einlesen',
            onTap: () => context.push('/settings/transfer'),
          ),
          const SizedBox(height: 18),
          Text(
            'Foliant 0.1.0',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_rounded),
      onTap: onTap,
    ),
  );
}
