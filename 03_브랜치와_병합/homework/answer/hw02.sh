#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "공통 내용" > conflict.txt
git add . && git commit -q -m "init"

git switch -c feature/b
echo "feature 내용" > conflict.txt
git add . && git commit -q -m "feat: feature version"

git switch main
echo "main 내용" > conflict.txt
git add . && git commit -q -m "chore: main version"

echo "=== 충돌 발생 ==="
git merge feature/b 2>&1 || true

echo "해결된 내용" > conflict.txt
git add conflict.txt
git commit -m "merge: resolve conflict in conflict.txt"

echo ""
echo "=== 최종 그래프 ==="
git log --oneline --graph --all

rm -rf "$REPO"
