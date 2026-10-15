import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:finstep/content/course.dart';
import 'package:finstep/content/home_prompts.dart';
import '../tool/import_content.dart' show buildCore50;

Course loadCourse() =>
    Course(jsonDecode(File('assets/data/course.json').readAsStringSync()));
void main() {
  test(
    'Exactly the supplied 50 concepts are partitioned into seven coherent categories',
    () {
      final c = loadCourse();
      c.validate();
      expect(
        c.concepts.map((x) => x['original_number']).toSet(),
        Set.of(List.generate(50, (i) => i + 1)),
      );
      expect(c.categories.map((g) => c.inCategory(g['id']).length), [
        9,
        9,
        3,
        4,
        9,
        10,
        6,
      ]);
      for (final entry in {
        'K17': 'G1',
        'K24': 'G1',
        'K03': 'G2',
        'K18': 'G2',
        'K40': 'G4',
        'K46': 'G6',
        'K45': 'G7',
      }.entries) {
        expect(c.lesson(entry.key).categoryId, entry.value);
      }
      expect(c.lessons.length, 50);
      expect(c.questions.length, 150);
      for (final x in c.concepts) {
        expect(
          c.edges.any(
            (e) => e['from'] == x['concept_id'] || e['to'] == x['concept_id'],
          ),
          isTrue,
        );
      }
    },
  );
  test('Runtime catalog is reproducible from the reviewed Markdown source', () {
    final generated = buildCore50(
      File('08_Core_50_Data.md').readAsStringSync(),
      jsonDecode(File('docs/archive/course-v0.3.0.json').readAsStringSync()),
    );
    expect(generated, loadCourse().data);
    expect(loadCourse().previous!.data, generated['previous_course']);
  });
  test(
    'Every concept has concise core, optional details, distinct quiz and home prompts',
    () {
      final c = loadCourse();
      final home = promptsFor(c);
      expect(home.length, 50);
      expect(home.map((p) => p.id).toSet().length, 50);
      for (final l in c.lessons) {
        expect(l.brief['core'].length, lessThanOrEqualTo(65), reason: l.id);
        expect(l.pages.first['body'], isNotEmpty);
        expect(l.data['scenario']['meaning'], isNotEmpty);
        final qs = c.forLesson(l.id);
        expect(qs.length, c.practiceCount + 1);
        expect(qs.map((q) => q.prompt).toSet().length, 3);
        expect(
          qs.map((q) => q.prompt),
          isNot(contains(home.singleWhere((p) => p.lessonId == l.id).title)),
        );
        for (final q in qs) {
          expect(q.prompt.length, lessThanOrEqualTo(85));
          expect(q.isCorrect(q.answer), isTrue);
          expect(
            q.isCorrect([
              q.options.keys.firstWhere((k) => !q.answer.contains(k)),
            ]),
            isFalse,
          );
        }
      }
    },
  );
  test(
    'Examples and all quiz money stay small; interactive calculations are exact',
    () {
      final c = loadCourse();
      for (final l in c.lessons) {
        final exercise = l.exercise;
        if (exercise == null) continue;
        for (var i = 1; i <= exercise.values.length; i++) {
          expect(exercise.input(i), inInclusiveRange(1, 100000));
          expect(exercise.result(i), inInclusiveRange(0, 100000));
          expect(exercise.result(i) % 1, 0);
        }
      }
      expect(c.lesson('K01').exercise!.result(1), 10000);
      expect(c.lesson('K11').exercise!.result(1), 2000);
      final text = jsonEncode([
        c.data['lessons'],
        c.data['questions'],
        c.data['home_prompts'],
      ]);
      expect(RegExp(r'[0-9]\s*(억|조|만 주)').hasMatch(text), isFalse);
      for (final m in RegExp(r'([0-9][0-9,]*)원').allMatches(text)) {
        expect(int.parse(m[1]!.replaceAll(',', '')), lessThanOrEqualTo(100000));
      }
    },
  );
  test('High-risk misconceptions have unambiguous corrected answers', () {
    final c = loadCourse();
    const answers = {
      'Q_K08_003': '배당락',
      'Q_K13_002': '부채',
      'Q_K14_002': '주가가 BPS보다 낮음',
      'Q_K18_002': '현금 자산을 따로 봐요',
      'Q_K23_001': '발행사의 신용위험',
      'Q_K28_001': '다음 화요일',
      'Q_K37_001': '만기 채권 원금 재투자 축소',
      'Q_K39_001': '2%',
      'Q_K41_003': '전년 감소지만 예상은 상회',
      'Q_K50_003': '별개의 위험은 남아요',
    };
    for (final a in answers.entries) {
      final q = c.question(a.key);
      expect(q.options[q.answer.single], a.value);
    }
  });
  test(
    'Importer rejects missing originals and invalid category membership',
    () {
      final md = File('08_Core_50_Data.md').readAsStringSync();
      final old = loadCourse().previous!.data;
      expect(
        () => buildCore50(md.replaceFirst('"number": 50', '"number": 49'), old),
        throwsFormatException,
      );
      expect(
        () => buildCore50(
          md.replaceFirst('"category": "G3"', '"category": "G6"'),
          old,
        ),
        throwsFormatException,
      );
    },
  );
}
