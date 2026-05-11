#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name  "실습용"
git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "첫 번째 내용" > file.txt
git add file.txt && git commit -q -m "feat: first file"

echo "두 번째 줄 추가" >> file.txt
git add file.txt && git commit -q -m "feat: add second line"

echo "=== git log --oneline ==="
git log --oneline

echo ""
echo "=== git log --stat ==="
git log --stat --oneline

echo ""
echo "=== git show HEAD ==="
git show HEAD

echo ""
echo "=== git show HEAD~1 (이전 커밋) ==="
git show HEAD~1 --stat

rm -rf "$REPO"
