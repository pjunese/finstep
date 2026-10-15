import 'package:flutter/material.dart';
import '../state/account.dart';
import 'brand.dart';
import 'theme.dart';

void openLogin(BuildContext context, AccountController account) =>
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen(account)),
    );

class LoginScreen extends StatelessWidget {
  const LoginScreen(this.account, {super.key});
  final AccountController account;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: account,
    builder: (context, _) => Scaffold(
      appBar: FocusBar('로그인 · 회원가입', onBack: () => Navigator.pop(context)),
      body: PageBody([
        const BrandMark(size: 64),
        Text('작게 쌓은 배움,\n내 계정으로 이어가요.', style: F.title),
        Text(
          '사용하는 계정으로 간편하게 시작해요.',
          style: F.body.copyWith(color: F.secondary),
        ),
        if (!account.configured)
          const Note('로그인은 준비 중이에요. 지금은 가입 없이 학습할 수 있어요.'),
        const SizedBox(height: 8),
        for (final provider in LoginProvider.values)
          _ProviderButton(provider, account, () async {
            final ok = await account.signIn(provider);
            if (ok && context.mounted) Navigator.pop(context);
          }),
        if (account.message != null)
          Semantics(liveRegion: true, child: Note(account.message!)),
        Text(
          account.configured
              ? '처음 이용하는 계정이라면 가입 절차로 이어져요.'
              : '현재 학습 기록은 이 기기에 저장돼요.',
          style: F.meta,
        ),
      ]),
      bottomNavigationBar: Footer([
        ActionButton(
          '지금은 게스트로 계속하기',
          secondary: true,
          onTap: () => Navigator.pop(context),
        ),
      ]),
    ),
  );
}

class _ProviderButton extends StatelessWidget {
  const _ProviderButton(this.provider, this.account, this.onTap);
  final LoginProvider provider;
  final AccountController account;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final pending = account.pendingProvider == provider;
    final available = account.supports(provider);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        key: ValueKey('login-${provider.name}'),
        onPressed: account.busy ? null : onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: F.ink,
          minimumSize: const Size(0, 58),
          side: const BorderSide(color: F.line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                pending ? '${provider.label} 연결 중…' : '${provider.label}로 계속하기',
                style: F.label,
              ),
            ),
            if (pending)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Text(available ? '›' : '준비 중', style: F.meta),
          ],
        ),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen(this.account, {super.key});
  final AccountController account;
  Future<void> leave(BuildContext context, {bool delete = false}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(delete ? '계정을 삭제할까요?' : '로그아웃할까요?'),
        content: Text(
          delete
              ? '계정과 서버에 저장된 개인 데이터를 삭제해요. 삭제가 끝나면 되돌릴 수 없어요.'
              : '다시 로그인하면 계정을 이용할 수 있어요.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(delete ? '계정 삭제' : '로그아웃'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (delete) {
      await account.deleteAccount();
    } else {
      await account.signOut();
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: account,
    builder: (context, _) => Scaffold(
      appBar: FocusBar('계정 관리', onBack: () => Navigator.pop(context)),
      body: PageBody([
        Text(account.connected ? '연결된 계정' : '게스트로 이용 중이에요.', style: F.title),
        if (account.user case final user?) ...[
          CardBox(
            child: VStack([
              Text('${user.provider.label} 계정', style: F.section),
              if (user.email != null) Text(user.email!, style: F.body),
              if (user.displayName != null)
                Text(user.displayName!, style: F.meta),
            ]),
          ),
          ActionButton(
            '로그아웃',
            secondary: true,
            onTap: account.busy ? null : () => leave(context),
          ),
          DetailLink(
            '회원 탈퇴',
            onTap: () {
              if (!account.busy) leave(context, delete: true);
            },
          ),
        ] else ...[
          const Note('현재 기록은 이 기기에 저장돼요. 계정 로그인은 준비 중이에요.'),
          ActionButton(
            '로그인 · 회원가입',
            onTap: account.busy ? null : () => openLogin(context, account),
          ),
        ],
        if (account.message != null)
          Semantics(liveRegion: true, child: Note(account.message!)),
      ]),
    ),
  );
}
