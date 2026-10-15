import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finstep/main.dart';
import 'package:finstep/state/progress.dart';
import 'package:finstep/ui/explore.dart';
import 'package:finstep/ui/lesson.dart';
import 'package:finstep/ui/theme.dart';
import 'content_test.dart' show loadCourse;

void main() {
  testWidgets(
    'Home, direct learning, feedback and completion work on a narrow screen',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = LearningController(loadCourse(), MemoryProgressStore());
      await c.load();
      await tester.pumpWidget(FinStepApp(controller: c));
      await tester.pumpAndSettle();
      expect(find.text('돈 공부도,\n한 입부터.'), findsOneWidget);
      final next = find.byKey(const ValueKey('home-next-lesson'));
      await tester.ensureVisible(next);
      await tester.tap(next);
      await tester.pumpAndSettle();
      while (c.session('K07')!['phase'] != 'complete') {
        final s = c.session('K07')!;
        if (s['phase'] == 'quiz') {
          final q = c.course.question(s['questions'][s['index']]);
          final answer = find.byKey(ValueKey('answer-${q.answer.first}'));
          await tester.ensureVisible(answer);
          await tester.tap(answer);
          await tester.pumpAndSettle();
        }
        final action = find
            .descendant(
              of: find.byType(Footer).last,
              matching: find.byType(TextButton),
            )
            .first;
        await tester.tap(action);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      expect(c.xp, 30);
      expect(find.text('+30 XP'), findsOneWidget);
      await tester.tap(find.text('오늘은 여기까지'));
      await tester.pumpAndSettle();
      expect(find.text('오늘의 한입'), findsOneWidget);
    },
  );
  testWidgets(
    'Details are optional and opening them does not advance the lesson',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = LearningController(loadCourse(), MemoryProgressStore());
      await c.load();
      await c.start('K11');
      await tester.pumpWidget(
        MaterialApp(theme: F.theme, home: LessonPlayer(c, 'K11')),
      );
      await tester.pumpAndSettle();
      expect(find.text(c.course.lesson('K11').brief['core']), findsOneWidget);
      expect(
        find.text(c.course.lesson('K11').pages.first['body']),
        findsNothing,
      );
      final before = c.snapshot;
      await tester.tap(find.text('자세히 알아보기  ›'));
      await tester.pumpAndSettle();
      expect(
        find.text(c.course.lesson('K11').pages.first['body']),
        findsOneWidget,
      );
      expect(c.snapshot, before);
      await tester.tap(find.byTooltip('닫기').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('작은 예시로 확인하기'));
      await tester.pumpAndSettle();
      expect(c.session('K11')!['phase'], 'experiment');
      expect(find.text('2,000원'), findsOneWidget);
      await tester.tap(find.text('+'));
      await tester.pumpAndSettle();
      expect(find.text('1,000원'), findsOneWidget);
      await tester.tap(find.text('퀴즈 풀기'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(
          ValueKey(
            'answer-${c.course.question('Q_K11_001').options.keys.firstWhere((k) => !c.course.question('Q_K11_001').answer.contains(k))}',
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('정답 확인'));
      await tester.pumpAndSettle();
      expect(find.text('관련 개념'), findsNothing);
      expect(
        find.text(
          c.course
              .question('Q_K11_001')
              .feedback(c.session('K11')!['selected'].first),
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('해설과 관련 개념 보기  ›'));
      await tester.pumpAndSettle();
      expect(find.text('관련 개념'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('Hedging quiz works with large text at 320px width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final c = LearningController(loadCourse(), MemoryProgressStore());
    await c.load();
    await c.start('K50');
    while (c.session('K50')!['phase'] != 'quiz') {
      await c.advance('K50');
    }
    await tester.pumpWidget(
      MaterialApp(
        theme: F.theme,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.5)),
          child: child!,
        ),
        home: LessonPlayer(c, 'K50'),
      ),
    );
    await tester.pumpAndSettle();
    for (final a in c.course.question('Q_K50_001').answer) {
      final f = find.byKey(ValueKey('answer-$a'));
      await tester.ensureVisible(f);
      await tester.tap(f);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('정답 확인'));
    await tester.pumpAndSettle();
    expect(c.events.last['correct'], isTrue);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Search uses actual concepts and saved filter persists', (
    tester,
  ) async {
    final c = LearningController(loadCourse(), MemoryProgressStore());
    await c.load();
    await c.toggleSaved('C50_01');
    await tester.pumpWidget(MaterialApp(theme: F.theme, home: SearchScreen(c)));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'EPS');
    await tester.pumpAndSettle();
    expect(find.text('EPS · 주당순이익'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '');
    await tester.ensureVisible(find.text('저장한 개념'));
    await tester.tap(find.text('저장한 개념'));
    await tester.pumpAndSettle();
    expect(find.text('저장한 개념 · 1개'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
