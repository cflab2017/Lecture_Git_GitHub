#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

printf 'line1\nline2\nline3\n' > file.txt
git add file.txt && git commit -q -m "init"

echo "line4" >> file.txt
git add file.txt

echo "line5" >> file.txt

echo "=== diff: 워킹 vs 스테이징 ==="
git diff

echo ""
echo "=== diff --staged: 스테이징 vs HEAD ==="
git diff --staged

git commit -q -m "add line4 (staged only)"
echo ""
echo "=== 커밋 후 남은 변경 ==="
git diff

rm -rf "$REPO"
