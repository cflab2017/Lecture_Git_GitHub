#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

printf '할 일 1\n할 일 2\n할 일 3\n' > notes.txt
git add notes.txt && git commit -q -m "init: add notes"

echo "할 일 4" >> notes.txt
git add notes.txt

echo "할 일 5" >> notes.txt

echo "=== diff: 워킹 vs 스테이징 ==="
git diff

echo ""
echo "=== diff --staged: 스테이징 vs HEAD ==="
git diff --staged

rm -rf "$REPO"
