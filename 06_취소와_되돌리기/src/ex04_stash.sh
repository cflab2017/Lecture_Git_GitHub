#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "초기 앱 코드" > app.py
git add . && git commit -q -m "init: app.py"

# 새 기능 개발 중 (커밋 안 된 상태)
echo "WIP: 새 기능 작업 중" >> app.py
echo ""
echo "[1] 작업 중 status"
git status --short

# 긴급 수정 요청 → stash
git stash push -m "WIP: 새 기능 개발"
echo ""
echo "[2] stash 후 status (clean)"
git status --short

echo ""
echo "[3] stash list"
git stash list

# 긴급 hotfix
git switch -c hotfix/critical -q
echo "긴급 수정 완료" > hotfix.py
git add . && git commit -q -m "fix: critical hotfix"
git switch main -q
git merge hotfix/critical -q

echo ""
echo "[4] hotfix 병합 후 로그"
git log --oneline

# 원래 작업 복원
git stash pop
echo ""
echo "[5] stash pop 후 status"
git status --short
echo "app.py 내용:"
cat app.py

rm -rf "$REPO"
