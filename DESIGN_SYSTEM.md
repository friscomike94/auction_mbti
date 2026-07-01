# Real Estate AI Design System — Mono Signal

부동산 투자성향 테스트와 이후 강의자료, 리포트, 랜딩페이지에 공통 적용할 PropTech AI 디자인 시스템입니다.

## 1. 컨셉

- 테마 이름: **Mono Signal**
- 방향: 다크 배경 + 단일 라임 시그널 컬러. 데이터/AI 진단 제품 느낌.
- 원칙: 강조는 라임 하나로만. 배경은 거의 무채색, 정보는 밝은 텍스트로.
- 화려한 다색 그라디언트, 형광 남발, 과한 블러는 쓰지 않습니다.

## 2. 컬러 토큰

| Token | Value | Use |
| --- | --- | --- |
| BG 0 | #0b0b0d | 최상단 배경 |
| BG 1 | #141417 | 하단 배경(그라디언트 끝) |
| Surface | rgba(255,255,255,.035) | 기본 카드 |
| Surface 2 | rgba(255,255,255,.06) | 강조 카드, 질문/결과 패널 |
| Ink | #f4f4f2 | 제목·핵심 텍스트 |
| Ink 2 | #d9d9d4 | 본문 텍스트 |
| Muted | rgba(230,230,225,.58) | 설명·보조 |
| Line | rgba(255,255,255,.1) | 카드 경계 |
| Lime | #c8fa46 | 시그널 강조(버튼, 코드, 강조 단어) |
| Lime 2 | #a6e800 | 라임 그라디언트 끝 |
| Lime soft | rgba(200,250,70,.12) | 라임 배경 톤 |
| Danger | #ff6a5a | 강경고 |
| Warn | #ffb454 | 주의·경계형 |
| Info | #5ab7ff | 안내·규제 정보 |
| Success | #8fe08a | 확인됨·긍정 |

## 3. 타이포그래피

- 제목/라벨: Space Grotesk (한글은 Noto Sans KR fallback)
- 본문: Noto Sans KR
- 제목 weight 700, letter spacing -4~-5%
- 본문 weight 500-600, line height 1.65-1.8

| 역할 | Web |
| --- | --- |
| Hero title | clamp(44px, 6.2vw, 83px) |
| Result code | clamp(48px, 8vw, 99px) |
| Section title | 24-32px |
| Body | 16-18px |
| Label | 11-13px, uppercase |

## 4. 레이아웃

- 최대 폭: 1040px
- 카드 radius: 16-26px
- 카드 padding: 22-48px
- 배경: 라인 그리드 오버레이(라임 5% 이하) + 흐릿한 대형 라임 도형만.

## 5. 컴포넌트 규칙

### Hero
- 큰 제목 2줄, 강조 단어만 Lime → Lime 2 그라디언트.
- 배경은 유리판(반투명 카드) + 라인 그리드.

### Card
- 어두운 반투명 Surface + 얇은 라인.
- Hover는 위로 5px + 라인 강조.
- 선택 상태는 라임 라인 + 상단 라임 바 + SELECTED 배지.

### Button
- Primary: Lime 그라디언트, 어두운 텍스트(#101206).
- Ghost: 반투명 Surface, hover 시 라임.
- Disabled: 반투명 회색, 그림자 제거.

### Result
- 결과 코드는 Lime 그라디언트로 강하게.
- Identity 패널만 Lime 배경 + 어두운 텍스트로 단 하나 강조.
- 축 카드 경계형은 Warn 톤으로 표시.

### Alert
- Info(blue) / Warn(amber) / Danger(red) / Success(green): 모두 낮은 채도, 어두운 배경 위 밝은 라벨.

## 6. 자료 적용 가이드

- 강의 표지: Hero 규칙(다크 배경 + 라임 강조 단어) 그대로.
- 본문 슬라이드: 다크 배경 + Surface 카드 1-2개.
- 강조 색은 한 화면에 Lime 하나만. 경고류만 예외.
- 라이트 자료가 필요하면 배경/텍스트만 반전하고 Lime 강조는 유지.

## 7. 토큰 소스

웹 테스트의 CSS `:root` 변수 블록이 기준 소스입니다. 다른 자료를 만들 때 색상·radius·typography 규칙을 먼저 복사한 뒤 컴포넌트만 변형하세요.
