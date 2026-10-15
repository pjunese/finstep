import 'dart:async';
import 'package:flutter/material.dart';
import '../state/progress.dart';
import 'theme.dart';
import 'lesson.dart';
import 'explore.dart';

class LearningHistoryScreen extends StatelessWidget {
  const LearningHistoryScreen(this.c, {super.key});
  final LearningController c;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: c,
    builder: (context, _) => Scaffold(
      appBar: FocusBar('학습 기록', onBack: () => Navigator.pop(context)),
      body: PageBody([
        Text('${c.completed.length}개의 레슨을\n차근차근 마쳤어요.', style: F.title),
        ProgressLine(c.completed.length / c.course.lessons.length),
        Text(
          '${c.completed.length} / ${c.course.lessons.length} 완료 · ${c.xp} XP',
          style: F.meta,
        ),
        if (c.completed.isEmpty) const Note('첫 학습을 마치면 여기에 기록이 남아요.'),
        ...c.completed.reversed.map(
          (id) => LinkRow(
            c.course.lesson(id).title,
            c.missed.any((q) => c.course.question(q).lessonId == id)
                ? '다시 확인할 문항이 있어요'
                : c.newEvidence(id) > 0
                ? '새 복습 문항 ${c.newEvidence(id)}개 확인'
                : '학습 완료',
            marker: '✓',
            onTap: () => openLesson(context, c, c.course.lesson(id)),
          ),
        ),
        if (c.legacy != null) ...[
          const Divider(),
          Text('이전 기초 과정 기록', style: F.section),
          Text(
            '이전 과정 ${c.legacy!['completed'].length}개 완료 · ${c.legacyXp} XP 보존',
            style: F.label,
          ),
          const Note('새 핵심 50 과정은 별도로 시작해요. 이전의 완료·저장·응답 기록은 그대로 보관했어요.'),
          ...List<String>.from(c.legacy!['completed']).map(
            (id) => Text(
              '✓ ${c.course.previous!.lesson(id).title}',
              style: F.label,
            ),
          ),
          if ((c.legacy!['saved'] as List).isNotEmpty)
            Text(
              '이전 저장 개념 · ${List<String>.from(c.legacy!['saved']).map((id) => c.course.previous!.concept(id)['name_ko']).join(', ')}',
              style: F.meta,
            ),
          Text(
            '이전 퀴즈 응답 ${c.legacy!['events'].length}개 · 남은 오답 ${c.legacy!['missed'].length}개',
            style: F.meta,
          ),
          if (c.legacy!['lastSession'] != null &&
              c.legacy!['sessions'][c.legacy!['lastSession']]['phase'] !=
                  'complete')
            Text(
              '이전 과정에서 보던 개념 · ${c.course.previous!.lesson(c.legacy!['sessions'][c.legacy!['lastSession']]['lesson']).title}',
              style: F.meta,
            ),
        ],
        Text('XP는 학습 참여 기록이에요.', style: F.meta),
      ]),
    ),
  );
}

class ReviewScreen extends StatefulWidget {
  const ReviewScreen(this.c, {super.key});
  final LearningController c;
  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen>
    with WidgetsBindingObserver {
  LearningController get c => widget.c;
  Timer? midnight;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    schedule();
  }

  void schedule() {
    midnight?.cancel();
    final now = c.now;
    midnight = Timer(
      DateTime(now.year, now.month, now.day + 1).difference(now) +
          const Duration(seconds: 1),
      refresh,
    );
  }

  void refresh() {
    if (!mounted) return;
    setState(() {});
    schedule();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) refresh();
  }

  @override
  void dispose() {
    midnight?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: c,
    builder: (context, _) {
      final due = c.reviewsDue(c.now);
      final suggestions = {for (final item in due) item.lessonId: item};
      final lessons = {
        ...suggestions.keys,
        ...c.reviewLessons.map((l) => l.id),
        ...c.completed,
      }.map(c.course.lesson).toList();
      return Scaffold(
        appBar: FocusBar('짧게 복습', onBack: () => Navigator.pop(context)),
        body: PageBody([
          Text('다른 문항에서도\n구분해볼까요?', style: F.title),
          Text(
            due.isEmpty
                ? '오늘 추천할 복습은 없어요. 원하는 개념을 자유롭게 다시 볼 수 있어요.'
                : '오늘 다시 볼 개념 ${due.length}개를 먼저 모았어요. 오답이 있는 개념부터 확인해요.',
            style: F.body.copyWith(color: F.secondary),
          ),
          if (c.error != null) Note(c.error!),
          if (lessons.isEmpty) const Note('학습을 시작하면 다시 볼 레슨을 여기서 찾을 수 있어요.'),
          ...lessons.map((l) {
            final resume = c.session('review:${l.id}');
            return CardBox(
              child: VStack([
                Text(
                  suggestions[l.id]?.reason ??
                      (c.reviewDueDay(l.id) != null
                          ? '다음 추천 ${c.reviewDueDay(l.id)} · 지금도 복습할 수 있어요'
                          : '학습한 레슨'),
                  style: F.meta,
                ),
                Text(l.title, style: F.heading),
                Text(l.hook, style: F.label),
                ActionButton(
                  resume != null && resume['phase'] != 'complete'
                      ? '복습 이어하기'
                      : '다른 문항으로 복습하기',
                  onTap: c.busy
                      ? null
                      : () => beginLesson(context, c, l, review: true),
                ),
              ]),
            );
          }),
          const Note('복습은 XP를 다시 지급하지 않아요. 처음 본 문항과 해설을 본 문항의 응답을 따로 기록해요.'),
          const Note(
            '첫 학습 다음 날부터 다시 볼 개념을 추천해요. 복습을 모두 맞히면 3일·7일·14일·30일로 간격을 늘리고, 헷갈리면 다음 날 다시 추천해요. 알림을 보내는 기능은 아니에요.',
          ),
        ]),
      );
    },
  );
}
