#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "base" > base.txt
git add . && git commit -q -m "init: add base.txt"

git switch -c feature/a
echo "기능 A" > a.txt
git add . && git commit -q -m "feat: add a.txt"

git switch main
echo "서포트 파일" > b.txt
git add . && git commit -q -m "chore: add b.txt on main"

git merge feature/a -m "merge: feature/a into main"

echo "=== 3-way merge 결과 ==="
git log --oneline --graph --all

rm -rf "$REPO"
