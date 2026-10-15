import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finstep/main.dart';
import 'package:finstep/state/account.dart';
import 'package:finstep/state/profile.dart';
import 'package:finstep/state/progress.dart';
import 'package:finstep/ui/account.dart';
import 'package:finstep/ui/brand.dart';
import 'package:finstep/ui/profile.dart';
import 'package:finstep/ui/theme.dart';
import 'content_test.dart' show loadCourse;

void main() {
  testWidgets(
    'My page saves profile and opens saved-only concepts and history',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final learning = LearningController(loadCourse(), MemoryProgressStore());
      await learning.load();
      await learning.start('K07');
      await learning.toggleSaved('C50_01');
      final store = MemoryProgressStore();
      final profile = ProfileController(store);
      await profile.load();
      await tester.pumpWidget(
        FinStepApp(controller: learning, profile: profile),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('마이'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('프로필 수정'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const ValueKey('nickname')), '한 걸음');
      await tester.tap(find.byKey(const ValueKey('avatar-2')));
      await tester.tap(find.text('저장하기'));
      await tester.pumpAndSettle();
      expect(find.text('한 걸음'), findsOneWidget);
      expect(profile.avatar, 2);
      final restored = ProfileController(store);
      await restored.load();
      expect(restored.nickname, '한 걸음');
      final saved = find.widgetWithText(MenuRow, '저장한 개념');
      await tester.ensureVisible(saved);
      await tester.tap(saved);
      await tester.pumpAndSettle();
      expect(find.text('저장한 개념 · 1개'), findsOneWidget);
      await tester.tap(find.byTooltip('뒤로'));
      await tester.pumpAndSettle();
      final history = find.widgetWithText(MenuRow, '학습 기록');
      await tester.ensureVisible(history);
      await tester.tap(history);
      await tester.pumpAndSettle();
      expect(find.text('학습 기록'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Unconfigured login is transparent and returns to guest learning',
    (tester) async {
      final learning = LearningController(loadCourse(), MemoryProgressStore());
      await learning.load();
      final before = learning.snapshot;
      await tester.pumpWidget(FinStepApp(controller: learning));
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('마이'));
      await tester.pumpAndSettle();
      final link = find.text('로그인 · 회원가입');
      await tester.ensureVisible(link);
      await tester.tap(link);
      await tester.pumpAndSettle();
      for (final provider in LoginProvider.values) {
        final button = find.byKey(ValueKey('login-${provider.name}'));
        await tester.ensureVisible(button);
        await tester.tap(button);
        await tester.pumpAndSettle();
        expect(
          find.text('${provider.label} 로그인은 준비 중이에요. 지금은 가입 없이 학습할 수 있어요.'),
          findsOneWidget,
        );
      }
      await tester.tap(find.text('지금은 게스트로 계속하기'));
      await tester.pumpAndSettle();
      expect(find.text('마이페이지'), findsOneWidget);
      expect(learning.snapshot, before);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Account screens and splash support 320px with large text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final learning = LearningController(loadCourse(), MemoryProgressStore());
    final profile = ProfileController(MemoryProgressStore());
    final account = AccountController(const UnconfiguredAuthGateway());
    await Future.wait([learning.load(), profile.load()]);
    Widget host(Widget child) => MaterialApp(
      theme: F.theme,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(1.5)),
        child: child!,
      ),
      home: child,
    );
    for (final screen in [
      const BrandSplash(),
      BrandSplash(failed: true, onRetry: () {}),
      Scaffold(body: PageBody([MyPage(learning, profile, account)])),
      LoginScreen(account),
      ProfileEditor(profile),
      SettingsScreen(profile, account),
      AccountScreen(account),
    ]) {
      await tester.pumpWidget(host(screen));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '${screen.runtimeType}');
    }
  });
}
