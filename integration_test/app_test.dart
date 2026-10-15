import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:finstep/content/course.dart';
import 'package:finstep/main.dart';
import 'package:finstep/state/progress.dart';
import 'package:finstep/state/profile.dart';
import 'package:finstep/state/account.dart';
import 'package:finstep/ui/brand.dart';
import 'package:finstep/ui/theme.dart';
import 'package:finstep/ui/lesson.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'Native learning loop, wrong-answer feedback, disk restore and screenshots',
    (tester) async {
      final course = await Course.load();
      course.validate();
      final base = await getApplicationSupportDirectory();
      final qa = await Directory(
        '${base.path}/finstep-qa',
      ).create(recursive: true);
      final dir = await qa.createTemp('run-');
      final store = FileProgressStore(dir);
      var testNow = DateTime.now();
      final c = LearningController(course, store, clock: () => testNow);
      await c.load();
      final profile = ProfileController(ProfileFileStore(dir));
      final account = AccountController(const UnconfiguredAuthGateway());
      await Future.wait([profile.load(), account.restore()]);
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: F.theme,
          home: const BrandSplash(),
        ),
      );
      await tester.pumpAndSettle();
      if (Platform.isAndroid) {
        await binding.convertFlutterSurfaceToImage();
        await tester.pumpAndSettle();
      }
      final prefix = Platform.isIOS ? 'ios' : 'android';
      Future<void> capture(String name) async {
        await tester.pumpAndSettle();
        await Future<void>.delayed(const Duration(milliseconds: 400));
        await binding.takeScreenshot(name);
      }

      await capture('$prefix-brand');
      await tester.pumpWidget(
        FinStepApp(controller: c, profile: profile, account: account),
      );
      await tester.pumpAndSettle();
      await capture('$prefix-home-fresh');
      final goal = find.byKey(const ValueKey('change-daily-goal'));
      await tester.ensureVisible(goal);
      await tester.tap(goal);
      await tester.pumpAndSettle();
      await capture('$prefix-daily-goal');
      await tester.tap(find.byKey(const ValueKey('daily-goal-2')));
      await tester.pumpAndSettle();
      expect(c.dailyGoal, 2);
      final day = testNow;
      final prompt = c.dailyPrompt(day);
      final option = find.byKey(const ValueKey('home-choice-0'));
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pumpAndSettle();
      expect(find.text(prompt.takeaway), findsOneWidget);
      expect(c.xp, 0);
      expect(c.events, isEmpty);
      await capture('$prefix-home-discovery');
      final next = find.byKey(const ValueKey('home-next-lesson'));
      await tester.ensureVisible(next);
      await tester.tap(next);
      await tester.pumpAndSettle();
      await capture('$prefix-reading');
      while (c.session('K07')!['phase'] != 'complete') {
        final s = c.session('K07')!;
        if (s['phase'] == 'quiz') {
          final q = course.question(s['questions'][s['index']]);
          final option = s['index'] == 0
              ? q.options.keys.firstWhere((k) => !q.answer.contains(k))
              : q.answer.first;
          final choice = find.byKey(ValueKey('answer-$option'));
          await tester.ensureVisible(choice);
          await tester.tap(choice);
          await tester.pumpAndSettle();
          if (s['index'] == 0) await capture('$prefix-quiz');
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
        if (c.session('K07')!['phase'] == 'feedback' &&
            c.session('K07')!['index'] == 0) {
          await capture('$prefix-feedback');
        }
      }
      expect(c.xp, 30);
      expect(c.missed, ['Q_K07_001']);
      await capture('$prefix-complete');
      await tester.tap(find.text('오늘은 여기까지'));
      await tester.pumpAndSettle();
      await capture('$prefix-home');
      final restored = LearningController(course, store, clock: () => testNow);
      await restored.load();
      expect(restored.completed, ['K07']);
      expect(restored.xp, 30);
      expect(restored.events.length, 2);
      expect(restored.homeAnswer(day)!['choice'], 0);
      expect(restored.dailyGoal, 2);
      expect(restored.dailyCompleted(day), 1);
      expect(restored.reviewDueDay('K07'), isNotNull);
      await tester.pumpWidget(
        FinStepApp(
          key: UniqueKey(),
          controller: restored,
          profile: profile,
          account: account,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('오늘의 한입'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('마이'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('프로필 수정'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('nickname')), '한 걸음');
      await tester.tap(find.byKey(const ValueKey('avatar-1')));
      await tester.tap(find.text('저장하기'));
      await tester.pumpAndSettle();
      expect(find.text('한 걸음'), findsOneWidget);
      final diskProfile = ProfileController(ProfileFileStore(dir));
      await diskProfile.load();
      expect(diskProfile.nickname, '한 걸음');
      expect(diskProfile.avatar, 1);
      diskProfile.dispose();
      await capture('$prefix-mypage');
      final login = find.text('로그인 · 회원가입');
      await tester.ensureVisible(login);
      await tester.tap(login);
      await tester.pumpAndSettle();
      await capture('$prefix-login');
      await tester.tap(find.byKey(const ValueKey('login-google')));
      await tester.pumpAndSettle();
      expect(account.connected, isFalse);
      expect(account.message, contains('준비 중'));
      expect(restored.xp, 30);
      await tester.tap(find.text('지금은 게스트로 계속하기'));
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('학습'));
      await tester.pumpAndSettle();
      await capture('$prefix-map');
      await tester.tap(find.text('개념 연결'));
      await tester.pumpAndSettle();
      await capture('$prefix-connections');
      await restored.start('K01');
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: F.theme,
          home: LessonPlayer(restored, 'K01'),
        ),
      );
      await tester.pumpAndSettle();
      await capture('$prefix-short-core');
      await tester.tap(find.text('자세히 알아보기  ›'));
      await tester.pumpAndSettle();
      expect(restored.session('K01')!['phase'], 'read');
      await capture('$prefix-optional-detail');
      await tester.tap(find.byTooltip('닫기').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('작은 예시로 확인하기'));
      await tester.pumpAndSettle();
      expect(restored.session('K01')!['phase'], 'experiment');
      expect(find.text('10,000원'), findsOneWidget);
      await tester.tap(find.text('+'));
      await tester.pumpAndSettle();
      expect(find.text('20,000원'), findsOneWidget);
      await capture('$prefix-small-numbers');
      // Reopen on a later local day and follow the actual home recommendation.
      testNow = DateTime(day.year, day.month, day.day + 1, 10);
      await tester.pumpWidget(
        FinStepApp(
          key: UniqueKey(),
          controller: restored,
          profile: profile,
          account: account,
        ),
      );
      await tester.pumpAndSettle();
      expect(restored.dailyCompleted(testNow), 0);
      final todayStudy = find.byKey(const ValueKey('start-today-study'));
      await tester.ensureVisible(todayStudy);
      await capture('$prefix-study-plan');
      await tester.tap(todayStudy);
      await tester.pumpAndSettle();
      expect(restored.session('review:K07')!['phase'], 'quiz');
      while (restored.session('review:K07')!['phase'] != 'complete') {
        final session = restored.session('review:K07')!;
        if (session['phase'] == 'quiz') {
          final question = course.question(
            session['questions'][session['index']],
          );
          final answer = find.byKey(
            ValueKey('answer-${question.answer.first}'),
          );
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
      }
      expect(restored.dailyCompleted(testNow), 1);
      expect(restored.missed, isEmpty);
      expect(restored.xp, 30);
      expect(restored.reviewsDue(testNow), isEmpty);
      await capture('$prefix-review-complete');
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      profile.dispose();
      account.dispose();
      c.dispose();
      restored.dispose();
      await dir.delete(recursive: true);
    },
  );
}
