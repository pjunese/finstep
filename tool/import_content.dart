import 'dart:convert';
import 'dart:io';

typedef Json = Map<String, dynamic>;
String lessonId(int n) => 'K${n.toString().padLeft(2, '0')}';
String conceptId(int n) => 'C50_${n.toString().padLeft(2, '0')}';

/// Canonical content lives in Markdown; generated JSON has no hand-written copy.
Json buildCore50(String markdown, Json previous) {
  final blocks = RegExp(r'```json\s*\n([\s\S]*?)\n```')
      .allMatches(markdown)
      .map((m) => Map<String, dynamic>.from(jsonDecode(m[1]!)))
      .toList();
  if (blocks.length != 51) {
    throw const FormatException('Expected metadata + 50 concepts');
  }
  final meta = blocks.first, records = blocks.skip(1).toList();
  final numbers = records.map((r) => r['number']).toSet();
  if (numbers.length != 50 ||
      !List.generate(50, (i) => i + 1).every(numbers.contains)) {
    throw const FormatException('Original numbers 1–50 must each occur once');
  }
  final categories = List<Json>.from(meta['categories']);
  final order = categories.expand((g) => List<int>.from(g['numbers'])).toList();
  if (categories.length != 7 ||
      order.length != 50 ||
      order.toSet().length != 50 ||
      !order.every(numbers.contains)) {
    throw const FormatException('Categories must partition all 50 concepts');
  }
  final lessons = <Json>[],
      concepts = <Json>[],
      questions = <Json>[],
      prompts = <Json>[];
  final cards = <String, Json>{}, edges = <String, Json>{};
  for (final n in order) {
    final r = records.singleWhere((r) => r['number'] == n);
    final category = categories.singleWhere((g) => g['id'] == r['category']);
    if (!(category['numbers'] as List).contains(n)) {
      throw FormatException('Wrong category $n');
    }
    final lid = lessonId(n), cid = conceptId(n);
    final related = List<int>.from(r['related']);
    if (related.isEmpty ||
        related.contains(n) ||
        !related.every(numbers.contains)) {
      throw FormatException('Invalid links $n');
    }
    final qs = List<Json>.from(r['questions']);
    if (qs.length != 3) throw FormatException('Need 2 practice + 1 review: $n');
    for (final (i, q) in qs.indexed) {
      final options = List<String>.from(q['options']);
      final answer = q['answer'] as int;
      if (options.length < 2 ||
          options.length > 4 ||
          options.toSet().length != options.length ||
          answer < 0 ||
          answer >= options.length) {
        throw FormatException('Invalid answer $n/$i');
      }
      final keys = List.generate(
        options.length,
        (j) => String.fromCharCode(65 + j),
      );
      questions.add({
        'question_id': 'Q_${lid}_${(i + 1).toString().padLeft(3, '0')}',
        'lesson_id': lid,
        'question_type': 'single_select',
        'prompt': q['prompt'],
        'options': {for (var j = 0; j < keys.length; j++) keys[j]: options[j]},
        'answer': [keys[answer]],
        'explanation': q['explanation'],
        'key_takeaway': q['explanation'],
        'option_feedback': {
          for (var j = 0; j < keys.length; j++)
            keys[j]: '${j == answer ? '맞아요. ' : ''}${q['explanation']}',
        },
        'concept_ids': [cid],
        'remediation_concept_ids': [cid],
      });
    }
    final home = Map<String, dynamic>.from(r['home']);
    prompts.add({
      ...home,
      'id': 'bite-$lid-v1',
      'lesson_id': lid,
      'facts': [
        ['오늘의 개념', r['name']],
        ['분류', category['title']],
      ],
    });
    lessons.add({
      'lesson_id': lid,
      'original_number': n,
      'category_id': category['id'],
      'short_title': r['name'],
      'hook_question': home['prompt'],
      'summary': r['core'],
      'next_question': r['remember'],
      'concept_ids': [cid],
      'prerequisite_ids': <String>[],
      'learning_objectives': [r['core'], r['remember']],
      'brief': {
        'title': r['name'],
        'core': r['core'],
        'example': r['example'],
        'result': r['result'],
        'remember': r['remember'],
      },
      'pages': [
        {'title': '조금 더 알아보기', 'body': r['detail']},
        {
          'title': '뉴스에서 구분하기 · 가상 예시',
          'body': '${r['news']['headline']}\n\n${r['news']['meaning']}',
        },
      ],
      'scenario': r['news'],
      if (r['exercise'] != null) 'exercise': r['exercise'],
    });
    concepts.add({
      'concept_id': cid,
      'original_number': n,
      'category_id': category['id'],
      'name_ko': r['name'],
      'name_en': r['english'],
      'short_definition': r['core'],
      'lesson_ids': [lid],
      if (r['formula'] != null) 'formula': r['formula'],
      'basis_note': r['remember'],
    });
    cards[cid] = {
      'one_liner': r['core'],
      'remember': r['remember'],
      if (r['formula'] != null) 'formula': r['formula'],
    };
    for (final other in related) {
      final pair = [n, other]..sort();
      edges['${pair[0]}-${pair[1]}'] = {
        'from': conceptId(pair[0]),
        'to': conceptId(pair[1]),
        'label_ko': '함께 이해할 개념',
      };
    }
  }
  return {
    ...meta, 'lessons': lessons, 'concepts': concepts, 'cards': cards,
    'questions': questions,
    'edges': edges.values.toList(),
    'home_prompts': prompts,
    // Read-only old definitions validate and display archived progress honestly.
    'previous_course': previous,
  };
}

void main(List<String> args) {
  final data = buildCore50(
    File('08_Core_50_Data.md').readAsStringSync(),
    jsonDecode(File('docs/archive/course-v0.3.0.json').readAsStringSync()),
  );
  final output = '${const JsonEncoder.withIndent('  ').convert(data)}\n';
  final target = File('assets/data/course.json');
  if (args.contains('--check')) {
    if (target.readAsStringSync() != output) {
      throw StateError('Run dart run tool/import_content.dart to sync content');
    }
  } else {
    target.writeAsStringSync(output);
  }
  stdout.writeln(
    'Core 50: 7 categories, 50 concepts, 150 quizzes, 50 home prompts',
  );
}
