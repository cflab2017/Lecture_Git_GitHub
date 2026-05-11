#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "base" > base.txt
git add . && git commit -q -m "A: initial commit"

# feature 브랜치 작업
git switch -c feature
echo "기능 1" > feat1.txt
git add . && git commit -q -m "C: add feature 1"
echo "기능 2" > feat2.txt
git add . && git commit -q -m "D: add feature 2"

# main 브랜치에 별도 커밋
git switch main
echo "main 추가" > extra.txt
git add . && git commit -q -m "B: main extra work"

echo "=== rebase 전 그래프 ==="
git log --oneline --graph --all

# feature 를 main 위로 rebase
git switch feature
git rebase main

echo ""
echo "=== rebase 후 그래프 (선형 이력) ==="
git log --oneline --graph --all

echo ""
echo "=== feature 브랜치 파일 목록 ==="
ls

rm -rf "$REPO"
