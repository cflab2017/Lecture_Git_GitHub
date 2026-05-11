#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "메인 코드" > main.txt && git add . && git commit -q -m "init"

git switch -c develop
echo "로그인 기능" > login.py    && git add . && git commit -q -m "feat: add login"
echo "보안 패치" > security.py  && git add . && git commit -q -m "fix: security patch"
echo "대시보드" > dashboard.py  && git add . && git commit -q -m "feat: add dashboard"

echo "=== develop 로그 ==="
git log --oneline

git switch main
SECURITY=$(git log develop --oneline | grep "security patch" | awk '{print $1}')
git cherry-pick "$SECURITY"

echo ""
echo "=== main 로그 (security patch 만) ==="
git log --oneline

echo ""
echo "=== main 파일 목록 ==="
ls

rm -rf "$REPO"
