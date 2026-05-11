#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "초기 파일" > README.md
git add . && git commit -q -m "init"

# feature 브랜치에서 커밋
git switch -c feature/3way
echo "기능 A" > feature_a.txt
git add . && git commit -q -m "feat: add feature A"
echo "기능 B" > feature_b.txt
git add . && git commit -q -m "feat: add feature B"

# main 에서도 별도 커밋 (분기 상태 만들기)
git switch main
echo "main 에서 버그 수정" > bugfix.txt
git add . && git commit -q -m "fix: bugfix on main"

echo "=== 병합 전 그래프 ==="
git log --oneline --graph --all

git merge feature/3way -m "merge: feature/3way into main"

echo ""
echo "=== 3-way merge 후 그래프 (병합 커밋 있음) ==="
git log --oneline --graph --all

rm -rf "$REPO"
