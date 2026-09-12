import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/languages.dart';
import '../../../core/widgets/expressive.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/application/settings_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final pageController = PageController();
  final customLanguageController = TextEditingController();
  int page = 0;
  String language = 'en';
  String direction = 'foreign_to_de';
  bool typing = true;

  @override
  void dispose() {
    pageController.dispose();
    customLanguageController.dispose();
    super.dispose();
  }

  void next() {
    if (page < 3) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutBack,
      );
    } else {
      finish();
    }
  }

  Future<void> finish() async {
    await ref
        .read(settingsControllerProvider.notifier)
        .setSettings(
          (current) => current.copyWith(
            languageCode: language,
            direction: direction,
            typingShare: typing ? 50 : 0,
            onboardingDone: true,
          ),
        );
    if (!mounted) return;
    context.go('/learn');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                children: [
                  Text(
                    l.appName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  Text('${page + 1}/4'),
                ],
              ),
            ),
            LinearProgressIndicator(value: (page + 1) / 4, minHeight: 3),
            Expanded(
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (value) => setState(() => page = value),
                children: [
                  _languagePage(l),
                  _directionPage(l),
                  _typingPage(l),
                  _aiPage(l),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (page > 0)
                    TextButton(
                      onPressed: () => pageController.previousPage(
                        duration: const Duration(milliseconds: 320),
                        curve: Curves.easeOutCubic,
                      ),
                      child: Text(l.backLabel),
                    ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: next,
                    icon: Icon(
                      page == 3
                          ? Icons.check_rounded
                          : Icons.arrow_forward_rounded,
                    ),
                    label: Text(page == 3 ? l.skipLabel : l.continueLabel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _languagePage(AppLocalizations l) => ListView(
    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
    children: [
      ExpressiveHero(
        title: l.languageTitle,
        subtitle: l.languageSubtitle,
        titleMaxLines: 2,
        titleStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 30,
              height: 1.05,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
      ),
      const SizedBox(height: 20),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: supportedLearningLanguages
            .map(
              (item) => ChoiceChip(
                selected: language == item.code,
                label: Text('${item.label} · ${item.code.toUpperCase()}'),
                onSelected: (_) => setState(() => language = item.code),
              ),
            )
            .toList(),
      ),
      const SizedBox(height: 20),
      TextField(
        controller: customLanguageController,
        decoration: InputDecoration(
          labelText: l.customLanguage,
          prefixIcon: const Icon(Icons.translate_rounded),
        ),
        onChanged: (value) {
          if (value.trim().isNotEmpty) setState(() => language = value.trim());
        },
      ),
    ],
  );

  Widget _directionPage(AppLocalizations l) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      ExpressiveHero(
        title: l.directionTitle,
        subtitle: l.directionAlwaysVisible,
      ),
      const SizedBox(height: 20),
      ChoiceTile(
        title: l.directionForeignToDe,
        subtitle: 'Prompt: ${language.toUpperCase()} · Antwort: DE',
        icon: Icons.east_rounded,
        selected: direction == 'foreign_to_de',
        onTap: () => setState(() => direction = 'foreign_to_de'),
      ),
      const SizedBox(height: 12),
      ChoiceTile(
        title: l.directionDeToForeign,
        subtitle: 'Prompt: DE · Antwort: ${language.toUpperCase()}',
        icon: Icons.west_rounded,
        selected: direction == 'de_to_foreign',
        onTap: () => setState(() => direction = 'de_to_foreign'),
      ),
    ],
  );

  Widget _typingPage(AppLocalizations l) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      ExpressiveHero(
        title: l.typingTitle,
        subtitle: 'Du kannst Karteikarten und Tippen später jederzeit mischen.',
      ),
      const SizedBox(height: 20),
      ChoiceTile(
        title: l.typingYes,
        icon: Icons.keyboard_alt_rounded,
        selected: typing,
        onTap: () => setState(() => typing = true),
      ),
      const SizedBox(height: 12),
      ChoiceTile(
        title: l.typingLater,
        icon: Icons.style_rounded,
        selected: !typing,
        onTap: () => setState(() => typing = false),
      ),
    ],
  );

  Widget _aiPage(AppLocalizations l) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      ExpressiveHero(title: l.aiOnboardingTitle, subtitle: l.aiOnboardingBody),
      const SizedBox(height: 20),
      Card(
        child: ListTile(
          contentPadding: const EdgeInsets.all(20),
          leading: const Icon(Icons.lock_rounded),
          title: const Text('Offline zuerst'),
          subtitle: const Text(
            'OCR läuft auf dem Gerät. API-Keys werden ausschließlich im Secure Storage gespeichert.',
          ),
        ),
      ),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: () => context.push('/settings/ai'),
        icon: const Icon(Icons.auto_awesome_rounded),
        label: Text(l.settingsAi),
      ),
    ],
  );
}
