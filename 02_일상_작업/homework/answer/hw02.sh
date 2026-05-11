#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

for i in 1 2 3 4 5; do
    echo "commit $i" > "file$i.txt"
    git add "file$i.txt"
    git commit -q -m "chore: add file$i"
done

echo "*.log" > .gitignore
git add .gitignore
git commit -q -m "chore: ignore *.log files"

echo "some debug info" > debug.log

echo "=== git status (.log 파일이 보이지 않아야 함) ==="
git status

echo ""
echo "=== git log --oneline (전체) ==="
git log --oneline

echo ""
echo "=== git log --oneline -n 3 (최근 3개) ==="
git log --oneline -n 3

rm -rf "$REPO"
