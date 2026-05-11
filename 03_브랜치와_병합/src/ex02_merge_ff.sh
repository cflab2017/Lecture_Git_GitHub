#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "init" > README.md
git add . && git commit -q -m "init"

git switch -c feature/fast-forward
echo "FF 기능 추가" > feature.txt
git add . && git commit -q -m "feat: add feature"

echo "=== 병합 전 로그 ==="
git log --oneline --graph --all

git switch main
git merge feature/fast-forward

echo ""
echo "=== fast-forward 병합 후 로그 (직선) ==="
git log --oneline --graph --all

echo ""
echo "=== --no-ff 로 병합 커밋 강제 생성 ==="
git switch -c feature/no-ff
echo "no-ff 기능" > noff.txt
git add . && git commit -q -m "feat: add no-ff feature"

git switch main
git merge --no-ff feature/no-ff -m "merge: feature/no-ff into main"

echo ""
echo "=== --no-ff 후 로그 (병합 커밋 있음) ==="
git log --oneline --graph --all

rm -rf "$REPO"
