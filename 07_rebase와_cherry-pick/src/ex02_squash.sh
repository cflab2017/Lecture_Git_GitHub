#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "베이스" > app.py
git add . && git commit -q -m "init: base"

# 작업 커밋 여러 개 (WIP)
echo "단계 1" >> app.py && git add . && git commit -q -m "wip: step 1"
echo "단계 2" >> app.py && git add . && git commit -q -m "wip: step 2"
echo "오타수정" >> app.py && git add . && git commit -q -m "fix: typo"
echo "단계 3" >> app.py && git add . && git commit -q -m "wip: step 3"

echo "=== squash 전 로그 (WIP 커밋 4개) ==="
git log --oneline

# git rebase -i 는 대화형이므로, reset --soft 로 squash 시뮬레이션
git reset --soft HEAD~4
git commit -m "feat: implement full feature (squashed 4 commits)

- step 1, 2, 3 구현
- 오타 수정 포함"

echo ""
echo "=== squash 후 로그 (1개로 합쳐짐) ==="
git log --oneline

echo ""
echo "=== 최종 커밋 메시지 ==="
git log -1 --format="%B"

rm -rf "$REPO"
