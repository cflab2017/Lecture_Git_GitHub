#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "a" > a.txt && git add . && git commit -q -m "add a"
echo "b" > b.txt && git add . && git commit -q -m "add b"
echo "c" > c.txt && git add . && git commit -q -m "add c"

echo "=== 초기 로그 ==="
git log --oneline

echo ""
echo "--- soft reset ---"
git reset --soft HEAD~1
git status --short
git log --oneline

echo ""
echo "--- mixed reset ---"
git reset HEAD~1
git status --short
git log --oneline

echo ""
echo "(re-commit b and c)"
git add . && git commit -q -m "re-commit b and c"

echo ""
echo "--- hard reset ---"
git reset --hard HEAD~1
git status --short
echo "남은 파일:"
ls

rm -rf "$REPO"
