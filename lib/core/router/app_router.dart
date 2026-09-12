import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai/presentation/ai_settings_screen.dart';
import '../../features/import/presentation/import_screen.dart';
import '../../features/learning/presentation/learning_home_screen.dart';
import '../../features/learning/presentation/session_screen.dart';
import '../../features/library/presentation/library_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/settings/presentation/more_screen.dart';
import '../../features/settings/presentation/typing_settings_screen.dart';
import '../../features/settings/presentation/transfer_screen.dart';
import '../widgets/app_shell.dart';
import '../widgets/startup_gate.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/startup',
  routes: [
    GoRoute(path: '/startup', builder: (_, _) => const StartupGate()),
    GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/learn',
              builder: (_, _) => const LearningHomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/library', builder: (_, _) => const LibraryScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/import', builder: (_, _) => const ImportScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/more', builder: (_, _) => const MoreScreen()),
          ],
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/session',
      builder: (context, state) => SessionScreen(
        mode: state.uri.queryParameters['mode'] ?? 'mixed',
        setId: state.uri.queryParameters['set'],
      ),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/settings/ai',
      builder: (_, _) => const AiSettingsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/settings/typing',
      builder: (_, _) => const TypingSettingsScreen(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/settings/transfer',
      builder: (_, _) => const TransferScreen(),
    ),
  ],
);
