import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finstep/main.dart';
import 'package:finstep/state/progress.dart';
import 'package:finstep/ui/explore.dart';
import 'package:finstep/ui/lesson.dart';
import 'package:finstep/ui/records.dart';
import 'package:finstep/ui/theme.dart';
import 'content_test.dart' show loadCourse;
import 'progress_test.dart' show finish;

void main() {
  testWidgets(
    'All 50 core, example and quiz screens fit narrow large-text phones',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = LearningController(loadCourse(), MemoryProgressStore());
      await c.load();
      for (final lesson in c.course.lessons) {
        await c.start(lesson.id);
        await tester.pumpWidget(
          MaterialApp(
            theme: F.theme,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.5)),
              child: child!,
            ),
            home: LessonPlayer(c, lesson.id, key: ValueKey(lesson.id)),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text(lesson.brief['core']), findsOneWidget);
        expect(tester.takeException(), isNull, reason: '${lesson.id} core');
        await tester.tap(find.text('작은 예시로 확인하기'));
        await tester.pumpAndSettle();
        expect(c.session(lesson.id)!['phase'], 'experiment');
        expect(tester.takeException(), isNull, reason: '${lesson.id} example');
        await tester.tap(find.text('퀴즈 풀기'));
        await tester.pumpAndSettle();
        expect(c.session(lesson.id)!['phase'], 'quiz');
        final q = c.course.forLesson(lesson.id).first;
        final answer = find.byKey(ValueKey('answer-${q.answer.single}'));
        await tester.ensureVisible(answer);
        await tester.tap(answer);
        await tester.pumpAndSettle();
        await tester.tap(find.text('정답 확인'));
        await tester.pumpAndSettle();
        expect(c.events.last['correct'], isTrue);
        expect(tester.takeException(), isNull, reason: '${lesson.id} feedback');
      }
    },
  );
  testWidgets(
    'Category filter intersects search and shows all 50 when cleared',
    (tester) async {
      final c = LearningController(loadCourse(), MemoryProgressStore());
      await c.load();
      await tester.pumpWidget(
        MaterialApp(theme: F.theme, home: SearchScreen(c)),
      );
      await tester.pumpAndSettle();
      expect(find.text('검색 결과 · 50개'), findsOneWidget);
      await tester.tap(find.widgetWithText(ChoiceChip, '투자상품과 위험관리'));
      await tester.pumpAndSettle();
      expect(find.text('검색 결과 · 4개'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'ETN');
      await tester.pumpAndSettle();
      expect(find.text('검색 결과 · 1개'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '금리');
      await tester.pumpAndSettle();
      expect(find.text('검색 결과 · 0개'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '');
      await tester.tap(find.widgetWithText(ChoiceChip, '전체'));
      await tester.pumpAndSettle();
      expect(find.text('검색 결과 · 50개'), findsOneWidget);
    },
  );
  testWidgets(
    'Seven course groups expose the matching concepts and connection navigation',
    (tester) async {
      final c = LearningController(loadCourse(), MemoryProgressStore());
      await c.load();
      await tester.pumpWidget(FinStepApp(controller: c));
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('학습'));
      await tester.pumpAndSettle();
      expect(find.text('0 / 50 완료'), findsOneWidget);
      final group = find.text('6. 경제지표와 통화정책');
      await tester.ensureVisible(group);
      await tester.tap(group);
      await tester.pumpAndSettle();
      expect(find.text('경기동행지수와 선행지수'), findsOneWidget);
      final links = find.text('개념 연결');
      await tester.ensureVisible(links);
      await tester.tap(links);
      await tester.pumpAndSettle();
      expect(find.text('시가총액'), findsWidgets);
      final relation = find.text('PBR · 주가순자산비율');
      await tester.ensureVisible(relation);
      await tester.tap(relation);
      await tester.pumpAndSettle();
      expect(
        find.text(c.course.concept('C50_14')['short_definition']),
        findsOneWidget,
      );
    },
  );
  testWidgets(
    'Archived progress is visible without claiming new lessons completed',
    (tester) async {
      final course = loadCourse();
      final store = MemoryProgressStore();
      final old = LearningController(course.previous!, store);
      await old.load();
      await old.start('L01');
      await finish(old, 'L01');
      final c = LearningController(course, store);
      await c.load();
      await tester.pumpWidget(
        MaterialApp(theme: F.theme, home: LearningHistoryScreen(c)),
      );
      await tester.pumpAndSettle();
      expect(find.text('0 / 50 완료 · 30 XP'), findsOneWidget);
      expect(find.text('이전 과정 1개 완료 · 30 XP 보존'), findsOneWidget);
      expect(find.text('✓ 주식 한 주'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
