# 05. Concept Map Data
## FinStep 첫 코스 개념지도 원천 데이터

**버전:** v1.0  
**기준일:** 2026-10-06  
**대상 코스:** `C01 — 주가를 넘어 기업의 숫자 이해하기`  
**용도:** 개념지도 UI, 선행학습 연결, 복습 라우팅, 레슨 간 관계 표시, DB/JSON seed 작성의 원천 데이터

> 이 문서는 투자 추천 모델이 아니라 학습 그래프다. 화살표는 경제적 인과를 단정하는 표시가 아니라, 정의·계산·해석을 위해 어떤 개념이 연결되는지를 뜻한다.

---

## 1. 데이터 사용 원칙

1. `concept_id`는 화면 문구와 분리된 영구 식별자로 사용한다.
2. `prerequisite`는 반드시 잠금 조건을 뜻하지 않는다. 이해가 막힐 때 돌아갈 개념을 뜻한다.
3. `formula_dependency`는 산식에 직접 들어가는 관계다.
4. `interpretation_dependency`는 계산은 가능하지만 해석하려면 함께 알아야 하는 관계다.
5. `contrast`는 초보자가 자주 혼동하는 두 개념을 구분하기 위한 관계다.
6. 시가총액, EPS, PER처럼 실제 데이터 제공처마다 세부 기준이 달라질 수 있는 값은 화면에 `basis_note`를 표시할 수 있게 한다.
7. MVP의 계산 문제는 실제 종목 대신 가상 기업과 명시된 가정을 사용한다.

---

## 2. 권장 데이터 스키마

```yaml
ConceptNode:
  concept_id: string
  name_ko: string
  name_en: string
  category: string
  level: integer
  short_definition: string
  prerequisite_ids: [string]
  lesson_ids: [string]
  formula: string | null
  misconception_tags: [string]
  time_sensitive: boolean

ConceptEdge:
  edge_id: string
  from: concept_id
  to: concept_id
  relation_type: prerequisite | represents | has_price | formula_dependency | derived_metric | contrast | interpretation_dependency | limitation
  label_ko: string
  direction_meaning: string
  strength: core | supporting
  lesson_ids: [string]
```

---

## 3. 개념 노드

### C_COMPANY — 기업

```yaml
concept_id: C_COMPANY
name_ko: 기업
name_en: Company / Corporation
category: entity
level: 0
short_definition: 재화나 서비스를 제공하는 경제 주체이며, 주식회사의 경우 지분을 주식 단위로 나누어 발행할 수 있다.
prerequisite_ids: []
lesson_ids: [L01, L04, L08]
formula: null
misconception_tags:
  - company_equals_stock
  - company_value_equals_share_price
time_sensitive: false
```

### C_COMMON_STOCK — 보통주

```yaml
concept_id: C_COMMON_STOCK
name_ko: 보통주
name_en: Common Stock / Ordinary Share
category: security
level: 1
short_definition: 기업에 대한 지분을 나타내는 대표적인 주식 종류. 일반적으로 의결권이 있으며 기업의 성과와 잔여가치에 대한 지분을 가진다.
prerequisite_ids: [C_COMPANY]
lesson_ids: [L01]
formula: null
misconception_tags:
  - stock_is_loan
  - dividend_is_guaranteed
  - shareholder_owns_specific_asset
time_sensitive: false
```

### C_SHARE — 주식 한 주

```yaml
concept_id: C_SHARE
name_ko: 주식 한 주
name_en: One Share
category: security_unit
level: 1
short_definition: 회사 지분을 나눈 단위 중 하나. 한 주를 보유하면 해당 주식 종류가 부여하는 권리와 경제적 이해관계의 일부를 가진다.
prerequisite_ids: [C_COMPANY, C_COMMON_STOCK]
lesson_ids: [L01, L02]
formula: null
misconception_tags:
  - one_share_means_one_percent
  - share_is_company_asset
time_sensitive: false
```

### C_SHAREHOLDER — 주주

```yaml
concept_id: C_SHAREHOLDER
name_ko: 주주
name_en: Shareholder / Stockholder
category: participant
level: 1
short_definition: 회사의 주식을 보유하여 지분 이해관계를 가진 사람 또는 기관.
prerequisite_ids: [C_SHARE]
lesson_ids: [L01]
formula: null
misconception_tags:
  - shareholder_directly_controls_company_assets
time_sensitive: false
```

### C_SHARE_PRICE — 주가

```yaml
concept_id: C_SHARE_PRICE
name_ko: 주가
name_en: Share Price / Stock Price
category: market_metric
level: 2
short_definition: 시장에서 특정 주식 한 주에 형성되는 가격.
prerequisite_ids: [C_SHARE]
lesson_ids: [L02, L03, L06, L07, L08]
formula: null
misconception_tags:
  - low_price_means_cheap_company
  - high_price_means_large_company
  - share_price_equals_company_value
time_sensitive: true
```

### C_SHARES_OUTSTANDING — 유통주식수

```yaml
concept_id: C_SHARES_OUTSTANDING
name_ko: 유통주식수
name_en: Shares Outstanding
category: share_count
level: 2
short_definition: 특정 시점에 발행되어 투자자 등이 보유하고 있는 주식 수. 시가총액 계산에서 주가와 함께 사용되는 핵심 수량이다.
prerequisite_ids: [C_SHARE]
lesson_ids: [L03, L05, L07, L08]
formula: null
misconception_tags:
  - outstanding_equals_float
  - outstanding_always_constant
  - outstanding_equals_weighted_average_shares
time_sensitive: true
basis_note: 데이터 제공처와 주식 종류·자기주식 처리 등에 따라 표시 기준을 확인해야 한다.
```

### C_MARKET_CAP — 시가총액

```yaml
concept_id: C_MARKET_CAP
name_ko: 시가총액
name_en: Market Capitalization
category: market_metric
level: 3
short_definition: 시장이 특정 시점에 회사의 주식 전체에 부여하고 있는 시장가치의 대표적 척도.
prerequisite_ids: [C_SHARE_PRICE, C_SHARES_OUTSTANDING]
lesson_ids: [L03, L07, L08]
formula: market_cap = share_price × shares_outstanding
misconception_tags:
  - market_cap_equals_revenue
  - market_cap_equals_net_income
  - market_cap_equals_book_equity
  - market_cap_equals_enterprise_value
time_sensitive: true
basis_note: 학습 예시는 하나의 보통주 종류와 명시된 주식 수를 가정한다.
```

### C_REVENUE — 매출

```yaml
concept_id: C_REVENUE
name_ko: 매출
name_en: Revenue
category: financial_statement_metric
level: 2
short_definition: 일정 기간 기업이 제품 판매나 서비스 제공 등 주요 활동을 통해 인식한 수익의 대표적 금액.
prerequisite_ids: [C_COMPANY]
lesson_ids: [L04, L08]
formula: null
misconception_tags:
  - revenue_equals_cash_inflow
  - revenue_equals_profit
  - more_revenue_always_means_more_profit
time_sensitive: false
basis_note: 실제 회계의 수익 인식은 계약과 회계기준에 따라 판단된다. MVP에서는 단순 손익계산 예시를 사용한다.
```

### C_EXPENSE — 비용

```yaml
concept_id: C_EXPENSE
name_ko: 비용
name_en: Expense
category: financial_statement_metric
level: 2
short_definition: 일정 기간 기업이 수익을 창출하고 사업을 운영하는 과정 등에서 인식한 경제적 자원의 소모.
prerequisite_ids: [C_COMPANY]
lesson_ids: [L04, L08]
formula: null
misconception_tags:
  - expense_equals_cash_outflow
  - all_expense_is_cost_of_goods_sold
time_sensitive: false
```

### C_NET_INCOME — 당기순이익

```yaml
concept_id: C_NET_INCOME
name_ko: 당기순이익
name_en: Net Income / Net Profit
category: financial_statement_metric
level: 3
short_definition: 일정 기간의 수익에서 관련 비용과 세금 등을 반영한 뒤 남는 최종 손익의 대표적 지표.
prerequisite_ids: [C_REVENUE, C_EXPENSE]
lesson_ids: [L04, L05, L08]
formula: educational_example_only: net_income = revenue - total_expenses
misconception_tags:
  - net_income_equals_cash_flow
  - positive_net_income_means_cash_increased
  - net_income_equals_revenue
time_sensitive: false
basis_note: 실제 손익계산서에는 다양한 수익·비용 항목과 표시 기준이 존재한다.
```

### C_WEIGHTED_AVG_SHARES — 가중평균유통보통주식수

```yaml
concept_id: C_WEIGHTED_AVG_SHARES
name_ko: 가중평균유통보통주식수
name_en: Weighted-average Ordinary/Common Shares Outstanding
category: accounting_denominator
level: 4
short_definition: EPS 계산 대상 기간 동안 유통된 보통주 수를 유통 기간에 따라 가중하여 계산한 주식 수.
prerequisite_ids: [C_SHARES_OUTSTANDING]
lesson_ids: [L05]
formula: weighted_average_shares = Σ(shares_outstanding_for_interval × time_weight)
misconception_tags:
  - eps_uses_only_period_end_shares
  - weighted_average_equals_current_shares
time_sensitive: false
```

### C_BASIC_EPS — 기본주당이익

```yaml
concept_id: C_BASIC_EPS
name_ko: 기본주당이익
name_en: Basic Earnings per Share (Basic EPS)
category: per_share_metric
level: 4
short_definition: 보통주에 귀속되는 기간 이익을 해당 기간의 가중평균 유통보통주식수로 나누어 주당 기준으로 나타낸 이익 지표.
prerequisite_ids: [C_NET_INCOME, C_WEIGHTED_AVG_SHARES]
lesson_ids: [L05, L06, L07, L08]
formula: basic_eps = earnings_attributable_to_ordinary_equity_holders / weighted_average_ordinary_shares
misconception_tags:
  - eps_equals_dividend
  - eps_equals_cash_per_share
  - eps_uses_current_share_count_only
  - high_eps_always_means_better_company
time_sensitive: false
basis_note: MVP 계산 예시는 우선주·중단영업·복잡한 자본변동이 없는 가상 기업으로 단순화한다.
```

### C_DILUTED_EPS — 희석주당이익

```yaml
concept_id: C_DILUTED_EPS
name_ko: 희석주당이익
name_en: Diluted Earnings per Share
category: per_share_metric
level: 5
short_definition: 전환증권, 옵션 등 희석 효과가 있는 잠재적 보통주가 실제 보통주가 된 상황을 반영해 계산하는 EPS.
prerequisite_ids: [C_BASIC_EPS]
lesson_ids: [L05]
formula: advanced_not_in_mvp_calculation
misconception_tags:
  - diluted_eps_is_forecast_eps
  - diluted_eps_always_lower_without_conditions
time_sensitive: false
mvp_role: awareness_only
```

### C_PE_RATIO — PER

```yaml
concept_id: C_PE_RATIO
name_ko: 주가수익비율(PER)
name_en: Price-to-Earnings Ratio (P/E Ratio)
category: valuation_ratio
level: 5
short_definition: 주가가 주당이익(EPS)의 몇 배 수준인지 나타내는 비율.
prerequisite_ids: [C_SHARE_PRICE, C_BASIC_EPS]
lesson_ids: [L06, L07, L08]
formula: pe_ratio = share_price / eps
misconception_tags:
  - low_pe_means_undervalued
  - high_pe_means_overvalued
  - pe_is_payback_period
  - pe_alone_decides_investment
  - negative_eps_pe_is_normally_comparable
time_sensitive: true
basis_note: 가격 시점과 EPS 기간/기준을 일치시켜 해석해야 한다. MVP에서는 명시된 같은 기준의 양수 EPS만 계산 문제에 사용한다.
```

### C_INFORMATION_LIMIT — 정보의 한계

```yaml
concept_id: C_INFORMATION_LIMIT
name_ko: 지표로 알 수 있는 것과 알 수 없는 것
name_en: Limits of a Metric
category: reasoning_skill
level: 6
short_definition: 하나의 숫자나 비율이 설명하는 범위와, 결론을 내리기 위해 추가 정보가 필요한 범위를 구분하는 능력.
prerequisite_ids: [C_MARKET_CAP, C_NET_INCOME, C_BASIC_EPS, C_PE_RATIO]
lesson_ids: [L06, L07, L08]
formula: null
misconception_tags:
  - one_metric_is_enough
  - metric_is_investment_signal
  - correlation_means_cause
time_sensitive: false
```

---

## 4. 핵심 관계(Edges)

```yaml
edges:
  - edge_id: E01
    from: C_SHARE
    to: C_COMPANY
    relation_type: represents
    label_ko: 기업에 대한 지분 단위를 나타낸다
    direction_meaning: 주식 한 주의 의미를 기업의 소유지분과 연결
    strength: core
    lesson_ids: [L01]

  - edge_id: E02
    from: C_SHARE
    to: C_SHARE_PRICE
    relation_type: has_price
    label_ko: 시장에서 한 주의 가격이 형성된다
    direction_meaning: 주식 단위와 주가를 구분
    strength: core
    lesson_ids: [L02]

  - edge_id: E03
    from: C_SHARE_PRICE
    to: C_MARKET_CAP
    relation_type: formula_dependency
    label_ko: 시가총액 계산의 한 요소다
    direction_meaning: 주가만으로 회사 전체 시장가치를 판단할 수 없음을 설명
    strength: core
    lesson_ids: [L03]

  - edge_id: E04
    from: C_SHARES_OUTSTANDING
    to: C_MARKET_CAP
    relation_type: formula_dependency
    label_ko: 시가총액 계산의 다른 요소다
    direction_meaning: 주식 수가 함께 필요함을 설명
    strength: core
    lesson_ids: [L03]

  - edge_id: E05
    from: C_REVENUE
    to: C_NET_INCOME
    relation_type: interpretation_dependency
    label_ko: 매출은 최종 이익을 이해하는 출발점 중 하나다
    direction_meaning: 매출과 순이익을 동일시하지 않도록 연결
    strength: core
    lesson_ids: [L04]

  - edge_id: E06
    from: C_EXPENSE
    to: C_NET_INCOME
    relation_type: interpretation_dependency
    label_ko: 비용을 반영해야 최종 손익을 이해할 수 있다
    direction_meaning: 많이 팔았다는 사실만으로 많이 남았다고 판단할 수 없음을 설명
    strength: core
    lesson_ids: [L04]

  - edge_id: E07
    from: C_NET_INCOME
    to: C_BASIC_EPS
    relation_type: formula_dependency
    label_ko: 보통주에 귀속되는 이익이 EPS 분자에 연결된다
    direction_meaning: 기업 전체 이익을 주당 기준으로 전환
    strength: core
    lesson_ids: [L05]

  - edge_id: E08
    from: C_WEIGHTED_AVG_SHARES
    to: C_BASIC_EPS
    relation_type: formula_dependency
    label_ko: 기간 가중평균 주식 수가 EPS 분모에 연결된다
    direction_meaning: EPS가 단순히 기말 주식수로 나누는 값이 아님을 설명
    strength: core
    lesson_ids: [L05]

  - edge_id: E09
    from: C_SHARES_OUTSTANDING
    to: C_WEIGHTED_AVG_SHARES
    relation_type: contrast
    label_ko: 특정 시점 주식 수와 기간 평균 개념을 구분한다
    direction_meaning: 시가총액의 주식 수 기준과 EPS 분모를 동일시하지 않도록 함
    strength: supporting
    lesson_ids: [L05]

  - edge_id: E10
    from: C_SHARE_PRICE
    to: C_PE_RATIO
    relation_type: formula_dependency
    label_ko: PER의 분자다
    direction_meaning: 주가를 이익과 연결해 보는 비율
    strength: core
    lesson_ids: [L06]

  - edge_id: E11
    from: C_BASIC_EPS
    to: C_PE_RATIO
    relation_type: formula_dependency
    label_ko: PER의 분모다
    direction_meaning: 주가만 비교할 때와 다른 정보를 제공
    strength: core
    lesson_ids: [L06]

  - edge_id: E12
    from: C_PE_RATIO
    to: C_INFORMATION_LIMIT
    relation_type: limitation
    label_ko: PER 하나만으로 투자 매력 전체를 판정할 수 없다
    direction_meaning: 계산 결과와 투자 결론을 분리
    strength: core
    lesson_ids: [L06, L08]

  - edge_id: E13
    from: C_MARKET_CAP
    to: C_INFORMATION_LIMIT
    relation_type: limitation
    label_ko: 시가총액은 기업가치의 모든 측면을 설명하지 않는다
    direction_meaning: 부채·현금·사업질·미래수익 등을 별도로 볼 필요가 있음
    strength: supporting
    lesson_ids: [L08]

  - edge_id: E14
    from: C_NET_INCOME
    to: C_INFORMATION_LIMIT
    relation_type: limitation
    label_ko: 순이익은 현금흐름과 동일하지 않다
    direction_meaning: 손익과 현금의 차이를 인지
    strength: supporting
    lesson_ids: [L08]

  - edge_id: E15
    from: C_BASIC_EPS
    to: C_DILUTED_EPS
    relation_type: contrast
    label_ko: 잠재적 보통주의 희석 효과를 반영하면 희석 EPS를 별도로 본다
    direction_meaning: 실제 공시에서 Basic/Diluted EPS가 구분됨을 인지
    strength: supporting
    lesson_ids: [L05]
```

---

## 5. 화면용 축약 그래프

### 5.1 MVP 기본 그래프

```text
기업
  ↓ 발행/소유지분
주식 한 주
  ↓ 한 주의 시장가격
주가 ──────────────┐
  │                │
  │                ↓
  │             시가총액
  │                ↑
  │            유통주식수
  │
  │                매출
  │                 ↓
  │             비용과 함께 해석
  │                 ↓
  │              순이익
  │                 ↓
  │     가중평균유통보통주식수와 결합
  │                 ↓
  └──────────────→ EPS
                    ↓
주가 ─────────────→ PER
                    ↓
          알 수 있는 것 / 더 필요한 정보
```

### 5.2 반드시 표시해야 하는 비인과 관계

- `주가 → 시가총액`: 계산 관계이지 “주가가 오르면 회사의 사업가치가 그만큼 좋아졌다”는 인과 판정이 아니다.
- `순이익 → EPS`: EPS 산식의 분자와 연결되지만 실제 기본 EPS는 보통주 귀속이익과 가중평균 주식수를 사용한다.
- `EPS → PER`: 계산 관계다. EPS 변화의 원인은 매출·비용·세금·주식수 등 여러 요소일 수 있다.
- `PER → 투자판단`: 직접 화살표를 만들지 않는다. 반드시 `정보의 한계` 노드를 거친다.

---

## 6. 레슨별 활성 노드

| 레슨 | 주 노드 | 복습 노드 | 다음 연결 |
|---|---|---|---|
| L01 | `C_COMPANY`, `C_COMMON_STOCK`, `C_SHARE`, `C_SHAREHOLDER` | 없음 | `C_SHARE_PRICE` |
| L02 | `C_SHARE`, `C_SHARE_PRICE` | `C_COMPANY` | `C_SHARES_OUTSTANDING`, `C_MARKET_CAP` |
| L03 | `C_SHARE_PRICE`, `C_SHARES_OUTSTANDING`, `C_MARKET_CAP` | `C_SHARE` | `C_REVENUE`, `C_NET_INCOME` |
| L04 | `C_REVENUE`, `C_EXPENSE`, `C_NET_INCOME` | `C_COMPANY` | `C_BASIC_EPS` |
| L05 | `C_NET_INCOME`, `C_WEIGHTED_AVG_SHARES`, `C_BASIC_EPS`, `C_DILUTED_EPS` | `C_SHARES_OUTSTANDING` | `C_PE_RATIO` |
| L06 | `C_SHARE_PRICE`, `C_BASIC_EPS`, `C_PE_RATIO`, `C_INFORMATION_LIMIT` | `C_NET_INCOME` | 변화 분석 |
| L07 | `C_SHARE_PRICE`, `C_SHARES_OUTSTANDING`, `C_MARKET_CAP`, `C_BASIC_EPS`, `C_PE_RATIO` | 관련 산식 노드 | `C_INFORMATION_LIMIT` |
| L08 | 전체 핵심 노드 | 오답 태그별 동적 연결 | 다음 코스 또는 복습 |

---

## 7. 오개념 태그 사전

| tag | 오개념 | 되돌릴 개념 |
|---|---|---|
| `stock_is_loan` | 주식을 사는 것은 회사에 돈을 빌려주는 것과 같다 | `C_COMMON_STOCK`, `C_SHARE` |
| `one_share_means_one_percent` | 한 주는 항상 회사의 1%다 | `C_SHARE`, `C_SHARES_OUTSTANDING` |
| `low_price_means_cheap_company` | 주가가 낮으면 회사 전체도 싸다 | `C_SHARE_PRICE`, `C_MARKET_CAP` |
| `high_price_means_large_company` | 주가가 높은 회사가 반드시 더 큰 회사다 | `C_MARKET_CAP` |
| `market_cap_equals_enterprise_value` | 시가총액은 기업가치(EV)와 완전히 같다 | `C_MARKET_CAP`, `C_INFORMATION_LIMIT` |
| `revenue_equals_profit` | 매출은 회사가 최종적으로 번 돈이다 | `C_REVENUE`, `C_EXPENSE`, `C_NET_INCOME` |
| `net_income_equals_cash_flow` | 순이익이 곧 현금 증가액이다 | `C_NET_INCOME`, `C_INFORMATION_LIMIT` |
| `eps_equals_dividend` | EPS만큼 배당을 반드시 받는다 | `C_BASIC_EPS` |
| `eps_uses_current_share_count_only` | EPS는 기말 주식수로만 나눈다 | `C_WEIGHTED_AVG_SHARES`, `C_BASIC_EPS` |
| `low_pe_means_undervalued` | PER이 낮으면 무조건 저평가다 | `C_PE_RATIO`, `C_INFORMATION_LIMIT` |
| `high_pe_means_overvalued` | PER이 높으면 무조건 고평가다 | `C_PE_RATIO`, `C_INFORMATION_LIMIT` |
| `pe_is_payback_period` | PER 10배면 반드시 10년 후 원금을 회수한다 | `C_PE_RATIO` |
| `one_metric_is_enough` | 지표 하나로 매수·매도 결론을 낼 수 있다 | `C_INFORMATION_LIMIT` |

---

## 8. 검증 규칙

개념지도 데이터를 수정할 때 아래 테스트를 통과해야 한다.

```yaml
validation_rules:
  - id: V01
    rule: C_MARKET_CAP에는 C_SHARE_PRICE와 C_SHARES_OUTSTANDING 두 formula_dependency가 모두 존재해야 한다.
  - id: V02
    rule: C_BASIC_EPS에는 C_NET_INCOME 계열 분자와 C_WEIGHTED_AVG_SHARES 분모가 연결되어야 한다.
  - id: V03
    rule: C_PE_RATIO에는 C_SHARE_PRICE와 C_BASIC_EPS가 연결되어야 한다.
  - id: V04
    rule: C_PE_RATIO에서 investment_signal, buy_signal, undervalued 확정 노드로 직접 연결하면 안 된다.
  - id: V05
    rule: C_SHARES_OUTSTANDING와 C_WEIGHTED_AVG_SHARES를 동일 concept_id로 합치지 않는다.
  - id: V06
    rule: C_NET_INCOME와 cash_flow를 동일 개념으로 취급하지 않는다.
  - id: V07
    rule: 화면에서 인과 화살표와 계산/선행학습 화살표를 시각적으로 구분하거나 범례로 설명한다.
```

---

## 9. 검토 근거

- 미국 SEC Investor.gov — Stock: https://www.investor.gov/introduction-investing/investing-basics/glossary/stock
- 미국 SEC Investor.gov — Market Capitalization: https://www.investor.gov/introduction-investing/investing-basics/glossary/market-capitalization
- 미국 SEC Investor.gov — Price-earnings (P/E) Ratio: https://www.investor.gov/introduction-investing/investing-basics/glossary/price-earnings-pe-ratio
- 미국 SEC — Beginners' Guide to Financial Statements: https://www.sec.gov/about/reports-publications/beginners-guide-financial-statements
- IFRS Foundation — IAS 33 Earnings per Share: https://www.ifrs.org/issued-standards/list-of-standards/ias-33-earnings-per-share/
- 한국회계기준원 — 시행 중 K-IFRS 제1033호 주당이익 목록: https://www.kasb.or.kr/front/board/ingAccountingList.do

**검토 메모:** SEC의 입문 자료는 EPS를 이해하기 쉽게 단순화해 설명하지만, 실제 회계 기준의 기본 EPS는 보통주 귀속이익과 기간 가중평균 보통주식수를 사용한다. 앱에서는 쉬운 설명과 실제 정의를 분리하여 표시한다.
