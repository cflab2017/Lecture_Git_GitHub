#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
echo "저장소 위치: $REPO"
cd "$REPO"

git init -b main
git config user.name  "홍길동"
git config user.email "gildong@example.com"
    git config commit.gpgsign false

echo "# 나의 첫 번째 저장소" > README.md
git add README.md
git commit -m "docs: initial README"

echo ""
echo "=== 커밋 로그 ==="
git log --oneline

rm -rf "$REPO"
echo "정리 완료"
