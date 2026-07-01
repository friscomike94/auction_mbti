---
name: rmbti-orchestrator
description: 부동산 투자성향 MBTI 테스트를 설계·제작하는 에이전트 팀 오케스트레이터. 유형 축 설계→진단 문항/채점→유형 콘텐츠/활용가이드→웹 테스트→정합성 검증을 조율하고, 진단 결과→경매 물건 검색조건 생성까지 연결한다. "부동산 투자성향 테스트/MBTI 만들어줘", "투자성향 진단", "매매/경매 성향 유형", "투자성향 테스트 다시/업데이트/수정/보완", "유형 추가", "문항만 다시", "결과화면 개선", "규제 반영", "검색조건/물건검색 기준 생성/수정" 같은 요청 시 반드시 이 스킬을 사용하라. 단순 질문(개념 설명 등)은 직접 응답 가능.
---

# 부동산 투자성향 MBTI 오케스트레이터

매매/매수 및 경매 투자에 쓰는 **부동산 투자성향 MBTI**를 에이전트 팀으로 설계·제작한다. 산출물: 인터랙티브 웹 테스트 + 유형 정의 콘텐츠 + 채점 엔진 + 투자 활용 가이드.

**실행 모드:** 에이전트 팀 (파이프라인 + 생성-검증). 6명: typology-architect, diagnostic-designer, content-writer, search-criteria-mapper, web-builder, qa.

> **search-criteria-mapper**: 경매 진단 결과(유형+입력값)를 법원경매 검색조건(지역·가격대·물건종류·유찰횟수·권리난이도)으로 변환하는 매핑(`04_search_criteria.md/.json`)을 설계. `auction-search-criteria` 스킬 사용. 자금→가격대 환산에 규제 대출한도(`00_regulations.md`) 반영. T2(02_gyeongmae.json)·콘텐츠·규제 문서에 의존 → web-builder 전에 실행. 규제 grounding 문서(`00_regulations.md`)는 규제 수치의 단일 출처(기억 금지).

## Phase 0: 컨텍스트 확인

`_workspace/` 상태로 실행 모드를 판별한다:
- `_workspace/`에 산출물 없음 → **초기 실행** (전체 파이프라인)
- 산출물 있음 + 사용자가 부분 수정 요청(예: "문항만 다시", "이 유형 보완") → **부분 재실행** (해당 에이전트만 재호출, 다운스트림 정합성만 재검증)
- 산출물 있음 + 새 요구(축 재설계 등) → 기존 `_workspace/`를 `_workspace_prev/`로 옮기고 **새 실행**

부분 재실행 시: 변경이 유형 코드 체계를 건드리면 다운스트림(문항·프로필·웹) 전부 영향 → 사용자에게 범위를 알리고 진행.

## Phase 1: 팀 구성 & 작업 분배

`TeamCreate`로 5인 팀 구성. 모든 Agent 호출에 `model: "opus"` 명시. `TaskCreate`로 의존성 있는 작업을 등록한다:

```
T1 (typology-architect): 매매/경매 축·유형 매트릭스 설계 → 01_typology.md
T2 (diagnostic-designer): 문항+채점 엔진 [dep: T1] → 02_*.json, 02_scoring.md
T3 (content-writer): 유형 프로필+활용가이드 [dep: T1] → 03_profiles.md, 03_strategy_guide.md
T4 (web-builder): 인터랙티브 웹 테스트 [dep: T2, T3] → 부동산투자성향테스트.html
T5 (qa): 경계면 정합성 검증 [점진적: T1,T2,T3,T4 각 직후] → 99_qa_report.md
```

T2와 T3은 T1 완료 후 **병렬**. T4는 둘 다 끝나야 시작. QA는 각 단계 직후 점진 검증.

## Phase 2: 파이프라인 실행 (데이터 흐름)

```
typology-architect ──01_typology.md──┬──> diagnostic-designer ──02_*.json/scoring──┐
                                     └──> content-writer ──03_profiles/strategy──┐ │
                                                                                 ▼ ▼
                                                              web-builder ──> 부동산투자성향테스트.html
   qa: 각 산출물 직후 경계면 교차검증 (코드 일관성 / 채점 재현 / 경매변수 / 톤균형)
```

**데이터 전달**: 파일 기반(`_workspace/`) + 메시지 기반(SendMessage로 코드 체계·스키마 공유) + 태스크 기반(TaskUpdate로 진행).

**핵심 계약(절대 깨지면 안 됨):**
1. 유형 코드 체계는 typology-architect가 정본. 모두 그대로 사용.
2. JSON 스키마는 `diagnostic-engine/references/data-schema.md` 준수. web-builder가 그대로 소비.
3. 채점 로직은 `02_scoring.md`가 정본. web-builder의 JS는 이를 재현, qa가 골든 케이스로 검증.

## Phase 3: 종합 & 인도

QA 전 항목 통과 후 리더가 종합한다. 사용자에게:
- 최종 HTML 경로와 여는 법
- 유형 체계 요약(매매 N유형, 경매 N유형, 핵심 유형)
- `_workspace/`의 중간 산출물 위치(감사·재실행용 보존)

## 에러 핸들링

- 에이전트 1회 재시도 후 재실패 → 해당 결과 없이 진행하고 최종 보고에 누락 명시.
- 유형 모순(content-writer 발견) → 삭제 말고 typology-architect에 피드백, 매트릭스 주석으로 출처 병기.
- 채점 불일치(qa 발견) → scoring.md가 정본, web-builder가 JS 수정.
- 스키마 위반 → diagnostic-designer가 data-schema.md에 맞춰 수정, web-builder 대기.

## 팀 크기/모드 메모

중~대규모(20+ 작업). 5인이 적정. QA는 general-purpose(스크립트 실행), 나머지는 정의된 전문 에이전트. 단일 세션 1팀; Phase 간 재구성 불필요(전 과정 동일 팀).

## 테스트 시나리오

**정상 흐름:** "부동산 매매·경매 투자성향 테스트 만들어줘" → 초기 실행 → T1 축 설계 → T2/T3 병렬 → T4 웹 → QA 통과 → HTML 인도. 검증: 매매/경매 각 트랙을 끝까지 풀어 유형·가이드가 뜨고, 경매 개인화 경고가 조건대로 출력.

**에러 흐름:** QA가 "웹 채점 결과 ≠ scoring.md 골든 케이스(M-SHLE 기대인데 M-SHLA 출력)" 발견 → web-builder에 출처·기대·실제 통지 → JS 동점/축순서 수정 → 재검증 통과. scoring.md는 수정하지 않음(정본).

## 재실행 키워드

"다시/재실행/업데이트/수정/보완/추가", "문항만 다시", "이 유형만 고쳐", "결과화면 개선", "경매 변수 추가", "이전 결과 기반으로" → Phase 0에서 부분/새 실행 판별.
