#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "main content" > main.txt
git add . && git commit -q -m "init: main"

echo "=== 브랜치 생성 ==="
git branch feature/hello
git branch feature/world

echo ""
echo "=== 브랜치 목록 ==="
git branch

echo ""
echo "=== feature/hello 로 전환 ==="
git switch feature/hello
echo "hello" > hello.txt
git add . && git commit -q -m "feat: add hello"

echo ""
echo "=== 전체 그래프 ==="
git log --oneline --graph --all

echo ""
echo "=== main 으로 복귀 ==="
git switch main
git branch

rm -rf "$REPO"
