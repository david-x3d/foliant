import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/settings/application/settings_controller.dart';
import '../providers.dart';

class StartupGate extends ConsumerStatefulWidget {
  const StartupGate({super.key});

  @override
  ConsumerState<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends ConsumerState<StartupGate> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_boot);
  }

  Future<void> _boot() async {
    await ref.read(databaseProvider).seedDemoIfEmpty();
    final settings = await ref.read(settingsControllerProvider.future);
    if (!mounted) return;
    context.go(settings.onboardingDone ? '/learn' : '/onboarding');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: .72, end: 1),
        duration: const Duration(milliseconds: 850),
        curve: Curves.elasticOut,
        builder: (_, scale, child) =>
            Transform.scale(scale: scale, child: child),
        child: Container(
          width: 76,
          height: 76,
          decoration: ShapeDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(34),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(34),
              ),
            ),
          ),
          child: const Icon(Icons.auto_stories_rounded, size: 34),
        ),
      ),
    ),
  );
}
