#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

for i in 1 2 3; do
    echo "v$i" > file.txt
    git add .
    git commit -q -m "commit $i"
done

echo "=== 초기 로그 (3개 커밋) ==="
git log --oneline

echo ""
echo "--- soft reset HEAD~1 ---"
git reset --soft HEAD~1
echo "status (staged 상태):"
git status --short
echo "log:"
git log --oneline

echo ""
echo "(다시 커밋)"
git commit -q -m "commit 3 (re-committed)"

echo ""
echo "--- mixed reset HEAD~1 (기본값) ---"
git reset HEAD~1
echo "status (unstaged 상태):"
git status --short
echo "log:"
git log --oneline

echo ""
echo "(다시 add + 커밋)"
git add . && git commit -q -m "commit 3 (re-added)"

echo ""
echo "--- hard reset HEAD~1 ---"
git reset --hard HEAD~1
echo "status (clean - 변경 사라짐):"
git status --short
echo "log:"
git log --oneline

rm -rf "$REPO"
