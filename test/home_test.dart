import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finstep/content/home_prompts.dart';
import 'package:finstep/main.dart';
import 'package:finstep/state/progress.dart';
import 'package:finstep/ui/home_feed.dart';
import 'package:finstep/ui/lesson.dart';
import 'package:finstep/ui/theme.dart';
import 'content_test.dart' show loadCourse;
import 'progress_test.dart' show finish;

void main() {
  final homePrompts = promptsFor(loadCourse());
  final day = DateTime(2026, 10, 7);

  test(
    'Home prompt persists without changing XP, course evidence or resume',
    () async {
      final store = MemoryProgressStore();
      final c = LearningController(loadCourse(), store);
      await c.load();
      await c.start('K07');
      final session = Map.of(c.session('K07')!);
      expect(await c.answerHome(day, 1), isTrue);
      expect(await c.answerHome(day, 0), isFalse);
      final restored = LearningController(c.course, store);
      await restored.load();
      expect(restored.homeAnswer(day)!['choice'], 1);
      expect(restored.dailyPrompt(day).id, homePromptFor(day, homePrompts).id);
      expect(restored.homeAnswer(DateTime(2026, 10, 8)), isNull);
      expect(restored.xp, 0);
      expect(restored.completed, isEmpty);
      expect(restored.events, isEmpty);
      expect(restored.missed, isEmpty);
      expect(restored.session('K07'), session);
      expect(restored.resumeKey, 'K07');
      expect(restored.activeDays, {'2026-10-07'});
    },
  );

  test('Home save failure can retry, concurrent answers commit once', () async {
    final store = MemoryProgressStore();
    final c = LearningController(loadCourse(), store);
    await c.load();
    store.failWrites = true;
    expect(await c.answerHome(day, 1), isFalse);
    expect(c.homeAnswer(day), isNull);
    expect(c.activeDays, isEmpty);
    store.failWrites = false;
    expect(await Future.wait([c.answerHome(day, 1), c.answerHome(day, 0)]), [
      true,
      false,
    ]);
    expect(c.homeAnswer(day)!['choice'], 1);
  });

  test('Old files load and malformed home history stays protected', () async {
    final store = MemoryProgressStore()
      ..value = jsonEncode(freshProgress()..remove('homeAnswers'));
    final c = LearningController(loadCourse(), store);
    await c.load();
    expect(c.ready, isTrue);
    expect(await c.answerHome(day, 2), isFalse);
    expect(await c.answerHome(day, 0), isTrue);
    final broken = c.snapshot;
    broken['homeAnswers']['2026-10-07']['choice'] = -1;
    store.value = jsonEncode(broken);
    await c.load();
    expect(c.ready, isFalse);
    expect(await c.answerHome(DateTime(2026, 10, 8), 0), isFalse);
    expect(store.value, jsonEncode(broken));
  });

  test('Daily rotation uses local dates and home history is bounded', () async {
    expect(
      homePromptFor(DateTime(2026, 10, 7, 0), homePrompts).id,
      homePromptFor(DateTime(2026, 10, 7, 23, 59), homePrompts).id,
    );
    expect(
      homePromptFor(day, homePrompts).id,
      isNot(homePromptFor(DateTime(2026, 10, 8), homePrompts).id),
    );
    expect(homePrompts.map((p) => p.id).toSet().length, homePrompts.length);
    final c = LearningController(loadCourse(), MemoryProgressStore());
    await c.load();
    for (final p in homePrompts) {
      expect(c.course.lesson(p.lessonId).id, p.lessonId);
      expect(p.options[p.answer], isNotEmpty);
    }
    for (var i = 0; i < 95; i++) {
      await c.answerHome(DateTime(2026, 7, 1 + i), 0);
    }
    expect((c.snapshot['homeAnswers'] as Map).length, 90);
    expect(c.homeAnswer(DateTime(2026, 7, 1)), isNull);
    expect(c.homeAnswer(DateTime(2026, 7, 95)), isNotNull);
  });

  testWidgets(
    'First home is interactive; feedback restores and opens its actual lesson',
    (tester) async {
      final store = MemoryProgressStore();
      var c = LearningController(loadCourse(), store);
      await c.load();
      await tester.pumpWidget(FinStepApp(controller: c));
      await tester.pumpAndSettle();
      expect(find.text('오늘의 한입'), findsOneWidget);
      expect(c.started, isFalse);
      final prompt = c.dailyPrompt(DateTime.now());
      final option = find.byKey(ValueKey('home-choice-${prompt.answer}'));
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pumpAndSettle();
      expect(find.text(prompt.takeaway), findsOneWidget);
      expect(find.text('바로 그거예요.'), findsOneWidget);
      expect(c.xp, 0);
      c = LearningController(c.course, store);
      await c.load();
      await tester.pumpWidget(FinStepApp(key: UniqueKey(), controller: c));
      await tester.pumpAndSettle();
      expect(find.text(prompt.takeaway), findsOneWidget);
      expect(find.byKey(const ValueKey('home-choice-0')), findsNothing);
      final lesson = find.byKey(const ValueKey('home-daily-lesson'));
      await tester.ensureVisible(lesson);
      await tester.tap(lesson);
      await tester.pumpAndSettle();
      expect(find.byType(LessonPlayer), findsOneWidget);
      expect(c.session(prompt.lessonId)!['phase'], 'read');
      expect(c.events, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Resume returns to saved review feedback without restarting', (
    tester,
  ) async {
    final c = LearningController(loadCourse(), MemoryProgressStore());
    await c.load();
    await c.start('K07');
    await finish(c, 'K07', wrong: true);
    await c.start('K07', review: true);
    await c.select('review:K07', 'A');
    await c.advance('review:K07');
    final before = c.snapshot;
    await tester.pumpWidget(FinStepApp(controller: c));
    await tester.pumpAndSettle();
    final resume = find.byKey(const ValueKey('home-resume'));
    await tester.ensureVisible(resume);
    await tester.tap(resume);
    await tester.pumpAndSettle();
    expect(find.byType(LessonPlayer), findsOneWidget);
    expect(c.snapshot, before);
    expect(c.resumeKey, 'review:K07');
  });

  testWidgets(
    'Completed course home links to review and has no next-lesson claim',
    (tester) async {
      final c = LearningController(loadCourse(), MemoryProgressStore());
      await c.load();
      for (final lesson in c.course.lessons) {
        await c.start(lesson.id);
        await finish(c, lesson.id);
      }
      await tester.pumpWidget(FinStepApp(controller: c));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('home-next-lesson')), findsNothing);
      final review = find.byKey(const ValueKey('home-course-complete'));
      await tester.ensureVisible(review);
      await tester.tap(review);
      await tester.pumpAndSettle();
      expect(find.text('짧게 복습'), findsOneWidget);
      expect(c.xp, 1500);
    },
  );

  testWidgets('All daily cards and feedback fit 320px with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final c = LearningController(loadCourse(), MemoryProgressStore());
    await c.load();
    for (var i = 0; i < homePrompts.length; i++) {
      final date = DateTime(2026, 10, 7 + i);
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
            body: PageBody([HomeFeed(c, date: date, onCourse: () {})]),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('home-choice-0')), findsOneWidget);
      final option = find.byKey(const ValueKey('home-choice-0'));
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pumpAndSettle();
      expect(
        find.text(c.dailyPrompt(date).takeaway).hitTestable(),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull, reason: c.dailyPrompt(date).id);
    }
  });
}
