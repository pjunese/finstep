import 'dart:async';
import 'package:flutter/material.dart';
import '../content/course.dart';
import '../content/home_prompts.dart';
import '../state/progress.dart';
import 'lesson.dart';
import 'records.dart';
import 'theme.dart';
import 'study_plan.dart';

/// The home can be used immediately, including before the first course session.
class HomeFeed extends StatefulWidget {
  const HomeFeed(this.c, {super.key, required this.onCourse, this.date});
  final LearningController c;
  final VoidCallback onCourse;
  final DateTime? date; // Fixed local date for deterministic previews/tests.
  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> with WidgetsBindingObserver {
  late DateTime today;
  Timer? midnight;
  final feedbackKey = GlobalKey();
  LearningController get c => widget.c;
  @override
  void initState() {
    super.initState();
    today = widget.date ?? c.now;
    WidgetsBinding.instance.addObserver(this);
    scheduleDay();
  }

  void scheduleDay() {
    midnight?.cancel();
    if (widget.date != null) return;
    final now = c.now;
    final next = DateTime(now.year, now.month, now.day + 1);
    midnight = Timer(
      next.difference(now) + const Duration(seconds: 1),
      refreshDay,
    );
  }

  void refreshDay() {
    if (!mounted) return;
    setState(() => today = widget.date ?? c.now);
    scheduleDay();
  }

  @override
  void didUpdateWidget(HomeFeed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.date != widget.date) {
      today = widget.date ?? c.now;
      scheduleDay();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) refreshDay();
  }

  @override
  void dispose() {
    midnight?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void review() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => ReviewScreen(c)),
  );

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: c,
    builder: (context, _) {
      final prompt = c.dailyPrompt(today);
      final answer = c.homeAnswer(today);
      final resume = c.resumeKey;
      final finished = c.completed.length == c.course.lessons.length;
      final due = c.reviewsDue(today);
      final otherLessons = c.course.lessons
          .where((l) => l.id != c.nextLesson.id && l.id != prompt.lessonId)
          .toList();
      otherLessons.sort(
        (a, b) => (c.completed.contains(a.id) ? 1 : 0).compareTo(
          c.completed.contains(b.id) ? 1 : 0,
        ),
      );
      return VStack([
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                '돈 공부도,\n한 입부터.',
                style: F.text(30, weight: FontWeight.w700, height: 1.3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                '${today.month}.${today.day.toString().padLeft(2, '0')} ${['월', '화', '수', '목', '금', '토', '일'][today.weekday - 1]}요일',
                style: F.meta,
              ),
            ),
          ],
        ),
        Text('주식·경제 핵심 50 · 하루 한 개념', style: F.meta),
        if (resume != null) _ResumeCard(c, resume),
        _DailyCard(c, prompt, today, answer, feedbackKey),
        DailyStudyCard(c, today),
        _SectionTitle('나의 다음 한 걸음', action: '전체 보기', onTap: widget.onCourse),
        if (!finished)
          _NextLesson(c, c.nextLesson)
        else
          _HomeLink(
            key: const ValueKey('home-course-complete'),
            icon: Icons.done_all_rounded,
            title: '핵심 50개를 모두 만났어요',
            subtitle: '배운 개념을 다른 문항으로 연결해봐요.',
            onTap: c.busy ? null : review,
          ),
        if (c.missed.isNotEmpty || due.isNotEmpty)
          _HomeLink(
            key: const ValueKey('home-review'),
            icon: Icons.replay_rounded,
            title: due.isNotEmpty
                ? '오늘 다시 볼 개념 ${due.length}개'
                : '헷갈린 것, 한 번만 더',
            subtitle: '남은 오답 ${c.missed.length}문항 · 내 속도로 복습해요.',
            onTap: c.busy ? null : review,
          ),
        if (otherLessons.isNotEmpty) ...[
          const _SectionTitle('이런 것도 궁금하지 않나요?'),
          LayoutBuilder(
            builder: (context, box) {
              final narrow =
                  box.maxWidth < 310 ||
                  MediaQuery.textScalerOf(context).scale(14) > 18;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final entry in otherLessons.take(2).indexed)
                    SizedBox(
                      width: narrow ? box.maxWidth : (box.maxWidth - 12) / 2,
                      child: _TopicCard(c, entry.$2, entry.$1),
                    ),
                ],
              );
            },
          ),
        ],
        _WeekActivity(c, today),
        const SizedBox(height: 4),
      ], gap: 20);
    },
  );
}

class _DailyCard extends StatelessWidget {
  const _DailyCard(
    this.c,
    this.prompt,
    this.day,
    this.answer,
    this.feedbackKey,
  );
  final LearningController c;
  final HomePrompt prompt;
  final DateTime day;
  final Json? answer;
  final GlobalKey feedbackKey;
  @override
  Widget build(BuildContext context) {
    final chosen = answer?['choice'] as int?;
    return Container(
      key: const ValueKey('home-daily-card'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: F.soft,
        borderRadius: BorderRadius.circular(26),
      ),
      child: VStack([
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: F.orange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lightbulb_outline_rounded,
                size: 20,
                color: F.ink,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text('오늘의 한입', style: F.section)),
            if (chosen != null)
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xff36745d),
                semanticLabel: '오늘 참여 완료',
              )
            else
              Text('질문 하나', style: F.meta),
          ],
        ),
        Text(prompt.title, style: F.heading),
        LayoutBuilder(
          builder: (context, box) {
            final narrow =
                box.maxWidth < 250 ||
                MediaQuery.textScalerOf(context).scale(12) > 17;
            final facts = [
              for (final fact in prompt.facts)
                Container(
                  width: narrow ? box.maxWidth : (box.maxWidth - 10) / 2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .8),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: VStack([
                    Text(fact.$1, style: F.meta),
                    Text(
                      fact.$2,
                      style: F.label.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ], gap: 4),
                ),
            ];
            return Wrap(spacing: 10, runSpacing: 10, children: facts);
          },
        ),
        if (chosen == null) ...[
          Text('어떻게 생각하세요?', style: F.meta),
          for (var i = 0; i < prompt.options.length; i++)
            _Choice(
              prompt.options[i],
              i,
              onTap: c.busy
                  ? null
                  : () async {
                      if (await c.answerHome(day, i) && context.mounted) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          final target = feedbackKey.currentContext;
                          if (target != null && target.mounted) {
                            Scrollable.ensureVisible(
                              target,
                              alignment: .12,
                              duration: const Duration(milliseconds: 240),
                              curve: Curves.easeOut,
                            );
                          }
                        });
                      }
                    },
            ),
        ] else ...[
          Semantics(
            key: feedbackKey,
            liveRegion: true,
            child: VStack([
              Text(
                chosen == prompt.answer ? '바로 그거예요.' : '이렇게 생각해보세요.',
                style: F.section.copyWith(color: const Color(0xff7c3c19)),
              ),
              Text(prompt.takeaway, style: F.label),
              Text('내 선택 · ${prompt.options[chosen]}', style: F.meta),
            ], gap: 8),
          ),
          ActionButton(
            c.session(prompt.lessonId) != null &&
                    c.session(prompt.lessonId)!['phase'] != 'complete'
                ? '이어서 알아보기'
                : '이유를 짧게 알아보기',
            key: const ValueKey('home-daily-lesson'),
            onTap: c.busy
                ? null
                : () =>
                      beginLesson(context, c, c.course.lesson(prompt.lessonId)),
          ),
        ],
      ], gap: 14),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice(this.text, this.index, {required this.onTap});
  final String text;
  final int index;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    child: InkWell(
      key: ValueKey('home-choice-$index'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: F.neutral,
                shape: BoxShape.circle,
              ),
              child: Text(index == 0 ? 'A' : 'B', style: F.meta),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: F.label)),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 17,
              color: F.secondary,
            ),
          ],
        ),
      ),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.action, this.onTap});
  final String title;
  final String? action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(title, style: F.section)),
      if (action != null)
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: F.secondary,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: Text('$action  ›', style: F.meta),
        ),
    ],
  );
}

class _NextLesson extends StatelessWidget {
  const _NextLesson(this.c, this.lesson);
  final LearningController c;
  final Lesson lesson;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      key: const ValueKey('home-next-lesson'),
      borderRadius: BorderRadius.circular(20),
      onTap: c.busy ? null : () => beginLesson(context, c, lesson),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: VStack([
          Row(
            children: [
              Expanded(
                child: Text(
                  '${c.course.category(lesson.categoryId)['title']}',
                  style: F.meta,
                ),
              ),
              Text(
                '${c.completed.length}/${c.course.lessons.length} 완료',
                style: F.meta,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text(lesson.hook, style: F.section)),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: F.orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_rounded, size: 20),
              ),
            ],
          ),
          Text('짧은 핵심 → 작은 예시 → 퀴즈 ${c.course.practiceCount}개', style: F.meta),
        ], gap: 12),
      ),
    ),
  );
}

class _ResumeCard extends StatelessWidget {
  const _ResumeCard(this.c, this.sessionKey);
  final LearningController c;
  final String sessionKey;
  @override
  Widget build(BuildContext context) {
    final session = c.session(sessionKey)!;
    final lesson = c.course.lesson(session['lesson']);
    final phase = switch (session['phase']) {
      'read' => '핵심 읽는 중',
      'experiment' => '작은 예시 보는 중',
      _ =>
        '퀴즈 ${session['index'] + 1}/${(session['questions'] as List).length}',
    };
    return _HomeLink(
      key: const ValueKey('home-resume'),
      icon: Icons.play_arrow_rounded,
      title: '아까 보던 곳부터 이어가요',
      subtitle: '${lesson.title} · ${session['review'] ? '복습 · ' : ''}$phase',
      onTap: c.busy
          ? null
          : () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LessonPlayer(c, sessionKey)),
            ),
    );
  }
}

class _HomeLink extends StatelessWidget {
  const _HomeLink({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
  final IconData icon;
  final String title, subtitle;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: F.soft,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: VStack([
                Text(title, style: F.label),
                Text(subtitle, style: F.meta),
              ], gap: 4),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: F.secondary,
            ),
          ],
        ),
      ),
    ),
  );
}

class _TopicCard extends StatelessWidget {
  const _TopicCard(this.c, this.lesson, this.position);
  final LearningController c;
  final Lesson lesson;
  final int position;
  @override
  Widget build(BuildContext context) => Material(
    color: position == 0 ? const Color(0xffeaf2ed) : const Color(0xffedf1f8),
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      key: ValueKey('home-topic-${lesson.id}'),
      borderRadius: BorderRadius.circular(20),
      onTap: c.busy ? null : () => beginLesson(context, c, lesson),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: VStack([
          Icon(
            lesson.categoryId == 'G1'
                ? Icons.pie_chart_outline_rounded
                : Icons.calculate_outlined,
            size: 26,
          ),
          Text(lesson.hook.replaceAll('\n', ' '), style: F.section),
          Row(
            children: [
              Expanded(child: Text(lesson.title, style: F.meta)),
              const Icon(Icons.arrow_forward_rounded, size: 17),
            ],
          ),
        ], gap: 14),
      ),
    ),
  );
}

class _WeekActivity extends StatelessWidget {
  const _WeekActivity(this.c, this.today);
  final LearningController c;
  final DateTime today;
  @override
  Widget build(BuildContext context) {
    final monday = DateTime(
      today.year,
      today.month,
      today.day - today.weekday + 1,
    );
    final dates = List.generate(
      7,
      (i) => DateTime(monday.year, monday.month, monday.day + i),
    );
    final days = c.activeDays;
    final count = dates
        .where((d) => !d.isAfter(today) && days.contains(localDay(d)))
        .length;
    return CardBox(
      border: false,
      padding: 20,
      child: VStack([
        Text('이번 주, 작은 발자국', style: F.section),
        Text(
          count == 0 ? '가벼운 한입으로 첫 발자국을 남겨봐요.' : '$count일, 배움에 들렀어요.',
          style: F.label,
        ),
        Row(
          children: [
            for (var i = 0; i < dates.length; i++)
              Expanded(
                child: Semantics(
                  label:
                      '${dates[i].month}월 ${dates[i].day}일 ${days.contains(localDay(dates[i])) && !dates[i].isAfter(today) ? '학습 참여' : '참여 기록 없음'}',
                  excludeSemantics: true,
                  child: VStack(
                    [
                      Text(
                        ['월', '화', '수', '목', '금', '토', '일'][i],
                        style: F.meta,
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              days.contains(localDay(dates[i])) &&
                                  !dates[i].isAfter(today)
                              ? F.orange
                              : F.neutral,
                          shape: BoxShape.circle,
                          border: localDay(dates[i]) == localDay(today)
                              ? Border.all(color: F.ink, width: 1.2)
                              : null,
                        ),
                        child:
                            days.contains(localDay(dates[i])) &&
                                !dates[i].isAfter(today)
                            ? const Icon(Icons.check_rounded, size: 16)
                            : const SizedBox.shrink(),
                      ),
                    ],
                    gap: 8,
                    cross: CrossAxisAlignment.center,
                  ),
                ),
              ),
          ],
        ),
        Text('한입 질문에 답하거나 퀴즈를 푼 날이에요.', style: F.meta),
      ], gap: 14),
    );
  }
}
