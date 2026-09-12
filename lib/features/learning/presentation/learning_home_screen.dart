import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers.dart';
import '../../../core/widgets/expressive.dart';
import '../../../data/local/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/application/settings_controller.dart';

class LearningHomeScreen extends ConsumerWidget {
  const LearningHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final db = ref.watch(databaseProvider);
    final settings = ref.watch(settingsControllerProvider).value;
    final mode = settings?.lastMode ?? 'mixed';
    return SafeArea(
      child: StreamBuilder<List<VocabularyItem>>(
        stream: db.watchDueItems(),
        builder: (context, snapshot) {
          final due = snapshot.data ?? const [];
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ExpressiveHero(
                title: l.homeHeadline,
                subtitle: l.tagline,
                trailing: _ProgressBlob(value: due.length),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l.homeDue,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Badge(
                    label: Text('${due.length}'),
                    child: const Icon(Icons.schedule_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _DueCard(count: due.length),
              const SizedBox(height: 24),
              Text(
                l.modeTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              LearningModeSelector(
                selected: mode,
                onSelected: (selection) => ref
                    .read(settingsControllerProvider.notifier)
                    .setSettings((s) => s.copyWith(lastMode: selection)),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: due.isEmpty
                    ? null
                    : () => context.push('/session?mode=$mode'),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(l.homeStart),
              ),
              if (due.isEmpty) ...[
                const SizedBox(height: 14),
                TextButton.icon(
                  onPressed: () => context.go('/library'),
                  icon: const Icon(Icons.library_books_rounded),
                  label: Text(l.homeEmptyAction),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class LearningModeSelector extends StatelessWidget {
  const LearningModeSelector({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final modes = [
      ('cards', Icons.style_rounded, l.modeCards),
      ('quiz', Icons.checklist_rounded, l.modeQuiz),
      ('typing', Icons.keyboard_alt_rounded, l.modeTyping),
      ('mixed', Icons.shuffle_rounded, l.modeMixed),
    ];
    // Wrap whole choices onto a new row instead of squeezing four labels into
    // equal-width segments. Text keeps its natural size, including text scaling.
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final (value, icon, label) in modes)
          ChoiceChip(
            avatar: Icon(icon, size: 20),
            label: Text(label),
            selected: selected == value,
            showCheckmark: false,
            onSelected: (_) => onSelected(value),
          ),
      ],
    );
  }
}

class _DueCard extends StatelessWidget {
  const _DueCard({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: ShapeDecoration(
        color: count == 0 ? scheme.surfaceContainer : scheme.primaryContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(38),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(38),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            count == 0 ? Icons.done_all_rounded : Icons.bolt_rounded,
            size: 36,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              count == 0
                  ? l.homeEmpty
                  : '$count ${count == 1 ? 'Karte wartet' : 'Karten warten'} auf dich',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBlob extends StatelessWidget {
  const _ProgressBlob({required this.value});
  final int value;

  @override
  Widget build(BuildContext context) => Container(
    width: 64,
    height: 64,
    alignment: Alignment.center,
    decoration: ShapeDecoration(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(10),
        ),
      ),
    ),
    child: Text(
      '$value',
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
    ),
  );
}
