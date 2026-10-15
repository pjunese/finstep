import 'dart:convert';
import 'package:flutter/services.dart';

typedef Json = Map<String, dynamic>;

class Lesson {
  Lesson(this.data);
  final Json data;
  String get id => data['lesson_id'];
  String get title =>
      const {'L01': '주식 한 주', 'L02': '주가', 'L07': '숫자의 변화'}[id] ??
      data['short_title'];
  String get categoryId => data['category_id'] ?? '';
  String get hook => data['hook_question'];
  String get summary => data['summary'];
  String get nextQuestion =>
      (data['next_question'] as String).replaceAll('`', '');
  List<Json> get pages => List<Json>.from(data['pages']);
  Json get brief => Map<String, dynamic>.from(data['brief']);
  NumberExercise? get exercise =>
      data['exercise'] == null ? null : NumberExercise(data['exercise']);
  List<String> get concepts => List<String>.from(data['concept_ids']);
  List<String> get prerequisites => List<String>.from(data['prerequisite_ids']);
  List<String> get objectives => List<String>.from(data['learning_objectives']);
}

class QuizQuestion {
  QuizQuestion(this.data);
  final Json data;
  String get id => data['question_id'];
  String get lessonId => data['lesson_id'];
  String get prompt => data['prompt'];
  bool get multi => data['question_type'] == 'multi_select';
  Map<String, String> get options => Map<String, String>.from(data['options']);
  List<String> get answer => List<String>.from(data['answer']);
  String get explanation => data['explanation'];
  String get takeaway => data['key_takeaway'];
  List<String> get concepts => List<String>.from(data['concept_ids']);
  List<String> get remediation =>
      List<String>.from(data['remediation_concept_ids']);
  String feedback(String option) => data['option_feedback'][option];
  bool isCorrect(List<String> selected) =>
      selected.toSet().length == answer.length &&
      answer.every(selected.contains);
}

/// Discrete, deliberately small examples avoid accidental fractions or huge units.
class NumberExercise {
  NumberExercise(this.data);
  final Json data;
  int get fixed => data['fixed'];
  List<int> get values => List<int>.from(data['values']);
  int input(int step) => values[step.clamp(1, values.length) - 1];
  num result(int step) {
    final value = input(step);
    return switch (data['operation']) {
      'ownership' => value / fixed * 100,
      'split' || 'eps' || 'pe_eps' => fixed / value,
      'market_cap' => fixed * value,
      'profit' => fixed - value,
      'pe_price' => value / fixed,
      _ => throw StateError('Unknown exercise'),
    };
  }
}

class Course {
  Course(this.data)
    : lessons = (data['lessons'] as List).map((e) => Lesson(e)).toList(),
      questions = (data['questions'] as List)
          .map((e) => QuizQuestion(e))
          .toList();
  final Json data;
  final List<Lesson> lessons;
  final List<QuizQuestion> questions;
  bool get isCore50 => data['schema_version'] == 2;
  int get practiceCount => data['practice_question_count'] ?? 3;
  late final Course? previous = data['previous_course'] == null
      ? null
      : Course(data['previous_course']);
  List<Json> get categories => List<Json>.from(data['categories'] ?? []);
  Json category(String id) => categories.firstWhere((g) => g['id'] == id);
  List<Lesson> inCategory(String id) =>
      lessons.where((l) => l.categoryId == id).toList();
  List<Json> get concepts => List<Json>.from(data['concepts']);
  List<Json> get edges => List<Json>.from(data['edges']);
  Lesson lesson(String id) => lessons.firstWhere((l) => l.id == id);
  QuizQuestion question(String id) => questions.firstWhere((q) => q.id == id);
  Json concept(String id) => concepts.firstWhere((c) => c['concept_id'] == id);
  Json? card(String id) => data['cards'][id];
  List<QuizQuestion> forLesson(String id) =>
      questions.where((q) => q.lessonId == id).toList();
  static Future<Course> load() async => Course(
    jsonDecode(await rootBundle.loadString('assets/data/course.json')),
  );
  void validate() {
    final ids = concepts.map((c) => c['concept_id']).toSet();
    if (lessons.length != (isCore50 ? 50 : 8) ||
        questions.length != (isCore50 ? 150 : 32) ||
        ids.length != concepts.length) {
      throw StateError('Unexpected content counts');
    }
    if (questions.map((q) => q.id).toSet().length != questions.length) {
      throw StateError('Duplicate questions');
    }
    if (lessons.map((l) => l.id).toSet().length != lessons.length) {
      throw StateError('Duplicate lesson');
    }
    if (isCore50) {
      final grouped = categories.expand((g) => inCategory(g['id'])).toList();
      if (categories.length != 7 ||
          grouped.length != 50 ||
          grouped.map((l) => l.id).toSet().length != 50 ||
          concepts.length != 50 ||
          (data['cards'] as Map).length != 50) {
        throw StateError('Invalid core50 coverage');
      }
      if (concepts
          .map((c) => c['original_number'])
          .toSet()
          .difference(Set.of(List.generate(50, (i) => i + 1)))
          .isNotEmpty) {
        throw StateError('Invalid source numbers');
      }
      for (final c in concepts) {
        if (!lessons.any(
          (l) =>
              l.concepts.contains(c['concept_id']) &&
              l.categoryId == c['category_id'],
        )) {
          throw StateError('Concept category mismatch');
        }
      }
    }
    for (final l in lessons) {
      if (l.pages.isEmpty ||
          l.summary.isEmpty ||
          forLesson(l.id).length != practiceCount + 1 ||
          ![
            'title',
            'core',
            'example',
            'result',
            'remember',
          ].every((key) => l.brief[key] is String && l.brief[key].isNotEmpty)) {
        throw StateError('Incomplete ${l.id}');
      }
      if (![...l.concepts, ...l.prerequisites].every(ids.contains)) {
        throw StateError('Missing concept in ${l.id}');
      }
    }
    for (final q in questions) {
      if (!lessons.any((l) => l.id == q.lessonId)) {
        throw StateError('Missing question lesson');
      }
      if ((q.options.length < 2 || q.options.length > 4) ||
          q.answer.isEmpty ||
          !q.answer.every(q.options.containsKey) ||
          (!q.multi && q.answer.length != 1)) {
        throw StateError('Invalid answer ${q.id}');
      }
      if (![...q.concepts, ...q.remediation].every(ids.contains)) {
        throw StateError('Missing concept ${q.id}');
      }
      for (final k in q.options.keys) {
        if (q.feedback(k).isEmpty) throw StateError('Missing feedback ${q.id}');
      }
      if (q.takeaway.isEmpty) throw StateError('Missing takeaway ${q.id}');
    }
    for (final e in edges) {
      if (!ids.contains(e['from']) || !ids.contains(e['to'])) {
        throw StateError('Broken edge');
      }
    }
  }
}
