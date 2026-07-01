# 웹 테스트 구현 패턴

## 데이터 임베드 (단일 파일)

```html
<script>
const DATA = {
  maemae:   { /* 02_maemae.json 내용 */ },
  gyeongmae:{ /* 02_gyeongmae.json 내용 */ }
};
const PROFILES = { "M-SHLE": { strength:[...], weakness:[...], blindspot:"...", guide:{...} }, ... };
</script>
```

JSON을 그대로 붙이되, `03_*.md`의 유형별 본문은 PROFILES 객체로 정리(마크다운 파싱 대신 빌드시 변환). 유형 코드를 키로.

## 채점 함수 (scoring.md 재현)

```js
function score(track, answers, profile) {
  const data = DATA[track];
  const tally = {};                       // 극코드 -> 점수
  for (const q of data.questions) {
    const opt = answers[q.id];            // 선택된 option
    if (!opt || !opt.score) continue;
    for (const [pole, pts] of Object.entries(opt.score))
      tally[pole] = (tally[pole] || 0) + pts;
  }
  let code = data.code_prefix;
  for (const axisId of data.axis_order) {
    const ax = data.axes.find(a => a.id === axisId);
    const a = tally[ax.pole_a.code] || 0, b = tally[ax.pole_b.code] || 0;
    code += (a === b) ? ax.default_pole          // 동점 → 기본극
          : (a > b ? ax.pole_a.code : ax.pole_b.code);
  }
  const flags = computeFlags(track, profile); // 경매 개인화 경고
  return { code, flags, borderline: /* 동점 발생 여부 */ };
}
```

`computeFlags`는 scoring.md의 플래그 규칙(예: 다주택+단기매각→양도세 경고)을 그대로 옮긴다.

## 렌더링 흐름

- `state = { track, step, answers, profile }` 단일 상태 객체.
- 문항 렌더: `data.questions[step]` → 라디오/카드 선택지. 선택 시 `answers[q.id]=opt`.
- 진행률: `step / total`.
- 결과 렌더: `score()` → PROFILES[code]로 강점/약점/맹점/가이드 표시.

## algo-design 톤 적용 체크

- 배경 크림(#FAF7F0 계열), 본문 Lora/제목 Poppins, 액센트 오렌지/블루/그린.
- 선택지는 카드 또는 세그먼트 칩. 호버·선택 상태 명확.
- 결과 유형은 큰 코드 + 키워드 칩 + 카드 섹션.
- 과한 애니메이션 금지, 잔잔한 전환만.

## self-check

브라우저로 열어 매매/경매 각 트랙을 끝까지 풀고:
1. 결과 유형이 나오는가
2. scoring.md 골든 케이스대로 응답 시 기대 유형이 나오는가
3. 경매 개인화 경고가 조건에 맞게 뜨는가
4. 다시하기/저장이 동작하는가
