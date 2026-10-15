import 'package:flutter/material.dart';
import '../state/account.dart';
import '../state/profile.dart';
import '../state/progress.dart';
import 'account.dart';
import 'brand.dart';
import 'explore.dart';
import 'records.dart';
import 'theme.dart';
import 'study_plan.dart';

const avatarColors = [
  F.orange,
  Color(0xffbee4d4),
  Color(0xffb9d8f1),
  Color(0xffd8c7ee),
];
const avatarNames = ['살구', '민트', '하늘', '라일락'];

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar(this.avatar, {super.key, this.size = 64});
  final int avatar;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: avatarColors[avatar],
      borderRadius: BorderRadius.circular(size * .32),
    ),
    child: Icon(Icons.person_outline_rounded, color: F.ink, size: size * .5),
  );
}

class MyPage extends StatelessWidget {
  const MyPage(this.learning, this.profile, this.account, {super.key});
  final LearningController learning;
  final ProfileController profile;
  final AccountController account;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([learning, profile, account]),
    builder: (context, _) => VStack([
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileAvatar(profile.avatar),
          const SizedBox(width: 16),
          Expanded(
            child: VStack([
              Text(
                profile.nickname,
                style: F.heading,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                account.connected
                    ? '${account.user!.provider.label} 계정'
                    : '게스트 · 이 기기에 저장 중',
                style: F.meta,
              ),
            ], gap: 4),
          ),
          IconButton(
            tooltip: '프로필 수정',
            onPressed: profile.ready
                ? () => openProfileEditor(context, profile)
                : null,
            icon: const Icon(Icons.edit_outlined, size: 22),
          ),
        ],
      ),
      if (profile.error != null) ...[
        Note(profile.error!),
        if (!profile.ready)
          ActionButton(
            '프로필 다시 불러오기',
            secondary: true,
            onTap: profile.busy ? null : profile.load,
          ),
      ],
      const SizedBox(height: 8),
      MenuRow(
        '하루 학습 목표',
        '하루 ${learning.dailyGoal}개 · 새 개념과 복습',
        Icons.flag_outlined,
        () => showDailyGoal(context, learning),
      ),
      Row(
        children: [
          Expanded(child: _Stat('${learning.completed.length}', '마친 레슨')),
          const SizedBox(width: 10),
          Expanded(child: _Stat('${learning.saved.length}', '저장한 개념')),
          const SizedBox(width: 10),
          Expanded(child: _Stat('${learning.xp}', '학습 XP')),
        ],
      ),
      CardBox(
        color: F.soft,
        border: false,
        child: VStack([
          Text('하나씩 쌓이는 나의 배움', style: F.section),
          Text(
            'Lv.${learning.level} · ${learning.xp % 100}/100 XP',
            style: F.label,
          ),
          ProgressLine((learning.xp % 100) / 100),
          Text('XP는 학습 참여 기록이에요.', style: F.meta),
        ], gap: 10),
      ),
      if (!account.connected)
        CardBox(
          child: VStack([
            Text('내 계정으로 이어가기', style: F.section),
            Text(
              '계정 기능을 준비하고 있어요.\n지금은 이 기기에서 배움을 쌓아보세요.',
              style: F.label.copyWith(color: F.secondary),
            ),
            ActionButton(
              '로그인 · 회원가입',
              onTap: () => openLogin(context, account),
            ),
          ], gap: 12),
        ),
      Text('나의 학습', style: F.section),
      MenuRow(
        '학습 기록',
        '${learning.completed.length}개 레슨 완료',
        Icons.history_rounded,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LearningHistoryScreen(learning)),
        ),
      ),
      MenuRow(
        '오답 복습',
        learning.missed.isEmpty
            ? '현재 남은 오답이 없어요'
            : '${learning.missed.length}개 문항 다시 확인',
        Icons.replay_rounded,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ReviewScreen(learning)),
        ),
      ),
      MenuRow(
        '저장한 개념',
        '${learning.saved.length}개 모아보기',
        Icons.bookmark_outline_rounded,
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SearchScreen(learning, initialSavedOnly: true),
          ),
        ),
      ),
      const Divider(),
      MenuRow(
        '설정',
        '프로필 · 계정 · 앱 정보',
        Icons.settings_outlined,
        () => openSettings(context, profile, account),
      ),
    ]),
  );
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label);
  final String value, label;
  @override
  Widget build(BuildContext context) => CardBox(
    padding: 10,
    child: VStack(
      [
        Text(value, style: F.heading),
        Text(label, style: F.meta, textAlign: TextAlign.center),
      ],
      gap: 4,
      cross: CrossAxisAlignment.center,
    ),
  );
}

class MenuRow extends StatelessWidget {
  const MenuRow(this.title, this.subtitle, this.icon, this.onTap, {super.key});
  final String title, subtitle;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: F.neutral,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 21, color: F.ink),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: VStack([
                Text(title, style: F.label),
                Text(subtitle, style: F.meta),
              ], gap: 3),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: F.secondary,
            ),
          ],
        ),
      ),
    ),
  );
}

void openProfileEditor(BuildContext context, ProfileController profile) =>
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfileEditor(profile)),
    );

class ProfileEditor extends StatefulWidget {
  const ProfileEditor(this.profile, {super.key});
  final ProfileController profile;
  @override
  State<ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends State<ProfileEditor> {
  late final input = TextEditingController(text: widget.profile.nickname);
  late int selected = widget.profile.avatar;
  final form = GlobalKey<FormState>();
  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.profile,
    builder: (context, _) => Scaffold(
      appBar: FocusBar('프로필 수정', onBack: () => Navigator.pop(context)),
      body: PageBody([
        Text('나를 부를 이름을\n정해볼까요?', style: F.title),
        Center(child: ProfileAvatar(selected, size: 88)),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (var i = 0; i < avatarColors.length; i++)
              Semantics(
                button: true,
                selected: selected == i,
                label: '${avatarNames[i]} 프로필',
                child: InkWell(
                  key: ValueKey('avatar-$i'),
                  onTap: widget.profile.busy
                      ? null
                      : () => setState(() => selected = i),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selected == i ? F.ink : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ProfileAvatar(i, size: 40),
                  ),
                ),
              ),
          ],
        ),
        Form(
          key: form,
          child: TextFormField(
            key: const ValueKey('nickname'),
            controller: input,
            maxLength: 16,
            enabled: !widget.profile.busy,
            decoration: const InputDecoration(
              labelText: '닉네임',
              hintText: '1~16자로 입력해주세요.',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            validator: (value) => ProfileController.nicknameError(value ?? ''),
          ),
        ),
        Text('닉네임과 프로필 색상은 이 기기에 저장돼요.', style: F.meta),
        if (widget.profile.error != null) Note(widget.profile.error!),
        if (!widget.profile.ready)
          ActionButton(
            '프로필 다시 불러오기',
            secondary: true,
            onTap: widget.profile.busy ? null : widget.profile.load,
          ),
      ]),
      bottomNavigationBar: Footer([
        ActionButton(
          widget.profile.busy ? '저장 중…' : '저장하기',
          onTap: widget.profile.busy || !widget.profile.ready
              ? null
              : () async {
                  if (!form.currentState!.validate()) return;
                  if (await widget.profile.save(input.text, selected) &&
                      context.mounted) {
                    Navigator.pop(context);
                  }
                },
        ),
      ]),
    ),
  );
}

void openSettings(
  BuildContext context,
  ProfileController profile,
  AccountController account,
) => Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => SettingsScreen(profile, account)),
);

class SettingsScreen extends StatelessWidget {
  const SettingsScreen(this.profile, this.account, {super.key});
  final ProfileController profile;
  final AccountController account;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: FocusBar('설정', onBack: () => Navigator.pop(context)),
    body: PageBody([
      Text('내게 맞게,\n편하게 배워요.', style: F.title),
      MenuRow(
        '프로필 수정',
        '닉네임과 프로필 색상',
        Icons.person_outline_rounded,
        () => openProfileEditor(context, profile),
      ),
      MenuRow(
        '계정 관리',
        '로그인 상태와 연결 계정',
        Icons.manage_accounts_outlined,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AccountScreen(account)),
        ),
      ),
      MenuRow(
        '데이터 보관 안내',
        '학습 기록은 어디에 저장되나요?',
        Icons.folder_outlined,
        () => showReading(
          context,
          '데이터 보관 안내',
          VStack([
            Text('지금은 이 기기에 저장해요.', style: F.heading),
            const Text('닉네임, 프로필 색상, 학습 진도, 오답과 저장한 개념을 이 기기의 앱 저장 공간에 보관해요.'),
            const Text(
              '현재 버전은 계정 서버로 기록을 보내지 않아요. 기기를 바꾸거나 앱을 삭제하면 기록을 복원하지 못할 수 있어요.',
            ),
            const Text('계정에 저장하는 기능은 준비 중이에요.'),
          ]),
        ),
      ),
      MenuRow(
        '자주 묻는 질문',
        '학습 · 복습 · XP',
        Icons.help_outline_rounded,
        () => showReading(
          context,
          '자주 묻는 질문',
          VStack([
            Text('회원가입을 해야 하나요?', style: F.section),
            const Text('가입 없이 모든 현재 레슨을 학습할 수 있어요.'),
            Text('틀리면 다음 레슨을 못 하나요?', style: F.section),
            const Text('틀려도 다음으로 갈 수 있어요. 헷갈린 문제는 오답 복습에서 다시 볼 수 있어요.'),
            Text('XP는 무엇인가요?', style: F.section),
            const Text('첫 레슨 완료에 30 XP가 쌓여요. 이해도나 투자 실력을 판정하는 점수는 아니에요.'),
            Text('자세한 설명은 어디에 있나요?', style: F.section),
            const Text('레슨의 ‘자세히 알아보기’나 퀴즈의 ‘해설과 관련 개념 보기’를 눌러보세요.'),
          ]),
        ),
      ),
      MenuRow(
        '앱 정보',
        '핀스텝 0.5.0',
        Icons.info_outline_rounded,
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AboutFinStep()),
        ),
      ),
    ]),
  );
}

class AboutFinStep extends StatelessWidget {
  const AboutFinStep({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: FocusBar('앱 정보', onBack: () => Navigator.pop(context)),
    body: PageBody([
      const BrandMark(),
      Text('핀스텝', style: F.title),
      Text('하나씩 배우고, 조금씩 연결해요.', style: F.body),
      Text('버전 0.5.0 · 미리보기', style: F.meta),
      const Divider(),
      const Text('짧은 핵심과 작은 예시로 투자 개념을 연결해보는 학습 앱이에요.'),
      DetailLink(
        '오픈소스 라이선스',
        onTap: () => showLicensePage(
          context: context,
          applicationName: '핀스텝',
          applicationVersion: '0.5.0',
        ),
      ),
    ]),
  );
}
