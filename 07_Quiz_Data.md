# 07. Quiz Data
## FinStep L01~L08 검증 문항 원천 데이터

**학습 화면 개정:** 2026-10-07 · 짧은 문항·한 문장 해설·10만 원 이하 가상 금액  
**버전:** v1.0  
**기준일:** 2026-10-06  
**문항 수:** 32개  
**대상 코스:** `C01 — 주가를 넘어 기업의 숫자 이해하기`  
**용도:** 레슨 확인 문제, 변형 문제, 오답 복습, 코스 통합 평가의 원천 데이터

> 이 문제은행은 투자 성향이나 종목 선택을 채점하지 않는다. 정답이 존재하는 개념·산식·논리 범위만 객관식으로 평가한다. 실제 시장 전망처럼 정답이 하나가 아닌 문제는 “추가 정보가 필요하다”를 정답으로 허용한다.

---

# 0. 문항 설계 규칙

## 0.1 권장 스키마

```yaml
question_id: string
lesson_id: string
concept_ids: [string]
question_type: single_choice | multi_select
skill_type: concept_discrimination | calculation | relationship_application | interpretation | information_limit
difficulty: 1 | 2 | 3
prompt: string
assumptions: [string]
options:
  A: string
  B: string
  C: string
  D: string
answer: [A]
key_takeaway: string
explanation: string
option_feedback:
  A: string
  B: string
  C: string
  D: string
misconception_tags: [string]
remediation_concept_ids: [string]
source_refs: [string]
```

## 0.2 난이도 기준

- `1`: 정의·직접 계산·명시적 구별
- `2`: 두 개 이상의 개념 연결 또는 조건 변화
- `3`: 정보의 한계, 여러 지표 통합, 오개념 판별

## 0.3 출제 원칙

- 질문·선택지는 핵심만 짧게 쓴다. 금액은 10만 원 이하로 두고 암산보다 개념 확인에 집중한다.
- 정답 뒤에는 `key_takeaway` 한 문장, 오답 뒤에는 해당 `option_feedback`을 먼저 보여준다. 전체 선택지 해설과 관련 개념은 선택해서 읽는다.
- 가중평균·희석 EPS·EV의 세부 계산을 기본 확인 문제에서 요구하지 않는다. 정밀한 설명은 레슨의 선택형 상세 본문에 남긴다.

- 같은 문제에서 단위와 기간을 섞지 않는다.
- 계산 결과는 소수점 반올림이 필요하면 문제에서 규칙을 명시한다.
- PER 계산은 별도 지시가 없으면 양수 EPS만 사용한다.
- EPS 계산은 학습용으로 주어진 `보통주 귀속이익`과 `가중평균 유통보통주식수`를 사용한다.
- `PER 낮음 = 저평가`, `주가 낮음 = 싼 회사` 같은 문장을 정답으로 만들지 않는다.
- 실제 시장 인과를 묻는 대신 `다른 조건이 동일할 때`를 명시한다.
- 해설을 본 뒤 같은 문제를 다시 맞힌 기록과 새로운 변형 문제의 정답을 별도 이벤트로 저장한다.

---

# 1. L01 — 주식 한 주의 의미

## Q_L01_001

```yaml
question_id: Q_L01_001
lesson_id: L01
concept_ids:
- C_COMMON_STOCK
- C_SHARE
question_type: single_choice
skill_type: concept_discrimination
difficulty: 1
prompt: 주식 한 주를 산다는 건 어떤 뜻일까요?
options:
  A: 회사에 돈을 빌려줘요.
  B: 회사 지분의 한 단위를 가져요.
  C: 회사 건물의 한 칸을 가져요.
  D: 매년 정해진 돈을 받아요.
answer:
- B
explanation: 주식은 회사의 소유권을 나눈 지분이에요.
option_feedback:
  A: 돈을 빌려주는 관계와 주식을 사는 것은 달라요.
  B: 주식 한 주는 회사 지분의 한 단위예요.
  C: 건물은 회사의 자산이에요. 주주가 한 칸을 직접 갖는 것은 아니에요.
  D: 보통주에 정해진 지급이 보장되지는 않아요.
misconception_tags:
- stock_is_loan
- shareholder_owns_specific_asset
remediation_concept_ids:
- C_COMMON_STOCK
- C_SHARE
source_refs:
- S01
- S02
key_takeaway: 주식은 회사의 소유권을 나눈 지분이에요.
```

## Q_L01_002

```yaml
question_id: Q_L01_002
lesson_id: L01
concept_ids:
- C_SHARE
question_type: single_choice
skill_type: calculation
difficulty: 1
prompt: 전체 20주 중 2주를 갖고 있어요. 내 지분은?
options:
  A: 1%
  B: 10%
  C: 20%
  D: 50%
answer:
- B
explanation: 2 ÷ 20 × 100 = 10%예요.
option_feedback:
  A: 20주의 1%는 0.2주예요.
  B: 20주 중 2주는 10분의 1, 즉 10%예요.
  C: 20%라면 4주가 필요해요.
  D: 50%라면 10주가 필요해요.
misconception_tags:
- one_share_means_one_percent
remediation_concept_ids:
- C_SHARE
source_refs:
- S01
key_takeaway: 2 ÷ 20 × 100 = 10%예요.
assumptions:
- 모든 주식의 권리는 같아요.
```

## Q_L01_003

```yaml
question_id: Q_L01_003
lesson_id: L01
concept_ids:
- C_COMMON_STOCK
question_type: single_choice
skill_type: interpretation
difficulty: 1
prompt: 주식을 사면 배당을 꼭 받을까요?
options:
  A: EPS만큼 꼭 받아요.
  B: 이자처럼 정해진 돈을 받아요.
  C: 회사가 배당을 정하면 받을 수 있어요.
  D: 매출이 생기면 반드시 받아요.
answer:
- C
explanation: 배당 여부와 금액은 회사의 결정 등에 따라 달라져요.
option_feedback:
  A: EPS와 배당금은 달라요.
  B: 보통주 배당은 약속된 이자가 아니에요.
  C: 배당할 수도 있지만, 지급이 보장되지는 않아요.
  D: 매출이 생겼다는 이유만으로 배당이 정해지지는 않아요.
misconception_tags:
- dividend_is_guaranteed
- eps_equals_dividend
remediation_concept_ids:
- C_COMMON_STOCK
source_refs:
- S02
key_takeaway: 배당 여부와 금액은 회사의 결정 등에 따라 달라져요.
```

## Q_L01_004

```yaml
question_id: Q_L01_004
lesson_id: L01
concept_ids:
- C_SHARE
- C_SHAREHOLDER
question_type: single_choice
skill_type: concept_discrimination
difficulty: 1
prompt: 빵 회사의 주식을 샀어요. 무엇을 가진 걸까요?
options:
  A: 회사의 오븐 일부
  B: 회사에 대한 지분
  C: 회사에 빌려준 돈을 받을 권리
  D: 회사 통장에서 돈을 꺼낼 권리
answer:
- B
explanation: 주주는 회사에 대한 지분을 가져요. 회사 자산을 직접 나눠 갖지는 않아요.
option_feedback:
  A: 오븐은 회사의 자산이에요.
  B: 회사의 소유권을 나눈 지분을 가진 거예요.
  C: 주식은 돈을 빌려준 증서가 아니에요.
  D: 주주가 회사 돈을 마음대로 인출할 수는 없어요.
misconception_tags:
- shareholder_owns_specific_asset
remediation_concept_ids:
- C_SHAREHOLDER
- C_SHARE
source_refs:
- S01
key_takeaway: 주주는 회사에 대한 지분을 가져요. 회사 자산을 직접 나눠 갖지는 않아요.
```

---

# 2. L02 — 주가

## Q_L02_001

```yaml
question_id: Q_L02_001
lesson_id: L02
concept_ids:
- C_SHARE_PRICE
question_type: single_choice
skill_type: concept_discrimination
difficulty: 1
prompt: 주가가 1,000원이에요. 무엇의 가격일까요?
options:
  A: 회사 전체
  B: 회사의 매출
  C: 주식 한 주
  D: 주주가 받을 배당금
answer:
- C
explanation: 주가는 주식 한 주의 시장가격이에요.
option_feedback:
  A: 회사 전체 주식의 가격은 주식 수도 함께 봐야 해요.
  B: 매출은 회사가 판매 등으로 얻은 수익이에요.
  C: 1,000원은 한 주의 시장가격이에요.
  D: 주가와 배당금은 달라요.
misconception_tags:
- share_price_equals_company_value
remediation_concept_ids:
- C_SHARE_PRICE
source_refs:
- S03
key_takeaway: 주가는 주식 한 주의 시장가격이에요.
```

## Q_L02_002

```yaml
question_id: Q_L02_002
lesson_id: L02
concept_ids:
- C_SHARE_PRICE
- C_MARKET_CAP
question_type: single_choice
skill_type: information_limit
difficulty: 1
prompt: A 주가 10,000원, B 주가 1,000원. 확실히 아는 것은?
options:
  A: A의 시가총액이 10배예요.
  B: A의 한 주 가격이 10배예요.
  C: A의 순이익이 10배예요.
  D: B가 더 좋은 투자예요.
answer:
- B
explanation: 주가만으로 알 수 있는 것은 한 주 가격의 차이예요.
option_feedback:
  A: 시가총액은 주식 수도 알아야 해요.
  B: 10,000 ÷ 1,000 = 10배예요.
  C: 주가만으로 순이익은 알 수 없어요.
  D: 투자 판단에는 더 많은 정보가 필요해요.
misconception_tags:
- high_price_means_large_company
- low_price_means_cheap_company
remediation_concept_ids:
- C_SHARE_PRICE
- C_MARKET_CAP
source_refs:
- S03
key_takeaway: 주가만으로 알 수 있는 것은 한 주 가격의 차이예요.
```

## Q_L02_003

```yaml
question_id: Q_L02_003
lesson_id: L02
concept_ids:
- C_SHARE_PRICE
- C_SHARES_OUTSTANDING
- C_MARKET_CAP
question_type: single_choice
skill_type: relationship_application
difficulty: 1
prompt: 한 주 4,000원, 전체 10주. 한 주를 2주로 나누면?
options:
  A: 한 주 2,000원 · 전체 20주
  B: 한 주 8,000원 · 전체 20주
  C: 한 주 2,000원 · 전체 5주
  D: 한 주 4,000원 · 전체 20주
answer:
- A
explanation: 주식 수는 2배, 한 주 가격은 절반. 전체는 40,000원으로 같아요.
option_feedback:
  A: 2,000원 × 20주 = 40,000원이에요.
  B: 조각 수가 늘면 한 조각 가격은 낮아져요.
  C: 한 주를 둘로 나누므로 주식 수는 늘어요.
  D: 주식 수만 늘고 가격이 같으면 전체 금액이 달라져요.
misconception_tags:
- share_price_equals_company_value
remediation_concept_ids:
- C_SHARE_PRICE
- C_MARKET_CAP
source_refs:
- S03
- S04
key_takeaway: 주식 수는 2배, 한 주 가격은 절반. 전체는 40,000원으로 같아요.
assumptions:
- 주식분할 외의 조건은 같아요.
```

## Q_L02_004

```yaml
question_id: Q_L02_004
lesson_id: L02
concept_ids:
- C_SHARE_PRICE
- C_INFORMATION_LIMIT
question_type: single_choice
skill_type: interpretation
difficulty: 1
prompt: 한 주가 5,000원이라는 사실만 알아요. 맞는 말은?
options:
  A: 저평가된 회사예요.
  B: 주가 50,000원인 회사보다 작아요.
  C: 한 주의 가격이 5,000원이에요.
  D: PER이 낮은 회사예요.
answer:
- C
explanation: 한 주 가격만으로 회사 규모나 저평가 여부는 알 수 없어요.
option_feedback:
  A: 저평가 여부는 다른 정보도 필요해요.
  B: 주식 수를 모르면 규모를 비교할 수 없어요.
  C: 주가가 알려주는 것은 한 주의 가격이에요.
  D: PER은 EPS도 알아야 계산해요.
misconception_tags:
- low_price_means_cheap_company
remediation_concept_ids:
- C_SHARE_PRICE
- C_INFORMATION_LIMIT
source_refs:
- S03
key_takeaway: 한 주 가격만으로 회사 규모나 저평가 여부는 알 수 없어요.
```

---

# 3. L03 — 시가총액

## Q_L03_001

```yaml
question_id: Q_L03_001
lesson_id: L03
concept_ids:
- C_MARKET_CAP
question_type: single_choice
skill_type: calculation
difficulty: 1
prompt: 한 주 2,000원, 전체 20주. 시가총액은?
options:
  A: 2,000원
  B: 20,000원
  C: 40,000원
  D: 100,000원
answer:
- C
explanation: 2,000원 × 20주 = 40,000원이에요.
option_feedback:
  A: 2,000원은 한 주 가격이에요.
  B: 전체 20주의 가격을 곱해봐요.
  C: 한 주 가격에 전체 주식 수를 곱해요.
  D: 2,000 × 20은 40,000이에요.
misconception_tags: []
remediation_concept_ids:
- C_MARKET_CAP
source_refs:
- S03
key_takeaway: 2,000원 × 20주 = 40,000원이에요.
```

## Q_L03_002

```yaml
question_id: Q_L03_002
lesson_id: L03
concept_ids:
- C_SHARE_PRICE
- C_SHARES_OUTSTANDING
- C_MARKET_CAP
question_type: single_choice
skill_type: relationship_application
difficulty: 1
prompt: A는 2,000원 × 10주, B는 1,000원 × 30주. 더 큰 시가총액은?
options:
  A: B · 30,000원
  B: A · 20,000원
  C: 둘 다 20,000원
  D: 주가가 높은 A가 무조건 커요.
answer:
- A
explanation: A는 20,000원, B는 30,000원. 주가가 낮은 B의 시가총액이 더 커요.
option_feedback:
  A: 주식 수까지 곱하면 B가 더 커요.
  B: A는 20,000원이지만 B는 30,000원이에요.
  C: B는 1,000 × 30 = 30,000원이에요.
  D: 한 주 가격만 비교하면 전체 규모를 놓쳐요.
misconception_tags:
- high_price_means_large_company
remediation_concept_ids:
- C_MARKET_CAP
source_refs:
- S03
key_takeaway: A는 20,000원, B는 30,000원. 주가가 낮은 B의 시가총액이 더 커요.
```

## Q_L03_003

```yaml
question_id: Q_L03_003
lesson_id: L03
concept_ids:
- C_MARKET_CAP
- C_REVENUE
- C_NET_INCOME
question_type: single_choice
skill_type: concept_discrimination
difficulty: 1
prompt: 시가총액이 100,000원이에요. 이 숫자만으로 모르는 것은?
options:
  A: 전체 주식의 시장 평가액
  B: 주가 × 주식 수의 값
  C: 1년간 매출
  D: 한 주 가격과는 다른 값이라는 점
answer:
- C
explanation: 시가총액과 매출은 달라요. 시가총액만으로 매출은 알 수 없어요.
option_feedback:
  A: 시가총액은 전체 주식의 시장 평가액이에요.
  B: 주가 × 주식 수로 구해요.
  C: 매출을 알려면 별도 정보가 필요해요.
  D: 한 주 가격은 주가, 전체 주식의 평가액은 시가총액이에요.
misconception_tags:
- market_cap_equals_revenue
remediation_concept_ids:
- C_MARKET_CAP
- C_REVENUE
source_refs:
- S03
key_takeaway: 시가총액과 매출은 달라요. 시가총액만으로 매출은 알 수 없어요.
```

## Q_L03_004

```yaml
question_id: Q_L03_004
lesson_id: L03
concept_ids:
- C_MARKET_CAP
question_type: single_choice
skill_type: calculation
difficulty: 1
prompt: 한 주 3,000원, 전체 10주. 전체 주식의 시장 평가액은?
options:
  A: 3,000원
  B: 30,000원
  C: 13,000원
  D: 매출을 알아야 계산해요.
answer:
- B
explanation: 3,000원 × 10주 = 30,000원이에요.
option_feedback:
  A: 3,000원은 한 주 가격이에요.
  B: 10주 전체를 계산하면 30,000원이에요.
  C: 주가와 주식 수는 더하지 않고 곱해요.
  D: 시가총액은 주가와 주식 수로 계산해요.
misconception_tags: []
remediation_concept_ids:
- C_MARKET_CAP
source_refs:
- S03
key_takeaway: 3,000원 × 10주 = 30,000원이에요.
```

---

# 4. L04 — 매출·비용·순이익

## Q_L04_001

```yaml
question_id: Q_L04_001
lesson_id: L04
concept_ids:
- C_REVENUE
- C_EXPENSE
- C_NET_INCOME
question_type: single_choice
skill_type: calculation
difficulty: 1
prompt: 매출 10,000원, 총비용 7,000원. 남은 순이익은?
options:
  A: 3,000원
  B: 7,000원
  C: 10,000원
  D: 17,000원
answer:
- A
explanation: 10,000 − 7,000 = 3,000원이에요.
option_feedback:
  A: 매출에서 총비용을 빼요.
  B: 7,000원은 비용이에요.
  C: 매출 전부가 이익으로 남지는 않아요.
  D: 비용은 더하지 않고 빼요.
misconception_tags:
- revenue_equals_profit
remediation_concept_ids:
- C_REVENUE
- C_EXPENSE
- C_NET_INCOME
source_refs:
- S05
- S06
key_takeaway: 10,000 − 7,000 = 3,000원이에요.
assumptions:
- 총비용에 모든 비용과 세금을 포함해요.
```

## Q_L04_002

```yaml
question_id: Q_L04_002
lesson_id: L04
concept_ids:
- C_REVENUE
- C_NET_INCOME
question_type: single_choice
skill_type: relationship_application
difficulty: 1
prompt: 전년 매출 10,000원·비용 8,000원, 올해 매출 12,000원·비용 11,000원. 순이익은?
options:
  A: 2,000원 → 1,000원
  B: 2,000원 → 3,000원
  C: 매출이 늘어서 꼭 늘어요.
  D: 두 해 모두 10,000원
answer:
- A
explanation: 매출은 늘었지만 비용이 더 늘어, 순이익은 2,000원에서 1,000원으로 줄어요.
option_feedback:
  A: 각 해의 매출에서 비용을 빼면 돼요.
  B: 올해는 12,000 − 11,000 = 1,000원이에요.
  C: 비용이 더 늘면 이익은 줄 수 있어요.
  D: 매출과 순이익은 다른 숫자예요.
misconception_tags:
- more_revenue_always_means_more_profit
remediation_concept_ids:
- C_REVENUE
- C_EXPENSE
- C_NET_INCOME
source_refs:
- S05
key_takeaway: 매출은 늘었지만 비용이 더 늘어, 순이익은 2,000원에서 1,000원으로 줄어요.
assumptions:
- 비용에 세금 등 모든 비용을 포함해요.
```

## Q_L04_003

```yaml
question_id: Q_L04_003
lesson_id: L04
concept_ids:
- C_NET_INCOME
- C_INFORMATION_LIMIT
question_type: single_choice
skill_type: concept_discrimination
difficulty: 1
prompt: 올해 순이익이 1,000원이에요. 맞는 설명은?
options:
  A: 통장 잔액도 꼭 1,000원 늘어요.
  B: 비용 등을 반영한 회계상 이익이에요.
  C: 매출이 1,000원이에요.
  D: 1,000원 전부를 배당해요.
answer:
- B
explanation: 순이익은 회계상 이익이에요. 현금 증가액이나 배당금과는 달라요.
option_feedback:
  A: 현금이 들어오고 나가는 시점은 다를 수 있어요.
  B: 해당 기간의 수익과 비용 등을 반영한 이익이에요.
  C: 매출은 비용을 빼기 전 숫자예요.
  D: 배당 여부와 금액은 별도로 정해져요.
misconception_tags:
- net_income_equals_cash_flow
- revenue_equals_profit
remediation_concept_ids:
- C_NET_INCOME
- C_INFORMATION_LIMIT
source_refs:
- S05
key_takeaway: 순이익은 회계상 이익이에요. 현금 증가액이나 배당금과는 달라요.
```

## Q_L04_004

```yaml
question_id: Q_L04_004
lesson_id: L04
concept_ids:
- C_REVENUE
- C_EXPENSE
- C_NET_INCOME
question_type: single_choice
skill_type: relationship_application
difficulty: 1
prompt: 매출 10,000원에서 재료비 5,000원, 다른 비용·세금 3,000원을 빼면?
options:
  A: 순이익 2,000원
  B: 순이익 5,000원
  C: 순이익 8,000원
  D: 순이익 18,000원
answer:
- A
explanation: 10,000 − 5,000 − 3,000 = 2,000원이에요.
option_feedback:
  A: 모든 비용을 빼면 2,000원이 남아요.
  B: 재료비 말고 다른 비용도 빼야 해요.
  C: 8,000원은 비용의 합계예요.
  D: 비용은 매출에 더하지 않아요.
misconception_tags:
- revenue_equals_profit
remediation_concept_ids:
- C_EXPENSE
- C_NET_INCOME
source_refs:
- S05
- S06
key_takeaway: 10,000 − 5,000 − 3,000 = 2,000원이에요.
```

---

# 5. L05 — EPS

## Q_L05_001

```yaml
question_id: Q_L05_001
lesson_id: L05
concept_ids:
- C_BASIC_EPS
question_type: single_choice
skill_type: calculation
difficulty: 1
prompt: 보통주 몫의 이익 12,000원, 주식 6주. EPS는?
options:
  A: 200원
  B: 1,200원
  C: 2,000원
  D: 12,000원
answer:
- C
explanation: 12,000원 ÷ 6주 = 한 주당 2,000원이에요.
option_feedback:
  A: 12,000을 6으로 나눠봐요.
  B: 1,200 × 6은 7,200이에요.
  C: 이익을 주식 수로 나눴어요.
  D: 12,000원은 전체 이익이에요.
misconception_tags: []
remediation_concept_ids:
- C_BASIC_EPS
source_refs:
- S07
- S08
key_takeaway: 12,000원 ÷ 6주 = 한 주당 2,000원이에요.
assumptions:
- 보통주만 있고 주식 수는 1년 내내 같아요.
```

## Q_L05_002

```yaml
question_id: Q_L05_002
lesson_id: L05
concept_ids:
- C_WEIGHTED_AVG_SHARES
- C_BASIC_EPS
question_type: single_choice
skill_type: calculation
difficulty: 1
prompt: 이익은 둘 다 10,000원. A는 5주, B는 10주라면?
options:
  A: 둘 다 EPS 1,000원
  B: A EPS 1,000원 · B EPS 2,000원
  C: A EPS 2,000원 · B EPS 1,000원
  D: 주식 수가 많은 B의 EPS가 높아요.
answer:
- C
explanation: 같은 이익을 더 많은 주식으로 나누면 한 주당 이익은 줄어요.
option_feedback:
  A: A는 10,000 ÷ 5 = 2,000원이에요.
  B: A와 B의 계산이 뒤바뀌었어요.
  C: A는 2,000원, B는 1,000원이에요.
  D: 같은 이익이라면 나눌 주식이 많을수록 EPS는 낮아요.
misconception_tags: []
remediation_concept_ids:
- C_WEIGHTED_AVG_SHARES
- C_BASIC_EPS
source_refs:
- S07
- S08
key_takeaway: 같은 이익을 더 많은 주식으로 나누면 한 주당 이익은 줄어요.
assumptions:
- 보통주 몫의 이익이며, 두 회사의 주식 수는 1년 내내 같아요.
```

## Q_L05_003

```yaml
question_id: Q_L05_003
lesson_id: L05
concept_ids:
- C_BASIC_EPS
question_type: single_choice
skill_type: concept_discrimination
difficulty: 1
prompt: EPS가 3,000원이에요. 확실히 아는 것은?
options:
  A: 배당금이 꼭 3,000원이에요.
  B: 주가가 꼭 3,000원이에요.
  C: 한 주당 이익이 3,000원으로 계산됐어요.
  D: 한 주당 현금도 3,000원 늘었어요.
answer:
- C
explanation: EPS는 한 주당 이익이에요. 배당금·주가·현금과는 달라요.
option_feedback:
  A: 배당금은 별도로 정해져요.
  B: 주가는 시장에서 정해지는 가격이에요.
  C: EPS가 뜻하는 한 주당 이익이에요.
  D: 회계상 이익과 현금 증가는 다를 수 있어요.
misconception_tags:
- eps_equals_dividend
- net_income_equals_cash_flow
remediation_concept_ids:
- C_BASIC_EPS
source_refs:
- S07
key_takeaway: EPS는 한 주당 이익이에요. 배당금·주가·현금과는 달라요.
```

## Q_L05_004

```yaml
question_id: Q_L05_004
lesson_id: L05
concept_ids:
- C_BASIC_EPS
question_type: single_choice
skill_type: calculation
difficulty: 1
prompt: 보통주 몫의 이익 20,000원, 주식 10주. 한 주당 이익은?
options:
  A: 200원
  B: 2,000원
  C: 10,000원
  D: 20,000원
answer:
- B
explanation: 20,000원 ÷ 10주 = EPS 2,000원이에요.
option_feedback:
  A: 20,000을 10으로 나눠봐요.
  B: 한 주 기준으로 나눈 이익이에요.
  C: 주식 수만큼 나누면 2,000원이에요.
  D: 20,000원은 회사 전체의 보통주 몫 이익이에요.
misconception_tags: []
remediation_concept_ids:
- C_BASIC_EPS
source_refs:
- S07
key_takeaway: 20,000원 ÷ 10주 = EPS 2,000원이에요.
assumptions:
- 보통주만 있고 주식 수는 1년 내내 같아요.
```

---

# 6. L06 — PER

## Q_L06_001

```yaml
question_id: Q_L06_001
lesson_id: L06
concept_ids:
- C_PE_RATIO
question_type: single_choice
skill_type: calculation
difficulty: 1
prompt: 주가 8,000원, EPS 1,000원. PER은?
options:
  A: 6배
  B: 8배
  C: 12배
  D: 80배
answer:
- B
explanation: 8,000 ÷ 1,000 = 8배예요.
option_feedback:
  A: 주가를 EPS로 나눠봐요.
  B: 주가가 EPS의 8배예요.
  C: 8,000 ÷ 1,000은 8이에요.
  D: 8,000원에는 1,000원이 8개 들어가요.
misconception_tags: []
remediation_concept_ids:
- C_PE_RATIO
source_refs:
- S10
key_takeaway: 8,000 ÷ 1,000 = 8배예요.
```

## Q_L06_002

```yaml
question_id: Q_L06_002
lesson_id: L06
concept_ids:
- C_SHARE_PRICE
- C_BASIC_EPS
- C_PE_RATIO
question_type: single_choice
skill_type: relationship_application
difficulty: 1
prompt: A는 주가 10,000원·EPS 1,000원, B는 주가 5,000원·EPS 250원. 맞는 말은?
options:
  A: 주가가 낮은 B의 PER도 낮아요.
  B: A는 10배, B는 20배예요.
  C: 둘 다 PER 10배예요.
  D: 주가가 높은 A의 PER이 높아요.
answer:
- B
explanation: A는 10배, B는 20배. 주가가 낮아도 PER은 더 높을 수 있어요.
option_feedback:
  A: PER은 주가뿐 아니라 EPS도 함께 봐요.
  B: 10,000 ÷ 1,000 = 10, 5,000 ÷ 250 = 20이에요.
  C: B는 5,000 ÷ 250 = 20배예요.
  D: 주가만으로 PER을 비교할 수 없어요.
misconception_tags:
- low_price_means_cheap_company
remediation_concept_ids:
- C_PE_RATIO
source_refs:
- S10
key_takeaway: A는 10배, B는 20배. 주가가 낮아도 PER은 더 높을 수 있어요.
assumptions:
- 두 EPS는 같은 기간·기준이에요.
```

## Q_L06_003

```yaml
question_id: Q_L06_003
lesson_id: L06
concept_ids:
- C_PE_RATIO
- C_INFORMATION_LIMIT
question_type: single_choice
skill_type: interpretation
difficulty: 1
prompt: A PER 8배, B PER 20배. 이 숫자만으로 알 수 있는 것은?
options:
  A: A는 무조건 사야 해요.
  B: B는 무조건 팔아야 해요.
  C: A의 주가/EPS 비율이 더 낮아요.
  D: B의 매출이 2.5배예요.
answer:
- C
explanation: PER의 크기는 비교할 수 있어요. 투자 판단에는 더 많은 정보가 필요해요.
option_feedback:
  A: 낮은 PER이 좋은 투자를 보장하지는 않아요.
  B: 높은 PER만으로 매도를 정할 수는 없어요.
  C: 8배가 20배보다 낮다는 비율 차이를 알 수 있어요.
  D: PER만으로 매출은 알 수 없어요.
misconception_tags:
- low_pe_means_undervalued
- high_pe_means_overvalued
- one_metric_is_enough
remediation_concept_ids:
- C_PE_RATIO
- C_INFORMATION_LIMIT
source_refs:
- S10
key_takeaway: PER의 크기는 비교할 수 있어요. 투자 판단에는 더 많은 정보가 필요해요.
```

## Q_L06_004

```yaml
question_id: Q_L06_004
lesson_id: L06
concept_ids:
- C_BASIC_EPS
- C_PE_RATIO
question_type: single_choice
skill_type: interpretation
difficulty: 1
prompt: 주가 5,000원, EPS 1,000원. PER 5배의 뜻은?
options:
  A: 5년 뒤 원금을 꼭 돌려받아요.
  B: 주가가 한 주당 이익의 5배예요.
  C: 매출이 5배 늘어요.
  D: 배당금을 5배 받아요.
answer:
- B
explanation: PER은 주가와 EPS의 비율이에요. 원금 회수 기간을 보장하지 않아요.
option_feedback:
  A: 이익과 배당은 달라 원금 회수를 보장하지 않아요.
  B: 5,000 ÷ 1,000 = 5배예요.
  C: PER은 매출 증가율이 아니에요.
  D: 배당금의 배수를 뜻하지 않아요.
misconception_tags:
- pe_is_payback_period
remediation_concept_ids:
- C_BASIC_EPS
- C_PE_RATIO
- C_INFORMATION_LIMIT
source_refs:
- S10
key_takeaway: PER은 주가와 EPS의 비율이에요. 원금 회수 기간을 보장하지 않아요.
```

---

# 7. L07 — 숫자가 변하는 이유

## Q_L07_001

```yaml
question_id: Q_L07_001
lesson_id: L07
concept_ids:
- C_BASIC_EPS
- C_PE_RATIO
question_type: single_choice
skill_type: relationship_application
difficulty: 1
prompt: 주가 20,000원 그대로, EPS가 1,000원 → 2,000원. PER은?
options:
  A: 20배 → 10배
  B: 10배 → 20배
  C: 20배 → 40배
  D: 20배 그대로
answer:
- A
explanation: 20,000 ÷ 1,000 = 20배, 20,000 ÷ 2,000 = 10배예요.
option_feedback:
  A: 주가가 같고 EPS가 커져 PER은 낮아져요.
  B: 주가가 같을 때 EPS가 늘면 PER은 낮아져요.
  C: EPS는 나누는 수예요. 커질수록 결과는 작아져요.
  D: PER은 EPS 변화에도 달라져요.
misconception_tags: []
remediation_concept_ids:
- C_PE_RATIO
source_refs:
- S10
key_takeaway: 20,000 ÷ 1,000 = 20배, 20,000 ÷ 2,000 = 10배예요.
```

## Q_L07_002

```yaml
question_id: Q_L07_002
lesson_id: L07
concept_ids:
- C_SHARE_PRICE
- C_BASIC_EPS
- C_PE_RATIO
question_type: single_choice
skill_type: information_limit
difficulty: 1
prompt: PER이 20배에서 10배로 내려갔어요. 이유를 알 수 있을까요?
options:
  A: 주가가 꼭 내려갔어요.
  B: EPS가 꼭 올라갔어요.
  C: 주가와 EPS를 각각 확인해야 해요.
  D: 매출이 꼭 줄었어요.
answer:
- C
explanation: 주가 하락, EPS 상승, 두 숫자의 동시 변화 모두 가능해요.
option_feedback:
  A: 주가가 같아도 EPS가 오르면 PER은 내려가요.
  B: EPS가 같아도 주가가 내리면 PER은 내려가요.
  C: PER만 보고 원인을 하나로 정할 수 없어요.
  D: PER 변화만으로 매출 변화는 알 수 없어요.
misconception_tags:
- correlation_means_cause
remediation_concept_ids:
- C_PE_RATIO
- C_INFORMATION_LIMIT
source_refs:
- S10
key_takeaway: 주가 하락, EPS 상승, 두 숫자의 동시 변화 모두 가능해요.
```

## Q_L07_003

```yaml
question_id: Q_L07_003
lesson_id: L07
concept_ids:
- C_SHARE_PRICE
- C_SHARES_OUTSTANDING
- C_MARKET_CAP
question_type: single_choice
skill_type: calculation
difficulty: 1
prompt: 전체 10주 그대로, 주가가 1,000원 → 2,000원. 시가총액은?
options:
  A: 10,000원 → 20,000원
  B: 10,000원 → 12,000원
  C: 1,000원 → 2,000원
  D: 10,000원 그대로
answer:
- A
explanation: 주식 수가 같아서, 주가가 2배면 시가총액도 2배예요.
option_feedback:
  A: 각 주가에 10주를 곱하면 돼요.
  B: 2,000원 × 10주는 20,000원이에요.
  C: 그 숫자는 한 주 가격이에요.
  D: 주식 수가 같아도 주가가 바뀌면 시가총액은 달라져요.
misconception_tags: []
remediation_concept_ids:
- C_MARKET_CAP
source_refs:
- S03
key_takeaway: 주식 수가 같아서, 주가가 2배면 시가총액도 2배예요.
```

## Q_L07_004

```yaml
question_id: Q_L07_004
lesson_id: L07
concept_ids:
- C_BASIC_EPS
- C_WEIGHTED_AVG_SHARES
question_type: single_choice
skill_type: relationship_application
difficulty: 1
prompt: 이익 10,000원은 같고, 주식 수가 5주 → 10주라면 EPS는?
options:
  A: 2,000원 → 1,000원
  B: 1,000원 → 2,000원
  C: 2,000원 → 3,000원
  D: 2,000원 그대로
answer:
- A
explanation: 10,000 ÷ 5 = 2,000원, 10,000 ÷ 10 = 1,000원이에요.
option_feedback:
  A: 나눌 주식 수가 늘어 한 주당 이익은 줄어요.
  B: 같은 이익을 더 많은 주식으로 나누면 EPS는 낮아져요.
  C: 주식 수가 늘었다고 EPS가 늘지는 않아요.
  D: EPS는 이익과 주식 수를 함께 봐요.
misconception_tags:
- eps_uses_current_share_count_only
remediation_concept_ids:
- C_BASIC_EPS
- C_WEIGHTED_AVG_SHARES
source_refs:
- S07
- S08
key_takeaway: 10,000 ÷ 5 = 2,000원, 10,000 ÷ 10 = 1,000원이에요.
assumptions:
- 두 기간의 보통주 몫 이익을 비교해요. 각 기간 안에서는 주식 수가 같아요.
```

---

# 8. L08 — 통합 해석

다음 Q_L08_001~004는 동일한 가상 데이터 세트를 사용한다.

```yaml
integrated_case_id: CASE_L08_B
assumptions:
- 같은 회계기간의 가상 회사예요.
- 보통주만 있고 주식 수는 1년 내내 같아요.
companies:
  C회사:
    share_price: 15000
    shares: 4
    revenue: 60000
    expenses: 48000
    net_income: 12000
    eps: 3000
    pe: 5
    market_cap: 60000
  D회사:
    share_price: 9000
    shares: 10
    revenue: 90000
    expenses: 81000
    net_income: 9000
    eps: 900
    pe: 10
    market_cap: 90000
```

표시용:

| 항목 | C회사 | D회사 |
|---|---:|---:|
| 주가 | 15,000원 | 9,000원 |
| 주식 수 | 4주 | 10주 |
| 매출 | 60,000원 | 90,000원 |
| 총비용 | 48,000원 | 81,000원 |
| 순이익 | 12,000원 | 9,000원 |
| EPS | 3,000원 | 900원 |
| PER | 5배 | 10배 |
| 시가총액 | 60,000원 | 90,000원 |

## Q_L08_001

```yaml
question_id: Q_L08_001
lesson_id: L08
concept_ids:
- C_MARKET_CAP
- C_NET_INCOME
- C_PE_RATIO
question_type: multi_select
skill_type: interpretation
difficulty: 2
prompt: 표에서 바로 알 수 있는 것을 모두 골라요.
options:
  A: D의 시가총액이 더 커요.
  B: C의 순이익이 더 커요.
  C: C의 PER이 더 낮아요.
  D: D가 무조건 더 좋은 투자예요.
answer:
- A
- B
- C
explanation: 규모·이익·PER은 비교할 수 있지만, 좋은 투자까지 정해주지는 않아요.
option_feedback:
  A: 90,000원이 60,000원보다 커요.
  B: 12,000원이 9,000원보다 커요.
  C: 5배가 10배보다 낮아요.
  D: 투자 판단에는 성장 가능성과 위험 등도 필요해요.
misconception_tags:
- one_metric_is_enough
remediation_concept_ids:
- C_INFORMATION_LIMIT
source_refs:
- S03
- S05
- S10
key_takeaway: 규모·이익·PER은 비교할 수 있지만, 좋은 투자까지 정해주지는 않아요.
```

## Q_L08_002

```yaml
question_id: Q_L08_002
lesson_id: L08
concept_ids:
- C_INFORMATION_LIMIT
question_type: single_choice
skill_type: information_limit
difficulty: 1
prompt: 표만으로 답할 수 없는 질문은?
options:
  A: 어느 회사의 주가가 더 높을까요?
  B: 어느 회사의 시가총액이 더 클까요?
  C: 어느 회사의 PER이 더 낮을까요?
  D: 어느 회사가 더 좋은 투자일까요?
answer:
- D
explanation: 좋은 투자 여부는 표 밖의 정보도 함께 봐야 해요.
option_feedback:
  A: 주가는 표로 비교할 수 있어요.
  B: 시가총액은 표로 비교할 수 있어요.
  C: PER은 표로 비교할 수 있어요.
  D: 성장 가능성·위험·재무상태 등의 정보가 더 필요해요.
misconception_tags:
- low_pe_means_undervalued
- one_metric_is_enough
remediation_concept_ids:
- C_INFORMATION_LIMIT
- C_PE_RATIO
source_refs:
- S10
key_takeaway: 좋은 투자 여부는 표 밖의 정보도 함께 봐야 해요.
```

## Q_L08_003

```yaml
question_id: Q_L08_003
lesson_id: L08
concept_ids:
- C_SHARE_PRICE
- C_SHARES_OUTSTANDING
- C_MARKET_CAP
- C_BASIC_EPS
- C_PE_RATIO
question_type: single_choice
skill_type: calculation
difficulty: 2
prompt: C의 주가만 18,000원으로 오르면, 시가총액과 PER은?
options:
  A: 72,000원 · 6배
  B: 60,000원 · 5배
  C: 90,000원 · 6배
  D: 72,000원 · 5배
answer:
- A
explanation: 18,000 × 4주 = 72,000원, 18,000 ÷ 3,000 = 6배예요.
option_feedback:
  A: 주식 수와 EPS는 그대로 두고 새 주가를 넣어요.
  B: 주가가 올랐으므로 두 값 모두 다시 계산해요.
  C: 18,000 × 4는 72,000이에요.
  D: EPS가 같고 주가가 올랐으므로 PER도 올라요.
misconception_tags: []
remediation_concept_ids:
- C_MARKET_CAP
- C_PE_RATIO
source_refs:
- S03
- S10
key_takeaway: 18,000 × 4주 = 72,000원, 18,000 ÷ 3,000 = 6배예요.
assumptions:
- 주식 수 4주와 EPS 3,000원은 그대로예요.
```

## Q_L08_004

```yaml
question_id: Q_L08_004
lesson_id: L08
concept_ids:
- C_PE_RATIO
- C_INFORMATION_LIMIT
question_type: single_choice
skill_type: interpretation
difficulty: 1
prompt: C의 PER이 D보다 낮아요. 정확한 설명은?
options:
  A: C가 무조건 저평가됐어요.
  B: C의 미래 수익률이 꼭 더 높아요.
  C: C의 주가/EPS 비율이 더 낮아요.
  D: C의 매출이 꼭 더 많아요.
answer:
- C
explanation: 확인한 것은 PER의 차이예요. 저평가나 미래 수익률은 따로 살펴봐야 해요.
option_feedback:
  A: 낮은 PER만으로 저평가를 확정할 수는 없어요.
  B: PER이 미래 수익률을 보장하지는 않아요.
  C: 표에서 확인할 수 있는 비율의 차이예요.
  D: PER로 매출을 알 수는 없어요.
misconception_tags:
- low_pe_means_undervalued
- one_metric_is_enough
remediation_concept_ids:
- C_PE_RATIO
- C_INFORMATION_LIMIT
source_refs:
- S10
key_takeaway: 확인한 것은 PER의 차이예요. 저평가나 미래 수익률은 따로 살펴봐야 해요.
```

---

# 9. 오답 라우팅 규칙

```yaml
remediation_rules:
  stock_is_loan:
    primary: C_COMMON_STOCK
    lesson: L01
    message: 주식의 지분관계와 채권의 채무관계를 다시 구분해보세요.

  one_share_means_one_percent:
    primary: C_SHARE
    lesson: L01
    message: 보유 주식 수를 전체 주식 수로 나누어 지분 비율을 확인해보세요.

  low_price_means_cheap_company:
    primary: C_MARKET_CAP
    lesson: L03
    message: 한 주의 가격과 회사 전체 주식의 시장가치를 나누어 보세요.

  high_price_means_large_company:
    primary: C_MARKET_CAP
    lesson: L03
    message: 시가총액에는 주가뿐 아니라 주식 수도 필요합니다.

  revenue_equals_profit:
    primary: C_NET_INCOME
    lesson: L04
    message: 매출에서 어떤 비용들이 빠진 뒤 순이익이 되는지 다시 확인해보세요.

  net_income_equals_cash_flow:
    primary: C_INFORMATION_LIMIT
    lesson: L04
    message: 손익계산의 이익과 실제 현금 흐름은 관련되지만 같은 숫자가 아닐 수 있습니다.

  eps_equals_dividend:
    primary: C_BASIC_EPS
    lesson: L05
    message: EPS는 주당이익 지표이고 실제 배당금은 별도로 결정됩니다.

  eps_uses_current_share_count_only:
    primary: C_WEIGHTED_AVG_SHARES
    lesson: L05
    message: 기본 EPS의 분모는 기간의 가중평균 주식 수라는 점을 다시 확인해보세요.

  low_pe_means_undervalued:
    primary: C_INFORMATION_LIMIT
    lesson: L06
    message: PER의 숫자와 저평가 판단을 분리하고 추가로 필요한 정보를 생각해보세요.

  high_pe_means_overvalued:
    primary: C_INFORMATION_LIMIT
    lesson: L06
    message: 높은 PER이 나타나는 여러 가능한 이유를 다시 확인해보세요.

  negative_eps_pe_is_normally_comparable:
    primary: C_PE_RATIO
    lesson: L06
    message: 손실기업의 음수 EPS에서는 일반적인 양수 PER 비교의 의미가 제한됩니다.

  one_metric_is_enough:
    primary: C_INFORMATION_LIMIT
    lesson: L08
    message: 현재 지표로 직접 알 수 있는 것과 추가 정보가 필요한 판단을 나누어 보세요.
```

---

# 10. 코스 평가용 문항 선택 규칙

MVP에서 코스 마지막 평가를 8문항으로 구성할 경우 권장 샘플:

```yaml
course_checkpoint_C01:
  question_ids:
    - Q_L01_004
    - Q_L02_002
    - Q_L03_002
    - Q_L04_003
    - Q_L05_002
    - Q_L06_003
    - Q_L07_002
    - Q_L08_001
  rationale:
    - 단순 정의 암기보다 개념 구별과 정보 한계를 포함한다.
    - 시가총액, 손익, EPS, PER의 핵심 관계를 모두 포함한다.
    - 레슨에서 본 숫자 그대로가 아닌 변형 사례를 사용한다.
```

코스 점수는 `투자 실력`으로 명명하지 않는다. 예시 UI:

- `7/8개 관계를 새 사례에서도 확인했어요.`
- `PER 변화 원인은 한 번 더 확인해보세요.`

피해야 할 UI:

- `투자능력 87.5점`
- `상위 10% 투자자`
- `PER 마스터 인증 — 저평가 종목을 찾을 수 있습니다.`

---

# 11. 구현 시 이벤트 구분

```yaml
answer_event_types:
  FIRST_ATTEMPT:
    description: 해설을 보기 전 첫 응답
  AFTER_FEEDBACK_RETRY:
    description: 같은 문항의 해설을 본 뒤 재응답
  TRANSFER_VARIANT:
    description: 숫자나 상황이 달라진 별도 문항 응답
  REVIEW_ATTEMPT:
    description: 이후 복습 세션에서의 응답
```

`FIRST_ATTEMPT`와 `TRANSFER_VARIANT`를 학습 이해 확인에 더 중요하게 보고, `AFTER_FEEDBACK_RETRY`의 정답을 독립 숙달 증거로 과대평가하지 않는다.

---

# 12. 검수 결과

```yaml
validation_summary:
  total_questions: 32
  lessons: 8
  questions_per_lesson: 4
  calculation_questions: 8
  concept_and_relationship_questions: 14
  interpretation_and_limit_questions: 10
  contains_investment_recommendation_as_answer: false
  negative_eps_handling_present: true
  weighted_average_eps_question_present: true
  market_cap_vs_share_price_questions_present: true
  revenue_vs_profit_questions_present: true
  transfer_case_present: true
```

> 분류 개수는 운영상 태그 기준이며 한 문항이 여러 학습 기능을 동시에 가질 수 있다. 실제 앱 통계에서는 `skill_type` 하나를 주 분류로 사용하고 `concept_ids`와 `misconception_tags`를 별도 축으로 저장하는 편이 단순하다.

---

# 13. 출처 참조

이 문서의 `S01`~`S10`은 `06_Concept_Content_Data.md`의 출처 카탈로그를 공유한다. 핵심 검증 근거는 다음과 같다.

- Investor.gov — Stock: https://www.investor.gov/introduction-investing/investing-basics/glossary/stock
- Investor.gov — Market Capitalization: https://www.investor.gov/introduction-investing/investing-basics/glossary/market-capitalization
- Investor.gov — Price-earnings (P/E) Ratio: https://www.investor.gov/introduction-investing/investing-basics/glossary/price-earnings-pe-ratio
- SEC — Beginners' Guide to Financial Statements: https://www.sec.gov/about/reports-publications/beginners-guide-financial-statements
- IFRS Foundation — IAS 33 Earnings per Share: https://www.ifrs.org/issued-standards/list-of-standards/ias-33-earnings-per-share/
- 한국회계기준원 — 시행 중 K-IFRS 제1033호 주당이익: https://www.kasb.or.kr/front/board/ingAccountingList.do

**검토일:** 2026-10-06  
**상태:** 첫 코스 정적 문제은행 v1.0. 출시 전 UI에 넣은 최종 렌더링 문구와 숫자 단위를 다시 QA할 것.
