import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finstep/main.dart';
import 'package:finstep/state/progress.dart';
import 'package:finstep/ui/home_feed.dart';
import 'package:finstep/ui/lesson.dart';
import 'package:finstep/ui/records.dart';
import 'package:finstep/ui/theme.dart';
import 'content_test.dart' show loadCourse;
import 'progress_test.dart' show finish, toQuiz;

void main() {
  late DateTime now;
  late LearningController c;
  late MemoryProgressStore store;
  setUp(() async {
    now = DateTime(2026, 10, 13, 12);
    store = MemoryProgressStore();
    c = LearningController(loadCourse(), store, clock: () => now);
    await c.load();
  });

  test(
    'Only full completions count; repeats are distinct by concept and local day',
    () async {
      expect(c.dailyGoal, 1);
      await c.answerHome(now, 0);
      expect(c.dailyCompleted(now), 0);
      await c.start('K07');
      await toQuiz(c, 'K07');
      await c.select('K07', 'A');
      await c.advance('K07');
      expect(c.dailyCompleted(now), 0);
      await finish(c, 'K07');
      expect(c.dailyCompleted(now), 1);
      expect(c.reviewDueDay('K07'), '2026-10-14');
      await c.start('K07', review: true);
      await finish(c, 'review:K07');
      expect(c.dailyCompleted(now), 1);
      expect(c.reviewDueDay('K07'), '2026-10-14');
      await c.start('K05');
      await finish(c, 'K05');
      expect(c.dailyCompleted(now), 2);
      expect(c.xp, 60);
      now = DateTime(2026, 10, 14);
      expect(c.dailyCompleted(now), 0);
      await c.start('K07', review: true);
      await finish(c, 'review:K07');
      expect(c.dailyCompleted(now), 1);
      expect(c.xp, 60);
    },
  );

  test(
    'Review intervals grow on later-day success and reset after a mistake',
    () async {
      await c.start('K07');
      await finish(c, 'K07');
      for (final (date, expected) in [
        (DateTime(2026, 10, 14), '2026-10-17'),
        (DateTime(2026, 10, 17), '2026-10-24'),
        (DateTime(2026, 10, 24), '2026-11-07'),
        (DateTime(2026, 11, 7), '2026-12-07'),
        (DateTime(2026, 12, 7), '2027-01-06'),
      ]) {
        now = date;
        expect(c.reviewsDue(now).first.lessonId, 'K07');
        await c.start('K07', review: true);
        await finish(c, 'review:K07');
        expect(c.reviewDueDay('K07'), expected);
        expect(c.reviewsDue(now), isEmpty);
      }
      now = DateTime(2027, 1, 6);
      await c.start('K07', review: true);
      await finish(c, 'review:K07', wrong: true);
      expect(c.reviewDueDay('K07'), '2027-01-07');
      await c.start('K07', review: true);
      await finish(c, 'review:K07');
      expect(c.reviewDueDay('K07'), '2027-01-07');
      expect(c.xp, 30);
    },
  );

  test(
    'Future reviews are excluded; mistakes precede other due concepts',
    () async {
      await c.start('K07');
      await finish(c, 'K07');
      await c.start('K05');
      await finish(c, 'K05', wrong: true);
      expect(c.reviewsDue(now), isEmpty);
      now = DateTime(2026, 10, 14);
      expect(c.reviewsDue(now).map((r) => r.lessonId), ['K05', 'K07']);
      expect(c.reviewsDue(now).first.hasMistakes, isTrue);
      await c.start('K05', review: true);
      await finish(c, 'review:K05');
      expect(c.reviewsDue(now).map((r) => r.lessonId), ['K07']);
    },
  );

  test(
    'Failed final save changes neither goal count, review date, completion nor XP',
    () async {
      await c.start('K07');
      await toQuiz(c, 'K07');
      for (var i = 0; i < 2; i++) {
        final q = c.course.question(c.session('K07')!['questions'][i]);
        await c.select('K07', q.answer.first);
        await c.advance('K07');
        if (i == 0) await c.advance('K07');
      }
      final before = c.snapshot;
      store.failWrites = true;
      expect(await c.advance('K07'), isFalse);
      expect(c.snapshot, before);
      expect(c.dailyCompleted(now), 0);
      expect(c.reviewDueDay('K07'), isNull);
      expect(c.xp, 0);
      store.failWrites = false;
      expect(await Future.wait([c.advance('K07'), c.advance('K07')]), [
        true,
        false,
      ]);
      expect(c.dailyCompleted(now), 1);
      expect(c.xp, 30);
    },
  );

  test(
    'Goal and review dates survive relaunch; invalid preferences never commit',
    () async {
      expect(await c.setDailyGoal(3), isTrue);
      await c.start('K07');
      await finish(c, 'K07');
      final restored = LearningController(c.course, store, clock: () => now);
      await restored.load();
      expect(restored.dailyGoal, 3);
      expect(restored.dailyCompleted(now), 1);
      expect(restored.reviewDueDay('K07'), '2026-10-14');
      final before = store.value;
      expect(await c.setDailyGoal(0), isFalse);
      expect(await c.setDailyGoal(4), isFalse);
      expect(store.value, before);
      store.failWrites = true;
      expect(await c.setDailyGoal(2), isFalse);
      expect(c.dailyGoal, 3);
      restored.dispose();
    },
  );

  test(
    'Pre-feature records remain untouched and get no invented completion dates',
    () async {
      await c.start('K07');
      await finish(c, 'K07');
      final old = c.snapshot..remove('studyPlan');
      store.value = jsonEncode(old);
      await c.load();
      expect(c.ready, isTrue);
      expect(c.dailyCompleted(now), 0);
      expect(c.xp, 30);
      expect(c.reviewsDue(now).single.dueDay, isNull);
      expect(store.value, jsonEncode(old));
      await c.start('K07', review: true);
      final unfinished = c.snapshot;
      unfinished['sessions']['review:K07'].remove('allCorrect');
      store.value = jsonEncode(unfinished);
      await c.load();
      await finish(c, 'review:K07');
      expect(c.reviewDueDay('K07'), '2026-10-14');
    },
  );

  test('Corrupt plan dates and unknown versions remain protected', () async {
    await c.setDailyGoal(1);
    final good = c.snapshot;
    for (final mutate in <void Function(Map<String, dynamic>)>[
      (d) => d['studyPlan']['version'] = 99,
      (d) => d['studyPlan']['days']['2026-02-30'] = ['K07'],
      (d) => d['studyPlan']['days']['2026-10-13'] = ['K07', 'K07'],
      (d) => d['studyPlan']['reviews']['K07'] = {
        'lastDay': '2026-10-13',
        'dueDay': '2026-10-12',
        'streak': 0,
      },
      (d) => d['studyPlan']['reviews']['K99'] = {
        'lastDay': '2026-10-13',
        'dueDay': '2026-10-14',
        'streak': 0,
      },
    ]) {
      final broken = Map<String, dynamic>.from(jsonDecode(jsonEncode(good)));
      mutate(broken);
      final raw = jsonEncode(broken);
      store.value = raw;
      await c.load();
      expect(c.ready, isFalse);
      expect(await c.setDailyGoal(2), isFalse);
      expect(store.value, raw);
    }
  });

  test(
    'Month/year rollover and device clock rollback preserve reminder dates',
    () async {
      now = DateTime(2026, 12, 31, 23, 59);
      await c.start('K07');
      await finish(c, 'K07');
      expect(c.reviewDueDay('K07'), '2027-01-01');
      now = DateTime(2026, 12, 20);
      await c.start('K07', review: true);
      await finish(c, 'review:K07', wrong: true);
      expect(c.reviewDueDay('K07'), '2027-01-01');
      expect(c.reviewsDue(now), isEmpty);
    },
  );

  test(
    'Daily history is bounded without losing long-term review schedules',
    () async {
      for (var i = 0; i < 95; i++) {
        now = DateTime(2026, 1, 1 + i);
        await c.start('K07');
        await finish(c, 'K07');
      }
      expect((c.snapshot['studyPlan']['days'] as Map).length, 90);
      expect(c.dailyCompleted(DateTime(2026, 1, 1)), 0);
      expect(c.dailyCompleted(now), 1);
      expect(c.reviewDueDay('K07'), isNotNull);
      expect(c.xp, 30);
    },
  );

  testWidgets(
    'Goal picker persists failures safely and large text stays usable',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          theme: F.theme,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.5)),
            child: child!,
          ),
          home: Scaffold(
            body: PageBody([HomeFeed(c, date: now, onCourse: () {})]),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final change = find.byKey(const ValueKey('change-daily-goal'));
      await tester.ensureVisible(change);
      await tester.tap(change);
      await tester.pumpAndSettle();
      final three = find.byKey(const ValueKey('daily-goal-3'));
      await tester.ensureVisible(three);
      store.failWrites = true;
      await tester.tap(three);
      await tester.pumpAndSettle();
      expect(c.dailyGoal, 1);
      expect(find.text('하루에 얼마나 배울까요?'), findsOneWidget);
      expect(c.error, isNotNull);
      store.failWrites = false;
      await tester.ensureVisible(three);
      await tester.tap(three);
      await tester.pumpAndSettle();
      expect(c.dailyGoal, 3);
      expect(find.text('하루에 얼마나 배울까요?'), findsNothing);
      expect(find.text('오늘 0 / 3개'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Home refreshes goals and recommendations when resumed on a new day',
    (tester) async {
      await c.start('K07');
      await finish(c, 'K07');
      await tester.pumpWidget(FinStepApp(controller: c));
      await tester.pumpAndSettle();
      expect(find.text('오늘 목표를 채웠어요'), findsOneWidget);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      now = DateTime(2026, 10, 14, 10);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(find.text('오늘 0 / 1개'), findsOneWidget);
      expect(find.text('추천 개념 복습하기'), findsOneWidget);
      final start = find.byKey(const ValueKey('start-today-study'));
      await tester.ensureVisible(start);
      await tester.tap(start);
      await tester.pumpAndSettle();
      expect(find.byType(LessonPlayer), findsOneWidget);
      expect(c.session('review:K07')!['phase'], 'quiz');
      expect(c.session('K07')!['phase'], 'complete');
    },
  );

  testWidgets('Open home updates at midnight without relaunch', (tester) async {
    now = DateTime(2026, 10, 13, 23, 59, 50);
    await c.start('K07');
    await finish(c, 'K07');
    await tester.pumpWidget(FinStepApp(controller: c));
    await tester.pumpAndSettle();
    expect(find.text('오늘 목표를 채웠어요'), findsOneWidget);
    now = DateTime(2026, 10, 14, 0, 0, 2);
    await tester.pump(const Duration(seconds: 12));
    await tester.pumpAndSettle();
    expect(find.text('오늘 0 / 1개'), findsOneWidget);
    expect(find.text('추천 개념 복습하기'), findsOneWidget);
  });

  testWidgets(
    'Review screen separates due reminders and optional early reviews',
    (tester) async {
      await c.start('K07');
      await finish(c, 'K07');
      await tester.pumpWidget(
        MaterialApp(theme: F.theme, home: ReviewScreen(c)),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('다음 추천 2026-10-14'), findsOneWidget);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      now = DateTime(2026, 10, 14);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(find.text('다시 볼 때가 됐어요'), findsOneWidget);
      expect(find.textContaining('오늘 다시 볼 개념 1개'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
