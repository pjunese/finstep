# 주식·경제 핵심 50 · 앱 콘텐츠 원본

사용자 제공 `50.md`의 50개 항목을 모두 유지하고 분류·설명을 교정했다. 숫자는 학습용 가정이며 뉴스 예시는 실제 기사가 아니다. `docs/09_Core_50_Audit.md`에 변경 근거를 기록한다.

이 파일의 JSON 블록을 수정한 뒤 `dart run tool/import_content.dart`를 실행한다. 메타데이터 블록 다음에 원문 번호 1~50을 각각 한 번 기재한다. 퀴즈 1·2는 본 학습, 3은 첫 복습용 새 문항이다.

## 과정 설정

```json
{
  "schema_version": 2,
  "content_version": "2026-10-08.core50-v1",
  "course_title": "주식·경제 핵심 50",
  "practice_question_count": 2,
  "categories": [
    {
      "id": "G1",
      "title": "주식과 주주의 권리",
      "description": "내 주식의 권리와 변화를 알아봐요",
      "numbers": [
        7,
        5,
        6,
        16,
        9,
        8,
        17,
        24,
        10
      ]
    },
    {
      "id": "G2",
      "title": "기업의 실적과 재무",
      "description": "회사가 벌고 남기는 돈을 읽어요",
      "numbers": [
        2,
        3,
        4,
        20,
        11,
        13,
        15,
        18,
        19
      ]
    },
    {
      "id": "G3",
      "title": "주가와 가치평가",
      "description": "가격을 이익·자산과 비교해요",
      "numbers": [
        1,
        12,
        14
      ]
    },
    {
      "id": "G4",
      "title": "투자상품과 위험관리",
      "description": "무엇에 투자하고 어떤 위험을 줄일까요",
      "numbers": [
        40,
        22,
        23,
        50
      ]
    },
    {
      "id": "G5",
      "title": "거래와 시장 제도",
      "description": "주문부터 결제까지 이해해요",
      "numbers": [
        25,
        28,
        29,
        30,
        21,
        26,
        27,
        43,
        44
      ]
    },
    {
      "id": "G6",
      "title": "경제지표와 통화정책",
      "description": "물가·금리·환율의 관계를 읽어요",
      "numbers": [
        31,
        32,
        39,
        33,
        34,
        46,
        35,
        36,
        37,
        38
      ]
    },
    {
      "id": "G7",
      "title": "뉴스와 시장 흐름",
      "description": "기사 속 표현을 정확히 구분해요",
      "numbers": [
        41,
        42,
        45,
        47,
        48,
        49
      ]
    }
  ],
  "sources": [
    {
      "organization": "SEC",
      "title": "재무제표 이해: 이익과 현금흐름의 차이",
      "url": "https://www.sec.gov/investor/pubs/begfinstmtguide.htm",
      "used_for": [
        "K02",
        "K03",
        "K04",
        "K11",
        "K13",
        "K19",
        "K20"
      ],
      "checked_at": "2026-10-08"
    },
    {
      "organization": "한국거래소",
      "title": "배당락과 권리락",
      "url": "https://regulation.krx.co.kr/contents/RGL/03/03010401/RGL03010401.jsp",
      "used_for": [
        "K05",
        "K08",
        "K17",
        "K24"
      ],
      "checked_at": "2026-10-08"
    },
    {
      "organization": "한국거래소",
      "title": "주식시장 매매거래중단제도",
      "url": "https://regulation.krx.co.kr/contents/RGL/03/03010402/RGL03010402.jsp",
      "used_for": [
        "K26"
      ],
      "checked_at": "2026-10-08"
    },
    {
      "organization": "한국거래소",
      "title": "프로그램매매: 사이드카",
      "url": "https://regulation.krx.co.kr/contents/RGL/03/03010404/RGL03010404.jsp",
      "used_for": [
        "K27"
      ],
      "checked_at": "2026-10-08"
    },
    {
      "organization": "한국거래소",
      "title": "ETN 투자위험",
      "url": "https://open.krx.co.kr/contents/OPN/01/01030303/OPN01030303.jsp",
      "used_for": [
        "K23"
      ],
      "checked_at": "2026-10-08"
    },
    {
      "organization": "SEC Investor.gov",
      "title": "단일 종목 ETF: 분산에 관한 주의",
      "url": "https://www.investor.gov/introduction-investing/investing-basics/glossary/single-stock-etfs",
      "used_for": [
        "K22"
      ],
      "checked_at": "2026-10-08"
    },
    {
      "organization": "SEC Investor.gov",
      "title": "주문 유형과 체결가격",
      "url": "https://www.investor.gov/introduction-investing/investing-basics/how-stock-markets-work/types-orders",
      "used_for": [
        "K25"
      ],
      "checked_at": "2026-10-08"
    },
    {
      "organization": "금융위원회",
      "title": "금융용어: 청산 및 결제",
      "url": "https://www.fsc.go.kr/in090301/view?dicId=1831",
      "used_for": [
        "K28"
      ],
      "checked_at": "2026-10-08"
    },
    {
      "organization": "Federal Reserve",
      "title": "FOMC의 역할",
      "url": "https://www.federalreserve.gov/faqs/federal-open-market-committee-fomc.htm",
      "used_for": [
        "K35"
      ],
      "checked_at": "2026-10-08"
    },
    {
      "organization": "Federal Reserve",
      "title": "공개시장운영과 자산 매입",
      "url": "https://www.federalreserve.gov/monetarypolicy/bst_openmarketops.htm",
      "used_for": [
        "K36"
      ],
      "checked_at": "2026-10-08"
    },
    {
      "organization": "St. Louis Fed",
      "title": "보유 자산 축소와 재투자 중단",
      "url": "https://www.stlouisfed.org/open-vault/2022/may/how-will-fed-reduce-balance-sheet",
      "used_for": [
        "K37"
      ],
      "checked_at": "2026-10-08"
    },
    {
      "organization": "미국 노동통계국",
      "title": "CPI: 지수와 가격 변화",
      "url": "https://www.bls.gov/cpi/",
      "used_for": [
        "K39"
      ],
      "checked_at": "2026-10-08"
    },
    {
      "organization": "SEC Investor.gov",
      "title": "채권의 구조와 위험",
      "url": "https://www.investor.gov/introduction-investing/investing-basics/investment-products/bonds-or-fixed-income-products/bonds",
      "used_for": [
        "K40"
      ],
      "checked_at": "2026-10-08"
    },
    {
      "organization": "고려아연 IR",
      "title": "유보율 산식 (2025 가치제고 계획 이행 현황)",
      "url": "https://investors.koreazinc.co.kr/media/qqqht410/2025%EB%85%84-%EA%B3%A0%EB%A0%A4%EC%95%84%EC%97%B0-%EA%B8%B0%EC%97%85%EA%B0%80%EC%B9%98-%EC%A0%9C%EA%B3%A0%EA%B3%84%ED%9A%8D-%EC%9D%B4%ED%96%89-%ED%98%84%ED%99%A9.pdf",
      "used_for": [
        "K18"
      ],
      "checked_at": "2026-10-08"
    }
  ]
}
```

## 01. 시가총액

```json
{
  "number": 1,
  "name": "시가총액",
  "english": "Market capitalization",
  "category": "G3",
  "core": "주가에 발행 주식 수를 곱한, 주식시장에서의 회사 규모예요.",
  "example": "한 주가 1,000원이고 모두 10주인 가상 회사라면?",
  "result": "시가총액은 10,000원이에요.",
  "remember": "회사 전체를 실제로 인수하는 가격과는 달라요.",
  "detail": "같은 주가라도 주식 수가 다르면 시가총액이 달라요. 계산 기준 시점과 주식 종류를 맞춰 비교해요. 부채까지 포함하는 기업가치나 장부상 자산과도 구분해요.",
  "news": {
    "headline": "주가는 낮지만 시가총액은 더 크다",
    "meaning": "발행 주식 수도 함께 확인해야 회사 규모를 비교할 수 있어요."
  },
  "home": {
    "prompt": "주가가 더 낮으면 작은 회사일까요?",
    "options": [
      "주식 수도 봐야 해요",
      "항상 더 작아요"
    ],
    "answer": 0,
    "takeaway": "시가총액에는 한 주 가격과 발행 주식 수가 모두 필요해요."
  },
  "related": [
    9,
    12,
    14
  ],
  "questions": [
    {
      "prompt": "주가 2,000원, 발행 주식 10주라면 시가총액은?",
      "options": [
        "20,000원",
        "2,000원"
      ],
      "answer": 0,
      "explanation": "2,000원 × 10주 = 20,000원이에요."
    },
    {
      "prompt": "주가가 같고 A의 주식 수가 B의 두 배라면?",
      "options": [
        "시가총액도 같음",
        "A의 시가총액이 두 배"
      ],
      "answer": 1,
      "explanation": "같은 주가에서는 주식 수가 두 배면 시가총액도 두 배예요."
    },
    {
      "prompt": "주식 수는 그대로, 주가가 절반이 되면 시가총액은?",
      "options": [
        "절반",
        "그대로"
      ],
      "answer": 0,
      "explanation": "곱하는 주가가 절반이 되어 시가총액도 절반이 돼요."
    }
  ],
  "formula": "주가 × 발행 주식 수",
  "exercise": {
    "title": "주식 수를\n바꿔볼까요?",
    "fixed_label": "한 주 가격",
    "fixed": 1000,
    "fixed_unit": "원",
    "input_label": "전체 주식 수",
    "values": [
      10,
      20,
      50
    ],
    "input_unit": "주",
    "operation": "market_cap",
    "result_label": "시가총액",
    "result_unit": "원",
    "assumption": "한 주 가격은 그대로예요."
  }
}
```

## 02. 매출액

```json
{
  "number": 2,
  "name": "매출액",
  "english": "Revenue",
  "category": "G2",
  "core": "상품이나 서비스를 팔아 얻은 금액으로, 비용을 빼기 전 숫자예요.",
  "example": "1,000원짜리 음료를 10잔 팔았어요.",
  "result": "매출은 10,000원이에요.",
  "remember": "많이 팔았다는 것과 많이 남겼다는 것은 달라요.",
  "detail": "일정 기간의 판매 성과를 나타내요. 외상 판매도 회계 기준에 따라 매출로 잡힐 수 있어 현금 유입과 같지 않아요. 이익과 현금흐름을 함께 살펴봐요.",
  "news": {
    "headline": "매출은 늘었는데 이익은 줄었다",
    "meaning": "원가나 인건비가 매출보다 더 늘었을 수 있어요."
  },
  "home": {
    "prompt": "가게에서 받은 판매대금은 전부 이익일까요?",
    "options": [
      "전부 이익이에요",
      "비용을 빼야 해요"
    ],
    "answer": 1,
    "takeaway": "매출과 이익 사이에는 재료비 등 비용이 있어요."
  },
  "related": [
    3,
    4,
    20
  ],
  "questions": [
    {
      "prompt": "2,000원짜리 빵을 5개 팔았다면 매출은?",
      "options": [
        "5,000원",
        "10,000원"
      ],
      "answer": 1,
      "explanation": "가격 2,000원에 판매 수량 5개를 곱해요."
    },
    {
      "prompt": "매출만 늘면 영업이익도 꼭 늘까요?",
      "options": [
        "비용에 따라 달라요",
        "반드시 늘어요"
      ],
      "answer": 0,
      "explanation": "매출보다 영업비용이 더 커지면 이익은 줄 수 있어요."
    },
    {
      "prompt": "외상 판매가 매출로 기록됐어요. 현금도 이미 받았나요?",
      "options": [
        "반드시 받았어요",
        "아직 아닐 수 있어요"
      ],
      "answer": 1,
      "explanation": "매출 인식 시점과 현금 수령 시점은 다를 수 있어요."
    }
  ],
  "formula": "판매 수량 × 판매 가격 · 단순 예시"
}
```

## 03. 영업이익

```json
{
  "number": 3,
  "name": "영업이익",
  "english": "Operating profit",
  "category": "G2",
  "core": "회사의 주된 사업에서 매출원가와 판매·관리 비용을 뺀 이익이에요.",
  "example": "매출 10,000원에서 재료비·임차료 등 영업비용 7,000원을 빼요.",
  "result": "영업이익은 3,000원이에요.",
  "remember": "이자·세금까지 반영한 최종 이익은 아니에요.",
  "detail": "본업의 성과를 볼 때 사용해요. 모든 현금 지출을 단순히 뺀 숫자는 아니며, 감가상각 같은 회계상 비용도 반영돼요. 같은 회계 기준과 기간으로 비교해요.",
  "news": {
    "headline": "매출은 같은데 영업이익이 늘었다",
    "meaning": "영업비용을 줄였거나 더 이익이 남는 상품을 팔았을 수 있어요."
  },
  "home": {
    "prompt": "본업이 잘되는지 먼저 볼 숫자는?",
    "options": [
      "영업이익",
      "주식 수"
    ],
    "answer": 0,
    "takeaway": "영업이익은 주된 영업활동에서 남긴 이익을 보여줘요."
  },
  "related": [
    2,
    4,
    20
  ],
  "questions": [
    {
      "prompt": "매출 20,000원, 영업비용 15,000원이면 영업이익은?",
      "options": [
        "5,000원",
        "20,000원"
      ],
      "answer": 0,
      "explanation": "20,000원에서 15,000원을 빼면 5,000원이에요."
    },
    {
      "prompt": "영업이익에 법인세까지 모두 반영돼 있나요?",
      "options": [
        "네",
        "아니요"
      ],
      "answer": 1,
      "explanation": "영업이익 이후 이자 등 영업외 손익과 세금 등을 반영해 순이익을 구해요."
    },
    {
      "prompt": "매출은 그대로인데 영업비용만 1,000원 줄었다면?",
      "options": [
        "영업이익 1,000원 증가",
        "영업이익도 감소"
      ],
      "answer": 0,
      "explanation": "매출에서 빼는 비용이 줄어 그만큼 이익이 늘어요."
    }
  ],
  "formula": "매출액 − 매출원가 − 판매비와 관리비",
  "exercise": {
    "title": "영업비용이 달라지면?",
    "fixed_label": "매출",
    "fixed": 10000,
    "fixed_unit": "원",
    "input_label": "영업비용",
    "values": [
      6000,
      8000,
      10000
    ],
    "input_unit": "원",
    "operation": "profit",
    "result_label": "영업이익",
    "result_unit": "원",
    "assumption": "매출에서 영업비용만 빼는 단순 예시예요."
  }
}
```

## 04. 당기순이익

```json
{
  "number": 4,
  "name": "당기순이익",
  "english": "Net income",
  "category": "G2",
  "core": "한 회계기간의 수익과 비용, 세금 등을 반영한 최종 이익이에요.",
  "example": "영업이익 3,000원, 다른 손익은 없고 이자·세금 합계가 1,000원이에요.",
  "result": "당기순이익은 2,000원이에요.",
  "remember": "순이익이 늘어도 현금이 같은 만큼 늘지는 않아요.",
  "detail": "본업 이익에 영업외 손익과 세금 등을 반영해요. 자산 매각처럼 한 번뿐인 이익으로 커질 수도 있어요. 연결재무제표에서는 지배기업 주주 몫과 비지배지분도 구분해요.",
  "news": {
    "headline": "순이익 급증, 건물 매각 효과",
    "meaning": "반복되는 본업 이익인지 일회성 이익인지 나눠봐요."
  },
  "home": {
    "prompt": "회사 통장 잔액과 순이익은 같을까요?",
    "options": [
      "같은 숫자예요",
      "서로 달라요"
    ],
    "answer": 1,
    "takeaway": "회계상 이익과 실제 현금의 움직임은 달라요."
  },
  "related": [
    2,
    3,
    11,
    15
  ],
  "questions": [
    {
      "prompt": "영업이익 5,000원에서 이자·세금 2,000원만 빼면 순이익은?",
      "options": [
        "7,000원",
        "3,000원"
      ],
      "answer": 1,
      "explanation": "다른 손익이 없다는 가정에서 5,000원 − 2,000원이에요."
    },
    {
      "prompt": "건물 처분으로 순이익이 늘었어요. 본업도 좋아졌나요?",
      "options": [
        "별도로 확인해야 해요",
        "반드시 좋아졌어요"
      ],
      "answer": 0,
      "explanation": "일회성 처분이익만으로 본업의 개선을 판단할 수 없어요."
    },
    {
      "prompt": "외상 매출 덕분에 흑자여도 현금이 부족할 수 있나요?",
      "options": [
        "그럴 수 없어요",
        "그럴 수 있어요"
      ],
      "answer": 1,
      "explanation": "대금을 아직 못 받았다면 이익과 현금 사이에 차이가 생겨요."
    }
  ]
}
```

## 05. 배당금

```json
{
  "number": 5,
  "name": "배당금",
  "english": "Dividend",
  "category": "G1",
  "core": "회사가 주주에게 나누어 주기로 정한 현금이나 주식이에요.",
  "example": "한 주당 현금배당이 1,000원이고 2주에 배당 권리가 있어요.",
  "result": "세전 배당금은 2,000원이에요.",
  "remember": "배당 여부·금액·기준일은 회사 공시를 확인해요.",
  "detail": "모든 회사가 배당하는 것은 아니고 매년 같은 금액도 아니에요. 이익과 배당가능재원, 회사의 결정에 따라 달라져요. 연말에만 지급되는 것도 아니며 기준일과 결제 일정을 함께 확인해요.",
  "news": {
    "headline": "올해 배당금 축소 결정",
    "meaning": "과거 배당금이 앞으로도 보장되는 것은 아니에요."
  },
  "home": {
    "prompt": "주식을 갖고 있으면 꼭 배당을 받을까요?",
    "options": [
      "배당 결정과 권리를 봐야 해요",
      "언제나 받아요"
    ],
    "answer": 0,
    "takeaway": "배당하지 않는 회사도 있고 배당받을 기준도 정해져 있어요."
  },
  "related": [
    6,
    7,
    16,
    8
  ],
  "questions": [
    {
      "prompt": "1주당 1,000원, 배당 권리가 있는 주식이 3주라면 세전 배당은?",
      "options": [
        "3,000원",
        "1,000원"
      ],
      "answer": 0,
      "explanation": "1주당 배당금에 권리가 있는 주식 수를 곱해요."
    },
    {
      "prompt": "작년에 배당했으면 올해도 같은 금액을 받을까요?",
      "options": [
        "반드시 같아요",
        "보장되지 않아요"
      ],
      "answer": 1,
      "explanation": "회사의 실적과 배당 결정에 따라 금액이 달라질 수 있어요."
    },
    {
      "prompt": "주식을 사기 전 배당 권리를 확인하려면?",
      "options": [
        "기준일과 결제 일정을 확인",
        "작년 지급액만 확인"
      ],
      "answer": 0,
      "explanation": "매수한 주식에 해당 배당 권리가 있는지 일정과 공시를 확인해요."
    }
  ]
}
```

## 06. 배당수익률

```json
{
  "number": 6,
  "name": "배당수익률",
  "english": "Dividend yield",
  "category": "G1",
  "core": "주가에 비해 현금배당금이 얼마나 되는지 나타내는 비율이에요.",
  "example": "주가 10,000원, 1년 주당 현금배당금 1,000원이라면?",
  "result": "세전 배당수익률은 10%예요.",
  "remember": "예금 이자율처럼 원금이나 지급이 보장되지 않아요.",
  "detail": "과거 확정 배당인지 예상 배당인지, 어느 시점의 주가인지 확인해요. 주가가 하락해서 비율만 높아질 수도 있어요. 세금과 주가 변동까지 합친 총수익률과는 달라요.",
  "news": {
    "headline": "배당수익률 상승, 주가 하락 영향",
    "meaning": "배당금이 늘어서인지 주가가 내려서인지 구분해요."
  },
  "home": {
    "prompt": "배당수익률이 높으면 예금처럼 안전할까요?",
    "options": [
      "원금까지 안전해요",
      "주가와 배당이 바뀔 수 있어요"
    ],
    "answer": 1,
    "takeaway": "주식 가격 하락과 배당 축소 위험은 그대로 있어요."
  },
  "related": [
    5,
    16,
    12
  ],
  "questions": [
    {
      "prompt": "주가 20,000원, 연간 주당 배당 1,000원이면 배당수익률은?",
      "options": [
        "20%",
        "5%"
      ],
      "answer": 1,
      "explanation": "1,000 ÷ 20,000 × 100 = 5%예요."
    },
    {
      "prompt": "배당금은 같은데 주가만 절반이 되면 배당수익률은?",
      "options": [
        "두 배",
        "절반"
      ],
      "answer": 0,
      "explanation": "분모인 주가가 절반이 되면 비율은 두 배가 돼요."
    },
    {
      "prompt": "표시된 예상 배당수익률 8%는 확정 수익인가요?",
      "options": [
        "네",
        "아니요"
      ],
      "answer": 1,
      "explanation": "예상 배당과 주가가 바뀔 수 있어 확정 수익이 아니에요."
    }
  ],
  "formula": "주당 현금배당금 ÷ 주가 × 100"
}
```

## 07. 보통주와 우선주

```json
{
  "number": 7,
  "name": "보통주와 우선주",
  "english": "Common and preferred shares",
  "category": "G1",
  "core": "보통주는 보통 의결권이 있고, 우선주는 배당 등에 우선권이 붙는 주식이에요.",
  "example": "같은 회사의 주식인데 하나는 투표권, 다른 하나는 배당 조건이 달라요.",
  "result": "주식 종류마다 권리와 가격이 달라질 수 있어요.",
  "remember": "우선권의 내용과 의결권 유무는 발행 조건을 확인해요.",
  "detail": "주식은 회사를 나눈 소유 지분이에요. 우선주라고 항상 배당을 더 많이 받거나 원금이 보장되는 것은 아니에요. 의결권이 제한되는 경우가 많지만 예외도 있어요. 배당 우선 조건, 누적 여부, 유동성을 공시에서 살펴봐요.",
  "news": {
    "headline": "같은 회사인데 우선주만 급등",
    "meaning": "권리 조건과 거래량 등을 확인해야 이유를 판단할 수 있어요."
  },
  "home": {
    "prompt": "이름에 우선주가 붙으면 원금이 보장될까요?",
    "options": [
      "보장되지 않아요",
      "보장돼요"
    ],
    "answer": 0,
    "takeaway": "우선권은 정해진 권리에 대한 조건이지 원금 보장이 아니에요."
  },
  "related": [
    5,
    16,
    1
  ],
  "questions": [
    {
      "prompt": "주주총회 의결권이 보통 붙는 것은?",
      "options": [
        "보통주",
        "모든 우선주"
      ],
      "answer": 0,
      "explanation": "보통주에는 일반적으로 의결권이 있으며 우선주는 조건이 달라요."
    },
    {
      "prompt": "우선주 권리를 정확히 알려면?",
      "options": [
        "이름만 확인",
        "발행 조건을 확인"
      ],
      "answer": 1,
      "explanation": "배당 우선권과 의결권 제한은 발행 조건마다 달라요."
    },
    {
      "prompt": "우선주 거래량이 매우 적다면 살펴볼 점은?",
      "options": [
        "원하는 가격에 거래하기 어려울 수 있음",
        "가격이 절대 안 변함"
      ],
      "answer": 0,
      "explanation": "거래량이 적으면 매수·매도 호가 차이와 체결 위험이 커질 수 있어요."
    }
  ]
}
```

## 08. 권리락

```json
{
  "number": 8,
  "name": "권리락",
  "english": "Ex-rights",
  "category": "G1",
  "core": "새 주식 배정 등의 권리가 빠진 상태로 거래되는 것을 알려주는 조치예요.",
  "example": "무상증자 권리락일에 처음 산 주식에는 이번 신주 배정 권리가 없어요.",
  "result": "가격뿐 아니라 붙어 있는 권리도 달라진 거예요.",
  "remember": "배당 권리가 빠지는 배당락과 구분해요.",
  "detail": "증자 일정과 비율에 따라 기준가격이 조정될 수 있어요. 조정된 가격만 보고 손실이나 호재로 단정하지 않아요. 실제 거래가격은 수급에 따라 변하고, 권리·주식 수·총평가액을 함께 봐요.",
  "news": {
    "headline": "무상증자 권리락으로 기준가격 조정",
    "meaning": "기준가격 조정과 실제 시장에서의 가격 변동을 나눠 읽어요."
  },
  "home": {
    "prompt": "권리락일에 사면 이번 신주를 받을까요?",
    "options": [
      "무조건 받아요",
      "해당 권리가 빠져 있어요"
    ],
    "answer": 1,
    "takeaway": "권리락은 그 권리가 없는 상태로 거래된다는 뜻이에요."
  },
  "related": [
    17,
    24,
    5,
    9
  ],
  "questions": [
    {
      "prompt": "증자 신주 배정 권리가 빠진 거래를 알리는 조치는?",
      "options": [
        "배당락",
        "권리락"
      ],
      "answer": 1,
      "explanation": "신주 배정 등 증자 권리는 권리락, 배당 권리는 배당락으로 구분해요."
    },
    {
      "prompt": "권리락 후 가격이 낮아졌다는 이유만으로 악재인가요?",
      "options": [
        "권리와 가격 조정을 함께 봐야 해요",
        "항상 악재예요"
      ],
      "answer": 0,
      "explanation": "권리 변화에 따른 조정과 실제 가치 변화는 구분해야 해요."
    },
    {
      "prompt": "현금배당 받을 권리가 빠지는 날을 설명하는 말은?",
      "options": [
        "권리락",
        "배당락"
      ],
      "answer": 1,
      "explanation": "배당에 관한 권리의 소멸은 배당락이에요."
    }
  ]
}
```

## 09. 액면분할

```json
{
  "number": 9,
  "name": "액면분할",
  "english": "Stock split",
  "category": "G1",
  "core": "주식 한 주를 여러 주로 나누어 주식 수를 늘리는 일이에요.",
  "example": "10,000원짜리 1주를 2주로 나누면 이론상 한 주는 5,000원이에요.",
  "result": "분할 자체로 총평가액이 늘지는 않아요.",
  "remember": "피자를 더 잘게 잘라도 피자 전체 크기는 같아요.",
  "detail": "액면가와 주식 수가 분할 비율에 맞춰 바뀌어요. 회사에 새 자금이 들어오는 것은 아니에요. 거래하기 쉬워질 수 있지만 실제 주가와 거래량의 변화는 보장되지 않아요.",
  "news": {
    "headline": "주식 수 두 배로 액면분할",
    "meaning": "분할 비율에 따른 주가 조정과 총평가액을 함께 확인해요."
  },
  "home": {
    "prompt": "주식 수가 늘면 내 돈도 저절로 늘까요?",
    "options": [
      "분할만으로 늘지 않아요",
      "그만큼 늘어요"
    ],
    "answer": 0,
    "takeaway": "나뉜 조각은 많아져도 전체 가치는 분할 자체로 변하지 않아요."
  },
  "related": [
    1,
    8,
    17
  ],
  "questions": [
    {
      "prompt": "1주 20,000원을 2주로 분할하면 이론상 한 주 가격은?",
      "options": [
        "10,000원",
        "40,000원"
      ],
      "answer": 0,
      "explanation": "주식 수가 두 배가 되어 이론상 한 주 가격은 절반이에요."
    },
    {
      "prompt": "액면분할로 회사에 새 현금이 들어오나요?",
      "options": [
        "네",
        "아니요"
      ],
      "answer": 1,
      "explanation": "기존 주식을 나누는 것으로 자금을 조달하는 유상증자와 달라요."
    },
    {
      "prompt": "2주를 가진 사람이 1주를 5주로 나누는 분할을 받으면?",
      "options": [
        "10주",
        "7주"
      ],
      "answer": 0,
      "explanation": "기존 2주 × 분할 비율 5 = 10주예요."
    }
  ],
  "formula": "분할 전후 주식 수 × 이론상 주가 = 동일"
}
```

## 10. 자사주 매입과 소각

```json
{
  "number": 10,
  "name": "자사주 매입과 소각",
  "english": "Share repurchase and retirement",
  "category": "G1",
  "core": "매입은 회사가 자기 주식을 사는 것, 소각은 그 주식을 없애는 것이에요.",
  "example": "가게가 자기 몫의 종이표를 다시 사서 보관하거나 없애는 것과 비슷해요.",
  "result": "사들이는 것과 영구히 없애는 것은 다른 결정이에요.",
  "remember": "발표만으로 주가 상승이 보장되지는 않아요.",
  "detail": "매입한 자사주는 보유하거나 처분할 수 있지만 소각한 주식은 사라져요. 매입 가격, 실제 이행, 재원과 소각 계획을 함께 확인해요. 자사주는 이미 EPS 계산 주식 수에서 제외될 수 있어 소각 때 EPS가 또 늘어난다고 단정하지 않아요.",
  "news": {
    "headline": "자사주 매입 발표, 소각은 미정",
    "meaning": "매입 규모와 기간, 소각 여부와 실제 이행을 나눠 확인해요."
  },
  "home": {
    "prompt": "자사주 매입 발표는 소각 완료라는 뜻일까요?",
    "options": [
      "같은 뜻이에요",
      "아직 달라요"
    ],
    "answer": 1,
    "takeaway": "매입·보유·처분·소각은 각각 구분할 일이에요."
  },
  "related": [
    1,
    11,
    16
  ],
  "questions": [
    {
      "prompt": "회사가 자기 주식을 사서 보유하는 것은?",
      "options": [
        "자사주 소각",
        "자사주 매입"
      ],
      "answer": 1,
      "explanation": "매입은 사들이는 행위이고 소각은 주식을 없애는 행위예요."
    },
    {
      "prompt": "자사주 소각 뉴스가 나오면 주가는 반드시 오르나요?",
      "options": [
        "보장되지 않아요",
        "반드시 올라요"
      ],
      "answer": 0,
      "explanation": "매입 가격과 기대 반영 여부 등 여러 요인이 주가에 영향을 줘요."
    },
    {
      "prompt": "매입한 자사주를 나중에 다시 팔 수 있나요?",
      "options": [
        "매입 즉시 영구 소멸해요",
        "조건에 따라 가능해요"
      ],
      "answer": 1,
      "explanation": "보유 자사주의 처분과 소각은 서로 다른 결정이에요."
    }
  ]
}
```

## 11. EPS · 주당순이익

```json
{
  "number": 11,
  "name": "EPS · 주당순이익",
  "english": "Earnings per share",
  "category": "G2",
  "core": "보통주 주주의 이익을 한 주 단위로 나눈 숫자예요.",
  "example": "기간 중 보통주 몫의 순이익 10,000원, 평균 주식 수가 10주라면?",
  "result": "EPS는 1,000원이에요.",
  "remember": "주주에게 실제로 지급한 배당금과는 달라요.",
  "detail": "기본 EPS는 기간 중 주식 수 변화를 반영한 가중평균 유통 보통주 수를 사용해요. 분기인지 연간인지 확인해요. 전환 가능 주식 등을 반영한 희석 EPS와도 구분해요.",
  "news": {
    "headline": "순이익은 같은데 EPS 상승",
    "meaning": "이익뿐 아니라 EPS 계산에 쓰이는 주식 수도 확인해요."
  },
  "home": {
    "prompt": "EPS 1,000원이면 1,000원을 입금받을까요?",
    "options": [
      "배당금과는 달라요",
      "자동으로 받아요"
    ],
    "answer": 0,
    "takeaway": "EPS는 이익을 한 주로 환산한 지표예요."
  },
  "related": [
    4,
    12,
    10
  ],
  "questions": [
    {
      "prompt": "보통주 순이익 20,000원, 평균 10주라면 EPS는?",
      "options": [
        "2,000원",
        "200원"
      ],
      "answer": 0,
      "explanation": "20,000원 ÷ 10주 = 2,000원이에요."
    },
    {
      "prompt": "연간 EPS와 한 분기 EPS를 그대로 비교해도 될까요?",
      "options": [
        "언제나 괜찮아요",
        "기간을 맞춰야 해요"
      ],
      "answer": 1,
      "explanation": "이익을 집계한 기간이 다르면 단순 비교가 어려워요."
    },
    {
      "prompt": "보통주 순이익이 두 배, 평균 주식 수는 같다면 EPS는?",
      "options": [
        "두 배",
        "그대로"
      ],
      "answer": 0,
      "explanation": "같은 주식 수로 두 배의 이익을 나누면 EPS도 두 배예요."
    }
  ],
  "formula": "보통주 귀속 순이익 ÷ 가중평균 유통 보통주 수",
  "exercise": {
    "title": "같은 이익을\n더 많은 주식으로 나누면?",
    "fixed_label": "보통주 몫의 이익",
    "fixed": 10000,
    "fixed_unit": "원",
    "input_label": "1년 내내 같은 주식 수",
    "values": [
      5,
      10,
      20
    ],
    "input_unit": "주",
    "operation": "eps",
    "result_label": "한 주당 이익 · EPS",
    "result_unit": "원",
    "assumption": "보통주만 있고, 각 경우의 주식 수는 1년 내내 같아요."
  }
}
```

## 12. PER · 주가수익비율

```json
{
  "number": 12,
  "name": "PER · 주가수익비율",
  "english": "Price-to-earnings ratio",
  "category": "G3",
  "core": "주가가 주당순이익의 몇 배인지 나타내는 비율이에요.",
  "example": "주가 10,000원, 연간 EPS 2,000원이라면?",
  "result": "PER은 5배예요.",
  "remember": "원금을 돌려받는 확정 기간이나 미래 수익률이 아니에요.",
  "detail": "같은 기간·회계 기준인지, 과거 이익인지 예상 이익인지 맞춰봐요. 낮은 PER은 성장 둔화나 일회성 이익의 영향일 수도 있어요. EPS가 0이거나 적자면 통상적인 양수 PER 비교가 어려워요.",
  "news": {
    "headline": "PER 하락, 이익 증가 영향",
    "meaning": "주가와 EPS 중 무엇이 변했는지 먼저 나눠봐요."
  },
  "home": {
    "prompt": "PER 5배면 5년 뒤 원금 회수가 보장될까요?",
    "options": [
      "보장돼요",
      "보장되지 않아요"
    ],
    "answer": 1,
    "takeaway": "이익이 일정하거나 전부 배당된다는 보장이 없어요."
  },
  "related": [
    1,
    11,
    14,
    15
  ],
  "questions": [
    {
      "prompt": "주가 20,000원, EPS 2,000원이면 PER은?",
      "options": [
        "2배",
        "10배"
      ],
      "answer": 1,
      "explanation": "20,000 ÷ 2,000 = 10배예요."
    },
    {
      "prompt": "PER이 낮다는 이유만으로 저평가인가요?",
      "options": [
        "이익의 지속성도 봐야 해요",
        "항상 저평가예요"
      ],
      "answer": 0,
      "explanation": "일회성 이익이나 성장 둔화 때문에 낮을 수도 있어요."
    },
    {
      "prompt": "주가는 같고 EPS만 두 배로 늘면 PER은?",
      "options": [
        "두 배",
        "절반"
      ],
      "answer": 1,
      "explanation": "주가를 더 큰 EPS로 나누므로 PER은 절반이 돼요."
    }
  ],
  "formula": "주가 ÷ EPS",
  "exercise": {
    "title": "EPS가 같을 때\n주가를 바꿔봐요.",
    "fixed_label": "EPS",
    "fixed": 1000,
    "fixed_unit": "원",
    "input_label": "주가",
    "values": [
      5000,
      10000,
      20000
    ],
    "input_unit": "원",
    "operation": "pe_price",
    "result_label": "PER",
    "result_unit": "배",
    "assumption": "같은 기간·기준의 양수 EPS를 사용해요."
  }
}
```

## 13. BPS · 주당순자산

```json
{
  "number": 13,
  "name": "BPS · 주당순자산",
  "english": "Book value per share",
  "category": "G2",
  "core": "장부상 순자산 중 보통주 몫을 한 주 단위로 나눈 숫자예요.",
  "example": "보통주 몫의 순자산 20,000원, 기준 주식 수 10주라면?",
  "result": "BPS는 2,000원이에요.",
  "remember": "회사를 정리할 때 꼭 받는 현금이 아니에요.",
  "detail": "순자산은 자산에서 부채를 뺀 장부상 금액이에요. 실제 매각 가격과 정리 비용은 다를 수 있어요. 우선주·자사주 처리 등 자료 제공처의 산정 기준도 확인해요.",
  "news": {
    "headline": "주가가 BPS 아래로 내려갔다",
    "meaning": "장부가와 실제 처분 가능한 가치가 같은 것은 아니에요."
  },
  "home": {
    "prompt": "BPS는 청산 때 보장되는 금액일까요?",
    "options": [
      "장부 기준의 지표예요",
      "보장되는 현금이에요"
    ],
    "answer": 0,
    "takeaway": "실제 자산 처분액과 비용에 따라 남는 금액이 달라져요."
  },
  "related": [
    14,
    15,
    19
  ],
  "questions": [
    {
      "prompt": "보통주 순자산 30,000원, 기준 10주라면 BPS는?",
      "options": [
        "3,000원",
        "30,000원"
      ],
      "answer": 0,
      "explanation": "30,000원 ÷ 10주 = 3,000원이에요."
    },
    {
      "prompt": "BPS를 구할 때 자산에서 빼야 하는 것은?",
      "options": [
        "매출액",
        "부채"
      ],
      "answer": 1,
      "explanation": "자산에서 부채를 뺀 순자산을 기준으로 해요."
    },
    {
      "prompt": "장부상 자산을 예상보다 낮게 팔면 청산 금액은 BPS와 같나요?",
      "options": [
        "달라질 수 있어요",
        "항상 같아요"
      ],
      "answer": 0,
      "explanation": "장부가와 실제 처분 가격은 같다는 보장이 없어요."
    }
  ],
  "formula": "보통주 몫의 장부상 순자산 ÷ 기준 보통주 수"
}
```

## 14. PBR · 주가순자산비율

```json
{
  "number": 14,
  "name": "PBR · 주가순자산비율",
  "english": "Price-to-book ratio",
  "category": "G3",
  "core": "주가가 주당순자산의 몇 배인지 나타내는 비율이에요.",
  "example": "주가 5,000원, BPS 10,000원이라면?",
  "result": "PBR은 0.5배예요.",
  "remember": "1배 미만이라고 무조건 싼 주식은 아니에요.",
  "detail": "자산의 질과 미래 수익성이 낮으면 장부가보다 낮게 거래될 수 있어요. 업종과 회계 기준을 맞추고 ROE 등과 함께 봐요. 순자산이 음수인 회사는 일반적인 비교가 어려워요.",
  "news": {
    "headline": "PBR 1배 미만 기업 증가",
    "meaning": "낮은 평가의 이유와 수익성을 함께 확인해요."
  },
  "home": {
    "prompt": "PBR 0.5배면 무조건 반값 할인일까요?",
    "options": [
      "확실한 할인이에요",
      "낮은 이유도 봐야 해요"
    ],
    "answer": 1,
    "takeaway": "장부상 순자산이 앞으로 이익을 잘 만들어낼지도 중요해요."
  },
  "related": [
    1,
    12,
    13,
    15
  ],
  "questions": [
    {
      "prompt": "주가 10,000원, BPS 5,000원이면 PBR은?",
      "options": [
        "0.5배",
        "2배"
      ],
      "answer": 1,
      "explanation": "10,000 ÷ 5,000 = 2배예요."
    },
    {
      "prompt": "PBR 1배 미만이 뜻하는 것은?",
      "options": [
        "주가가 BPS보다 낮음",
        "주가 상승 보장"
      ],
      "answer": 0,
      "explanation": "PBR은 장부상 순자산과 가격의 관계이지 수익 보장이 아니에요."
    },
    {
      "prompt": "주가는 그대로, BPS가 두 배가 되면 PBR은?",
      "options": [
        "두 배",
        "절반"
      ],
      "answer": 1,
      "explanation": "분모인 BPS가 커져 비율은 낮아져요."
    }
  ],
  "formula": "주가 ÷ BPS"
}
```

## 15. ROE · 자기자본이익률

```json
{
  "number": 15,
  "name": "ROE · 자기자본이익률",
  "english": "Return on equity",
  "category": "G2",
  "core": "주주의 자본으로 얼마나 이익을 냈는지 보는 비율이에요.",
  "example": "순이익 2,000원, 기간 평균 자기자본 20,000원이라면?",
  "result": "ROE는 10%예요.",
  "remember": "높은 ROE의 이유에 부채 증가나 자본 감소가 있을 수 있어요.",
  "detail": "연결 기준은 지배주주 순이익과 그에 대응하는 자기자본처럼 범위를 맞춰요. 단일 수치보다 여러 기간과 같은 업종을 비교해요. 자기자본이 너무 작거나 음수면 해석에 주의해요.",
  "news": {
    "headline": "ROE 상승, 차입 확대 동반",
    "meaning": "수익성 개선인지 부채와 자본 구조의 영향인지 확인해요."
  },
  "home": {
    "prompt": "ROE가 높으면 이유를 볼 필요가 없을까요?",
    "options": [
      "부채와 자본도 봐요",
      "숫자만 높으면 돼요"
    ],
    "answer": 0,
    "takeaway": "분자인 이익과 분모인 자본이 모두 비율에 영향을 줘요."
  },
  "related": [
    4,
    13,
    14,
    19
  ],
  "questions": [
    {
      "prompt": "순이익 1,000원, 평균 자기자본 10,000원이면 ROE는?",
      "options": [
        "10%",
        "1%"
      ],
      "answer": 0,
      "explanation": "1,000 ÷ 10,000 × 100 = 10%예요."
    },
    {
      "prompt": "이익이 같은데 자기자본이 줄면 ROE는?",
      "options": [
        "반드시 낮아져요",
        "높아질 수 있어요"
      ],
      "answer": 1,
      "explanation": "분모가 작아져 높아진 ROE가 본업 개선을 뜻하지는 않아요."
    },
    {
      "prompt": "ROE를 비교할 때 적절한 방법은?",
      "options": [
        "동일 기준·업종과 여러 기간 확인",
        "15%만 넘으면 무조건 우수"
      ],
      "answer": 0,
      "explanation": "업종과 재무 구조에 따라 적절한 수준과 의미가 달라요."
    }
  ],
  "formula": "순이익 ÷ 평균 자기자본 × 100"
}
```

## 16. 배당성향

```json
{
  "number": 16,
  "name": "배당성향",
  "english": "Dividend payout ratio",
  "category": "G1",
  "core": "회사가 번 이익 중 얼마를 배당으로 나누는지 나타내는 비율이에요.",
  "example": "순이익 10,000원 중 3,000원을 현금배당으로 나눠요.",
  "result": "배당성향은 30%예요.",
  "remember": "주가와 비교하는 배당수익률과 구분해요.",
  "detail": "분모의 순이익과 배당 대상 주주의 범위를 맞춰요. 비율이 높아도 투자할 재원과 배당 지속 가능성을 살펴봐야 해요. 적자이거나 일회성 이익이 크면 비율 해석이 어려워져요.",
  "news": {
    "headline": "배당성향 확대 발표",
    "meaning": "주가가 아니라 이익 중 나눌 몫을 늘린다는 의미예요."
  },
  "home": {
    "prompt": "배당성향은 무엇과 배당을 비교할까요?",
    "options": [
      "한 주 가격",
      "회사의 순이익"
    ],
    "answer": 1,
    "takeaway": "이익 중 배당 몫은 배당성향, 주가 대비 배당은 배당수익률이에요."
  },
  "related": [
    4,
    5,
    6,
    10
  ],
  "questions": [
    {
      "prompt": "순이익 20,000원, 현금배당 총액 10,000원이면 배당성향은?",
      "options": [
        "20%",
        "50%"
      ],
      "answer": 1,
      "explanation": "10,000 ÷ 20,000 × 100 = 50%예요."
    },
    {
      "prompt": "배당성향이 높으면 항상 더 좋은 회사인가요?",
      "options": [
        "재투자와 지속성도 봐야 해요",
        "항상 더 좋아요"
      ],
      "answer": 0,
      "explanation": "투자 기회와 재무 여건에 따라 적절한 배당 규모가 달라요."
    },
    {
      "prompt": "배당 총액은 같은데 순이익이 절반이면 배당성향은?",
      "options": [
        "절반",
        "두 배"
      ],
      "answer": 1,
      "explanation": "분모인 순이익이 줄어 비율이 커져요."
    }
  ],
  "formula": "현금배당 총액 ÷ 대응하는 순이익 × 100"
}
```

## 17. 무상증자

```json
{
  "number": 17,
  "name": "무상증자",
  "english": "Bonus issue",
  "category": "G1",
  "core": "회사의 잉여금을 자본금으로 옮기며 주주에게 새 주식을 배정하는 일이에요.",
  "example": "1주당 1주 무상증자로 2주를 가진 사람에게 2주가 더 배정돼요.",
  "result": "주식은 4주가 되지만 회사에 새 현금이 들어오지는 않아요.",
  "remember": "주식 수 증가만으로 내 자산이 두 배가 되지는 않아요.",
  "detail": "자본 항목 사이의 이동이므로 무상증자 자체가 순자산을 늘리지는 않아요. 배정 비율과 기준일, 권리락, 신주 상장일을 확인해요. 액면분할과 효과가 비슷해 보여도 법적·회계적 방식이 달라요.",
  "news": {
    "headline": "1주당 1주 무상증자 결정",
    "meaning": "주식 수와 기준가격이 함께 조정되는지 확인해요."
  },
  "home": {
    "prompt": "무상증자는 회사로 새 돈이 들어오는 걸까요?",
    "options": [
      "기존 잉여금을 옮겨요",
      "외부 돈이 들어와요"
    ],
    "answer": 0,
    "takeaway": "유상증자와 달리 주주가 새로 납입하는 돈은 없어요."
  },
  "related": [
    8,
    9,
    24,
    18
  ],
  "questions": [
    {
      "prompt": "1주당 1주 배정, 기존 3주라면 배정 후 몇 주인가요?",
      "options": [
        "6주",
        "4주"
      ],
      "answer": 0,
      "explanation": "기존 3주에 신주 3주가 더해져 6주예요."
    },
    {
      "prompt": "무상증자 자체로 회사의 순자산이 늘어나나요?",
      "options": [
        "네",
        "아니요"
      ],
      "answer": 1,
      "explanation": "잉여금이 자본금으로 옮겨가는 것이며 새 자산 유입은 없어요."
    },
    {
      "prompt": "무상증자 발표만으로 주가 상승을 확신해도 될까요?",
      "options": [
        "아니요",
        "네"
      ],
      "answer": 0,
      "explanation": "권리와 가격 조정, 시장 기대 등을 함께 봐야 해요."
    }
  ]
}
```

## 18. 유보율

```json
{
  "number": 18,
  "name": "유보율",
  "english": "Reserve-to-capital ratio",
  "category": "G2",
  "core": "자본금에 비해 자본잉여금과 이익잉여금이 얼마나 쌓였는지 보는 비율이에요.",
  "example": "잉여금 합계 20,000원, 자본금 10,000원이라면?",
  "result": "유보율은 200%예요.",
  "remember": "현금이 통장에 그만큼 있다는 뜻은 아니에요.",
  "detail": "잉여금에 대응하는 자산은 현금뿐 아니라 공장·재고·채권 등일 수 있어요. 자본금이 작아 비율이 높아질 수도 있어요. 현금 보유와 지급 능력은 재무상태표와 현금흐름을 따로 확인해요.",
  "news": {
    "headline": "유보율 높은데 자금 조달 추진",
    "meaning": "유보율과 당장 쓸 수 있는 현금은 다른 정보예요."
  },
  "home": {
    "prompt": "유보율 200%면 현금이 200% 쌓였을까요?",
    "options": [
      "맞아요",
      "현금 비율이 아니에요"
    ],
    "answer": 1,
    "takeaway": "잉여금은 자본 항목이며 어떤 자산으로 남아 있는지는 별개예요."
  },
  "related": [
    17,
    19,
    13
  ],
  "questions": [
    {
      "prompt": "잉여금 30,000원, 자본금 10,000원이면 유보율은?",
      "options": [
        "30%",
        "300%"
      ],
      "answer": 1,
      "explanation": "30,000 ÷ 10,000 × 100 = 300%예요."
    },
    {
      "prompt": "높은 유보율만으로 당장 쓸 현금이 많다고 판단할까요?",
      "options": [
        "현금 자산을 따로 봐요",
        "그렇게 판단해요"
      ],
      "answer": 0,
      "explanation": "잉여금에 대응하는 자산이 설비나 재고일 수 있어요."
    },
    {
      "prompt": "무상증자로 잉여금을 자본금으로 옮기면 유보율은?",
      "options": [
        "반드시 높아져요",
        "낮아질 수 있어요"
      ],
      "answer": 1,
      "explanation": "분자는 줄고 분모는 늘어 비율이 낮아질 수 있어요."
    }
  ],
  "formula": "(자본잉여금 + 이익잉여금) ÷ 자본금 × 100"
}
```

## 19. 부채비율

```json
{
  "number": 19,
  "name": "부채비율",
  "english": "Debt-to-equity ratio",
  "category": "G2",
  "core": "자기자본에 비해 부채가 얼마나 있는지 보는 비율이에요.",
  "example": "자기자본 10,000원, 부채 20,000원이라면?",
  "result": "부채비율은 200%예요.",
  "remember": "업종·부채 만기·이자 부담을 함께 봐요.",
  "detail": "부채에는 차입금뿐 아니라 매입채무 등도 포함돼요. 업종마다 사업 구조가 달라 200% 같은 한 기준만으로 위험을 단정하기 어려워요. 자기자본이 음수일 때 음의 비율을 안전하다고 해석하지 않아요.",
  "news": {
    "headline": "부채비율 하락, 자본 확충 영향",
    "meaning": "부채 감소와 자기자본 증가 중 무엇이 원인인지 확인해요."
  },
  "home": {
    "prompt": "부채비율은 매출과 빚을 비교할까요?",
    "options": [
      "자기자본과 비교해요",
      "매출과 비교해요"
    ],
    "answer": 0,
    "takeaway": "분모는 매출이 아니라 자기자본이에요."
  },
  "related": [
    13,
    15,
    18,
    40
  ],
  "questions": [
    {
      "prompt": "부채 5,000원, 자기자본 10,000원이면 부채비율은?",
      "options": [
        "50%",
        "200%"
      ],
      "answer": 0,
      "explanation": "5,000 ÷ 10,000 × 100 = 50%예요."
    },
    {
      "prompt": "업종이 다른 두 회사의 부채비율만 보고 위험을 단정하나요?",
      "options": [
        "비율 하나로 충분해요",
        "만기와 업종도 확인해요"
      ],
      "answer": 1,
      "explanation": "자금 회수 구조와 부채 상환 능력도 함께 봐야 해요."
    },
    {
      "prompt": "부채는 그대로, 자기자본이 두 배가 되면 부채비율은?",
      "options": [
        "절반",
        "두 배"
      ],
      "answer": 0,
      "explanation": "분모가 두 배가 되어 비율은 절반으로 내려가요."
    }
  ],
  "formula": "부채 ÷ 자기자본 × 100"
}
```

## 20. 영업이익률

```json
{
  "number": 20,
  "name": "영업이익률",
  "english": "Operating margin",
  "category": "G2",
  "core": "매출에서 영업이익이 차지하는 비율이에요.",
  "example": "매출 10,000원 중 영업이익이 2,000원이에요.",
  "result": "영업이익률은 20%예요.",
  "remember": "매출이 커도 남는 비율은 낮을 수 있어요.",
  "detail": "본업에서 얼마나 효율적으로 이익을 남기는지 볼 때 쓰지만 업종마다 수준이 달라요. 높다는 이유만으로 독점력이나 향후 이익을 보장하지 않아요. 가격·원가·상품 구성 변화도 살펴봐요.",
  "news": {
    "headline": "매출 증가에도 영업이익률 하락",
    "meaning": "규모는 커졌지만 매출당 남는 이익은 줄었을 수 있어요."
  },
  "home": {
    "prompt": "많이 팔면 남는 비율도 꼭 높을까요?",
    "options": [
      "꼭 높아져요",
      "비용에 따라 달라요"
    ],
    "answer": 1,
    "takeaway": "매출과 영업이익률은 별도로 확인해야 해요."
  },
  "related": [
    2,
    3,
    4
  ],
  "questions": [
    {
      "prompt": "매출 20,000원, 영업이익 2,000원이면 영업이익률은?",
      "options": [
        "20%",
        "10%"
      ],
      "answer": 1,
      "explanation": "2,000 ÷ 20,000 × 100 = 10%예요."
    },
    {
      "prompt": "영업이익률이 30%면 독점 기업이라는 뜻인가요?",
      "options": [
        "그것만으로 몰라요",
        "반드시 독점이에요"
      ],
      "answer": 0,
      "explanation": "이익률은 수익성 지표이며 시장 지배력의 확정 증거가 아니에요."
    },
    {
      "prompt": "매출이 두 배, 영업이익은 그대로면 영업이익률은?",
      "options": [
        "두 배",
        "절반"
      ],
      "answer": 1,
      "explanation": "같은 이익을 두 배의 매출로 나누므로 비율은 절반이에요."
    }
  ],
  "formula": "영업이익 ÷ 매출액 × 100"
}
```

## 21. 공매도

```json
{
  "number": 21,
  "name": "공매도",
  "english": "Short selling",
  "category": "G5",
  "core": "주식을 빌려 먼저 팔고, 나중에 사서 갚는 거래예요.",
  "example": "빌린 주식을 10,000원에 팔고 8,000원에 사서 돌려줘요.",
  "result": "비용을 빼기 전 차익은 2,000원이에요.",
  "remember": "반대로 가격이 오르면 손실이 커질 수 있어요.",
  "detail": "차입 비용과 상환 의무가 있고 가격 상승으로 손실이 크게 늘 수 있어요. 공매도 잔고만으로 앞으로의 주가를 단정하지 않아요. 허용 대상과 차입·공시 규정은 시장별 최신 규정을 확인해요.",
  "news": {
    "headline": "공매도 잔고 증가",
    "meaning": "하락 예상뿐 아니라 헤지 등 거래 목적도 있어 가격 방향을 단정할 수 없어요."
  },
  "home": {
    "prompt": "빌린 주식을 팔았는데 가격이 오르면 유리할까요?",
    "options": [
      "갚는 비용이 커져요",
      "이익이 늘어요"
    ],
    "answer": 0,
    "takeaway": "다시 사서 갚아야 하므로 더 비싸지면 불리해요."
  },
  "related": [
    29,
    30,
    50
  ],
  "questions": [
    {
      "prompt": "10,000원에 팔고 12,000원에 사서 갚았다면 비용 전 손익은?",
      "options": [
        "2,000원 손실",
        "2,000원 이익"
      ],
      "answer": 0,
      "explanation": "팔아 받은 돈보다 다시 사는 데 쓴 돈이 더 많아요."
    },
    {
      "prompt": "공매도한 주식은 나중에 돌려줘야 하나요?",
      "options": [
        "팔면 의무가 끝나요",
        "상환 의무가 있어요"
      ],
      "answer": 1,
      "explanation": "빌린 주식이므로 계약 조건에 따른 상환이 필요해요."
    },
    {
      "prompt": "공매도 잔고가 늘면 주가 하락이 확정되나요?",
      "options": [
        "아니요",
        "네"
      ],
      "answer": 0,
      "explanation": "거래 목적과 시장 상황이 다양해 잔고만으로 예측할 수 없어요."
    }
  ]
}
```

## 22. ETF · 상장지수펀드

```json
{
  "number": 22,
  "name": "ETF · 상장지수펀드",
  "english": "Exchange-traded fund",
  "category": "G4",
  "core": "주식처럼 거래소에서 사고파는 펀드예요.",
  "example": "여러 채권을 담은 펀드 한 주를 거래소에서 살 수도 있어요.",
  "result": "ETF에는 주식뿐 아니라 다양한 자산이 담길 수 있어요.",
  "remember": "무엇을 담고 어떻게 운용하는지 먼저 확인해요.",
  "detail": "지수를 따르는 상품뿐 아니라 액티브 ETF도 있어요. 모든 ETF가 넓게 분산되거나 안전한 것은 아니에요. 단일 종목·레버리지 등 구조와 비용, 순자산가치 대비 거래가격도 확인해요.",
  "news": {
    "headline": "이름은 비슷한데 ETF 수익률 차이",
    "meaning": "편입 자산과 운용 방식, 비용부터 비교해요."
  },
  "home": {
    "prompt": "ETF면 모두 여러 주식에 골고루 투자할까요?",
    "options": [
      "모두 같아요",
      "상품마다 달라요"
    ],
    "answer": 1,
    "takeaway": "채권이나 특정 자산에 집중하는 ETF도 있어요."
  },
  "related": [
    23,
    40,
    50
  ],
  "questions": [
    {
      "prompt": "ETF를 가장 잘 설명한 것은?",
      "options": [
        "원금 보장 예금",
        "거래소에서 거래되는 펀드"
      ],
      "answer": 1,
      "explanation": "ETF는 펀드이며 손실이 날 수 있어요."
    },
    {
      "prompt": "주식 ETF와 채권 ETF가 같은 자산을 담나요?",
      "options": [
        "담는 자산이 달라요",
        "항상 같아요"
      ],
      "answer": 0,
      "explanation": "ETF라는 거래 형태가 같아도 투자 대상은 다를 수 있어요."
    },
    {
      "prompt": "ETF 두 개를 샀으면 충분히 분산했나요?",
      "options": [
        "개수만 두 개면 충분",
        "편입 자산의 겹침도 확인"
      ],
      "answer": 1,
      "explanation": "같은 종목이나 업종에 집중하면 두 개라도 분산 효과가 작아요."
    }
  ]
}
```

## 23. ETN · 상장지수증권

```json
{
  "number": 23,
  "name": "ETN · 상장지수증권",
  "english": "Exchange-traded note",
  "category": "G4",
  "core": "지수 등의 수익률에 연동해 지급하기로 한, 발행사의 채무증권이에요.",
  "example": "약속한 지수 성과에 따라 돈을 지급받는 증서를 거래하는 셈이에요.",
  "result": "지수 움직임과 발행사의 지급 능력을 함께 봐요.",
  "remember": "발행사가 있다는 것이 원금 보장을 뜻하지는 않아요.",
  "detail": "펀드 지분인 ETF와 구조가 달라요. 발행사가 지급하지 못할 신용위험과 지수 변동 위험이 있어요. 만기·중도상환 조건·비용·괴리율도 확인해요. 레버리지 상품은 일간 수익률 기준을 주의해요.",
  "news": {
    "headline": "ETN 발행사 신용등급 하락",
    "meaning": "기초지수 외에 발행사의 신용위험도 가격에 영향을 줄 수 있어요."
  },
  "home": {
    "prompt": "ETN은 증권사가 발행하니 원금이 보장될까요?",
    "options": [
      "보장되지 않아요",
      "보장돼요"
    ],
    "answer": 0,
    "takeaway": "발행사 지급 불능과 기초지수 하락으로 손실이 날 수 있어요."
  },
  "related": [
    22,
    40,
    19
  ],
  "questions": [
    {
      "prompt": "ETN 투자에서 지수 외에 꼭 볼 위험은?",
      "options": [
        "발행사의 신용위험",
        "발행사와 무관한 보장 여부"
      ],
      "answer": 0,
      "explanation": "ETN은 발행사의 채무라 지급 능력이 중요해요."
    },
    {
      "prompt": "ETF와 ETN의 구조는 완전히 같은가요?",
      "options": [
        "이름만 달라요",
        "펀드와 채무증권으로 달라요"
      ],
      "answer": 1,
      "explanation": "ETF는 펀드, ETN은 발행사가 지급을 약속한 증권이에요."
    },
    {
      "prompt": "기초지수가 올라도 발행사가 지급 불능이면?",
      "options": [
        "손실 가능성이 있어요",
        "언제나 전액 보장돼요"
      ],
      "answer": 0,
      "explanation": "지수 성과가 좋아도 발행사 신용위험은 남아 있어요."
    }
  ]
}
```

## 24. 유상증자

```json
{
  "number": 24,
  "name": "유상증자",
  "english": "Rights offering / new share issue",
  "category": "G1",
  "core": "새 주식을 발행하고 돈 등을 납입받아 자본을 늘리는 일이에요.",
  "example": "회사가 새 주식 2주를 주당 5,000원에 발행해요.",
  "result": "발행비용 전 납입금은 10,000원이에요.",
  "remember": "조달 목적·발행 조건·기존 주주 지분 변화를 함께 봐요.",
  "detail": "설비 투자, 인수, 부채 상환 등 자금 용도가 다양해요. 돈이 들어와도 기존 주주가 참여하지 않으면 지분율이 낮아질 수 있어요. 자금 용도만으로 호재·악재를 단정하지 않아요.",
  "news": {
    "headline": "부채 상환 목적 유상증자 결정",
    "meaning": "희석 가능성과 재무 부담 완화 효과를 함께 살펴봐요."
  },
  "home": {
    "prompt": "유상증자로 새 주식을 만들면 기존 지분율은 그대로일까요?",
    "options": [
      "항상 그대로예요",
      "참여 여부 등에 따라 달라져요"
    ],
    "answer": 1,
    "takeaway": "내 주식 수가 그대로인데 전체 주식이 늘면 지분율은 낮아져요."
  },
  "related": [
    17,
    8,
    11,
    19
  ],
  "questions": [
    {
      "prompt": "새 주식 3주를 10,000원씩 납입받으면 비용 전 조달액은?",
      "options": [
        "10,000원",
        "30,000원"
      ],
      "answer": 1,
      "explanation": "발행 수량 3주 × 발행 가격 10,000원이에요."
    },
    {
      "prompt": "10주 중 2주를 보유했는데 남에게 10주를 추가 발행하면 내 지분율은?",
      "options": [
        "10%",
        "20%"
      ],
      "answer": 0,
      "explanation": "내 2주는 그대로이고 전체가 20주가 되어 2 ÷ 20 = 10%예요."
    },
    {
      "prompt": "공장 건설용 유상증자면 무조건 호재인가요?",
      "options": [
        "무조건 호재예요",
        "수익성과 조건도 봐야 해요"
      ],
      "answer": 1,
      "explanation": "투자 성과와 발행 가격, 지분 희석 등 여러 조건이 중요해요."
    }
  ]
}
```

## 25. 지정가와 시장가

```json
{
  "number": 25,
  "name": "지정가와 시장가",
  "english": "Limit and market orders",
  "category": "G5",
  "core": "지정가는 가격 조건을 정하고, 시장가는 가능한 상대 주문과의 체결을 우선해요.",
  "example": "매수 지정가 5,000원은 그 가격 이하에서만 사겠다는 주문이에요.",
  "result": "가격을 지켜도 주문이 체결되지 않을 수 있어요.",
  "remember": "시장가의 최종 체결가격은 화면의 최근 가격과 다를 수 있어요.",
  "detail": "지정가 매수는 지정 가격 이하, 매도는 지정 가격 이상이 조건이에요. 상대 주문 수량이 부족하면 일부만 체결될 수 있어요. 시장가도 거래 정지나 상대 주문 부족 때 즉시 전량 체결이 보장되지는 않아요.",
  "news": {
    "headline": "시장가 주문이 예상보다 비싸게 체결",
    "meaning": "최근 체결가와 지금 살 수 있는 호가·수량이 다를 수 있어요."
  },
  "home": {
    "prompt": "시장가면 화면 가격 그대로 살까요?",
    "options": [
      "실제 체결가격은 달라질 수 있어요",
      "꼭 그 가격이에요"
    ],
    "answer": 0,
    "takeaway": "주문을 받을 상대 호가와 수량에 따라 체결가격이 정해져요."
  },
  "related": [
    28,
    26,
    27
  ],
  "questions": [
    {
      "prompt": "매수 지정가가 5,000원인데 매도 호가가 6,000원뿐이라면?",
      "options": [
        "체결되지 않을 수 있어요",
        "6,000원에 바로 사요"
      ],
      "answer": 0,
      "explanation": "지정가 매수는 지정한 가격보다 비싸게 체결하지 않아요."
    },
    {
      "prompt": "시장가 주문이 우선하는 것은?",
      "options": [
        "특정 가격 보장",
        "가능한 상대 주문과의 체결"
      ],
      "answer": 1,
      "explanation": "시장가는 가격을 지정하지 않아 가격 변동 위험이 있어요."
    },
    {
      "prompt": "매도 지정가 10,000원이면 9,000원에도 팔리나요?",
      "options": [
        "그 가격으로는 안 팔려요",
        "무조건 팔려요"
      ],
      "answer": 0,
      "explanation": "매도 지정가는 지정 가격 이상에서만 체결돼요."
    }
  ]
}
```

## 26. 서킷브레이커

```json
{
  "number": 26,
  "name": "서킷브레이커",
  "english": "Market-wide circuit breaker",
  "category": "G5",
  "core": "시장 전체의 급격한 하락 때 단계별로 거래를 멈추는 제도예요.",
  "example": "비상 상황에서 잠시 멈추거나 운행을 끝내는 안전장치와 비슷해요.",
  "result": "국내 주식시장은 발동 단계에 따라 중단 또는 당일 종료가 달라요.",
  "remember": "언제나 20분만 멈추는 제도는 아니에요.",
  "detail": "일부 프로그램 주문만 제한하는 사이드카와 구분해요. 시장별 지수 하락 요건과 단계, 발동 가능 시간이 정해져 있어요. 세부 수치 암기보다 해당 시장의 거래소 공지와 재개 여부를 확인해요.",
  "news": {
    "headline": "서킷브레이커 발동, 거래 일시 중단",
    "meaning": "어느 시장에서 몇 단계가 발동됐는지 확인해요."
  },
  "home": {
    "prompt": "서킷브레이커는 한 회사 주문만 멈출까요?",
    "options": [
      "한 회사에만 적용돼요",
      "해당 시장 전체에 적용돼요"
    ],
    "answer": 1,
    "takeaway": "시장 전체 급락에 대응하는 제도예요."
  },
  "related": [
    27,
    25
  ],
  "questions": [
    {
      "prompt": "서킷브레이커와 사이드카를 구분할 때 볼 것은?",
      "options": [
        "이름의 길이",
        "중단 대상과 발동 단계"
      ],
      "answer": 1,
      "explanation": "시장 전체 거래 중단인지 프로그램 호가 제한인지 구분해요."
    },
    {
      "prompt": "모든 단계가 똑같이 잠깐 멈추고 재개되나요?",
      "options": [
        "당일 거래 종료 단계도 있어요",
        "모두 같은 시간 뒤 재개돼요"
      ],
      "answer": 0,
      "explanation": "국내 주식시장에는 당일 거래를 끝내는 단계도 있어요."
    },
    {
      "prompt": "발동 소식을 들었을 때 확인할 것은?",
      "options": [
        "주가가 곧 반등한다는 확신",
        "적용 시장·단계·거래소 공지"
      ],
      "answer": 1,
      "explanation": "거래 중단은 반등을 보장하지 않으며 재개 조건을 확인해야 해요."
    }
  ]
}
```

## 27. 사이드카

```json
{
  "number": 27,
  "name": "사이드카",
  "english": "Program trading curb",
  "category": "G5",
  "core": "시장 급변 때 해당 방향의 프로그램 매매호가 효력을 잠시 정지하는 제도예요.",
  "example": "큰 자동 주문 흐름에 잠깐 브레이크를 거는 것과 비슷해요.",
  "result": "주식시장 전체의 거래를 모두 멈추는 것은 아니에요.",
  "remember": "상승 때와 하락 때 모두 적용될 수 있어요.",
  "detail": "선물 등 가격 변동 요건을 충족하면 해당 방향 프로그램 호가를 제한해요. 시장마다 조건이 달라요. 발동 시간·대상·해제 내용은 거래소 공지에서 확인해요.",
  "news": {
    "headline": "매수 사이드카 발동",
    "meaning": "하락 때만 작동하는 제도가 아니라는 점을 기억해요."
  },
  "home": {
    "prompt": "사이드카가 발동하면 모든 주문이 멈출까요?",
    "options": [
      "프로그램 호가가 대상이에요",
      "전부 멈춰요"
    ],
    "answer": 0,
    "takeaway": "서킷브레이커처럼 시장 전체 거래를 멈추는 제도는 아니에요."
  },
  "related": [
    26,
    25
  ],
  "questions": [
    {
      "prompt": "사이드카의 주된 제한 대상은?",
      "options": [
        "해당 방향의 프로그램 매매호가",
        "모든 투자자의 출금"
      ],
      "answer": 0,
      "explanation": "주문 흐름을 안정시키는 제도이며 출금 정지와 달라요."
    },
    {
      "prompt": "주가가 급등할 때도 사이드카가 발동할 수 있나요?",
      "options": [
        "하락 때만 가능해요",
        "그럴 수 있어요"
      ],
      "answer": 1,
      "explanation": "상승 방향의 프로그램 매수 호가를 제한하는 경우도 있어요."
    },
    {
      "prompt": "사이드카가 해제되면 주가 상승이 보장되나요?",
      "options": [
        "아니요",
        "네"
      ],
      "answer": 0,
      "explanation": "호가 제한의 해제일 뿐 이후 가격 방향을 보장하지 않아요."
    }
  ]
}
```

## 28. 예수금과 D+2 출금

```json
{
  "number": 28,
  "name": "예수금과 D+2 출금",
  "english": "Cash balance and T+2 settlement",
  "category": "G5",
  "core": "예수금은 계좌에 맡긴 돈이고, 출금 가능 금액은 결제 상태 등을 반영한 돈이에요.",
  "example": "국내 주식을 월요일에 팔면 휴장일이 없을 때 보통 수요일에 결제돼요.",
  "result": "D+2는 달력 이틀이 아닌 두 거래일 뒤예요.",
  "remember": "화면의 예수금과 지금 출금 가능한 금액을 구분해요.",
  "detail": "국내 주식의 보통거래는 매매일로부터 두 거래일 뒤 결제하는 방식이에요. 재매수·미결제 주문·대출 등에 따라 출금 가능액은 달라져요. 해외 시장이나 다른 상품에도 똑같이 적용하지 않아요.",
  "news": {
    "headline": "주식을 팔았는데 바로 출금이 안 된다",
    "meaning": "매도 결제일과 출금 가능 금액을 확인해요."
  },
  "home": {
    "prompt": "금요일에 팔면 일요일이 D+2일까요?",
    "options": [
      "달력 이틀 뒤예요",
      "휴장일은 세지 않아요"
    ],
    "answer": 1,
    "takeaway": "국내 주식 보통거래에서는 거래일 기준으로 계산해요."
  },
  "related": [
    25,
    29,
    30
  ],
  "questions": [
    {
      "prompt": "휴장일 없이 금요일에 국내 주식을 팔면 보통 결제일은?",
      "options": [
        "일요일",
        "다음 화요일"
      ],
      "answer": 1,
      "explanation": "월요일이 첫 거래일, 화요일이 두 번째 거래일이에요."
    },
    {
      "prompt": "예수금 숫자만큼 지금 모두 출금할 수 있나요?",
      "options": [
        "출금 가능액을 따로 확인",
        "언제나 가능해요"
      ],
      "answer": 0,
      "explanation": "미결제 거래와 대출 등 때문에 금액이 다를 수 있어요."
    },
    {
      "prompt": "해외 주식도 무조건 국내와 같은 D+2인가요?",
      "options": [
        "전부 같아요",
        "시장별 결제를 확인해요"
      ],
      "answer": 1,
      "explanation": "시장과 상품별 결제 주기가 다를 수 있어요."
    }
  ]
}
```

## 29. 신용융자

```json
{
  "number": 29,
  "name": "신용융자",
  "english": "Margin loan",
  "category": "G5",
  "core": "증권사에서 주식 매수 자금을 빌려 투자하는 거래예요.",
  "example": "내 돈 10,000원에 빌린 돈 10,000원을 보태 주식을 사요.",
  "result": "이익과 손실이 내 돈에 비해 더 크게 움직일 수 있어요.",
  "remember": "주가가 내려도 빌린 돈과 이자는 갚아야 해요.",
  "detail": "담보유지비율과 만기, 이자율 등 약정 조건이 붙어요. 가격 하락으로 추가 담보가 필요하거나 반대매매가 생길 수 있어요. 대출을 받을 수 있다는 것이 손실 한도가 정해졌다는 뜻은 아니에요.",
  "news": {
    "headline": "신용융자 잔고 증가",
    "meaning": "빌린 돈으로 산 투자 규모를 보여주며 주가 방향을 확정하지 않아요."
  },
  "home": {
    "prompt": "빌린 돈으로 산 주식이 떨어지면 빚도 줄까요?",
    "options": [
      "빚은 따로 갚아야 해요",
      "같이 줄어요"
    ],
    "answer": 0,
    "takeaway": "투자자산 가치와 대출 상환 의무는 별개예요."
  },
  "related": [
    30,
    19,
    21
  ],
  "questions": [
    {
      "prompt": "내 돈 10,000원과 빚 10,000원으로 산 주식이 15,000원이면 빚 제외 몫은?",
      "options": [
        "5,000원",
        "15,000원"
      ],
      "answer": 0,
      "explanation": "이자·비용을 빼기 전에도 15,000원 − 빚 10,000원만 남아요."
    },
    {
      "prompt": "신용융자 투자에서 추가로 드는 비용은?",
      "options": [
        "보장된 배당 수수료",
        "대출 이자"
      ],
      "answer": 1,
      "explanation": "돈을 빌리므로 약정된 이자를 부담해요."
    },
    {
      "prompt": "담보 가치가 약정 기준 아래로 내려가면?",
      "options": [
        "추가 담보 요구 등이 생길 수 있어요",
        "상환 의무가 없어져요"
      ],
      "answer": 0,
      "explanation": "담보 부족을 해소하지 못하면 반대매매로 이어질 수 있어요."
    }
  ]
}
```

## 30. 반대매매

```json
{
  "number": 30,
  "name": "반대매매",
  "english": "Forced liquidation",
  "category": "G5",
  "core": "미수금이나 담보 부족 등을 해소하려고 증권사가 주식을 강제로 처분하는 일이에요.",
  "example": "빌린 돈의 담보가 부족한데 약정된 기한까지 보충하지 못했어요.",
  "result": "내가 원하는 시점·가격과 다르게 주식이 팔릴 수 있어요.",
  "remember": "발생 조건과 시점은 거래 유형·약정에 따라 달라요.",
  "detail": "신용거래의 담보 부족, 미수금 미납 등 원인이 있어요. 항상 다음 날 같은 시각에 같은 가격으로 파는 것은 아니에요. 처분 후에도 부족한 채무가 남을 수 있어요.",
  "news": {
    "headline": "담보 부족으로 반대매매 발생",
    "meaning": "약정된 담보 조건과 보충 기한을 확인해요."
  },
  "home": {
    "prompt": "반대매매로 팔면 남은 빚은 무조건 없어질까요?",
    "options": [
      "모두 없어져요",
      "부족한 빚이 남을 수 있어요"
    ],
    "answer": 1,
    "takeaway": "처분 대금이 채무보다 적으면 상환 의무가 남을 수 있어요."
  },
  "related": [
    29,
    28,
    25
  ],
  "questions": [
    {
      "prompt": "반대매매를 가장 잘 설명한 것은?",
      "options": [
        "원하는 가격의 예약 매도",
        "조건에 따른 강제 처분"
      ],
      "answer": 1,
      "explanation": "담보 부족 등을 해소하기 위한 처분이라 원하는 조건과 다를 수 있어요."
    },
    {
      "prompt": "반대매매는 항상 다음 날 같은 시각에 이뤄지나요?",
      "options": [
        "약정과 원인에 따라 달라요",
        "언제나 같아요"
      ],
      "answer": 0,
      "explanation": "거래 유형, 부족 사유, 증권사 약정 등을 확인해야 해요."
    },
    {
      "prompt": "주식 처분액 8,000원, 갚을 돈 10,000원이면 비용 전 부족액은?",
      "options": [
        "0원",
        "2,000원"
      ],
      "answer": 1,
      "explanation": "처분해도 10,000원 − 8,000원 = 2,000원이 부족해요."
    }
  ]
}
```

## 31. 기준금리

```json
{
  "number": 31,
  "name": "기준금리",
  "english": "Policy interest rate",
  "category": "G6",
  "core": "중앙은행이 통화정책에 사용하는 기준이 되는 금리예요.",
  "example": "물가와 경기를 보며 경제의 돈 조달 여건을 조절하는 손잡이와 비슷해요.",
  "result": "예금·대출 등 시장금리에 영향을 줘요.",
  "remember": "기준금리가 바뀌어도 모든 금리가 같은 폭으로 움직이지는 않아요.",
  "detail": "한국은행은 물가와 금융안정 등 경제 상황을 종합해 결정해요. 은행 금리는 조달 비용과 신용위험 등에도 영향을 받아요. 금리 변화만으로 주가가 오르거나 내린다고 단정하지 않아요.",
  "news": {
    "headline": "기준금리 동결, 대출금리는 변동",
    "meaning": "시장금리와 은행의 조달 여건 등이 별도로 작용할 수 있어요."
  },
  "home": {
    "prompt": "기준금리가 내리면 내 대출금리도 바로 똑같이 내릴까요?",
    "options": [
      "계약과 시장 여건에 따라 달라요",
      "반드시 똑같이 내려요"
    ],
    "answer": 0,
    "takeaway": "고정·변동 계약과 시장금리 반영 시점 등을 봐야 해요."
  },
  "related": [
    35,
    36,
    37,
    40
  ],
  "questions": [
    {
      "prompt": "기준금리를 결정하는 주체는?",
      "options": [
        "중앙은행",
        "개별 주식 투자자"
      ],
      "answer": 0,
      "explanation": "기준금리는 중앙은행의 통화정책 수단이에요."
    },
    {
      "prompt": "기준금리 인상만으로 주가 하락을 확신할 수 있나요?",
      "options": [
        "확신할 수 있어요",
        "다른 요인도 봐야 해요"
      ],
      "answer": 1,
      "explanation": "기업 실적과 시장 기대 등 여러 요인이 함께 작용해요."
    },
    {
      "prompt": "기준금리가 그대로인데 은행 대출금리가 달라질 수 있나요?",
      "options": [
        "그럴 수 있어요",
        "불가능해요"
      ],
      "answer": 0,
      "explanation": "은행 조달 비용과 신용위험 등도 대출금리에 영향을 줘요."
    }
  ]
}
```

## 32. 인플레이션

```json
{
  "number": 32,
  "name": "인플레이션",
  "english": "Inflation",
  "category": "G6",
  "core": "여러 상품과 서비스의 전반적인 가격 수준이 지속해서 오르는 현상이에요.",
  "example": "같은 장바구니가 10,000원에서 11,000원이 되면 같은 돈으로 덜 사요.",
  "result": "돈의 구매력이 줄어드는 방향이에요.",
  "remember": "물건 하나의 일시적인 가격 상승만으로 판단하지 않아요.",
  "detail": "수요 증가나 원재료·운송비 상승 등 원인은 다양해요. 소득이 같은 속도로 늘지 않으면 실질 구매력이 줄 수 있어요. CPI 같은 지표의 변화와 기간을 함께 살펴봐요.",
  "news": {
    "headline": "물가 상승률 둔화",
    "meaning": "가격이 떨어졌다는 뜻이 아니라 오르는 속도가 느려졌을 수 있어요."
  },
  "home": {
    "prompt": "물가 상승률이 낮아지면 가격도 떨어진 걸까요?",
    "options": [
      "꼭 가격이 떨어져요",
      "오르는 속도가 줄었을 수 있어요"
    ],
    "answer": 1,
    "takeaway": "상승률이 여전히 양수라면 물가 수준은 오르고 있어요."
  },
  "related": [
    39,
    33,
    34,
    31
  ],
  "questions": [
    {
      "prompt": "같은 장바구니가 10,000원에서 11,000원이면 상승률은?",
      "options": [
        "1%",
        "10%"
      ],
      "answer": 1,
      "explanation": "늘어난 1,000원을 원래 10,000원으로 나누면 10%예요."
    },
    {
      "prompt": "딸기 한 품목만 비싸졌다면 인플레이션이 확정되나요?",
      "options": [
        "전반적 물가도 봐야 해요",
        "바로 확정돼요"
      ],
      "answer": 0,
      "explanation": "개별 상품의 변화와 전반적·지속적 물가 상승은 달라요."
    },
    {
      "prompt": "소득은 그대로인데 전반적 물가가 오르면 구매력은?",
      "options": [
        "높아져요",
        "낮아져요"
      ],
      "answer": 1,
      "explanation": "같은 돈으로 살 수 있는 물건과 서비스가 줄어요."
    }
  ]
}
```

## 33. 디플레이션

```json
{
  "number": 33,
  "name": "디플레이션",
  "english": "Deflation",
  "category": "G6",
  "core": "여러 상품과 서비스의 전반적인 가격 수준이 지속해서 내려가는 현상이에요.",
  "example": "물건 가격이 계속 내릴 것으로 생각하면 구매를 미루는 사람이 늘 수 있어요.",
  "result": "소비와 투자 위축으로 이어질 수 있어요.",
  "remember": "할인 행사 하나나 물가 상승률 둔화와 구분해요.",
  "detail": "원인에 따라 경제 영향은 다르지만 수요 위축이 동반되면 매출·고용이 줄고 빚의 실질 부담이 커질 수 있어요. 물가가 느리게 오르는 디스인플레이션과는 달라요.",
  "news": {
    "headline": "물가 상승률은 낮아졌지만 여전히 양수",
    "meaning": "가격 수준이 지속해서 하락하는 디플레이션과는 구분해요."
  },
  "home": {
    "prompt": "마트 일주일 할인은 바로 디플레이션일까요?",
    "options": [
      "전반적·지속적 하락을 봐요",
      "할인이면 모두 그래요"
    ],
    "answer": 0,
    "takeaway": "특정 기간·상품의 할인만으로 판단하지 않아요."
  },
  "related": [
    32,
    34,
    31
  ],
  "questions": [
    {
      "prompt": "디플레이션에 가까운 상황은?",
      "options": [
        "전반적인 물가가 지속 하락",
        "물가가 전보다 천천히 상승"
      ],
      "answer": 0,
      "explanation": "하락 자체와 상승 속도의 둔화는 달라요."
    },
    {
      "prompt": "물가 상승률이 5%에서 2%가 되면 물가 수준은?",
      "options": [
        "3% 떨어졌어요",
        "아직 오르고 있어요"
      ],
      "answer": 1,
      "explanation": "상승률 2%는 여전히 가격 수준이 올랐다는 뜻이에요."
    },
    {
      "prompt": "가격 하락 예상으로 구매를 미루면 기업 매출은?",
      "options": [
        "줄어들 수 있어요",
        "반드시 늘어요"
      ],
      "answer": 0,
      "explanation": "소비가 미뤄지면 기업의 판매가 위축될 수 있어요."
    }
  ]
}
```

## 34. 스태그플레이션

```json
{
  "number": 34,
  "name": "스태그플레이션",
  "english": "Stagflation",
  "category": "G6",
  "core": "경기가 부진한데 물가는 오르는 상황이에요.",
  "example": "가게 손님은 줄었는데 재료비는 올라 어려워진 상황을 떠올려봐요.",
  "result": "경기와 물가를 동시에 다루기 어려워져요.",
  "remember": "개인 월급 하나보다 경제 전반의 흐름을 봐요.",
  "detail": "공급 충격 등으로 생산이 둔화하면서 비용이 오를 때 나타날 수 있어요. 경기 부양은 물가를, 물가 억제는 경기를 부담스럽게 할 수 있어 정책 판단이 어려워져요.",
  "news": {
    "headline": "성장 둔화와 높은 물가가 겹쳤다",
    "meaning": "경기 지표와 물가 지표를 함께 확인해요."
  },
  "home": {
    "prompt": "경기가 나쁘면 물가는 무조건 내릴까요?",
    "options": [
      "반드시 내려요",
      "동시에 오를 수도 있어요"
    ],
    "answer": 1,
    "takeaway": "공급 비용 상승 등으로 경기 부진과 물가 상승이 겹칠 수 있어요."
  },
  "related": [
    32,
    33,
    31,
    46
  ],
  "questions": [
    {
      "prompt": "스태그플레이션에 해당하는 조합은?",
      "options": [
        "경기 호황 + 물가 하락",
        "경기 부진 + 물가 상승"
      ],
      "answer": 1,
      "explanation": "스태그플레이션은 침체·부진과 인플레이션의 결합이에요."
    },
    {
      "prompt": "판단할 때 함께 볼 지표는?",
      "options": [
        "경기와 물가",
        "내 월급 하나만"
      ],
      "answer": 0,
      "explanation": "경제 전반의 생산·고용·물가 등을 함께 살펴봐요."
    },
    {
      "prompt": "이 상황에서 정책이 어려운 이유는?",
      "options": [
        "어떤 정책이든 둘 다 즉시 해결",
        "경기와 물가 대응이 충돌할 수 있음"
      ],
      "answer": 1,
      "explanation": "부양과 긴축의 효과가 서로 다른 목표에 부담을 줄 수 있어요."
    }
  ]
}
```

## 35. FOMC

```json
{
  "number": 35,
  "name": "FOMC",
  "english": "Federal Open Market Committee",
  "category": "G6",
  "core": "미국 연방준비제도에서 통화정책을 결정하는 위원회예요.",
  "example": "미국의 정책금리 방향과 자산 매입·축소 등을 논의하는 회의예요.",
  "result": "미국 정책이 세계 금융시장에도 영향을 줄 수 있어요.",
  "remember": "한국 기준금리를 직접 결정하는 곳은 아니에요.",
  "detail": "발표된 결정뿐 아니라 경제 평가와 앞으로의 정책 설명도 시장이 살펴봐요. 결과가 예상과 얼마나 다른지가 반응에 영향을 줄 수 있어요. 발표 하나만으로 주가 방향을 확정하지 않아요.",
  "news": {
    "headline": "FOMC 금리 동결, 향후 전망은 변화",
    "meaning": "당장의 금리 결정과 앞으로의 정책 설명을 나눠 읽어요."
  },
  "home": {
    "prompt": "FOMC가 한국 기준금리도 정할까요?",
    "options": [
      "한국은행이 따로 결정해요",
      "FOMC가 직접 정해요"
    ],
    "answer": 0,
    "takeaway": "미국 통화정책의 영향과 한국의 정책 결정은 구분해요."
  },
  "related": [
    31,
    36,
    37,
    38
  ],
  "questions": [
    {
      "prompt": "FOMC의 주요 역할은?",
      "options": [
        "미국 통화정책 결정",
        "한국 기업 배당금 결정"
      ],
      "answer": 0,
      "explanation": "미국 연방준비제도 내 통화정책 위원회예요."
    },
    {
      "prompt": "금리 동결 발표 뒤에도 시장 가격이 변할 수 있나요?",
      "options": [
        "동결이면 가격도 고정돼요",
        "전망과 설명 때문에 가능해요"
      ],
      "answer": 1,
      "explanation": "앞으로의 정책 경로에 대한 기대가 바뀔 수 있어요."
    },
    {
      "prompt": "FOMC 발표를 읽을 때 함께 볼 것은?",
      "options": [
        "결정과 경제 평가·전망",
        "위원회 이름만"
      ],
      "answer": 0,
      "explanation": "정책 판단의 배경과 앞으로의 설명도 의미가 있어요."
    }
  ]
}
```

## 36. 양적완화 · QE

```json
{
  "number": 36,
  "name": "양적완화 · QE",
  "english": "Quantitative easing",
  "category": "G6",
  "core": "중앙은행이 채권 등을 대규모로 사들여 금융 여건을 완화하는 정책이에요.",
  "example": "중앙은행이 금융시장에서 채권을 사며 자금을 공급하는 모습을 떠올려요.",
  "result": "금리와 자금 조달 여건에 영향을 줘요.",
  "remember": "모든 사람에게 현금을 직접 나눠주는 정책과 달라요.",
  "detail": "정책금리 인하만으로 대응하기 어려울 때 사용하는 비전통적 수단 중 하나예요. 장기금리와 자산 가격 등 여러 경로로 작용해요. 효과의 크기와 주가 반응은 경제 상황과 기대에 따라 달라요.",
  "news": {
    "headline": "중앙은행 자산 매입 확대",
    "meaning": "어떤 자산을 얼마나 사는지와 정책 목적을 확인해요."
  },
  "home": {
    "prompt": "양적완화는 국민 통장에 돈을 똑같이 넣어주는 걸까요?",
    "options": [
      "같은 뜻이에요",
      "자산 매입을 통한 정책이에요"
    ],
    "answer": 1,
    "takeaway": "금융시장을 통한 자산 매입과 직접 현금 지급은 달라요."
  },
  "related": [
    37,
    31,
    35,
    47
  ],
  "questions": [
    {
      "prompt": "양적완화의 대표적 방식은?",
      "options": [
        "기업의 배당 중단",
        "중앙은행의 대규모 채권 매입"
      ],
      "answer": 1,
      "explanation": "자산을 사들이며 금융 여건을 완화하려는 정책이에요."
    },
    {
      "prompt": "양적완화를 시작하면 모든 주식이 반드시 오르나요?",
      "options": [
        "보장되지 않아요",
        "반드시 올라요"
      ],
      "answer": 0,
      "explanation": "정책 효과와 기업·경기 상황은 다양하게 작용해요."
    },
    {
      "prompt": "양적완화를 읽을 때 확인할 정보는?",
      "options": [
        "돈을 받는 개인 명단",
        "매입 자산·규모·목적"
      ],
      "answer": 1,
      "explanation": "정책의 매입 대상과 규모가 작동 방식을 이해하는 데 중요해요."
    }
  ]
}
```

## 37. 양적긴축 · QT

```json
{
  "number": 37,
  "name": "양적긴축 · QT",
  "english": "Quantitative tightening",
  "category": "G6",
  "core": "중앙은행이 보유 자산을 줄여 완화했던 금융 여건을 되돌리는 정책이에요.",
  "example": "만기 채권에서 돌려받은 돈으로 새 채권을 다시 사지 않을 수 있어요.",
  "result": "채권을 직접 팔지 않아도 보유 자산이 줄 수 있어요.",
  "remember": "금리 인상과 자산 축소는 다른 정책 수단이에요.",
  "detail": "만기 원금의 재투자를 줄이거나 보유 자산을 매각하는 방식이 있어요. 축소 속도와 구성, 시장의 자금 수요에 따라 영향이 달라요. QT의 시행 여부와 세부 계획은 시점별 발표를 확인해요.",
  "news": {
    "headline": "QT 속도 조절 발표",
    "meaning": "축소 속도를 늦추는 것과 자산 매입을 늘리는 것은 구분해요."
  },
  "home": {
    "prompt": "QT는 채권을 시장에 팔아야만 가능할까요?",
    "options": [
      "만기 재투자를 줄일 수도 있어요",
      "매각만 가능해요"
    ],
    "answer": 0,
    "takeaway": "만기 상환 뒤 재투자하지 않아도 보유 규모가 줄어요."
  },
  "related": [
    36,
    35,
    31,
    47
  ],
  "questions": [
    {
      "prompt": "양적긴축에 해당하는 것은?",
      "options": [
        "만기 채권 원금 재투자 축소",
        "보유 채권 대규모 순매입"
      ],
      "answer": 0,
      "explanation": "상환받은 돈을 다시 투자하지 않으면 자산이 줄어들어요."
    },
    {
      "prompt": "QT 속도를 늦추면 바로 QE와 같은 뜻인가요?",
      "options": [
        "항상 같은 뜻이에요",
        "자산 증감 방향도 봐야 해요"
      ],
      "answer": 1,
      "explanation": "줄이는 속도가 느려져도 자산은 계속 줄어들 수 있어요."
    },
    {
      "prompt": "정책금리 동결 중에도 자산 축소가 가능할까요?",
      "options": [
        "두 수단은 별개라 가능해요",
        "불가능해요"
      ],
      "answer": 0,
      "explanation": "금리 수준 조절과 보유 자산 조절은 구분되는 수단이에요."
    }
  ]
}
```

## 38. 원·달러 환율

```json
{
  "number": 38,
  "name": "원·달러 환율",
  "english": "KRW per USD",
  "category": "G6",
  "core": "1달러를 사는 데 필요한 원화 금액이에요.",
  "example": "1달러가 1,000원에서 1,100원이 됐어요.",
  "result": "달러는 비싸지고 원화 가치는 달러에 비해 낮아졌어요.",
  "remember": "어느 통화를 기준으로 표시한 환율인지 먼저 봐요.",
  "detail": "수출·수입 가격과 외화 자산 평가에 영향을 줘요. 달러 매출이 있어도 수입 원가나 외화 부채가 크면 효과가 달라져요. 환율 상승만으로 모든 수출기업의 이익이나 외국인 매매를 단정하지 않아요.",
  "news": {
    "headline": "원·달러 환율 상승",
    "meaning": "달러당 원화 표시에서는 원화 약세를 뜻해요."
  },
  "home": {
    "prompt": "달러당 원화 숫자가 커지면 원화가 강해질까요?",
    "options": [
      "강해져요",
      "달러에 비해 약해져요"
    ],
    "answer": 1,
    "takeaway": "같은 1달러를 사는 데 원화가 더 많이 필요해요."
  },
  "related": [
    31,
    35,
    50
  ],
  "questions": [
    {
      "prompt": "1달러 1,000원에서 1,200원으로 오르면 10달러의 원화 금액은?",
      "options": [
        "10,000원에서 8,000원",
        "10,000원에서 12,000원"
      ],
      "answer": 1,
      "explanation": "10달러에 각각의 환율을 곱해요."
    },
    {
      "prompt": "원·달러 환율 상승이 모든 수출기업에 이익인가요?",
      "options": [
        "원가·부채 등에 따라 달라요",
        "항상 이익이에요"
      ],
      "answer": 0,
      "explanation": "달러로 지출하는 비용과 빚도 함께 봐야 해요."
    },
    {
      "prompt": "달러당 원화 환율이 내려가면 같은 원화로 살 수 있는 달러는?",
      "options": [
        "줄어들어요",
        "늘어나요"
      ],
      "answer": 1,
      "explanation": "달러 한 단위가 더 싸져 같은 원화로 더 많이 살 수 있어요."
    }
  ]
}
```

## 39. 소비자물가지수 · CPI

```json
{
  "number": 39,
  "name": "소비자물가지수 · CPI",
  "english": "Consumer Price Index",
  "category": "G6",
  "core": "가계가 소비하는 상품·서비스 묶음의 가격 변화를 보여주는 지수예요.",
  "example": "같은 기준의 지수가 100에서 105가 됐어요.",
  "result": "비교 기간 대비 가격 수준이 5% 오른 셈이에요.",
  "remember": "지수 수준과 상승률, 전월비와 전년비를 구분해요.",
  "detail": "품목마다 가계 소비에서 차지하는 비중이 달라 가중치를 적용해요. 내 소비 습관과는 다를 수 있어 체감물가와 차이가 나요. 중앙은행은 CPI 외에도 다양한 정보를 함께 봐요.",
  "news": {
    "headline": "CPI 상승률 예상보다 높아",
    "meaning": "어느 나라·비교 기간·지표 범위인지 확인해요."
  },
  "home": {
    "prompt": "CPI 105면 물가가 이번 달 105% 오른 걸까요?",
    "options": [
      "지수와 상승률은 달라요",
      "맞아요"
    ],
    "answer": 0,
    "takeaway": "기준 시점의 지수와 비교해야 상승률을 구할 수 있어요."
  },
  "related": [
    32,
    33,
    31
  ],
  "questions": [
    {
      "prompt": "비교 지수 100, 이번 지수 102라면 상승률은?",
      "options": [
        "2%",
        "102%"
      ],
      "answer": 0,
      "explanation": "102 ÷ 100 − 1 = 0.02, 즉 2%예요."
    },
    {
      "prompt": "CPI와 내가 느끼는 물가가 다를 수 있나요?",
      "options": [
        "절대 같아야 해요",
        "소비 구성이 달라 가능해요"
      ],
      "answer": 1,
      "explanation": "개인별 구매 품목과 비중이 전체 지수의 바구니와 달라요."
    },
    {
      "prompt": "전월비 1%와 전년비 1%는 같은 기간 비교인가요?",
      "options": [
        "비교 기간이 달라요",
        "같은 비교예요"
      ],
      "answer": 0,
      "explanation": "전월비는 직전 달, 전년비는 1년 전 같은 달과 비교해요."
    }
  ],
  "formula": "물가 상승률 = (이번 지수 ÷ 비교 지수 − 1) × 100"
}
```

## 40. 채권

```json
{
  "number": 40,
  "name": "채권",
  "english": "Bond",
  "category": "G4",
  "core": "돈을 빌린 쪽이 이자와 원금 지급 조건을 약속한 증권이에요.",
  "example": "액면 10,000원, 연 5% 이자를 약속한 채권을 생각해봐요.",
  "result": "약정대로 지급된다면 연 이자는 500원이에요.",
  "remember": "약속이 있다는 것과 원금이 안전하다는 것은 달라요.",
  "detail": "발행사의 지급 불능 위험과 금리 변동에 따른 가격 위험 등이 있어요. 다른 조건이 같으면 시장금리 상승 때 기존 고정금리 채권 가격은 대체로 내려가요. 표면금리와 내가 산 가격 기준 수익률을 구분해요.",
  "news": {
    "headline": "시장금리 상승에 기존 채권 가격 하락",
    "meaning": "새 채권보다 낮은 고정 이자의 매력이 줄어드는 관계를 떠올려요."
  },
  "home": {
    "prompt": "채권이면 중간에 팔 때도 산 가격을 보장받을까요?",
    "options": [
      "언제나 보장돼요",
      "시장가격이 변할 수 있어요"
    ],
    "answer": 1,
    "takeaway": "만기 전 매도 가격은 금리와 신용 상황에 따라 달라져요."
  },
  "related": [
    22,
    23,
    31,
    19
  ],
  "questions": [
    {
      "prompt": "액면 20,000원, 연 표면금리 5%라면 약정 연 이자는?",
      "options": [
        "5,000원",
        "1,000원"
      ],
      "answer": 1,
      "explanation": "20,000원 × 5% = 1,000원이에요."
    },
    {
      "prompt": "다른 조건이 같고 시장금리가 오르면 기존 고정금리 채권 가격은 보통?",
      "options": [
        "내려가요",
        "올라가요"
      ],
      "answer": 0,
      "explanation": "상대적으로 낮아진 이자 조건을 가격이 반영해요."
    },
    {
      "prompt": "발행사가 원금을 갚지 못할 위험은?",
      "options": [
        "배당락",
        "신용위험"
      ],
      "answer": 1,
      "explanation": "채권도 발행사의 지급 능력을 확인해야 해요."
    }
  ]
}
```

## 41. 어닝 서프라이즈

```json
{
  "number": 41,
  "name": "어닝 서프라이즈",
  "english": "Earnings surprise",
  "category": "G7",
  "core": "발표된 기업 실적이 시장의 예상보다 좋은 경우를 말해요.",
  "example": "예상 영업이익이 2,000원이었는데 실제로 3,000원이 나왔어요.",
  "result": "작년보다가 아니라 예상보다 좋았다는 뜻이에요.",
  "remember": "좋은 실적 발표가 당일 주가 상승을 보장하지는 않아요.",
  "detail": "어떤 지표의 어떤 예상치와 비교했는지 확인해요. 작년 대비 줄어든 이익도 예상보다 좋으면 서프라이즈일 수 있어요. 일회성 요인과 다음 기간 전망도 시장 반응에 영향을 줘요.",
  "news": {
    "headline": "이익은 감소했지만 어닝 서프라이즈",
    "meaning": "시장 예상치가 더 낮았다면 두 표현이 동시에 성립해요."
  },
  "home": {
    "prompt": "작년보다 이익이 줄어도 어닝 서프라이즈일 수 있을까요?",
    "options": [
      "예상보다 좋으면 가능해요",
      "절대 안 돼요"
    ],
    "answer": 0,
    "takeaway": "비교 대상은 작년 실적이 아니라 시장 예상이에요."
  },
  "related": [
    42,
    3,
    4,
    48
  ],
  "questions": [
    {
      "prompt": "예상 이익 1,000원, 실제 2,000원이면?",
      "options": [
        "예상보다 좋은 실적",
        "예상보다 나쁜 실적"
      ],
      "answer": 0,
      "explanation": "실제 이익이 시장 예상보다 높아요."
    },
    {
      "prompt": "어닝 서프라이즈가 나면 주가는 반드시 오르나요?",
      "options": [
        "반드시 올라요",
        "보장되지 않아요"
      ],
      "answer": 1,
      "explanation": "이미 반영된 기대와 향후 전망 등도 영향을 줘요."
    },
    {
      "prompt": "작년 5,000원, 예상 2,000원, 실제 3,000원이면?",
      "options": [
        "전년 감소지만 예상은 상회",
        "예상보다 나쁜 실적"
      ],
      "answer": 0,
      "explanation": "작년보다 줄었지만 예상 2,000원보다는 좋아요."
    }
  ]
}
```

## 42. 어닝 쇼크

```json
{
  "number": 42,
  "name": "어닝 쇼크",
  "english": "Earnings disappointment",
  "category": "G7",
  "core": "발표된 기업 실적이 시장 예상보다 크게 나쁜 경우를 말해요.",
  "example": "예상 이익 5,000원에 실제 이익은 2,000원이었어요.",
  "result": "이익이 나도 기대에 못 미치면 쇼크라고 표현할 수 있어요.",
  "remember": "적자나 전년 대비 감소와 같은 뜻은 아니에요.",
  "detail": "비교할 예상치의 시점과 실적 항목을 맞춰봐요. 전년보다 성장했어도 예상에 크게 못 미칠 수 있어요. 발표 뒤 주가는 이미 반영된 기대와 전망에 따라 다르게 움직여요.",
  "news": {
    "headline": "흑자였지만 어닝 쇼크",
    "meaning": "이익의 부호와 예상 대비 성과는 별개의 기준이에요."
  },
  "home": {
    "prompt": "흑자 기업에도 어닝 쇼크라는 말을 쓸까요?",
    "options": [
      "적자일 때만 써요",
      "예상보다 크게 낮으면 써요"
    ],
    "answer": 1,
    "takeaway": "흑자여도 시장 기대에 못 미칠 수 있어요."
  },
  "related": [
    41,
    3,
    4,
    48
  ],
  "questions": [
    {
      "prompt": "예상 10,000원, 실제 3,000원이면?",
      "options": [
        "예상을 웃돈 실적",
        "예상을 크게 밑돈 실적"
      ],
      "answer": 1,
      "explanation": "실제 이익이 예상보다 크게 낮아요."
    },
    {
      "prompt": "어닝 쇼크와 같은 뜻은?",
      "options": [
        "시장 예상보다 크게 부진",
        "무조건 적자"
      ],
      "answer": 0,
      "explanation": "기대 대비 평가이므로 적자인지가 기준은 아니에요."
    },
    {
      "prompt": "작년 1,000원, 예상 5,000원, 실제 2,000원이면?",
      "options": [
        "성장했으니 예상도 상회",
        "성장했지만 기대에는 미달"
      ],
      "answer": 1,
      "explanation": "전년 대비 성장과 예상 대비 부진이 동시에 가능해요."
    }
  ]
}
```

## 43. 블록딜

```json
{
  "number": 43,
  "name": "블록딜",
  "english": "Block trade",
  "category": "G5",
  "core": "많은 주식을 매도자와 매수자가 조건을 협의해 한꺼번에 거래하는 방식이에요.",
  "example": "대량 주문을 시장에 조금씩 내는 대신 상대방과 수량·가격을 협의해요.",
  "result": "보유 주체가 크게 바뀔 수 있어요.",
  "remember": "대량 거래를 묶어도 시장가격에 영향이 없다는 뜻은 아니에요.",
  "detail": "시간외 대량매매 등의 방식으로 이뤄질 수 있어요. 할인율, 매도 이유, 매수 주체, 보호예수 등을 함께 봐요. 소유 주식의 매매와 회사가 새 주식을 발행하는 유상증자는 구분해요.",
  "news": {
    "headline": "대주주 지분 블록딜 추진",
    "meaning": "회사로 새 돈이 들어오는지, 기존 지분이 바뀌는지 구분해요."
  },
  "home": {
    "prompt": "블록딜이면 주가에 아무 영향이 없을까요?",
    "options": [
      "영향이 있을 수 있어요",
      "영향이 전혀 없어요"
    ],
    "answer": 0,
    "takeaway": "거래 가격과 매도 이유가 시장의 기대에 영향을 줄 수 있어요."
  },
  "related": [
    25,
    1,
    44
  ],
  "questions": [
    {
      "prompt": "블록딜의 핵심 특징은?",
      "options": [
        "대량 주식의 협의 거래",
        "개인별 소액 적립"
      ],
      "answer": 0,
      "explanation": "대량 수량과 가격 등을 협의해 거래하는 방식이에요."
    },
    {
      "prompt": "기존 대주주가 자기 주식을 팔면 대금은 보통 누구에게 가나요?",
      "options": [
        "자동으로 회사에 입금",
        "주식을 판 대주주"
      ],
      "answer": 1,
      "explanation": "기존 주식 매매 대금은 매도자에게 가며 신주 발행과 달라요."
    },
    {
      "prompt": "블록딜 뉴스에서 함께 확인할 것은?",
      "options": [
        "가격·매도 이유·거래 상대",
        "거래량 숫자 하나만"
      ],
      "answer": 0,
      "explanation": "조건과 참여 주체에 따라 의미가 달라져요."
    }
  ]
}
```

## 44. IPO · 기업공개

```json
{
  "number": 44,
  "name": "IPO · 기업공개",
  "english": "Initial public offering",
  "category": "G5",
  "core": "기업이 처음으로 일반 투자자에게 주식을 공개 모집하는 일이에요.",
  "example": "그동안 제한된 주주가 가진 회사가 공모를 통해 새 투자자를 맞이해요.",
  "result": "공모 가격과 이후 시장가격은 다를 수 있어요.",
  "remember": "IPO와 거래소 상장은 밀접하지만 같은 절차는 아니에요.",
  "detail": "신주 발행이면 회사로 돈이 들어오고 구주 매출이면 기존 주주에게 대금이 가요. 공모가 산정 근거와 증권신고서, 상장 일정 등을 확인해요. 상장 첫날이나 이후 수익은 보장되지 않아요.",
  "news": {
    "headline": "IPO 공모가 확정",
    "meaning": "공모가와 비교 기업, 자금 사용 계획 등을 함께 살펴봐요."
  },
  "home": {
    "prompt": "공모가로 사면 상장 뒤 수익이 보장될까요?",
    "options": [
      "언제나 보장돼요",
      "시장가격은 달라질 수 있어요"
    ],
    "answer": 1,
    "takeaway": "공모 가격보다 낮게 거래될 수도 있어요."
  },
  "related": [
    24,
    43,
    1
  ],
  "questions": [
    {
      "prompt": "IPO의 핵심은?",
      "options": [
        "기존 주식의 매일 거래",
        "처음으로 일반 투자자에게 주식 공모"
      ],
      "answer": 1,
      "explanation": "이미 상장된 주식의 일상적 매매와 구분해요."
    },
    {
      "prompt": "IPO에 구주 매출이 포함되면 해당 대금은?",
      "options": [
        "기존 주식 매도자에게",
        "모두 회사의 새 자금으로"
      ],
      "answer": 0,
      "explanation": "구주 매출은 기존 주주의 주식을 파는 것이에요."
    },
    {
      "prompt": "IPO를 이해하려면 확인할 자료는?",
      "options": [
        "상장 첫날 상승 소문만",
        "증권신고서와 공모 조건"
      ],
      "answer": 1,
      "explanation": "공모 가격의 근거와 위험 요인, 자금 사용 계획을 확인해요."
    }
  ]
}
```

## 45. 서머 랠리와 산타 랠리

```json
{
  "number": 45,
  "name": "서머 랠리와 산타 랠리",
  "english": "Summer and Santa Claus rally",
  "category": "G7",
  "core": "여름이나 연말의 주가 상승 흐름을 가리키는 시장 표현이에요.",
  "example": "특정 계절의 상승을 설명할 때 붙이는 별명처럼 생각해요.",
  "result": "계절이 돌아온다고 상승이 예약되지는 않아요.",
  "remember": "기간의 정의와 실제 관측 결과는 자료마다 다를 수 있어요.",
  "detail": "정식 정책이나 확정적인 투자 법칙이 아니에요. 시장과 분석 기간에 따라 나타나지 않을 수 있어요. 이름보다 그 시점의 실적·금리·수급 등 실제 요인을 확인해요.",
  "news": {
    "headline": "산타 랠리 기대감",
    "meaning": "기대에 관한 표현이지 미래 상승을 확인한 사실은 아니에요."
  },
  "home": {
    "prompt": "연말이 되면 주가가 꼭 오를까요?",
    "options": [
      "계절만으로는 몰라요",
      "항상 올라요"
    ],
    "answer": 0,
    "takeaway": "산타 랠리는 상승을 묘사하는 표현이며 보장이 아니에요."
  },
  "related": [
    49,
    47,
    48
  ],
  "questions": [
    {
      "prompt": "서머 랠리가 뜻하는 것은?",
      "options": [
        "여름철 상승 흐름을 가리키는 표현",
        "여름마다 보장되는 수익"
      ],
      "answer": 0,
      "explanation": "시장 현상을 묘사하는 말이지 수익 약속이 아니에요."
    },
    {
      "prompt": "산타 랠리 기대 기사만으로 매수 시점을 확정할까요?",
      "options": [
        "계절이므로 확정",
        "실제 시장 요인도 확인"
      ],
      "answer": 1,
      "explanation": "실적과 금리 등 여러 요인이 가격에 영향을 줘요."
    },
    {
      "prompt": "작년에 계절 랠리가 있었다면 올해도 재현되나요?",
      "options": [
        "그렇지 않을 수 있어요",
        "반드시 재현돼요"
      ],
      "answer": 0,
      "explanation": "과거에 관측된 흐름이 매년 반복된다는 보장은 없어요."
    }
  ]
}
```

## 46. 경기동행지수와 선행지수

```json
{
  "number": 46,
  "name": "경기동행지수와 선행지수",
  "english": "Coincident and leading indicators",
  "category": "G6",
  "core": "동행지수는 현재 경기 흐름을, 선행지수는 앞으로의 흐름에 앞서는 신호를 묶어 봐요.",
  "example": "지금 상태를 보는 계기판과 앞길의 변화를 살피는 신호에 비유할 수 있어요.",
  "result": "둘은 살펴보려는 시점이 달라요.",
  "remember": "선행지수는 미래를 확정하는 예언이 아니에요.",
  "detail": "여러 생산·소비·금융 지표 등을 결합한 경기종합지수예요. 순환변동치와 증가율을 구분하고 한 달보다 추세를 살펴봐요. 통계가 나중에 수정될 수 있어 다른 지표와 함께 해석해요.",
  "news": {
    "headline": "선행지수 개선, 동행지수는 약세",
    "meaning": "미래 방향의 신호와 현재 경기 상태가 다르게 나타날 수 있어요."
  },
  "home": {
    "prompt": "선행지수가 오르면 경기 회복이 확정일까요?",
    "options": [
      "확정이에요",
      "다른 지표와 추세도 봐요"
    ],
    "answer": 1,
    "takeaway": "앞선 신호를 모은 지표이지 확정 예측은 아니에요."
  },
  "related": [
    34,
    32,
    48
  ],
  "questions": [
    {
      "prompt": "현재 경기 흐름을 파악하려는 지수는?",
      "options": [
        "선행지수",
        "동행지수"
      ],
      "answer": 1,
      "explanation": "동행은 현재와 함께, 선행은 변화보다 앞서는 신호를 봐요."
    },
    {
      "prompt": "선행지수가 한 달 올랐다는 이유만으로 미래를 단정할까요?",
      "options": [
        "추세와 다른 지표도 확인",
        "그 한 달로 확정"
      ],
      "answer": 0,
      "explanation": "일시 변동이나 통계 수정 가능성이 있어 함께 살펴봐요."
    },
    {
      "prompt": "동행지수와 선행지수가 다르게 움직일 수 있나요?",
      "options": [
        "항상 같은 방향이어야 함",
        "살펴보는 시점이 달라 가능"
      ],
      "answer": 1,
      "explanation": "현재 경기와 앞으로의 변화 신호는 일치하지 않을 수 있어요."
    }
  ]
}
```

## 47. 유동성 장세

```json
{
  "number": 47,
  "name": "유동성 장세",
  "english": "Liquidity-driven market",
  "category": "G7",
  "core": "풍부한 자금과 완화적인 금융 여건이 상승을 이끈다고 해석하는 시장 표현이에요.",
  "example": "기업 이익의 큰 변화보다 자금 유입이 가격 상승 이유로 거론돼요.",
  "result": "시장을 설명하는 관점 중 하나예요.",
  "remember": "공식 판정 지표나 모든 종목의 상승 보장은 아니에요.",
  "detail": "금리·자금 조달 여건·투자 수요가 배경으로 언급돼요. 실적 요인과 동시에 작용할 수 있고 딱 잘라 구분하기 어려워요. 돈이 많다는 설명만으로 적정 가격을 알 수는 없어요.",
  "news": {
    "headline": "풍부한 자금이 증시 상승 견인",
    "meaning": "자금 흐름의 영향이라는 해석과 실제 기업 실적을 함께 봐요."
  },
  "home": {
    "prompt": "유동성 장세라는 말은 모든 주식이 오른다는 뜻일까요?",
    "options": [
      "상승 배경에 대한 해석이에요",
      "전 종목 상승 보장이에요"
    ],
    "answer": 0,
    "takeaway": "자금 여건이 주된 동력이라는 설명일 뿐이에요."
  },
  "related": [
    36,
    37,
    31,
    48
  ],
  "questions": [
    {
      "prompt": "유동성 장세에서 주로 거론되는 동력은?",
      "options": [
        "자금 여건과 투자 수요",
        "모든 기업 이익의 확정 증가"
      ],
      "answer": 0,
      "explanation": "실적보다 자금 흐름의 역할을 강조하는 표현이에요."
    },
    {
      "prompt": "유동성 장세와 실적 장세 요인은 함께 작용할 수 있나요?",
      "options": [
        "서로 완전히 배타적이에요",
        "그럴 수 있어요"
      ],
      "answer": 1,
      "explanation": "자금과 기업 이익은 동시에 시장에 영향을 줄 수 있어요."
    },
    {
      "prompt": "자금이 많이 유입되면 현재 가격이 적정한가요?",
      "options": [
        "가치와 실적도 따로 봐요",
        "항상 적정해요"
      ],
      "answer": 0,
      "explanation": "유입 자금만으로 가격의 적정성을 판단할 수 없어요."
    }
  ]
}
```

## 48. 실적 장세

```json
{
  "number": 48,
  "name": "실적 장세",
  "english": "Earnings-driven market",
  "category": "G7",
  "core": "기업 실적 개선이 상승을 이끈다고 해석하는 시장 표현이에요.",
  "example": "주요 기업의 이익 전망이 좋아지며 주가도 함께 오르는 흐름을 말해요.",
  "result": "상승의 동력을 기업이 버는 이익에서 찾는 관점이에요.",
  "remember": "좋은 실적이라도 이미 주가에 반영됐을 수 있어요.",
  "detail": "유동성 장세와 달리 이익을 주된 설명 요인으로 보지만 두 요인이 겹칠 수 있어요. 실적의 지속성과 시장 기대를 함께 확인해요. 시장을 묘사하는 말이지 안전한 투자 구간을 뜻하지 않아요.",
  "news": {
    "headline": "기업 이익 개선에 실적 장세 기대",
    "meaning": "예상 이익과 실제 발표, 가격에 반영된 기대를 나눠 봐요."
  },
  "home": {
    "prompt": "좋은 실적이면 어느 가격에 사도 괜찮을까요?",
    "options": [
      "가격은 상관없어요",
      "이미 반영된 기대도 봐야 해요"
    ],
    "answer": 1,
    "takeaway": "기업 성과와 내가 지불하는 가격을 함께 봐야 해요."
  },
  "related": [
    41,
    42,
    47,
    3
  ],
  "questions": [
    {
      "prompt": "실적 장세에서 강조하는 상승 동력은?",
      "options": [
        "계절 이름 자체",
        "기업의 이익 개선"
      ],
      "answer": 1,
      "explanation": "기업이 버는 이익과 그 전망을 주된 배경으로 보는 표현이에요."
    },
    {
      "prompt": "실적 장세라는 말은 손실 위험이 없다는 뜻인가요?",
      "options": [
        "아니요",
        "네"
      ],
      "answer": 0,
      "explanation": "시장에 붙인 설명이 손실을 막아주지는 않아요."
    },
    {
      "prompt": "실적이 좋아졌는데 주가가 내려갈 수 있나요?",
      "options": [
        "불가능해요",
        "기대에 못 미치면 가능해요"
      ],
      "answer": 1,
      "explanation": "더 좋은 실적을 이미 기대했다면 반응이 다를 수 있어요."
    }
  ]
}
```

## 49. 모멘텀

```json
{
  "number": 49,
  "name": "모멘텀",
  "english": "Momentum",
  "category": "G7",
  "core": "가격 흐름의 힘이나 그 흐름을 움직이는 계기를 가리키는 말이에요.",
  "example": "신제품 기대나 실적 악화가 각각 상승·하락의 계기로 거론될 수 있어요.",
  "result": "좋은 소식만 가리키는 표현은 아니에요.",
  "remember": "기사에서 가격 추세를 말하는지 새로운 계기를 말하는지 구분해요.",
  "detail": "투자 전략에서는 최근 가격 추세의 지속성을 뜻하기도 해요. 뉴스에서는 실적·정책 등 방향 전환의 계기를 넓게 부르기도 해요. 모멘텀이 있다는 표현만으로 추세 지속이나 수익이 보장되지 않아요.",
  "news": {
    "headline": "실적 개선 모멘텀 약화",
    "meaning": "어떤 동력이 약해졌는지와 이미 가격에 반영됐는지 살펴봐요."
  },
  "home": {
    "prompt": "모멘텀은 무조건 좋은 소식일까요?",
    "options": [
      "하락 동력을 말할 수도 있어요",
      "항상 좋은 소식이에요"
    ],
    "answer": 0,
    "takeaway": "상승·하락의 힘이나 계기를 모두 설명할 수 있어요."
  },
  "related": [
    41,
    42,
    45,
    48
  ],
  "questions": [
    {
      "prompt": "모멘텀 기사에서 먼저 확인할 것은?",
      "options": [
        "무엇이 흐름을 움직인다는 것인지",
        "앞으로의 확정 수익률"
      ],
      "answer": 0,
      "explanation": "추세나 계기를 가리키는 말의 구체적 대상을 확인해요."
    },
    {
      "prompt": "가격이 최근 계속 올랐다면 앞으로도 계속 오르나요?",
      "options": [
        "반드시 계속 올라요",
        "추세가 바뀔 수 있어요"
      ],
      "answer": 1,
      "explanation": "관측된 추세가 미래를 보장하지는 않아요."
    },
    {
      "prompt": "실적 악화가 하락 모멘텀으로 표현될 수 있나요?",
      "options": [
        "그럴 수 있어요",
        "좋은 뉴스에만 쓰는 말이에요"
      ],
      "answer": 0,
      "explanation": "나쁜 소식도 하락 흐름의 계기로 설명될 수 있어요."
    }
  ]
}
```

## 50. 헤징 · 위험회피

```json
{
  "number": 50,
  "name": "헤징 · 위험회피",
  "english": "Hedging",
  "category": "G4",
  "core": "특정 위험의 손실을 다른 거래의 효과로 줄이려는 방법이에요.",
  "example": "앞으로 낼 달러 비용을 미리 정한 환율로 고정하는 계약을 생각해봐요.",
  "result": "환율 상승 위험을 줄이지만 유리한 변동의 이익도 줄 수 있어요.",
  "remember": "비용과 남는 위험이 있어 손실을 완전히 없애는 마법은 아니에요.",
  "detail": "환율·금리·가격 등 어떤 위험을 얼마나 줄일지 정하는 것이 먼저예요. 계약 조건이 원래 자산과 완전히 맞지 않으면 위험이 남아요. 자산을 나눠 담는 분산과 관련은 있지만 같은 뜻은 아니에요.",
  "news": {
    "headline": "환헤지 상품 출시",
    "meaning": "줄이는 위험의 범위와 비용, 환율 하락 때 효과도 확인해요."
  },
  "home": {
    "prompt": "헤지를 하면 모든 손실이 사라질까요?",
    "options": [
      "모든 위험이 없어져요",
      "특정 위험을 줄이는 거예요"
    ],
    "answer": 1,
    "takeaway": "헤지 대상 외 위험이나 비용은 남을 수 있어요."
  },
  "related": [
    38,
    40,
    21,
    22
  ],
  "questions": [
    {
      "prompt": "헤징의 주된 목적은?",
      "options": [
        "수익을 무조건 최대로 보장",
        "특정 위험으로 인한 손실 완화"
      ],
      "answer": 1,
      "explanation": "위험 노출을 줄이는 것이 목적이며 확정 수익을 뜻하지 않아요."
    },
    {
      "prompt": "환율을 고정했는데 이후 더 유리하게 움직였다면?",
      "options": [
        "그 이익을 놓칠 수 있어요",
        "유리한 효과는 전부 누려요"
      ],
      "answer": 0,
      "explanation": "불리한 변화뿐 아니라 유리한 변화의 효과도 제한될 수 있어요."
    },
    {
      "prompt": "환율 헤지를 하면 보유 기업의 부도 위험도 없어지나요?",
      "options": [
        "모두 없어져요",
        "별개의 위험은 남아요"
      ],
      "answer": 1,
      "explanation": "환율 위험과 기업의 신용위험은 서로 다른 위험이에요."
    }
  ]
}
```
