---
name: publish-site
description: 부동산 투자성향 테스트 웹(부동산투자성향테스트.html)을 index.html로 동기화하고 GitHub(earthskyisbig/auction_mbti main)에 커밋·푸시하여 공개 사이트(GitHub Pages)를 갱신하는 방법. "사이트 배포", "index 동기화", "배포해줘", "공개 사이트 업데이트", "깃 푸시(사이트)", "Pages 갱신" 또는 웹 테스트를 수정한 뒤 온라인에 반영하고 싶을 때 반드시 이 스킬을 사용하라.
---

# 사이트 배포 (index.html 동기화 → 푸시)

웹 테스트를 하네스로 재빌드하면 `부동산투자성향테스트.html`이 갱신된다. GitHub Pages는 `index.html`을 서빙하므로, 이 둘을 동기화하고 푸시해야 공개 사이트가 최신이 된다. 이 흐름을 한 번에 처리한다.

## 언제

- 웹 빌더가 `부동산투자성향테스트.html`을 갱신한 직후 (규제 반영·유형 추가·결과화면 수정 등)
- 사용자가 "사이트 배포/업데이트", "index 동기화 푸시"를 요청할 때

## 하는 일 (scripts/publish.sh)

1. `부동산투자성향테스트.html` → `index.html` 복사(동기화)
2. `git add -A` (웹 갱신에 딸린 `_workspace/` 산출물도 함께 반영)
3. 변경 없으면 커밋·푸시 생략(이미 최신)
4. 변경 있으면 커밋 후 `origin main` 푸시

실행:

```bash
.claude/skills/publish-site/scripts/publish.sh ["커밋 메시지"]
```

커밋 메시지를 생략하면 타임스탬프가 자동으로 붙는다. 의미 있는 변경이면 메시지를 넘겨라(예: `publish.sh "규제 반영 결과화면 갱신"`).

## 주의 — 푸시는 외부 공개 행위

이 리포는 **공개(PUBLIC)**다. 푸시하면 변경 내용이 즉시 공개 사이트에 반영된다. 따라서 **사용자가 배포를 원한다는 의사가 있을 때만** 실행한다. 웹만 재빌드하고 아직 공개하지 말라는 맥락이면 스크립트를 돌리지 말고, 배포할지 물어라.

## 배포 후

- 공개 URL: https://earthskyisbig.github.io/auction_mbti/ (반영까지 1~2분)
- 필요하면 `curl -s -o /dev/null -w "%{http_code}" https://earthskyisbig.github.io/auction_mbti/`로 200 확인.

## 확장

리모트 URL·브랜치가 바뀌면 `scripts/publish.sh`의 `git push origin main`과 이 문서의 URL을 갱신한다. 다른 산출물(예: 매매용 별도 페이지)을 추가로 게시하려면 동기화 대상 파일을 스크립트에 추가한다.
