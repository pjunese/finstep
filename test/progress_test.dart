import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:finstep/state/progress.dart';
import 'content_test.dart' show loadCourse;

Future<void> toQuiz(LearningController c, String key) async {
  while (['read', 'experiment'].contains(c.session(key)!['phase'])) {
    await c.advance(key);
  }
}

Future<void> finish(
  LearningController c,
  String key, {
  bool wrong = false,
}) async {
  await toQuiz(c, key);
  while (c.session(key)!['phase'] != 'complete') {
    final s = c.session(key)!;
    if (s['phase'] == 'quiz') {
      final q = c.course.question(s['questions'][s['index']]);
      for (final a
          in wrong
              ? [q.options.keys.firstWhere((a) => !q.answer.contains(a))]
              : q.answer) {
        await c.select(key, a);
      }
    }
    await c.advance(key);
  }
}

void main() {
  late LearningController c;
  late MemoryProgressStore store;
  setUp(() async {
    store = MemoryProgressStore();
    c = LearningController(loadCourse(), store);
    await c.load();
  });
  test(
    'All fifty concepts complete without perfect scores; XP awarded once only',
    () async {
      for (final l in c.course.lessons) {
        await c.start(l.id);
        await finish(c, l.id, wrong: true);
      }
      expect(c.completed.length, 50);
      expect(c.xp, 1500);
      expect(c.missed.length, 100);
      await c.start('K07');
      await finish(c, 'K07');
      expect(c.xp, 1500);
      expect(c.events.last['kind'], 'AFTER_FEEDBACK_RETRY');
    },
  );
  test(
    'Relaunch restores selected answer, feedback, reading position and bookmarks',
    () async {
      await c.start('K01');
      await c.advance('K01');
      await c.toggleSaved('C50_01');
      var restored = LearningController(c.course, store);
      await restored.load();
      expect(restored.session('K01')!['phase'], 'experiment');
      expect(restored.saved, ['C50_01']);
      await toQuiz(restored, 'K01');
      await restored.select('K01', 'A');
      restored = LearningController(c.course, store);
      await restored.load();
      expect(restored.session('K01')!['selected'], ['A']);
      await restored.advance('K01');
      restored = LearningController(c.course, store);
      await restored.load();
      expect(restored.session('K01')!['phase'], 'feedback');
      expect(restored.events.length, 1);
    },
  );
  test(
    'Write failure does not advance or award XP and retry is safe',
    () async {
      await c.start('K07');
      await toQuiz(c, 'K07');
      await c.select('K07', 'B');
      final before = c.snapshot;
      store.failWrites = true;
      expect(await c.advance('K07'), isFalse);
      expect(c.snapshot, before);
      expect(c.error, isNotNull);
      store.failWrites = false;
      expect(await c.advance('K07'), isTrue);
      expect(c.events.length, 1);
      await finish(c, 'K07');
      expect(c.xp, 30);
      await c.advance('K07');
      expect(c.xp, 30);
    },
  );
  test(
    'Review uses unseen third question, retains unresolved errors, never awards XP',
    () async {
      await c.start('K07');
      await finish(c, 'K07', wrong: true);
      await c.start('K07', review: true);
      final key = 'review:K07';
      final s = c.session(key)!;
      expect((s['questions'] as List).first, 'Q_K07_003');
      final q = c.course.question('Q_K07_003');
      await c.select(key, q.answer.first);
      await c.advance(key);
      expect(c.events.last['kind'], 'TRANSFER_VARIANT');
      expect(c.missed.length, 2);
      await c.advance(key);
      await finish(c, key);
      expect(c.missed, isEmpty);
      expect(c.xp, 30);
      expect(c.newEvidence('K07'), 1);
      await c.start('K07', review: true);
      await finish(c, key);
      expect(c.events.last['kind'], 'REVIEW_ATTEMPT');
      expect(c.newEvidence('K07'), 1);
    },
  );
  test(
    'Starting another lesson preserves the earlier unfinished session',
    () async {
      await c.start('K07');
      await c.advance('K07');
      await c.start('K05');
      await c.start('K07');
      expect(c.session('K07')!['phase'], 'experiment');
      expect(c.resumeKey, 'K07');
    },
  );
  test(
    'Every lesson reaches practice after one core screen, with no detail-reading gate',
    () async {
      for (final lesson in c.course.lessons) {
        await c.start(lesson.id);
        expect(c.session(lesson.id)!['phase'], 'read');
        await c.advance(lesson.id);
        expect(c.session(lesson.id)!['phase'], 'experiment');
        await c.back(lesson.id);
        expect(c.session(lesson.id)!['phase'], 'read');
        await c.advance(lesson.id);
        await c.advance(lesson.id);
        expect(c.session(lesson.id)!['phase'], 'quiz');
      }
    },
  );
  test(
    'Upgrade archives old completions, mistakes, answers and unfinished work exactly',
    () async {
      final oldStore = MemoryProgressStore();
      final old = LearningController(c.course.previous!, oldStore);
      await old.load();
      await old.start('L01');
      await finish(old, 'L01', wrong: true);
      await old.toggleSaved('C_MARKET_CAP');
      await old.start('L03');
      await old.advance('L03');
      await old.answerHome(DateTime(2026, 10, 7), 0);
      final before = old.snapshot;
      store.value = oldStore.value;
      await c.load();
      expect(c.ready, isTrue);
      expect(c.legacy, before);
      expect(c.completed, isEmpty);
      expect(c.events, isEmpty);
      expect(c.saved, ['C50_01']);
      expect(c.xp, 30);
      expect(c.resumeKey, isNull);
      expect(c.activeDays, contains('2026-10-07'));
      expect(c.homeAnswer(DateTime(2026, 10, 7)), isNull);
      expect(store.value, oldStore.value); // No write on read/migration.
      await c.start('K07');
      await finish(c, 'K07');
      expect(c.xp, 60);
      expect(c.completed, ['K07']);
      final restored = LearningController(c.course, store);
      await restored.load();
      expect(restored.snapshot, c.snapshot);
      expect(restored.legacy, before);
      expect(restored.xp, 60);
    },
  );
  test(
    'Legacy migration survives failed first save and refuses corrupt old IDs',
    () async {
      final old = LearningController(c.course.previous!, MemoryProgressStore());
      await old.load();
      await old.start('L01');
      await finish(old, 'L01');
      final raw = jsonEncode(old.snapshot);
      store.value = raw;
      await c.load();
      store.failWrites = true;
      expect(await c.start('K07'), isFalse);
      expect(store.value, raw);
      expect(c.legacy, old.snapshot);
      expect(c.xp, 30);
      store.failWrites = false;
      expect(await c.start('K07'), isTrue);
      final broken = old.snapshot;
      broken['completed'] = ['L99'];
      store.value = jsonEncode(broken);
      await c.load();
      expect(c.ready, isFalse);
      expect(await c.enter(), isFalse);
      expect(store.value, jsonEncode(broken));
    },
  );
  test('Overlapping taps cannot duplicate answer submission', () async {
    await c.start('K01');
    await toQuiz(c, 'K01');
    await c.select('K01', 'B');
    await Future.wait([c.advance('K01'), c.advance('K01')]);
    expect(c.events.length, 1);
    expect(c.session('K01')!['phase'], 'feedback');
  });
  test(
    'Corrupt or future snapshots remain intact and cannot be overwritten',
    () async {
      for (final raw in [
        'broken',
        jsonEncode({'version': 99}),
        jsonEncode({
          ...freshProgress(),
          'completed': ['L99'],
        }),
      ]) {
        store.value = raw;
        await c.load();
        expect(c.ready, isFalse);
        expect(await c.enter(), isFalse);
        expect(store.value, raw);
      }
    },
  );
  test(
    'Atomic file repository round trips and preserves previous snapshot',
    () async {
      final dir = await Directory.systemTemp.createTemp('finstep-test');
      addTearDown(() => dir.delete(recursive: true));
      final disk = FileProgressStore(dir);
      await disk.write('first');
      await disk.write('second');
      expect(await disk.read(), 'second');
      expect(await File('${disk.file.path}.backup').readAsString(), 'first');
      expect(await File('${disk.file.path}.tmp').exists(), isFalse);
    },
  );
}
