import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'progress.dart';

/// Separate file so profile edits cannot replace a learning snapshot.
class ProfileFileStore extends FileProgressStore {
  ProfileFileStore(super.directory);
  @override
  File get file => File('${directory.path}/profile-v1.json');
}

class ProfileController extends ChangeNotifier {
  ProfileController(this.store);
  final ProgressStore store;
  String nickname = '학습자';
  int avatar = 0;
  bool ready = false, busy = false;
  String? error;
  bool _disposed = false;
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  static String? nicknameError(String name) {
    final text = name.trim();
    if (text.isEmpty) return '닉네임을 입력해주세요.';
    if (text.characters.length > 16) return '닉네임은 16자까지 입력할 수 있어요.';
    if (RegExp(r'[\x00-\x1F\x7F]').hasMatch(text)) {
      return '줄바꿈이나 제어 문자는 사용할 수 없어요.';
    }
    return null;
  }

  Future<void> load() async {
    if (busy) return;
    busy = true;
    error = null;
    _notify();
    try {
      final raw = await store.read();
      if (raw != null) {
        final d = jsonDecode(raw);
        if (d is! Map ||
            d['version'] != 1 ||
            d['nickname'] is! String ||
            nicknameError(d['nickname']) != null ||
            d['avatar'] is! int ||
            d['avatar'] < 0 ||
            d['avatar'] > 3) {
          throw const FormatException('Invalid profile');
        }
        nickname = d['nickname'];
        avatar = d['avatar'];
      }
      ready = true;
    } catch (_) {
      ready = false;
      error = '프로필을 불러오지 못했어요. 다시 불러와주세요.';
    } finally {
      busy = false;
      _notify();
    }
  }

  Future<bool> save(String name, int selectedAvatar) async {
    if (!ready || busy) return false;
    error = nicknameError(name);
    if (error != null || selectedAvatar < 0 || selectedAvatar > 3) {
      error ??= '프로필 색상을 다시 골라주세요.';
      _notify();
      return false;
    }
    busy = true;
    _notify();
    try {
      final clean = name.trim();
      await store.write(
        jsonEncode({'version': 1, 'nickname': clean, 'avatar': selectedAvatar}),
      );
      nickname = clean;
      avatar = selectedAvatar;
      return true;
    } catch (_) {
      error = '프로필을 저장하지 못했어요. 다시 시도해주세요.';
      return false;
    } finally {
      busy = false;
      _notify();
    }
  }
}
