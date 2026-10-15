import 'package:flutter/material.dart';
import '../state/progress.dart';
import 'lesson.dart';
import 'theme.dart';

Future<void> showDailyGoal(
  BuildContext context,
  LearningController c,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (sheetContext) => SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AnimatedBuilder(
        animation: c,
        builder: (context, _) => VStack([
          Text('하루에 얼마나 배울까요?', style: F.heading),
          Text('새 개념이나 복습을 끝까지 마치면 1개예요. 같은 개념은 하루에 한 번만 세어요.', style: F.body),
          for (final goal in [1, 2, 3])
            ActionButton(
              key: ValueKey('daily-goal-$goal'),
              '하루 $goal개${c.dailyGoal == goal ? ' · 현재 목표' : ''}',
              secondary: c.dailyGoal != goal,
              onTap: c.busy
                  ? null
                  : () async {
                      if (await c.setDailyGoal(goal) && sheetContext.mounted) {
                        Navigator.pop(sheetContext);
                      }
                    },
            ),
          if (c.error != null) Note(c.error!),
          Text('언제든 바꿀 수 있어요. 목표를 채운 뒤에도 자유롭게 학습할 수 있어요.', style: F.meta),
        ]),
      ),
    ),
  ),
);

class DailyStudyCard extends StatelessWidget {
  const DailyStudyCard(this.c, this.day, {super.key});
  final LearningController c;
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final done = c.dailyCompleted(day);
    final reached = done >= c.dailyGoal;
    final reviews = c.reviewsDue(day);
    final next = reviews.isNotEmpty
        ? c.course.lesson(reviews.first.lessonId)
        : c.completed.length < c.course.lessons.length
        ? c.nextLesson
        : null;
    return CardBox(
      key: const ValueKey('daily-study-card'),
      child: VStack([
        Wrap(
          spacing: 12,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('오늘의 학습', style: F.section),
            TextButton(
              key: const ValueKey('change-daily-goal'),
              onPressed: c.busy ? null : () => showDailyGoal(context, c),
              child: Text('목표 바꾸기', style: F.label),
            ),
          ],
        ),
        Text(
          reached ? '오늘 목표를 채웠어요' : '오늘 $done / ${c.dailyGoal}개',
          style: F.heading,
        ),
        Semantics(
          label: '오늘 학습 $done개, 목표 ${c.dailyGoal}개',
          child: ProgressLine((done / c.dailyGoal).clamp(0, 1)),
        ),
        Text(
          reached
              ? '$done개를 끝까지 마쳤어요. 더 배우고 싶으면 아래에서 이어가세요.'
              : '새 개념이나 복습을 끝까지 마치면 기록돼요. 한입 질문은 준비 운동이에요.',
          style: F.label,
        ),
        if (!reached && next != null) ...[
          Text(
            reviews.isNotEmpty
                ? '추천 복습 · ${next.title}\n${reviews.first.reason}'
                : '새로 배울 개념 · ${next.title}',
            style: F.label,
          ),
          ActionButton(
            key: const ValueKey('start-today-study'),
            reviews.isNotEmpty ? '추천 개념 복습하기' : '오늘 학습 시작하기',
            onTap: c.busy
                ? null
                : () =>
                      beginLesson(context, c, next, review: reviews.isNotEmpty),
          ),
        ],
        if (!reached && next == null)
          Text('지금 추천할 복습은 없어요. 배운 개념은 마이페이지에서 언제든 다시 볼 수 있어요.', style: F.meta),
      ], gap: 12),
    );
  }
}
