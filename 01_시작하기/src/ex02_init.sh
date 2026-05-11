#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
echo "작업 디렉토리: $REPO"
cd "$REPO"

git init -b main
git config user.name  "실습용"
git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "# Hello Git" > README.md
git add README.md
git commit -m "chore: initial commit"

echo ""
echo "=== 커밋 목록 ==="
git log --oneline

echo ""
echo "=== .git 내부 구조 ==="
ls .git/

# 정리
rm -rf "$REPO"
echo ""
echo "임시 디렉토리 삭제 완료"
