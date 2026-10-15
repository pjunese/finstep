import 'course.dart';

/// Independent daily warm-ups. The old prompts below only validate archived records.
class HomePrompt {
  const HomePrompt(
    this.id,
    this.lessonId,
    this.title,
    this.facts,
    this.options,
    this.answer,
    this.takeaway,
  );
  final String id, lessonId, title, takeaway;
  final List<(String, String)> facts;
  final List<String> options;
  final int answer;
}

const legacyHomePrompts = [
  HomePrompt(
    'bite-shares-v1',
    'L01',
    '주식 2주를 샀어요.\n회사의 얼마가 내 몫일까요?',
    [('회사 전체', '20주'), ('내가 가진 주식', '2주')],
    ['회사의 2%', '회사의 10%'],
    1,
    '20조각 중 2조각, 내 몫은 10%예요. 주식은 회사를 나눈 작은 몫이에요.',
  ),
  HomePrompt(
    'bite-split-v1',
    'L02',
    '주식 수가 두 배, 가격은 절반.\n내 주식의 총액은?',
    [('분할 전', '2주 × 2,000원'), ('분할 직후', '4주 × 1,000원')],
    ['그대로예요', '절반이 돼요'],
    0,
    '둘 다 4,000원이에요. 주식분할 직후에는 조각 수와 한 조각 가격이 함께 바뀌어요.',
  ),
  HomePrompt(
    'bite-profit-v1',
    'L04',
    '1만 원을 팔았어요.\n전부 번 돈일까요?',
    [('판매한 금액', '10,000원'), ('모든 비용', '7,000원')],
    ['네, 1만 원을 벌었어요', '비용을 빼면 3천 원이에요'],
    1,
    '판 돈은 매출, 비용을 빼고 남은 돈은 이익이에요. 이 예시에서는 3,000원이 남아요.',
  ),
  HomePrompt(
    'bite-eps-v1',
    'L05',
    '회사가 번 돈을\n한 주씩 나누면 얼마일까요?',
    [('보통주 몫의 이익', '10,000원'), ('기간 평균 주식 수', '10주')],
    ['한 주당 1,000원', '한 주당 10,000원'],
    0,
    '1만 원을 10주로 나누면 한 주당 1,000원이에요. 이렇게 이익을 한 주 단위로 본 것이 EPS예요.',
  ),
  HomePrompt(
    'bite-pe-v1',
    'L06',
    'PER 5배라면,\n수익도 5배라는 뜻일까요?',
    [('한 주 가격', '5,000원'), ('한 주당 이익', '1,000원')],
    ['네, 수익이 5배예요', '주가가 이익의 5배예요'],
    1,
    'PER은 주가가 한 주당 이익의 몇 배인지 나타내요. 미래 수익률을 뜻하지 않아요.',
  ),
  HomePrompt(
    'bite-size-v1',
    'L03',
    '1,000원짜리 주식이면\n더 작은 회사일까요?',
    [('A 회사 · 한 주', '1,000원'), ('B 회사 · 한 주', '10,000원')],
    ['네, A 회사가 더 작아요', '주가만으로는 몰라요'],
    1,
    '발행한 주식 수도 알아야 해요. 회사의 시가총액은 ‘주가 × 발행 주식 수’로 비교해요.',
  ),
  HomePrompt(
    'bite-change-v1',
    'L07',
    '이익이 그대로인데 주가가 절반.\nPER도 절반이 될까요?',
    [('주가의 변화', '1만 → 5천 원'), ('한 주당 이익', '1,000원 그대로')],
    ['네, 10배에서 5배로', '아니요, 그대로예요'],
    0,
    '주가를 한 주당 이익으로 나누면 10배에서 5배가 돼요. PER이 바뀌면 주가와 이익을 함께 살펴봐요.',
  ),
  HomePrompt(
    'bite-context-v1',
    'L08',
    'PER이 같은 두 회사.\n성장 가능성도 같을까요?',
    [('A 회사', 'PER 5배'), ('B 회사', 'PER 5배')],
    ['네, 같다고 볼 수 있어요', '이 숫자만으론 몰라요'],
    1,
    '같은 PER이어도 부채와 성장 전망은 다를 수 있어요. 숫자 하나만으로 회사 전체를 알 수는 없어요.',
  ),
];

String localDay(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

HomePrompt homePromptFor(DateTime localDate, List<HomePrompt> prompts) {
  // UTC date arithmetic avoids DST changing the rotation within a local day.
  final ordinal =
      DateTime.utc(
        localDate.year,
        localDate.month,
        localDate.day,
      ).millisecondsSinceEpoch ~/
      Duration.millisecondsPerDay;
  return prompts[ordinal % prompts.length];
}

List<HomePrompt> promptsFor(Course course) => course.isCore50
    ? List<Json>.from(course.data['home_prompts'])
          .map(
            (p) => HomePrompt(
              p['id'],
              p['lesson_id'],
              p['prompt'],
              [for (final f in p['facts']) (f[0] as String, f[1] as String)],
              List<String>.from(p['options']),
              p['answer'],
              p['takeaway'],
            ),
          )
          .toList()
    : legacyHomePrompts;
