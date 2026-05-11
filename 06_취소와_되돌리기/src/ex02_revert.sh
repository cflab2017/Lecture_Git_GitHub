#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "정상 기능" > app.py
git add . && git commit -q -m "feat: good feature"

echo "버그가 있는 코드" > app.py
git add . && git commit -q -m "feat: introduce bug"

echo "다른 정상 기능" > other.py
git add . && git commit -q -m "feat: another feature"

echo "=== revert 전 로그 ==="
git log --oneline

echo "=== revert 전 app.py ==="
cat app.py

# "feat: introduce bug" 커밋을 revert
BUGGY=$(git log --oneline | grep "introduce bug" | awk '{print $1}')
git revert "$BUGGY" --no-edit

echo ""
echo "=== revert 후 로그 (새 커밋 추가됨, 이력 보존) ==="
git log --oneline

echo ""
echo "=== revert 후 app.py (버그 이전으로 복원) ==="
cat app.py

rm -rf "$REPO"
