import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../content/course.dart';
import '../content/home_prompts.dart';
import 'study_plan.dart';

abstract interface class ProgressStore {
  Future<String?> read();
  Future<void> write(String value);
}

/// Rename within the same directory makes each committed snapshot atomic.
/// The previous snapshot is preserved separately for manual recovery.
class FileProgressStore implements ProgressStore {
  FileProgressStore(this.directory);
  final Directory directory;
  File get file => File('${directory.path}/progress-v1.json');
  @override
  Future<String?> read() async =>
      await file.exists() ? file.readAsString() : null;
  @override
  Future<void> write(String value) async {
    await directory.create(recursive: true);
    final temp = File('${file.path}.tmp');
    await temp.writeAsString(value, flush: true);
    if (await file.exists()) await file.copy('${file.path}.backup');
    await temp.rename(file.path);
  }
}

class MemoryProgressStore implements ProgressStore {
  String? value;
  bool failWrites = false;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String next) async {
    if (failWrites) throw const FileSystemException('Disk full');
    value = next;
  }
}

Json freshProgress({int version = 2}) => {
  'version': version,
  'learningFlowVersion': 2,
  'started': false,
  'completed': <String>[],
  'saved': <String>[],
  'missed': <String>[],
  'events': <Json>[],
  'sessions': <String, dynamic>{},
  'lastSession': null,
  'homeAnswers': <String, dynamic>{},
};

class LearningController extends ChangeNotifier {
  LearningController(this.course, this.store, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now {
    _data = freshProgress(version: course.isCore50 ? 2 : 1);
  }
  final Course course;
  final ProgressStore store;
  final DateTime Function() clock;
  DateTime get now => clock().toLocal();
  Json _data = freshProgress();
  Json get snapshot => jsonDecode(jsonEncode(_data));
  bool ready = false, busy = false;
  String? error;
  bool get started => _data['started'];
  List<String> get completed => List<String>.from(_data['completed']);
  List<String> get saved => List<String>.from(_data['saved']);
  List<String> get missed => List<String>.from(_data['missed']);
  List<Json> get events => List<Json>.from(_data['events']);
  late final List<HomePrompt> homePrompts = promptsFor(course);
  Json? get legacy => _data['legacy'];
  int get legacyXp => ((legacy?['completed'] as List?)?.length ?? 0) * 30;
  int get xp => completed.length * 30 + legacyXp;
  int get level => 1 + xp ~/ 100;
  int get dailyGoal => (_data['studyPlan']?['dailyGoal'] as int?) ?? 1;
  int dailyCompleted(DateTime day) =>
      (_data['studyPlan']?['days']?[localDay(day.toLocal())] as List?)
          ?.length ??
      0;
  List<ReviewSuggestion> reviewsDue(DateTime day) =>
      suggestedReviews(course, _data, day);
  String? reviewDueDay(String lessonId) =>
      _data['studyPlan']?['reviews']?[lessonId]?['dueDay'] as String?;
  Future<bool> setDailyGoal(int goal) {
    if (goal < 1 || goal > 3) return Future.value(false);
    return _commit((d) {
      final plan = d.putIfAbsent('studyPlan', freshStudyPlan) as Map;
      plan['dailyGoal'] = goal;
    });
  }

  Json? session(String key) => _data['sessions'][key];
  Json? homeAnswer(DateTime day) {
    final value = (_data['homeAnswers'] as Map?)?[localDay(day)];
    return value == null ? null : Map<String, dynamic>.from(value);
  }

  HomePrompt dailyPrompt(DateTime day) {
    final answer = homeAnswer(day);
    return answer == null
        ? homePromptFor(day, homePrompts)
        : homePrompts.firstWhere((p) => p.id == answer['prompt']);
  }

  Set<String> get activeDays => {
    ...?(_data['homeAnswers'] as Map?)?.keys.cast<String>(),
    ...?(_data['studyPlan']?['days'] as Map?)?.keys.cast<String>(),
    ...?(legacy?['homeAnswers'] as Map?)?.keys.cast<String>(),
    for (final event in [...events, ...?legacy?['events'] as List?])
      if (event['at'] is String && DateTime.tryParse(event['at']) != null)
        localDay(DateTime.parse(event['at']).toLocal()),
  };
  String? get resumeKey {
    final key = _data['lastSession'] as String?;
    if (key != null && session(key)?['phase'] != 'complete') return key;
    return null;
  }

  Lesson get nextLesson => course.lessons.firstWhere(
    (l) => !completed.contains(l.id),
    orElse: () => course.lessons.last,
  );
  List<Lesson> get reviewLessons => course.lessons
      .where((l) => missed.any((id) => course.question(id).lessonId == l.id))
      .toList();
  int newEvidence(String lessonId) => events
      .where(
        (e) =>
            e['lesson'] == lessonId &&
            e['kind'] == 'TRANSFER_VARIANT' &&
            e['correct'] == true,
      )
      .length;

  Future<void> load() async {
    if (busy) return;
    busy = true;
    error = null;
    notifyListeners();
    try {
      final raw = await store.read();
      var data = raw == null
          ? freshProgress(version: course.isCore50 ? 2 : 1)
          : Map<String, dynamic>.from(jsonDecode(raw));
      if (course.isCore50 && data['version'] == 1) {
        final previous = course.previous;
        if (previous == null) {
          throw const FormatException('Missing legacy catalog');
        }
        final oldReader = LearningController(previous, MemoryProgressStore());
        try {
          oldReader.validate(data);
        } finally {
          oldReader.dispose();
        }
        // Keep the complete original snapshot, including unfinished work and
        // old bookmarks. Never reinterpret Lxx completion as a new Kxx lesson.
        final old = data;
        data = freshProgress()..['legacy'] = old;
        const bookmarkMap = {
          'C_MARKET_CAP': 'C50_01',
          'C_REVENUE': 'C50_02',
          'C_NET_INCOME': 'C50_04',
          'C_BASIC_EPS': 'C50_11',
          'C_DILUTED_EPS': 'C50_11',
          'C_COMMON_STOCK': 'C50_07',
          'C_PE_RATIO': 'C50_12',
        };
        data['saved'] = <String>{
          for (final id in old['saved'])
            if (bookmarkMap[id] != null) bookmarkMap[id]!,
        }.toList();
      }
      validate(data);
      // Keep old completions/answers while returning long reading pages to
      // the new one-screen introduction. Persist on the next normal action.
      if ((data['learningFlowVersion'] ?? 1) < 2) {
        for (final s in (data['sessions'] as Map).values) {
          s['page'] = 0;
          s['value'] = (s['value'] as int).clamp(1, 3);
        }
        data['learningFlowVersion'] = 2;
      }
      _data = data;
      ready = true;
    } catch (_) {
      ready = false;
      error = '학습 기록을 불러오지 못했어요. 기존 기록은 그대로 보관하고 있어요. 다시 시도해주세요.';
    }
    busy = false;
    notifyListeners();
  }

  void validate(Json d) {
    if (d['version'] != (course.isCore50 ? 2 : 1) ||
        d['started'] is! bool ||
        d['sessions'] is! Map ||
        d['events'] is! List) {
      throw const FormatException('Unsupported progress');
    }
    if (d['legacy'] != null) {
      if (!course.isCore50 || course.previous == null || d['legacy'] is! Map) {
        throw const FormatException('Invalid archive');
      }
      final reader = LearningController(
        course.previous!,
        MemoryProgressStore(),
      );
      try {
        reader.validate(Map<String, dynamic>.from(d['legacy']));
      } finally {
        reader.dispose();
      }
    }
    final lessons = course.lessons.map((l) => l.id).toSet();
    final concepts = course.concepts.map((c) => c['concept_id']).toSet();
    final questions = course.questions.map((q) => q.id).toSet();
    validateStudyPlan(d['studyPlan'], lessons);
    for (final key in ['completed', 'saved', 'missed']) {
      if (d[key] is! List) throw const FormatException('Invalid lists');
      final list = List<String>.from(d[key]);
      if (list.toSet().length != list.length ||
          !list.every(
            (key == 'completed'
                    ? lessons
                    : key == 'saved'
                    ? concepts
                    : questions)
                .contains,
          )) {
        throw const FormatException('Unknown content');
      }
    }
    for (final entry in (d['sessions'] as Map).entries) {
      final s = Map<String, dynamic>.from(entry.value);
      if (s['allCorrect'] != null && s['allCorrect'] is! bool) {
        throw const FormatException('Invalid session correctness');
      }
      if (!lessons.contains(s['lesson']) ||
          s['review'] is! bool ||
          ![
            'read',
            'experiment',
            'quiz',
            'feedback',
            'complete',
          ].contains(s['phase'])) {
        throw const FormatException('Invalid session');
      }
      final ids = List<String>.from(s['questions']);
      if (ids.isEmpty ||
          !ids.every(questions.contains) ||
          s['index'] is! int ||
          s['index'] < 0 ||
          s['index'] >= ids.length) {
        throw const FormatException('Invalid question index');
      }
      final l = course.lesson(s['lesson']);
      if (entry.key != (s['review'] ? 'review:${l.id}' : l.id) ||
          ids.toSet().length != ids.length ||
          !ids.every((id) => course.question(id).lessonId == l.id)) {
        throw const FormatException('Mismatched session');
      }
      if (s['page'] is! int ||
          s['page'] < 0 ||
          s['page'] >= l.pages.length ||
          s['value'] is! int) {
        throw const FormatException('Invalid page');
      }
      final selected = List<String>.from(s['selected']);
      final q = course.question(ids[s['index']]);
      if (selected.toSet().length != selected.length ||
          !selected.every(q.options.containsKey) ||
          (!q.multi && selected.length > 1)) {
        throw const FormatException('Invalid selection');
      }
      if (s['phase'] == 'feedback' && selected.isEmpty) {
        throw const FormatException('Missing answer');
      }
    }
    if (d['lastSession'] != null &&
        !(d['sessions'] as Map).containsKey(d['lastSession'])) {
      throw const FormatException('Invalid resume');
    }
    for (final e in d['events']) {
      if (!questions.contains(e['question']) ||
          !lessons.contains(e['lesson']) ||
          e['correct'] is! bool) {
        throw const FormatException('Invalid event');
      }
    }
    final homeAnswers = d['homeAnswers'];
    if (homeAnswers != null) {
      if (homeAnswers is! Map || homeAnswers.length > 90) {
        throw const FormatException('Invalid home activity');
      }
      for (final entry in homeAnswers.entries) {
        final day = entry.key is String ? DateTime.tryParse(entry.key) : null;
        final answer = entry.value;
        if (day == null ||
            localDay(day) != entry.key ||
            answer is! Map ||
            !homePrompts.any((p) => p.id == answer['prompt']) ||
            answer['choice'] is! int ||
            answer['choice'] < 0 ||
            answer['choice'] > 1) {
          throw const FormatException('Invalid home answer');
        }
      }
    }
  }

  Future<bool> _commit(void Function(Json) change) async {
    if (busy || !ready) return false;
    busy = true;
    error = null;
    notifyListeners();
    try {
      final next = snapshot;
      change(next);
      validate(next);
      await store.write(jsonEncode(next));
      _data = next;
      return true;
    } catch (_) {
      error = '저장하지 못했어요. 화면의 선택을 다시 눌러 재시도해주세요. 이전 기록은 유지돼요.';
      return false;
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  Future<bool> enter() => _commit((d) => d['started'] = true);
  Future<bool> answerHome(DateTime day, int choice) {
    if (choice < 0 || choice > 1 || homeAnswer(day) != null) {
      return Future.value(false);
    }
    return _commit((d) {
      final answers =
          d.putIfAbsent('homeAnswers', () => <String, dynamic>{}) as Map;
      answers[localDay(day)] = {
        'prompt': homePromptFor(day, homePrompts).id,
        'choice': choice,
      };
      final days = answers.keys.cast<String>().toList()..sort();
      for (final old in days.take((days.length - 90).clamp(0, days.length))) {
        answers.remove(old);
      }
    });
  }

  Future<bool> toggleSaved(String id) => _commit((d) {
    final list = d['saved'] as List;
    list.contains(id) ? list.remove(id) : list.add(id);
  });
  Future<bool> start(String lessonId, {bool review = false}) => _commit((d) {
    final key = review ? 'review:$lessonId' : lessonId;
    d['started'] = true;
    d['lastSession'] = key;
    final old = d['sessions'][key];
    if (old != null && old['phase'] != 'complete') return;
    final qs = course.forLesson(lessonId);
    final ids = review
        ? <String>[
            qs.last.id,
            ...List<String>.from(d['missed']).where(
              (id) =>
                  course.question(id).lessonId == lessonId && id != qs.last.id,
            ),
          ]
        : qs.take(course.practiceCount).map((q) => q.id).toList();
    d['sessions'][key] = {
      'lesson': lessonId,
      'review': review,
      'phase': review ? 'quiz' : 'read',
      'page': 0,
      'value': 1,
      'index': 0,
      'questions': ids,
      'selected': <String>[],
      'award': 0,
      'allCorrect': true,
    };
  });
  Future<bool> setValue(String key, int value) =>
      _commit((d) => d['sessions'][key]['value'] = value.clamp(1, 3));
  Future<bool> select(String key, String option) => _commit((d) {
    final s = d['sessions'][key];
    if (s['phase'] != 'quiz') return;
    final q = course.question(s['questions'][s['index']]);
    if (q.multi) {
      final list = s['selected'] as List;
      list.contains(option) ? list.remove(option) : list.add(option);
    } else {
      s['selected'] = [option];
    }
  });
  Future<bool> back(String key) => _commit((d) {
    final s = d['sessions'][key];
    if (s['phase'] == 'experiment') {
      s['phase'] = 'read';
      s['page'] = 0;
    }
  });
  Future<bool> advance(String key) => _commit((d) {
    final s = d['sessions'][key];
    final lesson = course.lesson(s['lesson']);
    switch (s['phase']) {
      case 'read':
        s['page'] = 0;
        s['phase'] = 'experiment';
      case 'experiment':
        s['phase'] = 'quiz';
      case 'quiz':
        final selected = List<String>.from(s['selected']);
        if (selected.isEmpty) return;
        final q = course.question(s['questions'][s['index']]);
        final previous = (d['events'] as List).any(
          (e) => e['question'] == q.id,
        );
        final kind = s['review']
            ? (previous ? 'REVIEW_ATTEMPT' : 'TRANSFER_VARIANT')
            : (previous ? 'AFTER_FEEDBACK_RETRY' : 'FIRST_ATTEMPT');
        final correct = q.isCorrect(selected);
        (d['events'] as List).add({
          'question': q.id,
          'lesson': q.lessonId,
          'selected': selected,
          'correct': correct,
          'kind': kind,
          'contentVersion': course.data['content_version'],
          'at': now.toUtc().toIso8601String(),
        });
        final missed = d['missed'] as List;
        if (!correct && !missed.contains(q.id)) missed.add(q.id);
        if (!correct) s['allCorrect'] = false;
        if (correct && s['review']) missed.remove(q.id);
        s['phase'] = 'feedback';
      case 'feedback':
        if (s['index'] + 1 < (s['questions'] as List).length) {
          s['index']++;
          s['selected'] = <String>[];
          s['phase'] = 'quiz';
        } else {
          s['phase'] = 'complete';
          final completed = d['completed'] as List;
          if (!s['review'] && !completed.contains(lesson.id)) {
            completed.add(lesson.id);
            s['award'] = 30;
          }
          recordStudyCompletion(
            d,
            lesson.id,
            now: now,
            review: s['review'],
            // Old unfinished sessions have no aggregate; schedule conservatively.
            allCorrect: s['allCorrect'] == true,
            hasMistakes: (d['missed'] as List).any(
              (id) => course.question(id).lessonId == lesson.id,
            ),
          );
        }
      case 'complete':
        break;
    }
  });
}
