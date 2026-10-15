import 'package:flutter/foundation.dart';

enum LoginProvider {
  google('Google'),
  kakao('카카오'),
  naver('네이버'),
  apple('Apple');

  const LoginProvider(this.label);
  final String label;
}

/// Public account data only. Tokens belong in the future SDK/secure adapter.
class AccountUser {
  const AccountUser({
    required this.id,
    required this.provider,
    this.displayName,
    this.email,
  });
  final String id;
  final LoginProvider provider;
  final String? displayName, email;
}

enum AuthFailure { unavailable, cancelled, failed }

class AuthException implements Exception {
  const AuthException(this.reason);
  final AuthFailure reason;
}

/// A real adapter must return only a server-verified identity, restore its
/// secure session, and complete server deletion before deleteAccount returns.
abstract interface class AuthGateway {
  Set<LoginProvider> get availableProviders;
  Future<AccountUser?> restore();
  Future<AccountUser> signIn(LoginProvider provider);
  Future<void> signOut();
  Future<void> deleteAccount();
}

/// Default until provider credentials AND a verified backend are connected.
/// This adapter never creates a local pretend account or emits a success.
class UnconfiguredAuthGateway implements AuthGateway {
  const UnconfiguredAuthGateway();
  @override
  Set<LoginProvider> get availableProviders => const {};
  @override
  Future<AccountUser?> restore() async => null;
  @override
  Future<AccountUser> signIn(LoginProvider provider) async =>
      throw const AuthException(AuthFailure.unavailable);
  @override
  Future<void> signOut() async =>
      throw const AuthException(AuthFailure.unavailable);
  @override
  Future<void> deleteAccount() async =>
      throw const AuthException(AuthFailure.unavailable);
}

class AccountController extends ChangeNotifier {
  AccountController(this.gateway);
  final AuthGateway gateway;
  AccountUser? user;
  bool busy = false;
  LoginProvider? pendingProvider;
  String? message;
  bool get connected => user != null;
  bool get configured => gateway.availableProviders.isNotEmpty;
  bool supports(LoginProvider provider) =>
      gateway.availableProviders.contains(provider);
  bool _disposed = false;
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> restore() async {
    if (busy) return;
    busy = true;
    message = null;
    _notify();
    try {
      final restored = await gateway.restore();
      if (restored != null && restored.id.trim().isEmpty) {
        throw const AuthException(AuthFailure.failed);
      }
      user = restored;
    } catch (_) {
      message = '로그인 상태를 확인하지 못했어요. 다시 로그인해주세요.';
    } finally {
      busy = false;
      _notify();
    }
  }

  Future<bool> signIn(LoginProvider provider) async {
    if (busy || connected) return false;
    message = null;
    if (!supports(provider)) {
      message = '${provider.label} 로그인은 준비 중이에요. 지금은 가입 없이 학습할 수 있어요.';
      _notify();
      return false;
    }
    busy = true;
    pendingProvider = provider;
    _notify();
    try {
      final confirmed = await gateway.signIn(provider);
      if (confirmed.id.trim().isEmpty || confirmed.provider != provider) {
        throw const AuthException(AuthFailure.failed);
      }
      user = confirmed;
      return true;
    } on AuthException catch (e) {
      if (e.reason != AuthFailure.cancelled) {
        message = e.reason == AuthFailure.unavailable
            ? '아직 로그인할 수 없어요. 잠시 후 다시 시도해주세요.'
            : '로그인하지 못했어요. 다시 시도해주세요.';
      }
      return false;
    } catch (_) {
      message = '로그인하지 못했어요. 연결 상태를 확인하고 다시 시도해주세요.';
      return false;
    } finally {
      busy = false;
      pendingProvider = null;
      _notify();
    }
  }

  Future<bool> signOut() => _leave(delete: false);
  Future<bool> deleteAccount() => _leave(delete: true);
  Future<bool> _leave({required bool delete}) async {
    if (busy || user == null) return false;
    busy = true;
    message = null;
    _notify();
    try {
      if (delete) {
        await gateway.deleteAccount();
      } else {
        await gateway.signOut();
      }
      user = null;
      return true;
    } catch (_) {
      message = delete
          ? '계정을 삭제하지 못했어요. 다시 시도해주세요.'
          : '로그아웃하지 못했어요. 다시 시도해주세요.';
      return false;
    } finally {
      busy = false;
      _notify();
    }
  }
}
