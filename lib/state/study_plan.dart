import '../content/course.dart';
import '../content/home_prompts.dart';

/// Calendar-day reminders, not a model of the learner's mastery.
class ReviewSuggestion {
  const ReviewSuggestion(this.lessonId, this.hasMistakes, this.dueDay);
  final String lessonId;
  final bool hasMistakes;
  final String? dueDay;
  String get reason => hasMistakes
      ? '헷갈린 문제를 다시 확인해요'
      : dueDay == null
      ? '배운 개념을 다시 확인해요'
      : '다시 볼 때가 됐어요';
}

Json freshStudyPlan() => {
  'version': 1,
  'dailyGoal': 1,
  'days': <String, dynamic>{},
  'reviews': <String, dynamic>{},
};

bool _validDay(dynamic value) {
  if (value is! String || !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
    return false;
  }
  final parsed = DateTime.tryParse(value);
  return parsed != null && localDay(parsed) == value;
}

void validateStudyPlan(dynamic plan, Set<String> lessons) {
  // Older snapshots have no plan. Do not manufacture completion dates for them.
  if (plan == null) return;
  if (plan is! Map ||
      plan['version'] != 1 ||
      plan['dailyGoal'] is! int ||
      !(plan['dailyGoal'] >= 1 && plan['dailyGoal'] <= 3) ||
      plan['days'] is! Map ||
      plan['days'].length > 90 ||
      plan['reviews'] is! Map) {
    throw const FormatException('Invalid study plan');
  }
  for (final entry in (plan['days'] as Map).entries) {
    final ids = entry.value;
    if (!_validDay(entry.key) ||
        ids is! List ||
        !ids.every(lessons.contains) ||
        ids.toSet().length != ids.length) {
      throw const FormatException('Invalid daily completion');
    }
  }
  for (final entry in (plan['reviews'] as Map).entries) {
    final state = entry.value;
    if (!lessons.contains(entry.key) ||
        state is! Map ||
        !_validDay(state['lastDay']) ||
        !_validDay(state['dueDay']) ||
        (state['dueDay'] as String).compareTo(state['lastDay']) <= 0 ||
        state['streak'] is! int ||
        state['streak'] < 0 ||
        state['streak'] > 4) {
      throw const FormatException('Invalid review schedule');
    }
  }
}

/// Called inside the same atomic transaction as lesson completion and XP.
void recordStudyCompletion(
  Json progress,
  String lessonId, {
  required DateTime now,
  required bool review,
  required bool allCorrect,
  required bool hasMistakes,
}) {
  final plan = progress.putIfAbsent('studyPlan', freshStudyPlan) as Map;
  final day = localDay(now.toLocal());
  final days = plan['days'] as Map;
  final ids = days.putIfAbsent(day, () => <String>[]) as List;
  if (!ids.contains(lessonId)) ids.add(lessonId);
  final dates = days.keys.cast<String>().toList()..sort();
  for (final old in dates.take((dates.length - 90).clamp(0, dates.length))) {
    days.remove(old);
  }
  final schedules = plan['reviews'] as Map;
  final old = schedules[lessonId] as Map?;
  // Clock rollback or travel must not move a stored reminder into the past.
  if (old != null && (old['lastDay'] as String).compareTo(day) > 0) return;
  final success = allCorrect && !hasMistakes;
  // Repeating answers today cannot push a reminder further away.
  if (old != null && old['lastDay'] == day && success) return;
  final streak = review && success
      ? (((old?['streak'] as int?) ?? 0) + 1).clamp(0, 4)
      : 0;
  const intervals = [1, 3, 7, 14, 30];
  final date = DateTime.parse(day);
  // Calendar arithmetic avoids DST changing the next local date.
  final due = DateTime(date.year, date.month, date.day + intervals[streak]);
  schedules[lessonId] = {
    'lastDay': day,
    'dueDay': localDay(due),
    'streak': streak,
  };
}

List<ReviewSuggestion> suggestedReviews(
  Course course,
  Json progress,
  DateTime now,
) {
  final day = localDay(now.toLocal());
  final mistakes = <String>{
    for (final id in progress['missed']) course.question(id).lessonId,
  };
  final completed = Set<String>.from(progress['completed']);
  final schedules = (progress['studyPlan']?['reviews'] as Map?) ?? {};
  final order = {for (final (i, l) in course.lessons.indexed) l.id: i};
  final result = <ReviewSuggestion>[];
  for (final lesson in course.lessons) {
    if (!completed.contains(lesson.id) && !mistakes.contains(lesson.id)) {
      continue;
    }
    final state = schedules[lesson.id] as Map?;
    final due = state?['dueDay'] as String?;
    if (due != null && due.compareTo(day) > 0) continue;
    result.add(ReviewSuggestion(lesson.id, mistakes.contains(lesson.id), due));
  }
  result.sort((a, b) {
    final mistakeOrder = (a.hasMistakes ? 0 : 1).compareTo(
      b.hasMistakes ? 0 : 1,
    );
    if (mistakeOrder != 0) return mistakeOrder;
    final dateOrder = (a.dueDay ?? '').compareTo(b.dueDay ?? '');
    return dateOrder != 0
        ? dateOrder
        : order[a.lessonId]!.compareTo(order[b.lessonId]!);
  });
  return result;
}
