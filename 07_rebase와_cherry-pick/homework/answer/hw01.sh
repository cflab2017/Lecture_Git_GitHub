#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "base" > base.txt && git add . && git commit -q -m "init: base"

git switch -c feature/work
echo "작업 내용" > work.txt && git add . && git commit -q -m "feat: add work"

git switch main
echo "핫픽스" > hotfix.txt && git add . && git commit -q -m "fix: hotfix"

echo "=== rebase 전 그래프 ==="
git log --oneline --graph --all

git switch feature/work
git rebase main

echo ""
echo "=== rebase 후 그래프 (선형) ==="
git log --oneline --graph --all

git switch main
git merge feature/work

echo ""
echo "=== fast-forward merge 후 최종 로그 ==="
git log --oneline --graph --all

rm -rf "$REPO"
