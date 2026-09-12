import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foliant/features/learning/presentation/learning_home_screen.dart';
import 'package:foliant/l10n/app_localizations.dart';

void main() {
  for (final width in [320.0, 360.0, 412.0]) {
    for (final scale in [1.0, 1.5, 2.0]) {
      testWidgets(
        'German mode labels stay on one line at width $width, scale $scale',
        (tester) async {
          await tester.binding.setSurfaceSize(Size(width, 900));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          String? selected;
          await tester.pumpWidget(
            MaterialApp(
              locale: const Locale('de'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: MediaQuery(
                  data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: LearningModeSelector(
                      selected: 'mixed',
                      onSelected: (v) => selected = v,
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          for (final label in ['Karteikarten', 'Quiz', 'Tippen', 'Gemischt']) {
            final paragraph = tester.renderObject<RenderParagraph>(
              find.text(label),
            );
            expect(
              paragraph.getBoxesForSelection(
                TextSelection(baseOffset: 0, extentOffset: label.length),
              ),
              hasLength(1),
            );
            expect(paragraph.didExceedMaxLines, isFalse);
          }
          await tester.tap(find.text('Karteikarten'));
          expect(selected, 'cards');
        },
      );
    }
  }
}
