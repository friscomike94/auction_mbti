#!/usr/bin/env bash
# 부동산투자성향테스트.html → index.html 동기화 후 커밋·푸시.
# GitHub Pages(https://earthskyisbig.github.io/auction_mbti/)에 최신 웹 테스트를 반영한다.
# 사용법: publish.sh ["커밋 메시지"]   (메시지 생략 시 타임스탬프 자동)
set -euo pipefail

# 저장소 루트 = 이 스크립트 기준 4단계 상위 (scripts→publish-site→skills→.claude→root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
cd "$REPO_ROOT"

SRC="부동산투자성향테스트.html"
DEST="index.html"

if [ ! -f "$SRC" ]; then
  echo "❌ '$SRC' 를 찾을 수 없습니다. (경로: $REPO_ROOT)" >&2
  exit 1
fi

# 1) 동기화
cp "$SRC" "$DEST"
echo "✓ 동기화: $SRC → $DEST"

# 2) 변경 스테이징 (웹 갱신에 딸린 _workspace 등도 함께 반영)
git add -A

if git diff --cached --quiet; then
  echo "ℹ️ 변경사항 없음 — 커밋·푸시 생략 (사이트 이미 최신)"
  exit 0
fi

# 3) 커밋 (로컬 git 설정이 없어도 동작하도록 identity 명시)
MSG="${1:-사이트 업데이트: index.html 동기화 ($(date '+%Y-%m-%d %H:%M'))}"
git -c user.name='earthskyisbig' -c user.email='algo1744@gmail.com' \
    commit -q -m "$MSG

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
echo "✓ 커밋: $MSG"

# 4) 푸시
git push -q origin main
echo "✓ 푸시 완료 → https://earthskyisbig.github.io/auction_mbti/ (반영까지 1~2분)"
