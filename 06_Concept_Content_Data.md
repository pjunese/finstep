# 06. Concept Content Data
## FinStep L01~L08 개념·레슨 원천 데이터

**학습 화면 개정:** 2026-10-07 · 핵심 한 화면 + 선택형 상세 설명, 작은 가상 숫자 사용  
**버전:** v1.0  
**기준일:** 2026-10-06  
**대상 코스:** `C01 — 주가를 넘어 기업의 숫자 이해하기`  
**용도:** 레슨 본문, 개념 카드, 예시, 오답 해설, 복습 카드, 검색/용어 상세 화면의 원천 데이터

> 목표는 금융 용어를 많이 외우게 하는 것이 아니라, 사용자가 주식 화면과 재무 숫자 사이의 관계를 설명할 수 있게 만드는 것이다. 실제 종목 추천이나 매매 신호로 사용하지 않는다.

---

# 0. 공통 작성 규칙

## 0.1 콘텐츠 레코드 권장 스키마

```yaml
lesson_id: L01
concept_ids: [C_SHARE]
title: string
hook_question: string
learning_objectives: [string]
prerequisite_ids: [string]
core_explanation:
  easy: string
  precise: string
formula:
  expression: string | null
  scope_note: string | null
example:
  assumptions: [string]
  data: object
  walkthrough: [string]
common_misconceptions:
  - tag: string
    wrong_belief: string
    correction: string
limits_and_cautions: [string]
summary_card: string
next_question: string
source_refs: [string]
brief:
  title: string
  core: string
  example: string
  result: string
  remember: string
exercise:
  title: string
  fixed_label: string
  fixed: number
  fixed_unit: string
  input_label: string
  values: [number, number, number]
  input_unit: string
  operation: ownership | split | market_cap | profit | eps | pe_price | pe_eps
  result_label: string
  result_unit: string
  assumption: string
review_status: source_based
```

## 0.2 표현 원칙

- 기본 경로는 핵심 한 문장 + 짧은 예시 한 개 → 숫자 확인 → 퀴즈다. 상세 설명은 선택해서 읽는다.
- `brief`는 기본 화면, 기존 레슨 본문은 선택형 상세 설명에 사용한다.
- 숫자는 천 원~10만 원 이내를 우선하고 주식 수는 1~50주처럼 작게 만든다. 실제 기업 규모를 재현하려고 큰 단위를 쓰지 않는다.
- `exercise.values`는 암산하기 쉬운 세 가지 값이다. 기본 활동은 정수 결과가 나오도록 고른다.

- `easy`는 입문자가 한 번에 이해할 수 있는 설명이다.
- `precise`는 쉬운 설명이 잘못된 일반화로 굳어지지 않도록 정확성을 보완한다.
- 계산 문제는 단위를 반드시 적는다.
- 기간 지표인 매출·순이익·EPS와 특정 시점 지표인 주가·시가총액을 섞을 때 기준 시점을 적는다.
- 실제 회계기준 전체를 초급 레슨에 밀어 넣지 않는다. 대신 어디를 단순화했는지 `scope_note`에 기록한다.
- `저평가`, `고평가`, `좋은 주식`, `사야 한다`, `팔아야 한다`를 지표 하나의 자동 결론으로 사용하지 않는다.
- 실제 기업명과 현재 시세는 MVP 핵심 콘텐츠에서 사용하지 않는다.

---

# 1. L01 — 주식 한 주의 의미

```yaml
lesson_id: L01
concept_ids:
- C_COMPANY
- C_COMMON_STOCK
- C_SHARE
- C_SHAREHOLDER
title: 주식 한 주를 산다는 것은 무엇일까?
hook_question: 내가 산 주식 한 주는 단순한 숫자일까, 회사와 어떤 관계를 나타낼까?
prerequisite_ids: []
learning_objectives:
- 주식이 회사에 돈을 빌려준 증서가 아니라 지분을 나타내는 증권임을 구분한다.
- 한 주가 전체 회사에서 차지하는 비율은 총 주식 수에 따라 달라짐을 설명한다.
- 주주가 회사의 개별 자산을 직접 소유하는 것과 회사 지분을 보유하는 것을 구분한다.
brief:
  title: '주식은 회사의

    지분이에요.'
  core: 회사의 소유권을 나눈 한 단위가 주식이에요.
  example: 전체 10주 중 1주를 갖고 있다면
  result: 회사 지분의 10%를 가진 거예요.
  remember: 주식을 사도 회사 돈을 마음대로 꺼낼 수는 없어요.
exercise:
  title: '내 주식이 늘면,

    지분은 얼마나 될까요?'
  fixed_label: 전체 주식 수
  fixed: 10
  fixed_unit: 주
  input_label: 내 주식 수
  values:
  - 1
  - 2
  - 5
  input_unit: 주
  operation: ownership
  result_label: 지분 비율
  result_unit: '%'
  assumption: 같은 권리의 주식만 있다고 가정해요.
```

## 1.1 상황

증권 앱에서 어떤 회사 주식 1주를 매수하면 계좌에 `1주`가 표시된다. 이 1주는 회사 건물의 한 조각이나 회사 통장의 돈 일부를 직접 떼어 가진다는 뜻이 아니다. **회사가 발행한 지분 단위 중 하나를 보유한다는 뜻**에 가깝다.

## 1.2 쉬운 설명

**주식은 회사에 대한 소유지분(equity)을 나타내는 증권이고, 한 주는 그 지분을 나눈 단위다.** 보통주를 가진 사람은 주주가 된다.

보통주는 일반적으로 다음과 같은 경제적·법적 이해관계와 연결된다.

- 회사 가치가 변하면 보유 주식의 시장가격도 영향을 받을 수 있다.
- 회사가 배당을 결정하면 주식 수와 종류에 따라 배당을 받을 수 있다.
- 많은 보통주는 주주총회에서 의결권을 가진다.
- 회사가 청산될 경우 보통주주는 채권자와 우선주주보다 뒤에 남는 잔여재산에 대한 이해관계를 가진다.

단, **배당은 주식을 갖고 있다는 이유만으로 반드시 지급되는 고정 이자가 아니다.** 또한 모든 종류의 주식이 완전히 같은 권리를 갖는 것도 아니다.

## 1.3 정확한 설명

Investor.gov는 주식을 기업의 소유지분을 나타내는 증권으로 설명하며, 보통주의 경우 일반적으로 의결권과 회사의 자산·이익에 대한 비례적 이해관계를 설명한다. 다만 주주가 회사의 특정 건물, 현금, 특허를 개인 명의로 직접 소유하는 것은 아니다. 법인은 주주와 별도의 법적 주체이고, 주주는 회사에 대한 지분증권을 보유한다.

실제 투자자는 증권사를 통해 주식을 간접 보유하는 `beneficial owner` 형태가 흔하다. MVP에서는 보유 방식의 법적 세부구조보다 **주식=회사에 대한 지분, 채권=채무관계**라는 첫 구분에 집중한다.

## 1.4 예시

같은 권리의 주식이 총 10주인 가상 회사에서 1주를 갖고 있다면 `1 ÷ 10 × 100 = 10%`의 지분이에요.

주식이 총 20주라면 같은 1주도 `1 ÷ 20 × 100 = 5%`예요. 한 주의 지분 비율은 전체 주식 수에 따라 달라져요. 회사 건물이나 통장의 일부를 직접 가져갈 권리라는 뜻은 아니에요.

## 1.5 흔한 오해

### `stock_is_loan`

- 잘못된 생각: “주식을 사면 회사가 나에게 원금을 갚아야 한다.”
- 교정: 주식은 일반적인 채권·대출처럼 만기 원금 상환을 약속하는 채무가 아니다. 보통주는 지분이다.

### `dividend_is_guaranteed`

- 잘못된 생각: “주주가 되면 정해진 이자를 반드시 받는다.”
- 교정: 보통주 배당은 회사의 결정과 법적·재무적 조건 등에 따라 달라질 수 있으며 보장된 이자가 아니다.

### `shareholder_owns_specific_asset`

- 잘못된 생각: “회사 지분 1%면 회사 건물의 1%를 직접 소유한다.”
- 교정: 주주는 회사의 지분을 보유하는 것이며 회사가 보유한 개별 자산의 직접 공동소유자로 단순 치환하면 안 된다.

## 1.6 핵심 카드

> **주식 한 주 = 회사 지분을 나눈 한 단위.** 한 주가 전체에서 차지하는 비율은 총 주식 수에 따라 달라진다.

## 1.7 다음 질문

> 그렇다면 그 한 주에 붙어 있는 `주가`는 회사 전체의 가격일까?

**source_refs:** `S01`, `S02`

---

# 2. L02 — 주가를 읽는 법

```yaml
lesson_id: L02
concept_ids:
- C_SHARE
- C_SHARE_PRICE
title: 화면에 보이는 주가는 무엇의 가격일까?
hook_question: 주가가 100,000원인 회사는 주가가 10,000원인 회사보다 열 배 큰 회사일까?
prerequisite_ids:
- C_SHARE
learning_objectives:
- 주가가 기본적으로 주식 한 주의 시장가격이라는 점을 설명한다.
- 주가만으로 회사 전체의 시장규모를 비교할 수 없음을 구분한다.
- 주식분할처럼 한 주의 단위가 바뀌면 주당 가격도 달라질 수 있음을 이해한다.
brief:
  title: '주가는

    한 주의 가격이에요.'
  core: 과자 한 봉지의 가격처럼, 주가는 주식 한 주의 가격이에요.
  example: 한 주가 1,000원이면, 2주는
  result: 2,000원이에요.
  remember: 한 주 가격만으로 회사 전체 규모는 알 수 없어요.
exercise:
  title: '한 주를 나누면

    가격은 어떻게 될까요?'
  fixed_label: 분할 전 한 주 가격
  fixed: 4000
  fixed_unit: 원
  input_label: 한 주를 나누는 수
  values:
  - 1
  - 2
  - 4
  input_unit: 개
  operation: split
  result_label: 나눈 뒤 한 주 가격
  result_unit: 원
  assumption: 주식분할만 일어나고 다른 조건은 같아요.
```

## 2.1 쉬운 설명

증권 앱의 `주가 25,000원`은 기본적으로 **그 회사 주식 한 주의 시장가격**을 나타낸다. 회사 전체의 가격을 뜻하지 않는다.

따라서 아래 두 회사가 있다고 해서 바로 B회사가 더 작은 회사라고 말할 수 없다.

| 가상 회사 | 주가 |
|---|---:|
| A회사 | 80,000원 |
| B회사 | 10,000원 |

회사 전체의 주식시장 규모를 비교하려면 **주가뿐 아니라 주식이 몇 주 존재하는지**도 알아야 한다.

## 2.2 정확한 설명

시장가격은 시장에서 거래가 이루어지며 형성되는 가격이다. 실제 거래 화면에서는 마지막 체결가격, 매수호가(bid), 매도호가(ask) 등이 서로 다를 수 있다. MVP에서는 호가 미시구조까지 다루지 않고 `주가 = 주식 한 주의 시장가격`이라는 핵심 의미를 사용한다.

주가가 낮다고 해서 자동으로 “싸다”라고 표현하면 안 된다. `싸다`라는 단어에는 흔히 가치평가 판단이 섞이기 때문이다. 초급 과정에서는 다음을 구분한다.

- **주가가 낮다**: 한 주의 가격 숫자가 낮다.
- **시가총액이 작다**: 주가와 주식 수를 결합한 전체 시장가치가 작다.
- **저평가다**: 내재가치와 시장가격을 비교한 별도의 가치판단이며 주가 숫자만으로 결정할 수 없다.

## 2.3 주식분할 사고실험

한 주 가격이 4,000원이고 전체 10주인 가상 회사가 한 주를 두 주로 나눈다고 생각해봐요.

- 나누기 전: `4,000원 × 10주 = 40,000원`
- 나눈 뒤: `2,000원 × 20주 = 40,000원`

다른 조건이 같다면 주식 수는 두 배, 한 주 가격은 절반이 되어 전체 금액은 같아요. 실제 시장가격에는 다른 요인도 작용하므로 이 예시는 주식분할만 따로 보는 사고실험이에요.

## 2.4 흔한 오해

### `low_price_means_cheap_company`

- 잘못된 생각: “1주가 3,000원이면 1주가 100,000원인 종목보다 싼 회사다.”
- 교정: 주가만으로 회사 전체 시장가치나 가치평가 수준을 판단할 수 없다.

### `share_price_equals_company_value`

- 잘못된 생각: “주가는 회사 전체 가격이다.”
- 교정: 주가는 한 주의 가격이다. 전체 시장가치를 보려면 주식 수를 함께 사용한다.

## 2.5 핵심 카드

> **주가 = 한 주의 시장가격.** 회사 전체의 시장규모를 비교하려면 주식 수가 추가로 필요하다.

## 2.6 다음 질문

> 한 주의 가격과 전체 주식 수를 함께 보면 어떤 숫자를 만들 수 있을까?

**source_refs:** `S03`, `S04`

---

# 3. L03 — 시가총액

```yaml
lesson_id: L03
concept_ids:
- C_SHARE_PRICE
- C_SHARES_OUTSTANDING
- C_MARKET_CAP
title: 주가가 다른 두 회사의 시장규모는 어떻게 비교할까?
hook_question: 주가가 더 낮은 회사가 오히려 시장에서 더 큰 가치로 평가될 수도 있을까?
prerequisite_ids:
- C_SHARE
- C_SHARE_PRICE
learning_objectives:
- 시가총액의 기본 산식을 사용할 수 있다.
- 주가와 시가총액을 구분한다.
- 시가총액이 매출·순이익·장부가치·기업가치(EV)와 같은 숫자가 아님을 설명한다.
brief:
  title: '시가총액은

    주가 × 주식 수예요.'
  core: 모든 주식을 지금 주가로 계산한 금액이에요.
  example: 한 주 1,000원 × 전체 10주
  result: = 시가총액 10,000원
  remember: 회사가 실제 가진 현금이나 매출과는 달라요.
exercise:
  title: '주식 수를

    바꿔볼까요?'
  fixed_label: 한 주 가격
  fixed: 1000
  fixed_unit: 원
  input_label: 전체 주식 수
  values:
  - 10
  - 20
  - 50
  input_unit: 주
  operation: market_cap
  result_label: 시가총액
  result_unit: 원
  assumption: 한 주 가격은 그대로예요.
```

## 3.1 핵심 관계

```text
시가총액 = 한 주의 시장가격 × 기준이 되는 발행·유통 주식 수
```

Investor.gov는 시가총액을 **현재 공개시장 주가에 총 발행주식수(outstanding shares)를 곱한 값**으로 설명한다.

## 3.2 비교 예시

학습용 가상 회사의 숫자예요.

- A회사: `2,000원 × 10주 = 20,000원`
- B회사: `1,000원 × 30주 = 30,000원`

B회사는 한 주 가격이 낮지만 시가총액은 더 커요. 한 주 가격뿐 아니라 전체 주식 수도 함께 봐야 해요.

## 3.3 시가총액이 말해주는 것

- 특정 시점에 주식시장이 회사의 **지분 전체**에 부여한 가격 규모를 비교하는 데 유용하다.
- 대형주·중형주·소형주 같은 분류에 활용될 수 있다.
- 주가만 보는 것보다 회사 전체 주식의 시장규모를 이해하는 데 적절하다.

## 3.4 시가총액이 말해주지 않는 것

시가총액은 다음과 동일하지 않다.

- **매출**: 회사가 일정 기간 제품·서비스 등을 통해 인식한 수익
- **순이익**: 비용과 세금 등을 반영한 뒤의 기간 손익
- **장부상 자본**: 회계장부상의 자산·부채를 바탕으로 계산되는 자본
- **현금 보유액**
- **기업가치(Enterprise Value, EV)**: 실무에서 시가총액 외에 순부채 등 다른 요소를 반영해 사용하는 별도 가치지표

따라서 시가총액 10만 원인 회사가 매출도 10만 원이라고 추정해서는 안 된다.

## 3.5 주식 수 기준 주의

학습 과정에서는 `shares_outstanding`이라는 하나의 숫자를 제공해 계산한다. 실제 데이터에서는 다음을 구분해야 할 수 있다.

- 발행주식수
- 자기주식 처리
- 유통주식수(outstanding shares)
- 유동주식수(free float)
- 복수 주식 종류(class)

따라서 실제 종목 데이터를 붙일 경우 데이터 공급자의 정의를 확인해야 한다.

## 3.6 흔한 오해

### `high_price_means_large_company`

주가 100,000원인 회사가 주가 10,000원인 회사보다 반드시 시가총액이 큰 것은 아니다.

### `market_cap_equals_enterprise_value`

시가총액은 지분 시장가치의 대표적 척도이며 EV와 동일한 지표가 아니다.

## 3.7 핵심 카드

> **시가총액 = 주가 × 주식 수.** 한 주의 가격이 낮아도 주식 수가 많으면 시가총액은 더 클 수 있다.

## 3.8 다음 질문

> 시장이 회사에 얼마의 가격을 붙였는지 알았다면, 회사가 실제 사업에서 얼마나 벌고 남겼는지는 어디서 볼까?

**source_refs:** `S03`, `S04`

---

# 4. L04 — 매출과 이익

```yaml
lesson_id: L04
concept_ids:
- C_REVENUE
- C_EXPENSE
- C_NET_INCOME
title: 많이 팔았다는 것과 많이 남겼다는 것은 같을까?
hook_question: 매출이 늘면 회사의 순이익도 반드시 늘어날까?
prerequisite_ids:
- C_COMPANY
learning_objectives:
- 매출과 비용, 순이익의 역할을 구분한다.
- 매출이 크다는 사실만으로 수익성이 높다고 결론 내리지 않는다.
- 순이익과 현금흐름이 같은 개념이 아님을 인지한다.
brief:
  title: '팔아서 번 돈과

    남는 돈은 달라요.'
  core: 매출에서 비용과 세금 등을 빼고 남은 이익이 순이익이에요.
  example: 매출 10,000원 − 총비용 8,000원
  result: = 순이익 2,000원
  remember: 순이익은 통장에 늘어난 현금과 다를 수 있어요.
exercise:
  title: '비용이 늘면

    얼마가 남을까요?'
  fixed_label: 매출
  fixed: 10000
  fixed_unit: 원
  input_label: 총비용
  values:
  - 6000
  - 8000
  - 10000
  input_unit: 원
  operation: profit
  result_label: 순이익
  result_unit: 원
  assumption: 총비용에 모든 비용과 세금을 포함한 단순 예시예요.
```

## 4.1 쉬운 설명

회사가 상품이나 서비스를 판매해 **얼마나 벌어들였는지의 출발점**이 매출이다. 하지만 제품을 만들고, 직원을 고용하고, 광고하고, 이자를 내고, 세금을 내는 등 사업에는 비용이 든다.

따라서 초급 예시는 다음처럼 생각할 수 있다.

```text
매출 - 여러 비용 = 최종적으로 남는 순이익(단순화)
```

하지만 실제 손익계산서는 여러 단계와 항목으로 구성된다.

## 4.2 손익계산서의 기본 흐름

SEC의 입문 자료는 손익계산서를 일정 기간의 매출(revenue), 그 매출과 관련된 비용·경비, 최종 순이익/순손실을 보여주는 보고서로 설명한다.

초급 학습용 흐름:

```text
매출
 - 매출원가
 = 매출총이익
 - 판매비와관리비 등 영업비용
 = 영업이익 계열
 ± 영업외 손익/이자 등
 - 법인세 등
 = 당기순이익(또는 순손실)
```

실제 기업의 표시 항목과 회계기준 적용은 더 복잡할 수 있다.

## 4.3 계산 예시

학습을 위해 모든 비용과 세금을 합쳐 계산해요.

- 매출: 10,000원
- 총비용: 8,000원
- 순이익: `10,000 − 8,000 = 2,000원`

10,000원을 팔아도 전부 이익으로 남는 것은 아니에요. 실제 손익계산서는 영업외 수익과 비용 등 더 많은 항목을 반영해요.

## 4.4 매출이 늘었는데 이익이 줄 수도 있다

| 구분 | 전년 | 올해 |
|---|---:|---:|
| 매출 | 10,000원 | 12,000원 |
| 총비용 | 8,000원 | 11,000원 |
| 순이익 | 2,000원 | 1,000원 |

매출이 늘어도 비용이 더 많이 늘면 남는 이익은 줄어요.

## 4.5 순이익과 현금흐름은 다르다

손익계산서의 순이익은 회계기준에 따라 인식된 수익과 비용의 결과다. 실제 현금 유입·유출 시점과 항상 일치하지 않는다. 감가상각 같은 비현금 비용, 매출채권·재고 변화 등으로 인해 **순이익과 현금흐름은 서로 다를 수 있다.**

MVP에서는 현금흐름표를 계산하지 않지만, `순이익 = 현금 증가액`이라는 오개념은 명확히 막는다.

## 4.6 흔한 오해

### `revenue_equals_profit`

- 잘못된 생각: “매출 10만 원이면 10만 원을 번 회사다.”
- 교정: 매출은 비용 차감 전의 수익 규모를 나타내는 출발점이고 최종 이익과 다르다.

### `more_revenue_always_means_more_profit`

- 잘못된 생각: “매출이 늘면 순이익은 반드시 늘어난다.”
- 교정: 비용, 가격, 원가, 이자, 세금 등 다른 항목의 변화에 따라 순이익은 감소할 수도 있다.

### `net_income_equals_cash_flow`

- 잘못된 생각: “순이익 1만 원이면 현금도 정확히 1만 원 늘었다.”
- 교정: 손익과 현금흐름은 관련되지만 동일하지 않다.

## 4.7 핵심 카드

> **매출은 얼마나 팔았는지, 순이익은 여러 비용을 반영한 뒤 최종적으로 얼마의 이익이 남았는지를 보는 서로 다른 숫자다.**

## 4.8 다음 질문

> 회사 전체의 순이익을 ‘주식 한 주당’ 기준으로 바꾸면 어떤 숫자가 될까?

**source_refs:** `S05`, `S06`

---

# 5. L05 — EPS

```yaml
lesson_id: L05
concept_ids:
- C_NET_INCOME
- C_SHARES_OUTSTANDING
- C_WEIGHTED_AVG_SHARES
- C_BASIC_EPS
- C_DILUTED_EPS
title: 회사의 이익을 주당 기준으로 보면?
hook_question: 순이익이 같은 두 회사라도 주식 수가 다르면 한 주당 이익은 같을까?
prerequisite_ids:
- C_NET_INCOME
- C_SHARE
learning_objectives:
- EPS가 이익을 주당 기준으로 나타내는 지표임을 설명한다.
- 기본 EPS 계산에서 기간의 가중평균 유통보통주식수가 중요함을 이해한다.
- EPS와 배당금을 구분한다.
- 기본 EPS와 희석 EPS가 별도로 존재한다는 사실을 인지한다.
brief:
  title: 'EPS는

    한 주당 이익이에요.'
  core: 보통주 몫의 이익을 주식 수로 나눠요.
  example: 이익 10,000원 ÷ 주식 10주
  result: = EPS 1,000원
  remember: 이 예시는 1년 내내 주식 수가 같아요. EPS가 배당금은 아니에요.
exercise:
  title: '같은 이익을

    더 많은 주식으로 나누면?'
  fixed_label: 보통주 몫의 이익
  fixed: 10000
  fixed_unit: 원
  input_label: 1년 내내 같은 주식 수
  values:
  - 5
  - 10
  - 20
  input_unit: 주
  operation: eps
  result_label: 한 주당 이익 · EPS
  result_unit: 원
  assumption: 보통주만 있고, 각 경우의 주식 수는 1년 내내 같아요.
```

## 5.1 쉬운 설명

EPS(Earnings per Share)는 **기업의 이익을 주식 한 주 기준으로 나누어 보는 지표**다.

초급 문제에서는 다음처럼 시작할 수 있다.

```text
교육용 단순식:
EPS ≈ 보통주에 귀속되는 이익 ÷ 기간의 평균적인 보통주식수
```

예를 들어 보통주에 귀속되는 이익이 12,000원이고, 학습 문제에서 사용하도록 주어진 가중평균 주식 수가 6주라면:

```text
12,000원 ÷ 6주 = 2,000원/주
```

기본 EPS는 **2,000원**이다.

## 5.2 실제 기본 EPS의 정확한 방향

IAS 33과 K-IFRS 제1033호의 기본 구조는 단순히 `당기순이익 ÷ 현재 주식수`가 아니다.

핵심은:

- 분자: 보통주(ordinary equity holders)에 귀속되는 관련 기간 이익
- 분모: 해당 기간의 **가중평균 유통보통주식수**

연결재무제표, 우선주, 중단영업, 주식분할, 무상증자, 유상증자 등 실제 상황에서는 추가 조정이 필요할 수 있다. MVP 계산에서는 이런 복잡성을 제거한 가상 사례를 사용한다.

## 5.3 왜 기말 주식수만 사용하지 않을까?

1년 도중에 주식 수가 바뀌면, 각 주식 수가 유지된 기간까지 반영해요.

- 앞 6개월: 4주
- 뒤 6개월: 6주
- 1년간 보통주 몫의 이익: 10,000원

기간을 반영한 평균 주식 수는 `4 × 0.5 + 6 × 0.5 = 5주`예요.
기본 EPS는 `10,000원 ÷ 5주 = 2,000원`이에요.

기말의 6주만 넣으면 기간 중 변화를 놓쳐요. 기본 학습 예시는 이 부담을 줄이기 위해 주식 수가 1년 내내 같다고 가정해요.

## 5.4 EPS는 배당금이 아니다

EPS 2,000원이라고 해서 주주가 반드시 주당 2,000원을 현금으로 받는 것은 아니다. EPS는 **주당 이익 지표**이고, 배당은 기업이 실제로 주주에게 분배하기로 한 금액이다. 기업은 이익의 일부를 배당하고 일부를 유보할 수도 있으며 배당하지 않을 수도 있다.

## 5.5 기본 EPS와 희석 EPS

상장기업의 재무제표에서는 `Basic EPS`와 `Diluted EPS`가 함께 제시될 수 있다.

- **기본 EPS:** 실제 보통주와 관련된 기본적인 주당이익 계산
- **희석 EPS:** 전환사채, 옵션, 워런트 등 희석 효과가 있는 잠재적 보통주가 보통주로 바뀌는 효과까지 반영한 계산

MVP에서는 희석 EPS를 직접 계산시키지 않고 “실제 공시에는 두 종류가 있을 수 있다”는 수준까지만 소개한다.

## 5.6 흔한 오해

### `eps_equals_dividend`

EPS가 3,000원이라고 해서 배당금이 3,000원으로 확정되는 것은 아니다.

### `eps_uses_current_share_count_only`

기본 EPS의 분모는 단순한 기말 현재 주식 수가 아니라 기간의 가중평균 개념이 중요하다.

### `high_eps_always_means_better_company`

EPS의 절대값은 회사의 주식 수 구조에 영향을 받으므로 서로 다른 회사의 EPS 숫자만 단독 비교해 우열을 판정하면 안 된다.

## 5.7 핵심 카드

> **EPS는 이익을 한 주 기준으로 바꾼 숫자다. 실제 기본 EPS는 보통주 귀속이익과 기간 가중평균 보통주식수를 사용한다.**

## 5.8 다음 질문

> 한 주의 가격인 주가와 한 주당 이익인 EPS를 함께 비교하면 어떤 정보를 얻을 수 있을까?

**source_refs:** `S07`, `S08`, `S09`

---

# 6. L06 — PER

```yaml
lesson_id: L06
concept_ids:
- C_SHARE_PRICE
- C_BASIC_EPS
- C_PE_RATIO
- C_INFORMATION_LIMIT
title: 주가와 주당이익을 함께 보면 무엇이 달라질까?
hook_question: 주가가 더 낮은 회사가 이익 대비로도 더 낮은 가격일까?
prerequisite_ids:
- C_SHARE_PRICE
- C_BASIC_EPS
learning_objectives:
- PER 산식을 정확히 적용한다.
- 주가가 낮은 것과 PER이 낮은 것을 구분한다.
- PER이 시장가격과 이익의 관계를 나타내지만 투자매력 전체를 판정하지는 않음을 설명한다.
- EPS가 음수일 때 일반적인 PER 비교가 어려워짐을 인지한다.
brief:
  title: 'PER은 주가가

    EPS의 몇 배인지예요.'
  core: 주가를 한 주당 이익인 EPS로 나눠요.
  example: 주가 10,000원 ÷ EPS 1,000원
  result: = PER 10배
  remember: 이 예시는 같은 기간의 양수 EPS를 써요. 낮다고 무조건 좋은 투자는 아니에요.
exercise:
  title: 'EPS가 같을 때

    주가를 바꿔봐요.'
  fixed_label: EPS
  fixed: 1000
  fixed_unit: 원
  input_label: 주가
  values:
  - 5000
  - 10000
  - 20000
  input_unit: 원
  operation: pe_price
  result_label: PER
  result_unit: 배
  assumption: 같은 기간·기준의 양수 EPS를 사용해요.
```

## 6.1 핵심 산식

```text
PER(P/E) = 주가 ÷ EPS
```

단위는 보통 `배`로 표현한다.

예를 들어 주가가 20,000원이고 EPS가 2,000원이면:

`20,000 ÷ 2,000 = 10`

→ PER은 **10배**다.

## 6.2 두 회사 비교

| 가상 회사 | 주가 | EPS | PER |
|---|---:|---:|---:|
| A회사 | 20,000원 | 2,000원 | 10배 |
| B회사 | 10,000원 | 500원 | 20배 |

B회사의 주가는 A회사보다 낮지만, EPS까지 함께 보면 B회사의 PER은 오히려 더 높다.

따라서:

- `주가가 낮다`와
- `이익 대비 주가의 배수가 낮다`

는 같은 말이 아니다.

## 6.3 PER이 알려주는 기본 의미

PER은 현재 또는 특정 기준의 주가가 **한 주당 이익의 몇 배 수준에서 거래되는지** 보여주는 비율이다. 과거의 자기 회사와 비교하거나, 조건이 비교 가능한 회사·산업과 함께 살펴보는 데 사용될 수 있다.

하지만 PER 차이에는 여러 이유가 있을 수 있다.

- 미래 성장에 대한 시장 기대
- 사업 위험의 차이
- 경기민감도
- 자본구조
- 일회성 이익·손실
- 회계 처리 및 이익의 질
- 산업별 구조 차이

따라서 PER이 낮다는 이유만으로 `저평가`, 높다는 이유만으로 `고평가`라고 확정하지 않는다.

## 6.4 “PER 10배면 10년이면 원금을 회수한다?”

이 표현은 직관적 비유로 등장하지만 **보장된 회수기간으로 이해하면 틀리다.** 미래 EPS는 변할 수 있고, 회사가 EPS만큼 현금을 전부 주주에게 지급하는 것도 아니며, 주가도 계속 변한다.

앱에서는 PER을 `가격/이익 비율`로 설명하고 `회수기간`이라는 확정 표현은 사용하지 않는다.

## 6.5 과거 PER과 예상 PER

실제 시장에서는 서로 다른 EPS 기준을 사용할 수 있다.

- **Trailing P/E:** 과거 실적 기반 EPS를 사용
- **Forward P/E:** 애널리스트 또는 시장의 미래 예상 EPS를 사용

두 값은 분모의 성격이 다르므로 그대로 섞어 비교하면 안 된다. MVP 계산 문제에서는 **문제 안에 제공된 동일 기간·동일 기준의 EPS**만 사용한다.

## 6.6 EPS가 0 또는 음수라면

EPS가 0이면 `주가 ÷ 0`은 정의할 수 없다. EPS가 음수면 수학적으로 음의 비율이 나오지만, 일반적인 양수 PER과 같은 방식으로 가치배수를 비교하기 어렵기 때문에 데이터 서비스에서는 `N/A` 등으로 표시하기도 한다.

초급 PER 비교 문제에서는 원칙적으로 **양수 EPS**를 사용한다.

## 6.7 흔한 오해

### `low_pe_means_undervalued`

낮은 PER은 낮은 성장 기대나 높은 위험, 일시적으로 높은 이익 등 여러 이유에서 나올 수 있다. 저평가의 충분조건이 아니다.

### `high_pe_means_overvalued`

높은 PER 역시 높은 성장 기대 등 다양한 이유를 반영할 수 있다. 고평가의 충분조건이 아니다.

### `pe_is_payback_period`

PER은 미래 수익과 현금배당이 고정되어 있다는 보장이 없는 비율이므로 확정 회수기간으로 해석하지 않는다.

## 6.8 핵심 카드

> **PER = 주가 ÷ EPS.** 주가와 이익을 함께 비교하는 비율이지만, PER 하나만으로 좋은 투자·저평가 여부를 확정할 수 없다.

## 6.9 다음 질문

> PER이 어제 20배였는데 오늘 15배가 됐다면, 무엇이 변한 것일까? 주가일까, EPS일까, 둘 다일까?

**source_refs:** `S10`, `S05`

---

# 7. L07 — 숫자가 변하는 이유

```yaml
lesson_id: L07
concept_ids:
- C_SHARE_PRICE
- C_SHARES_OUTSTANDING
- C_MARKET_CAP
- C_BASIC_EPS
- C_PE_RATIO
title: 같은 지표가 달라지는 이유는 하나뿐일까?
hook_question: PER이 내려가면 항상 주가가 하락한 것일까?
prerequisite_ids:
- C_MARKET_CAP
- C_BASIC_EPS
- C_PE_RATIO
learning_objectives:
- 비율의 분자와 분모를 나누어 변화를 분석한다.
- 다른 조건을 고정했을 때 각 변수 변화의 방향을 설명한다.
- 실제 시장에서는 여러 변수가 동시에 변할 수 있음을 구분한다.
brief:
  title: 'PER이 내려간 이유는

    하나가 아니에요.'
  core: 주가가 내려가도, EPS가 올라가도 PER은 낮아질 수 있어요.
  example: 주가 20,000원 그대로, EPS 1,000 → 2,000원
  result: PER은 20배 → 10배가 돼요.
  remember: 무엇이 바뀌고 무엇이 그대로인지 먼저 봐요.
exercise:
  title: '주가는 그대로,

    EPS만 올라가면?'
  fixed_label: 주가
  fixed: 20000
  fixed_unit: 원
  input_label: EPS
  values:
  - 1000
  - 2000
  - 4000
  input_unit: 원
  operation: pe_eps
  result_label: PER
  result_unit: 배
  assumption: 주가는 고정하고 같은 기준의 EPS만 바꿔요.
```

## 7.1 기본 상태

```yaml
base_case:
  share_price: 30000
  eps: 1500
  pe: 20
```

`30,000 ÷ 1,500 = 20배`

## 7.2 한 변수씩 바꿔보기

| 상황 | 주가 | EPS | PER | 설명 |
|---|---:|---:|---:|---|
| 기준 | 30,000원 | 1,500원 | 20배 | 기준 상태 |
| A | 36,000원 | 1,500원 | 24배 | EPS가 같고 주가만 오르면 PER 상승 |
| B | 30,000원 | 2,000원 | 15배 | 주가가 같고 EPS만 오르면 PER 하락 |
| C | 36,000원 | 2,000원 | 18배 | 둘 다 변하면 결과는 상대적 변화에 따라 결정 |

따라서 `PER이 하락했다 → 주가가 하락했다`는 결론은 성립하지 않는다. **EPS가 증가해서 PER이 낮아졌을 수도 있다.**

## 7.3 역으로 원인을 하나로 확정할 수 없는 이유

PER은 두 숫자의 비율이다.

```text
PER = P / E
```

PER만 20배에서 15배로 변했다는 사실만 알고 있다면 가능한 경우는 여러 개다.

- P가 낮아짐, E는 동일
- P는 동일, E가 높아짐
- P와 E가 모두 변했지만 E 증가율이 상대적으로 큼
- 시점/기간 기준이 바뀜

따라서 비율 변화의 원인을 확인하려면 분자와 분모를 각각 확인해야 한다.

## 7.4 시가총액도 구성요소를 나눠 본다

```text
시가총액 = 주가 × 주식 수
```

- 주식 수가 같고 주가가 10% 오르면 시가총액도 10% 오른다.
- 주가가 같고 기준 주식 수가 늘면 시가총액은 산술적으로 증가한다.
- 현실에서는 신주발행 같은 사건이 주가에도 영향을 줄 수 있으므로 “주식 수 증가 → 시가총액 반드시 그만큼 증가”를 시장 예측 규칙으로 사용하면 안 된다.

## 7.5 EPS 변화도 분해한다

교육용 핵심 관계:

```text
EPS ≈ 보통주 귀속이익 / 가중평균 주식 수
```

다른 조건이 같다면:

- 이익 증가 → EPS 증가 방향
- 가중평균 주식 수 증가 → EPS 감소 방향

하지만 현실에서는 이익과 주식 수가 동시에 변할 수 있다. 주식 수 증가를 무조건 EPS 하락으로 단정하거나, EPS 증가를 무조건 매출 증가 때문이라고 단정하면 안 된다.

## 7.6 변화 문제를 푸는 3단계

1. **공식을 적는다.** 무엇이 분자이고 분모인지 확인한다.
2. **문제에서 고정된 값을 찾는다.** “다른 조건은 동일”이 명시되었는지 본다.
3. **실제 시장 설명인지 수학 관계 확인인지 구분한다.** 학습 문제의 ceteris paribus(다른 조건 동일)와 현실 예측을 섞지 않는다.

## 7.7 핵심 카드

> **비율이 변했다면 분자와 분모를 각각 확인한다.** 결과 숫자 하나만 보고 변화 원인을 하나로 단정하지 않는다.

## 7.8 다음 질문

> 이제 주가·시가총액·매출·순이익·EPS·PER을 한 회사 사례에서 함께 읽어보면 어디까지 판단할 수 있을까?

**source_refs:** `S03`, `S07`, `S10`

---

# 8. L08 — 연결해서 읽기

```yaml
lesson_id: L08
concept_ids:
- C_SHARE_PRICE
- C_SHARES_OUTSTANDING
- C_MARKET_CAP
- C_REVENUE
- C_EXPENSE
- C_NET_INCOME
- C_BASIC_EPS
- C_PE_RATIO
- C_INFORMATION_LIMIT
title: 숫자를 연결해서 읽고, 모르는 것은 모른다고 말하기
hook_question: 숫자가 여러 개 주어졌을 때 무엇을 비교할 수 있고 무엇은 아직 판단할 수 없을까?
prerequisite_ids:
- C_MARKET_CAP
- C_NET_INCOME
- C_BASIC_EPS
- C_PE_RATIO
learning_objectives:
- 여러 지표를 같은 사례에서 연결해 계산하고 비교한다.
- 서로 다른 지표가 답하는 질문을 구분한다.
- 주어진 정보만으로 판단할 수 없는 문제를 식별한다.
brief:
  title: '숫자로 아는 것과

    더 알아볼 것을 나눠요.'
  core: 시가총액과 PER은 비교할 수 있지만, 좋은 투자까지 정해주지는 않아요.
  example: A회사 PER 5배, B회사 PER 10배
  result: A의 PER이 더 낮다는 것만 알 수 있어요.
  remember: 성장 가능성과 위험 같은 정보도 필요해요.
```

## 8.1 통합 가상 사례

```yaml
learning_case_id: CASE_L08_A
companies:
  A회사:
    share_price: 10000
    shares: 4
    revenue: 50000
    expenses: 42000
    net_income: 8000
    eps: 2000
    pe: 5
    market_cap: 40000
  B회사:
    share_price: 5000
    shares: 10
    revenue: 80000
    expenses: 75000
    net_income: 5000
    eps: 500
    pe: 10
    market_cap: 50000
```

같은 회계기간의 학습용 가상 회사예요. 보통주만 있고, 주식 수는 1년 내내 같다고 가정해요.

| 항목 | A회사 | B회사 |
|---|---:|---:|
| 주가 | 10,000원 | 5,000원 |
| 주식 수 | 4주 | 10주 |
| 매출 | 50,000원 | 80,000원 |
| 총비용 | 42,000원 | 75,000원 |
| 순이익 | 8,000원 | 5,000원 |
| EPS | 2,000원 | 500원 |
| PER | 5배 | 10배 |
| 시가총액 | 40,000원 | 50,000원 |

A회사: 시가총액 `10,000 × 4 = 40,000원`, EPS `8,000 ÷ 4 = 2,000원`, PER `10,000 ÷ 2,000 = 5배`.

B회사: 시가총액 `5,000 × 10 = 50,000원`, EPS `5,000 ÷ 10 = 500원`, PER `5,000 ÷ 500 = 10배`.

B회사의 주가가 더 낮아도 시가총액은 더 커요. A회사의 PER이 더 낮아도 더 좋은 투자라고 단정할 수는 없어요.

## 8.2 이 표만으로 말할 수 있는 것

- B회사의 **주가**가 더 낮다.
- B회사의 **시가총액**은 더 크다.
- B회사의 **매출**은 더 크다.
- A회사의 **순이익**은 더 크다.
- A회사의 **EPS**가 더 높다.
- A회사의 **PER**이 더 낮다.

이 문장들은 표의 숫자와 산식으로 직접 확인할 수 있다.

## 8.3 이 표만으로 말할 수 없는 것

다음 결론에는 추가 정보가 필요하다.

- 어느 회사가 미래에 더 빨리 성장할 것인가?
- 어느 회사의 이익이 더 지속가능한가?
- 어느 회사의 부채 부담이 더 큰가?
- 어느 회사가 현금을 더 잘 창출하는가?
- 어느 회사의 경영진이 더 우수한가?
- 어느 회사가 현재 `저평가`되어 있는가?
- 어느 주식을 사야 하는가?

필요할 수 있는 추가 정보:

- 과거 여러 기간의 매출·이익 추세
- 영업현금흐름·잉여현금흐름
- 부채와 현금
- 사업 부문과 경쟁환경
- 이익의 일회성 요인
- 미래 성장 전망과 불확실성
- 주식 발행·자사주·희석 요인
- 산업 특성과 비교기업

## 8.4 “추가 정보가 필요하다”도 정답이다

금융 학습에서 중요한 능력은 모든 문제에 즉시 결론을 내리는 것이 아니다. **현재 가진 정보가 어떤 질문에 충분하고 어떤 질문에는 부족한지를 구분하는 것**도 핵심 학습 결과다.

예:

> “A의 PER이 더 낮으니 A가 더 좋은 투자다.”

이 문장은 주어진 데이터만으로는 확정할 수 없다. 정확한 답은:

> “A의 PER이 더 낮다는 것은 확인할 수 있지만, 투자 매력 전체를 판단하려면 성장·위험·현금흐름·재무구조 등 추가 정보가 필요하다.”

## 8.5 서로 다른 지표가 답하는 질문

| 지표 | 주로 답하는 질문 | 단독으로 답하지 못하는 질문 |
|---|---|---|
| 주가 | 한 주가 얼마에 거래되는가? | 회사 전체가 얼마나 큰가? |
| 시가총액 | 주식시장 기준 전체 지분가치 규모는? | 사업이 얼마나 돈을 버는가? |
| 매출 | 일정 기간 사업의 수익 규모는? | 최종적으로 얼마가 남았는가? |
| 순이익 | 비용 등을 반영한 기간 최종 손익은? | 현금이 정확히 얼마나 늘었는가? |
| EPS | 보통주 한 주 기준 이익은? | 실제 배당금은 얼마인가? |
| PER | 주가가 EPS의 몇 배인가? | 반드시 저평가/고평가인가? |

## 8.6 최종 코스 요약

```text
한 주를 보유한다
  ↓
그 한 주에 시장가격(주가)이 있다
  ↓
주가 × 주식 수 = 시가총액

회사는 일정 기간 매출을 만들고 비용을 부담한다
  ↓
최종 손익을 순이익으로 본다
  ↓
보통주 귀속이익 ÷ 가중평균 주식 수 = 기본 EPS
  ↓
주가 ÷ EPS = PER
  ↓
각 숫자가 말하는 범위와 말하지 못하는 범위를 구분한다
```

## 8.7 코스 완료 문구

> 이제 주가 하나만 보고 회사를 비교하지 않고, 시가총액·이익·EPS·PER이 각각 어떤 질문에 답하는지 구분할 수 있습니다. 다음 단계에서는 이 숫자들을 시간에 따라 비교하거나 다른 투자상품과 연결할 수 있습니다.

**source_refs:** `S03`, `S05`, `S07`, `S10`

---

# 9. 앱 내 개념 카드용 축약 데이터

## `C_SHARE`

```yaml
name: 주식 한 주
one_liner: 회사 지분을 나눈 한 단위.
remember: 한 주가 회사의 몇 %인지는 전체 주식 수에 따라 달라진다.
not_equal_to: 회사에 빌려준 돈, 회사 자산 한 조각의 직접 소유권
```

## `C_SHARE_PRICE`

```yaml
name: 주가
one_liner: 주식 한 주의 시장가격.
remember: 한 주의 가격과 회사 전체 시장가치는 다르다.
not_equal_to: 시가총액, 기업 전체 가치판정
```

## `C_MARKET_CAP`

```yaml
name: 시가총액
one_liner: 주가와 주식 수를 곱한 주식 전체의 시장가치 규모.
formula: 주가 × 주식 수
remember: 주가가 낮아도 주식 수가 많으면 시가총액이 클 수 있다.
not_equal_to: 매출, 순이익, 장부가치, EV
```

## `C_REVENUE`

```yaml
name: 매출
one_liner: 일정 기간 제품·서비스 판매 등으로 인식한 수익의 대표적 규모.
remember: 비용을 빼기 전의 출발점이므로 순이익과 다르다.
not_equal_to: 순이익, 현금 유입액
```

## `C_NET_INCOME`

```yaml
name: 당기순이익
one_liner: 일정 기간 수익에서 비용·세금 등을 반영한 최종 손익.
remember: 이익과 현금흐름은 같은 숫자가 아니다.
not_equal_to: 매출, 영업현금흐름
```

## `C_BASIC_EPS`

```yaml
name: 기본 EPS
one_liner: 보통주에 귀속되는 이익을 한 주 기준으로 본 지표.
formula: 보통주 귀속이익 ÷ 가중평균 유통보통주식수
remember: 기말 주식수 하나만 사용하는 단순 계산이 아니다.
not_equal_to: 배당금, 현금흐름/주
```

## `C_PE_RATIO`

```yaml
name: PER
one_liner: 주가가 EPS의 몇 배인지 나타내는 비율.
formula: 주가 ÷ EPS
remember: 낮다고 자동 저평가, 높다고 자동 고평가가 아니다.
not_equal_to: 확정 회수기간, 매수·매도 신호
```

---

# 10. 콘텐츠 검수 체크리스트

각 레슨 공개 전 아래 조건을 확인한다.

- [ ] 정의가 특정 국가의 세법·거래제도를 보편적 금융원리처럼 표현하지 않았는가?
- [ ] 시점값(주가·시가총액)과 기간값(매출·이익·EPS)의 기준이 섞이지 않았는가?
- [ ] 계산 예시의 단위가 모두 맞는가?
- [ ] EPS 예시는 `기말 주식수만 사용`하는 식으로 실제 개념을 잘못 가르치지 않는가?
- [ ] PER에서 사용한 주가와 EPS의 기준이 명시되었는가?
- [ ] 음수 EPS를 일반적인 양수 PER과 동일하게 비교하도록 만들지 않았는가?
- [ ] `PER 낮음 = 저평가` 같은 확정 문장이 없는가?
- [ ] 순이익을 현금흐름과 동일시하지 않는가?
- [ ] 시가총액을 EV·매출·장부가치와 동일시하지 않는가?
- [ ] 문제의 정답이 하나라면 조건만으로 유일하게 결정되는가?
- [ ] 현실 예측과 `다른 조건 동일` 학습 계산을 구분했는가?
- [ ] 출처와 검토일이 기록되어 있는가?

---

# 11. 출처 카탈로그

```yaml
sources:
  - id: S01
    organization: U.S. SEC Investor.gov
    title: Stock
    url: https://www.investor.gov/introduction-investing/investing-basics/glossary/stock
    used_for: [L01]

  - id: S02
    organization: U.S. SEC Investor.gov
    title: Stocks - FAQs
    url: https://www.investor.gov/introduction-investing/investing-basics/investment-products/stocks
    used_for: [L01]

  - id: S03
    organization: U.S. SEC Investor.gov
    title: Market Capitalization
    url: https://www.investor.gov/introduction-investing/investing-basics/glossary/market-capitalization
    used_for: [L02, L03, L07, L08]

  - id: S04
    organization: U.S. SEC Investor.gov
    title: Investor Bulletin - Index Funds
    url: https://www.investor.gov/introduction-investing/general-resources/news-alerts/alerts-bulletins/investor-bulletins-26
    used_for: [L02, L03]

  - id: S05
    organization: U.S. Securities and Exchange Commission
    title: Beginners' Guide to Financial Statements
    url: https://www.sec.gov/about/reports-publications/beginners-guide-financial-statements
    used_for: [L04, L06, L08]

  - id: S06
    organization: U.S. SEC Office of the Advocate for Small Business Capital Formation
    title: What is an income statement?
    url: https://www.sec.gov/files/income-statement-building-blocks.pdf
    used_for: [L04]

  - id: S07
    organization: IFRS Foundation
    title: IAS 33 Earnings per Share
    url: https://www.ifrs.org/issued-standards/list-of-standards/ias-33-earnings-per-share/
    used_for: [L05, L07, L08]

  - id: S08
    organization: 한국회계기준원
    title: 시행 중 K-IFRS 제1033호 주당이익
    url: https://www.kasb.or.kr/front/board/ingAccountingList.do
    used_for: [L05]

  - id: S09
    organization: 한국회계기준원
    title: 주당이익 산출 시 보통주 귀속이익 관련 K-IFRS 제1033호 질의회신
    url: https://kasb.or.kr/front/board/View016005.do?seq=38599
    used_for: [L05]
    note: 질의회신 페이지 자체는 정규 기준서 본문이 아니므로 기준서 원칙 보조 확인용으로만 사용한다.

  - id: S10
    organization: U.S. SEC Investor.gov
    title: Price-earnings (P/E) Ratio
    url: https://www.investor.gov/introduction-investing/investing-basics/glossary/price-earnings-pe-ratio
    used_for: [L06, L07, L08]
```

**검토일:** 2026-10-06  
**검토 상태:** L01~L08 핵심 정의·산식 1차 검증 완료. 실제 한국 상장사 데이터를 연결하는 기능을 추가할 때는 KRX/FSS/DART 데이터 필드와 주식수·EPS 산정 기준을 별도로 매핑할 것.
