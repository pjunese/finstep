import 'package:flutter/material.dart';
import '../content/course.dart';
import '../state/progress.dart';
import 'theme.dart';
import 'lesson.dart';

void openConcept(BuildContext context, LearningController c, String id) =>
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ConceptScreen(c, id)));
void openLesson(BuildContext context, LearningController c, Lesson lesson) =>
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => LessonDetail(c, lesson)));
void showReading(BuildContext context, String title, Widget content) =>
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: .88,
        child: Column(
          children: [
            FocusBar(title, onClose: () => Navigator.pop(context)),
            Expanded(child: PageBody([content])),
          ],
        ),
      ),
    );

class ConceptScreen extends StatelessWidget {
  const ConceptScreen(this.c, this.id, {super.key});
  final LearningController c;
  final String id;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: c,
    builder: (context, _) {
      final concept = c.course.concept(id), card = c.course.card(id);
      final related = c.course.edges
          .where((e) => e['from'] == id || e['to'] == id)
          .take(5)
          .toList();
      final lesson = c.course.lesson((concept['lesson_ids'] as List).first);
      return Scaffold(
        appBar: FocusBar('개념 상세', onBack: () => Navigator.pop(context)),
        body: PageBody([
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(concept['name_ko'], style: F.title)),
              const SizedBox(width: 8),
              ActionButton(
                c.saved.contains(id) ? '저장됨' : '저장',
                compact: true,
                secondary: true,
                onTap: c.busy ? null : () => c.toggleSaved(id),
              ),
            ],
          ),
          Text(
            '${c.course.category(lesson.categoryId)['title']} · ${concept['name_en']}',
            style: F.meta,
          ),
          Text(
            card?['one_liner'] ?? concept['short_definition'],
            style: F.body,
          ),
          if (card?['formula'] != null || concept['formula'] != null)
            CardBox(
              color: F.neutral,
              border: false,
              child: VStack([
                Text('핵심 관계', style: F.meta),
                Text(card?['formula'] ?? concept['formula'], style: F.label),
              ], gap: 10),
            ),
          if (concept['basis_note'] != null)
            Text(concept['basis_note'], style: F.meta),
          if (card?['remember'] != null) Note(card!['remember']),
          if (card?['not_equal_to'] != null)
            Text('구분해서 보기 · ${card!['not_equal_to']}', style: F.label),
          Text('관련 개념', style: F.section),
          ...related.map((e) {
            final other = e['from'] == id ? e['to'] : e['from'];
            return LinkRow(
              c.course.concept(other)['name_ko'],
              e['label_ko'],
              onTap: () => openConcept(context, c, other),
            );
          }),
          if (c.error != null) Note(c.error!),
        ]),
        bottomNavigationBar: Footer([
          ActionButton(
            '이 개념 학습하기',
            onTap: () => openLesson(context, c, lesson),
          ),
        ]),
      );
    },
  );
}

class SearchScreen extends StatefulWidget {
  const SearchScreen(this.c, {super.key, this.initialSavedOnly = false});
  final bool initialSavedOnly;
  final LearningController c;
  @override
  State<SearchScreen> createState() => _SearchState();
}

class _SearchState extends State<SearchScreen> {
  final input = TextEditingController();
  String? category;
  late bool savedOnly = widget.initialSavedOnly;
  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: widget.c,
    builder: (context, _) {
      final c = widget.c, q = input.text.trim().toLowerCase();
      final results = c.course.concepts
          .where(
            (x) =>
                (!savedOnly || c.saved.contains(x['concept_id'])) &&
                (category == null || x['category_id'] == category) &&
                ('${x['name_ko']} ${x['name_en']} ${x['short_definition']} ${c.course.category(x['category_id'])['title']}'
                    .toLowerCase()
                    .contains(q)),
          )
          .toList();
      return Scaffold(
        appBar: FocusBar('개념 찾기', onBack: () => Navigator.pop(context)),
        body: PageBody([
          Text('어떤 개념이\n궁금한가요?', style: F.title),
          TextField(
            controller: input,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: '개념 이름 검색',
              hintStyle: F.label.copyWith(color: F.secondary),
              prefixIcon: const Padding(
                padding: EdgeInsets.all(14),
                child: AppIcon('search'),
              ),
              filled: true,
              fillColor: F.neutral,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['시가총액', 'ETF', '환율']
                .map(
                  (s) => ActionButton(
                    s,
                    compact: true,
                    secondary: true,
                    onTap: () {
                      setState(() {
                        input.text = s;
                      });
                    },
                  ),
                )
                .toList(),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              ChoiceChip(
                label: const Text('전체'),
                selected: category == null,
                onSelected: (_) => setState(() => category = null),
              ),
              for (final group in c.course.categories)
                ChoiceChip(
                  label: Text(group['title']),
                  selected: category == group['id'],
                  onSelected: (_) => setState(() => category = group['id']),
                ),
            ],
          ),
          ActionButton(
            savedOnly ? '전체 개념 보기' : '저장한 개념',
            secondary: true,
            onTap: () => setState(() => savedOnly = !savedOnly),
          ),
          Text(
            '${savedOnly ? '저장한 개념' : '검색 결과'} · ${results.length}개',
            style: F.section,
          ),
          if (results.isEmpty)
            Note(
              savedOnly
                  ? '아직 저장한 개념이 없어요. 개념 상세에서 저장할 수 있어요.'
                  : '일치하는 개념이 없어요. 다른 이름으로 찾아보세요.',
            ),
          ...results.map(
            (x) => LinkRow(
              x['name_ko'],
              c.course.card(x['concept_id'])?['one_liner'] ??
                  x['short_definition'],
              onTap: () => openConcept(context, c, x['concept_id']),
            ),
          ),
        ]),
      );
    },
  );
}

class Connections extends StatefulWidget {
  const Connections(this.c, {super.key});
  final LearningController c;
  @override
  State<Connections> createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {
  String focus = 'C50_01';
  @override
  Widget build(BuildContext context) {
    final c = widget.c;
    final concept = c.course.concept(focus);
    final related = c.course.edges.where(
      (e) => e['from'] == focus || e['to'] == focus,
    );
    return VStack([
      Text('개념끼리 이어봐요', style: F.heading),
      Text('궁금한 개념을 고르면 함께 알아둘 개념이 보여요.', style: F.label),
      DropdownButtonFormField<String>(
        key: ValueKey(focus),
        initialValue: focus,
        isExpanded: true,
        decoration: const InputDecoration(
          labelText: '중심 개념 선택',
          border: OutlineInputBorder(),
        ),
        items: [
          for (final x in c.course.concepts)
            DropdownMenuItem(
              value: x['concept_id'] as String,
              child: Text(x['name_ko'], overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: (id) {
          if (id != null) setState(() => focus = id);
        },
      ),
      CardBox(
        color: F.soft,
        border: false,
        child: VStack([
          Text(
            c.course.category(concept['category_id'])['title'],
            style: F.meta,
          ),
          Text(concept['name_ko'], style: F.heading),
          Text(concept['short_definition'], style: F.body),
          ActionButton(
            '개념 자세히',
            secondary: true,
            onTap: () => openConcept(context, c, focus),
          ),
        ]),
      ),
      Center(child: Icon(Icons.account_tree_outlined, color: F.orange)),
      Text('함께 이해할 개념 · ${related.length}개', style: F.section),
      ...related.map((e) {
        final id = e['from'] == focus ? e['to'] : e['from'];
        final x = c.course.concept(id);
        return LinkRow(
          x['name_ko'],
          x['short_definition'],
          onTap: () => setState(() => focus = id),
        );
      }),
      const Note('연결은 학습에 도움이 되는 관계예요. 가격의 움직임을 예측하는 표시는 아니에요.'),
      ActionButton(
        '50개 개념 찾아보기',
        secondary: true,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SearchScreen(c)),
        ),
      ),
    ]);
  }
}
