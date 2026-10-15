import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:finstep/state/account.dart';
import 'package:finstep/state/profile.dart';
import 'package:finstep/state/progress.dart';

// Only test code may simulate a verified provider response.
class TestGateway implements AuthGateway {
  @override
  Set<LoginProvider> availableProviders = {LoginProvider.google};
  AccountUser? restored;
  Object? failure;
  Completer<AccountUser>? pending;
  int calls = 0;
  @override
  Future<AccountUser?> restore() async {
    if (failure != null) throw failure!;
    return restored;
  }

  @override
  Future<AccountUser> signIn(LoginProvider provider) async {
    calls++;
    if (failure != null) throw failure!;
    if (pending != null) return pending!.future;
    return AccountUser(id: 'verified-test-id', provider: provider);
  }

  @override
  Future<void> signOut() async {
    if (failure != null) throw failure!;
  }

  @override
  Future<void> deleteAccount() async {
    if (failure != null) throw failure!;
  }
}

void main() {
  test(
    'Unconfigured providers never authenticate or create an account',
    () async {
      final account = AccountController(const UnconfiguredAuthGateway());
      await account.restore();
      for (final provider in LoginProvider.values) {
        expect(await account.signIn(provider), isFalse);
        expect(account.connected, isFalse);
        expect(account.message, contains('준비 중'));
      }
      final gateway = TestGateway();
      final configured = AccountController(gateway);
      expect(await configured.signIn(LoginProvider.kakao), isFalse);
      expect(gateway.calls, 0);
    },
  );

  test(
    'Provider cancellation and failure keep guest state and allow retry',
    () async {
      final gateway = TestGateway()
        ..failure = const AuthException(AuthFailure.cancelled);
      final account = AccountController(gateway);
      expect(await account.signIn(LoginProvider.google), isFalse);
      expect(account.message, isNull);
      gateway.failure = StateError('Do not expose SDK details');
      expect(await account.signIn(LoginProvider.google), isFalse);
      expect(account.message, isNot(contains('SDK')));
      expect(account.connected, isFalse);
      gateway.failure = null;
      expect(await account.signIn(LoginProvider.google), isTrue);
      expect(account.user!.id, 'verified-test-id');
    },
  );

  test(
    'Repeated login taps send one request and reject invalid identities',
    () async {
      final gateway = TestGateway()..pending = Completer<AccountUser>();
      final account = AccountController(gateway);
      final first = account.signIn(LoginProvider.google);
      expect(account.busy, isTrue);
      expect(await account.signIn(LoginProvider.google), isFalse);
      expect(gateway.calls, 1);
      gateway.pending!.complete(
        const AccountUser(id: '', provider: LoginProvider.google),
      );
      expect(await first, isFalse);
      expect(account.connected, isFalse);
      gateway.pending = Completer<AccountUser>();
      final second = account.signIn(LoginProvider.google);
      gateway.pending!.complete(
        const AccountUser(id: 'wrong-provider', provider: LoginProvider.naver),
      );
      expect(await second, isFalse);
      expect(account.busy, isFalse);
    },
  );

  test(
    'Restore uses gateway identity; failed deletion or logout retains it',
    () async {
      final gateway = TestGateway()
        ..restored = const AccountUser(
          id: 'server-id',
          provider: LoginProvider.google,
        );
      final account = AccountController(gateway);
      await account.restore();
      expect(account.user!.id, 'server-id');
      gateway.failure = const AuthException(AuthFailure.failed);
      expect(await account.deleteAccount(), isFalse);
      expect(account.connected, isTrue);
      expect(await account.signOut(), isFalse);
      expect(account.connected, isTrue);
      gateway.failure = null;
      expect(await account.deleteAccount(), isTrue);
      expect(account.connected, isFalse);
      await account.restore();
      expect(await account.signOut(), isTrue);
      expect(account.connected, isFalse);
    },
  );

  test('Invalid restored account is never accepted', () async {
    final account = AccountController(
      TestGateway()
        ..restored = const AccountUser(id: ' ', provider: LoginProvider.google),
    );
    await account.restore();
    expect(account.connected, isFalse);
    expect(account.message, isNotNull);
  });

  test(
    'Profile persists to disk independently from learning records',
    () async {
      final dir = await Directory.systemTemp.createTemp(
        'finstep-profile-test-',
      );
      addTearDown(() => dir.delete(recursive: true));
      final learning = FileProgressStore(dir);
      await learning.write('existing-learning-record');
      final store = ProfileFileStore(dir);
      final profile = ProfileController(store);
      await profile.load();
      expect(await profile.save('  작은 배움  ', 2), isTrue);
      final restored = ProfileController(store);
      await restored.load();
      expect(restored.nickname, '작은 배움');
      expect(restored.avatar, 2);
      expect(await learning.read(), 'existing-learning-record');
    },
  );

  test(
    'Failed profile write preserves old values and can be retried',
    () async {
      final store = MemoryProgressStore();
      final profile = ProfileController(store);
      await profile.load();
      await profile.save('처음', 1);
      final saved = store.value;
      store.failWrites = true;
      expect(await profile.save('다음', 3), isFalse);
      expect(profile.nickname, '처음');
      expect(profile.avatar, 1);
      expect(store.value, saved);
      store.failWrites = false;
      expect(await profile.save('다음', 3), isTrue);
      expect(profile.error, isNull);
    },
  );

  test(
    'Corrupt profile is not overwritten; nickname limits use graphemes',
    () async {
      final store = MemoryProgressStore()..value = '{broken';
      final profile = ProfileController(store);
      await profile.load();
      expect(profile.ready, isFalse);
      expect(await profile.save('덮어쓰기', 0), isFalse);
      expect(store.value, '{broken');
      expect(ProfileController.nicknameError('   '), isNotNull);
      expect(ProfileController.nicknameError('가' * 17), isNotNull);
      expect(ProfileController.nicknameError('👨‍👩‍👧' * 16), isNull);
      expect(ProfileController.nicknameError('가\n나'), isNotNull);
      store.value = null;
      await profile.load();
      expect(await profile.save('다시 시작', 4), isFalse);
      expect(await profile.save('다시 시작', 0), isTrue);
    },
  );
}
