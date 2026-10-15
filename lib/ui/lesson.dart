import 'package:flutter/material.dart';
import '../content/course.dart';
import '../state/progress.dart';
import 'theme.dart';
import 'explore.dart';

Future<void> beginLesson(
  BuildContext context,
  LearningController c,
  Lesson lesson, {
  bool review = false,
}) async {
  final ok = await c.start(lesson.id, review: review);
  if (ok && context.mounted) {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            LessonPlayer(c, review ? 'review:${lesson.id}' : lesson.id),
      ),
    );
  }
}

class LessonDetail extends StatelessWidget {
  const LessonDetail(this.c, this.lesson, {super.key});
  final LearningController c;
  final Lesson lesson;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: c,
    builder: (context, _) => Scaffold(
      appBar: FocusBar(
        '학습 안내',
        onBack: () => Navigator.pop(context),
        onClose: () => Navigator.pop(context),
      ),
      body: PageBody([
        Text(
          '${c.course.category(lesson.categoryId)['title']} · 퀴즈 ${c.course.practiceCount}개',
          style: F.meta,
        ),
        Text(lesson.title, style: F.title),
        Text(lesson.hook, style: F.heading),
        Text(
          '질문에서 시작해, 직접 확인하고\n앞에서 배운 내용과 이어가요.',
          style: F.body.copyWith(color: F.secondary),
        ),
        Text('이렇게 배워요', style: F.section),
        ...[
          ('01', '질문에서 시작', '한 가지 개념을 짧게 읽어요.'),
          ('02', '직접 확인', '다른 숫자와 예시에 적용해요.'),
          ('03', '개념 연결', '앞에서 배운 내용과 이어가요.'),
        ].map(
          (s) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 44, child: Text(s.$1, style: F.meta)),
              Expanded(
                child: VStack([
                  Text(s.$2, style: F.section),
                  Text(s.$3, style: F.label.copyWith(color: F.secondary)),
                ], gap: 4),
              ),
            ],
          ),
        ),
        if (lesson.prerequisites.isNotEmpty) ...[
          Text('앞에서 연결되는 개념', style: F.section),
          ...lesson.prerequisites.map(
            (id) => LinkRow(
              c.course.concept(id)['name_ko'],
              '필요할 때 다시 살펴봐요',
              onTap: () => openConcept(context, c, id),
            ),
          ),
        ],
        if (c.error != null) Note(c.error!),
      ]),
      bottomNavigationBar: Footer([
        ActionButton(
          c.session(lesson.id) != null &&
                  c.session(lesson.id)!['phase'] != 'complete'
              ? '이어서 학습하기'
              : c.completed.contains(lesson.id)
              ? '다시 학습하기'
              : '학습 시작하기',
          onTap: c.busy ? null : () => beginLesson(context, c, lesson),
        ),
      ]),
    ),
  );
}

class LessonPlayer extends StatefulWidget {
  const LessonPlayer(this.c, this.sessionKey, {super.key});
  final LearningController c;
  final String sessionKey;
  @override
  State<LessonPlayer> createState() => _PlayerState();
}

class _PlayerState extends State<LessonPlayer> {
  final scroll = ScrollController();
  LearningController get c => widget.c;
  Json get s => c.session(widget.sessionKey)!;
  Lesson get lesson => c.course.lesson(s['lesson']);
  Future<void> advance() async {
    if (await c.advance(widget.sessionKey)) {
      if (scroll.hasClients) scroll.jumpTo(0);
    }
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }

  Future<void> pause() async {
    if (c.busy) return;
    if (s['phase'] == 'complete') {
      Navigator.pop(context);
      return;
    }
    final exit = await showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          top: false,
          child: VStack([
            Text('여기서 잠깐 멈출까요?', style: F.heading),
            Text(
              '지금까지 저장한 위치에서\n다음에 바로 이어갈 수 있어요.',
              style: F.body.copyWith(color: F.secondary),
            ),
            ActionButton('계속 학습하기', onTap: () => Navigator.pop(context, false)),
            ActionButton(
              '저장하고 나가기',
              secondary: true,
              onTap: () => Navigator.pop(context, true),
            ),
          ]),
        ),
      ),
    );
    if (exit == true && mounted) Navigator.pop(context);
  }

  Future<void> back() async {
    if (s['phase'] == 'experiment') {
      await c.back(widget.sessionKey);
      if (scroll.hasClients) scroll.jumpTo(0);
    } else {
      await pause();
    }
  }

  void fullReading() => showReading(
    context,
    lesson.title,
    VStack([
      ...lesson.pages.map(
        (p) => VStack([Text(p['title'], style: F.heading), Copy(p['body'])]),
      ),
      if (List<Json>.from(
        c.course.data['sources'],
      ).any((x) => (x['used_for'] as List).contains(lesson.id)))
        Text('보완 참고자료', style: F.section),
      ...List<Json>.from(c.course.data['sources'])
          .where((x) => (x['used_for'] as List).contains(lesson.id))
          .map(
            (x) => VStack([
              Text('${x['organization']} · ${x['title']}', style: F.label),
              SelectableText(x['url'], style: F.meta),
            ], gap: 4),
          ),
    ]),
  );
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: c,
    builder: (context, _) {
      final phase = s['phase'] as String;
      final q = c.course.question(s['questions'][s['index']]);
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) pause();
        },
        child: Scaffold(
          appBar: FocusBar(
            phase == 'complete'
                ? '오늘의 학습 완료'
                : s['review']
                ? '짧게 복습'
                : lesson.title,
            onBack: back,
            onClose: pause,
          ),
          body: PageBody(controller: scroll, [
            Steps(
              phase == 'complete'
                  ? 2
                  : ['quiz', 'feedback'].contains(phase)
                  ? 1
                  : 0,
            ),
            if (c.error != null) Note(c.error!),
            ...switch (phase) {
              'read' => reading(),
              'experiment' => experiment(),
              'quiz' => quiz(q),
              'feedback' => feedback(q),
              'complete' => complete(),
              _ => [],
            },
          ]),
          bottomNavigationBar: Footer(
            phase == 'complete'
                ? [
                    if (!s['review'] &&
                        c.course.lessons.indexOf(lesson) <
                            c.course.lessons.length - 1)
                      ActionButton(
                        '다음 개념 배우기',
                        onTap: c.busy
                            ? null
                            : () async {
                                final next =
                                    c.course.lessons[c.course.lessons.indexOf(
                                          lesson,
                                        ) +
                                        1];
                                if (await c.start(next.id) && context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LessonPlayer(c, next.id),
                                    ),
                                  );
                                }
                              },
                      ),
                    ActionButton(
                      s['review']
                          ? '복습 마치기'
                          : c.completed.length == c.course.lessons.length
                          ? '코스 기록 보기'
                          : '오늘은 여기까지',
                      secondary: !s['review'],
                      onTap: () =>
                          Navigator.popUntil(context, (r) => r.isFirst),
                    ),
                  ]
                : [
                    ActionButton(
                      phase == 'read'
                          ? '작은 예시로 확인하기'
                          : phase == 'experiment'
                          ? '퀴즈 풀기'
                          : phase == 'quiz'
                          ? '정답 확인'
                          : s['index'] + 1 < (s['questions'] as List).length
                          ? '다음 문제'
                          : '배운 내용 정리하기',
                      onTap:
                          c.busy ||
                              phase == 'quiz' && (s['selected'] as List).isEmpty
                          ? null
                          : advance,
                    ),
                  ],
          ),
        ),
      );
    },
  );
  List<Widget> reading() {
    final brief = lesson.brief;
    return [
      Text(brief['title'], style: F.title),
      Text(brief['core'], style: F.body),
      CardBox(
        color: F.soft,
        border: false,
        child: VStack([
          Text('예를 들면', style: F.meta),
          Text(brief['example'], style: F.body),
          Text(brief['result'], style: F.section),
        ], gap: 10),
      ),
      Text(brief['remember'], style: F.meta),
      DetailLink('자세히 알아보기', onTap: fullReading),
    ];
  }

  List<Widget> quiz(QuizQuestion q) => [
    Text(
      '${s['review'] ? '복습' : '적용 퀴즈'} · ${s['index'] + 1} / ${(s['questions'] as List).length}',
      style: F.meta,
    ),
    Text(q.prompt, style: F.heading),
    if (q.data['assumptions'] != null)
      Text((q.data['assumptions'] as List).join(' '), style: F.meta),
    if (q.multi) Text('맞는 답을 모두 골라주세요.', style: F.label),
    ...q.options.entries.map((o) {
      final selected = (s['selected'] as List).contains(o.key);
      return Semantics(
        selected: selected,
        button: true,
        onTap: c.busy ? null : () => c.select(widget.sessionKey, o.key),
        label: '${o.key}. ${o.value}',
        excludeSemantics: true,
        child: Material(
          color: selected ? F.soft : Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            key: ValueKey('answer-${o.key}'),
            onTap: c.busy ? null : () => c.select(widget.sessionKey, o.key),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(minHeight: 56),
              decoration: BoxDecoration(
                border: Border.all(color: selected ? F.orange : F.line),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: F.neutral,
                      shape: BoxShape.circle,
                    ),
                    child: Text(o.key, style: F.meta.copyWith(color: F.ink)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(o.value, style: F.label)),
                  const SizedBox(width: 8),
                  Text(
                    selected
                        ? '✓'
                        : q.multi
                        ? '□'
                        : '○',
                    style: F.section,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }),
  ];
  List<Widget> feedback(QuizQuestion q) {
    final selected = List<String>.from(s['selected']);
    final correct = q.isCorrect(selected);
    return [
      Text(correct ? '맞아요!' : '이렇게 생각해봐요.', style: F.title),
      Text(
        '선택 ${selected.join(', ')} · 정답 ${q.answer.join(', ')}',
        style: F.meta,
      ),
      CardBox(
        color: correct ? F.soft : F.neutral,
        border: false,
        child: Text(
          !correct && !q.multi ? q.feedback(selected.first) : q.takeaway,
          style: F.body,
        ),
      ),
      if (!correct)
        Text(
          q.answer.map((key) => '$key. ${q.options[key]}').join('\n'),
          style: F.label,
        ),
      DetailLink(
        '해설과 관련 개념 보기',
        onTap: () => showReading(
          context,
          '자세한 해설',
          VStack([
            Copy(q.explanation),
            ...q.options.entries.map(
              (option) => VStack([
                Text('${option.key}. ${option.value}', style: F.label),
                Text(q.feedback(option.key), style: F.body),
              ], gap: 8),
            ),
            if (q.data['assumptions'] != null)
              Text((q.data['assumptions'] as List).join('\n'), style: F.meta),
            Text('관련 개념', style: F.section),
            ...q.remediation.map(
              (id) => LinkRow(
                c.course.concept(id)['name_ko'],
                '개념 다시 보기',
                onTap: () => openConcept(context, c, id),
              ),
            ),
          ]),
        ),
      ),
      if (!correct) Text('이 문제는 나중에 다시 볼 수 있어요.', style: F.meta),
    ];
  }

  List<Widget> complete() {
    final brief = lesson.brief;
    final needs = c.missed.any(
      (id) => c.course.question(id).lessonId == lesson.id,
    );
    return [
      Text(
        s['review'] ? '다른 문항에서도\n다시 살펴봤어요.' : '${lesson.title}\n개념을 연결해봤어요.',
        style: F.heading,
      ),
      Text(brief['core'], style: F.body),
      Text(
        needs
            ? '다시 확인할 문항을 복습에 남겼어요.'
            : s['review']
            ? '복습 문항의 해설까지 확인했어요.'
            : '설명과 확인 활동을 마쳤어요.',
        style: F.label.copyWith(color: F.secondary),
      ),
      CardBox(
        color: F.neutral,
        child: VStack([
          Row(
            children: [
              Expanded(child: Text('+${s['award']} XP', style: F.section)),
              Text('Lv.${c.level}', style: F.label),
            ],
          ),
          Text(
            s['review']
                ? '복습은 XP를 다시 지급하지 않아요.'
                : s['award'] == 0
                ? '이미 완료한 레슨이에요. 기록만 업데이트해요.'
                : '학습 참여 보상 · 이해도 점수와는 달라요.',
            style: F.meta,
          ),
        ], gap: 12),
      ),
      Row(
        children: [
          Expanded(child: Text('코스 진행', style: F.label)),
          Text(
            '${c.completed.length} / ${c.course.lessons.length} 완료',
            style: F.label,
          ),
        ],
      ),
      ProgressLine(c.completed.length / c.course.lessons.length),
      Text(
        '오늘 ${c.dailyCompleted(c.now)}개 완료 · 하루 목표 ${c.dailyGoal}개',
        style: F.section,
      ),
      if (c.reviewDueDay(lesson.id) != null)
        Text('다음 복습 추천 ${c.reviewDueDay(lesson.id)}', style: F.meta),
      if (c.course.lessons.indexOf(lesson) < c.course.lessons.length - 1)
        Text(
          c.course.lessons[c.course.lessons.indexOf(lesson) + 1].hook,
          style: F.label.copyWith(color: F.secondary),
        ),
    ];
  }

  List<Widget> experiment() {
    if (lesson.exercise == null) {
      final scenario = lesson.data['scenario'];
      return [
        Text('뉴스에서 만나면?', style: F.title),
        Text('실제 기사가 아닌 학습용 예시예요.', style: F.meta),
        CardBox(
          color: F.soft,
          border: false,
          child: VStack([
            Text('가상 뉴스', style: F.meta),
            Text(scenario['headline'], style: F.heading),
            Text(scenario['meaning'], style: F.body),
          ]),
        ),
        Text(lesson.brief['remember'], style: F.label),
        DetailLink('자세히 알아보기', onTap: fullReading),
      ];
    }
    final step = s['value'] as int;
    final exercise = lesson.exercise!;
    final e = exercise.data;
    final input = exercise.input(step);
    final result = exercise.result(step);
    final expression = switch (e['operation']) {
      'ownership' => '$input ÷ ${exercise.fixed} × 100',
      'split' ||
      'eps' ||
      'pe_eps' => '${number(exercise.fixed)} ÷ ${number(input)}',
      'market_cap' => '${number(exercise.fixed)} × $input',
      'profit' => '${number(exercise.fixed)} − ${number(input)}',
      'pe_price' => '${number(input)} ÷ ${number(exercise.fixed)}',
      _ => '',
    };
    return [
      Text(e['title'], style: F.heading),
      Text(
        '${e['fixed_label']} · ${number(exercise.fixed)}${e['fixed_unit']}',
        style: F.body,
      ),
      CardBox(
        child: VStack([
          Text(e['input_label'], style: F.meta),
          Row(
            children: [
              _step(
                '−',
                step > 1 ? () => c.setValue(widget.sessionKey, step - 1) : null,
              ),
              Expanded(
                child: Text(
                  '${number(input)}${e['input_unit']}',
                  style: F.heading,
                  textAlign: TextAlign.center,
                ),
              ),
              _step(
                '+',
                step < exercise.values.length
                    ? () => c.setValue(widget.sessionKey, step + 1)
                    : null,
                primary: true,
              ),
            ],
          ),
        ], gap: 10),
      ),
      CardBox(
        color: F.soft,
        border: false,
        child: VStack([
          Text(e['result_label'], style: F.meta),
          Text('${number(result)}${e['result_unit']}', style: F.title),
          Text('$expression = ${number(result)}', style: F.label),
        ], gap: 8),
      ),
      Text('학습용 가상 숫자예요. ${e['assumption']}', style: F.meta),
      DetailLink('자세히 알아보기', onTap: fullReading),
    ];
  }

  Widget _step(String label, VoidCallback? onTap, {bool primary = false}) =>
      Semantics(
        label: label == '+' ? '값 늘리기' : '값 줄이기',
        button: true,
        child: SizedBox(
          width: 44,
          height: 44,
          child: TextButton(
            onPressed: c.busy ? null : onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: primary ? F.orange : F.neutral,
              foregroundColor: F.ink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(label, style: F.heading),
          ),
        ),
      );
}

String number(num n) {
  final str = n % 1 == 0 ? n.toInt().toString() : n.toStringAsFixed(2);
  final parts = str.split('.');
  return '${parts.first.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}${parts.length > 1 ? '.${parts[1]}' : ''}';
}
