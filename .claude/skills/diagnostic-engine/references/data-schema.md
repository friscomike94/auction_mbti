# 진단 데이터 스키마 (고정 계약)

문항·유형·채점 데이터의 표준 JSON 구조. diagnostic-designer가 생성하고 web-builder가 소비한다. **필드명과 중첩 구조를 바꾸지 말 것.** 확장이 필요하면 새 필드를 추가하되 기존 필드는 유지하고, 스키마 version을 올려 web-builder에 알린다.

## 트랙 파일 구조 (`02_maemae.json`, `02_gyeongmae.json`)

```json
{
  "version": "1.0",
  "track": "maemae",                 // "maemae" | "gyeongmae"
  "track_label": "매매 투자성향",
  "code_prefix": "M-",               // "M-" | "A-"
  "axis_order": ["RISK", "HORIZON", "BASIS", "CAPITAL"],

  "axes": [
    {
      "id": "RISK",
      "label": "리스크 성향",
      "pole_a": { "code": "S", "label": "안정형", "desc": "검증된 입지, 하방 방어 우선" },
      "pole_b": { "code": "A", "label": "공격형", "desc": "저평가·호재 베팅" },
      "default_pole": "S"            // 동점 시 채택할 극
    }
    // ... 축마다 하나
  ],

  "questions": [
    {
      "id": "q1",
      "axis": "RISK",               // axes[].id 중 하나
      "text": "10% 싼데 권리관계가 복잡한 물건 vs 시세대로지만 깔끔한 물건, 무엇을 택하나요?",
      "options": [
        { "label": "복잡해도 싼 쪽",   "score": { "A": 2 } },
        { "label": "깔끔한 쪽",        "score": { "S": 2 } }
      ]
    }
    // score는 { 극코드: 점수 } 형태. 4점 리커트면 한 선택지가 {"A":2} 또는 {"A":1} 등.
  ],

  // 경매 전용 — 축 판별 + 결과 개인화에 모두 쓰이는 변수.
  // 매매 파일에는 없거나 빈 배열.
  "profile_inputs": [
    {
      "id": "ownership",
      "label": "주택보유상황",
      "text": "현재 주택 보유 상황은?",
      "options": [
        { "label": "무주택",  "value": "none" },
        { "label": "1주택",   "value": "one" },
        { "label": "다주택",  "value": "multi" }
      ]
    },
    {
      "id": "experience",
      "label": "경매경험",
      "text": "지금까지 입찰/낙찰 경험은?",
      "options": [
        { "label": "0~1회(초보)", "value": "novice" },
        { "label": "2~5회(중급)", "value": "inter"  },
        { "label": "6회+(숙련)",  "value": "expert" }
      ]
    }
    // 투자자금/투자용도/투자지역도 동일 형식. 일부는 axis 점수에도 기여하면
    // 별도 "score" 필드를 옵션에 추가해도 됨(profile_input이면서 축 기여).
  ],

  "types": [
    {
      "code": "M-SHLE",
      "axes": { "RISK": "S", "HORIZON": "H", "BASIS": "L", "CAPITAL": "E" },
      "name": "거북이 실속파",
      "keywords": ["안정", "장기보유", "입지우선"],
      "summary": "검증된 입지를 자기자본으로 길게 들고 가는 안정 추구형."   // 결과화면 1줄
      // 상세 강점/약점/맹점/가이드는 03_profiles.md, 03_strategy_guide.md 참조(웹은 거기서 가져옴)
    }
    // 가능한 모든 조합. 희귀/모순 유형은 "rare": true 플래그.
  ]
}
```

## 개인화 플래그 (경매 결과)

채점 시 profile_inputs 조합으로 경고/안내 플래그를 산출한다. 형식 예시(scoring.md에 규칙 명시, 웹에서 동적 계산):

```json
"flags": [
  { "when": { "ownership": "multi", "purpose": "flip" },
    "level": "warn",
    "message": "다주택 단기매각은 양도세 중과 대상 — 보유기간·세율 사전 검토 필수." }
]
```

## 일관성 규칙 (QA가 검사)

- `types[].code`의 극 조합 == `axis_order` 순서대로 `axes[].axis` 극 코드.
- 모든 `questions[].axis`는 `axes[].id`에 존재.
- `types[].code` 집합 == `01_typology.md`의 유형 == `03_profiles.md`/`03_strategy_guide.md`의 유형.
- 경매 파일은 투자자금·투자용도·투자지역·주택보유상황·경매경험을 questions 또는 profile_inputs로 모두 포함.
