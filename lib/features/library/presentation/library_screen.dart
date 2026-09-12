import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/languages.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/expressive.dart';
import '../../../data/local/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/application/settings_controller.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final db = ref.watch(databaseProvider);
    return SafeArea(
      child: StreamBuilder<List<VocabularySet>>(
        stream: db.watchSets(),
        builder: (context, snapshot) {
          final sets = snapshot.data ?? const [];
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ExpressiveHero(
                title: l.libraryHeadline,
                subtitle: '${sets.length} ${sets.length == 1 ? 'Set' : 'Sets'}',
              ),
              const SizedBox(height: 20),
              for (var index = 0; index < sets.length; index++) ...[
                _SetCard(
                  set: sets[index],
                  onTap: () => _openSet(context, ref, sets[index]),
                ),
                const SizedBox(height: 12),
              ],
              if (sets.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      const Icon(Icons.auto_stories_outlined, size: 64),
                      const SizedBox(height: 14),
                      Text(
                        l.libraryEmpty,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(l.libraryEmptyBody, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: () => _createSet(context, ref),
                icon: const Icon(Icons.add_rounded),
                label: Text(l.createSet),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _createSet(BuildContext context, WidgetRef ref) async {
    final name = TextEditingController();
    String source = 'en';
    String direction = 'foreign_to_de';
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final l = AppLocalizations.of(context)!;
          return Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              0,
              20,
              20 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.createSet,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: name,
                  decoration: InputDecoration(labelText: l.setName),
                  autofocus: true,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: source,
                  decoration: InputDecoration(labelText: l.sourceLanguage),
                  items: supportedLearningLanguages
                      .map(
                        (lang) => DropdownMenuItem(
                          value: lang.code,
                          child: Text(lang.label),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => source = value ?? source),
                ),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: 'foreign_to_de',
                      label: Text('${source.toUpperCase()} → DE'),
                    ),
                    ButtonSegment(
                      value: 'de_to_foreign',
                      label: Text('DE → ${source.toUpperCase()}'),
                    ),
                  ],
                  selected: {direction},
                  onSelectionChanged: (s) =>
                      setState(() => direction = s.first),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(l.saveLabel),
                ),
              ],
            ),
          );
        },
      ),
    );
    if (created == true && name.text.trim().isNotEmpty) {
      await ref
          .read(databaseProvider)
          .createSet(
            name: name.text.trim(),
            sourceLang: source,
            targetLang: 'de',
            direction: direction,
          );
    }
    name.dispose();
  }

  void _openSet(BuildContext context, WidgetRef ref, VocabularySet set) {
    var mode = ref.read(settingsControllerProvider).value?.lastMode ?? 'mixed';
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final l = AppLocalizations.of(context)!;
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  set.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '${set.sourceLang.toUpperCase()} ↔ ${set.targetLang.toUpperCase()} · ${set.defaultDirection == 'foreign_to_de' ? 'Fremd → DE' : 'DE → Fremd'}',
                ),
                const SizedBox(height: 20),
                Text(
                  l.modeTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(value: 'cards', label: Text(l.modeCards)),
                    ButtonSegment(value: 'quiz', label: Text(l.modeQuiz)),
                    ButtonSegment(value: 'typing', label: Text(l.modeTyping)),
                    ButtonSegment(value: 'mixed', label: Text(l.modeMixed)),
                  ],
                  selected: {mode},
                  onSelectionChanged: (s) => setState(() => mode = s.first),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/session?mode=$mode&set=${set.id}');
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(l.homeStart),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SetCard extends StatelessWidget {
  const _SetCard({required this.set, required this.onTap});
  final VocabularySet set;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(38),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 68,
                decoration: BoxDecoration(
                  color: Color(set.coverColor),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(7),
                    bottomLeft: Radius.circular(7),
                    bottomRight: Radius.circular(22),
                  ),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      set.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${set.sourceLang.toUpperCase()} ↔ ${set.targetLang.toUpperCase()}',
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
