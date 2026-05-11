#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "메인 코드" > main.txt
git add . && git commit -q -m "init"

# develop 브랜치에서 여러 커밋
git switch -c develop
echo "기능 A" > feature_a.txt && git add . && git commit -q -m "feat: feature A"
echo "핫픽스" > hotfix.txt    && git add . && git commit -q -m "fix: critical hotfix"
echo "기능 B" > feature_b.txt && git add . && git commit -q -m "feat: feature B"
echo "기능 C" > feature_c.txt && git add . && git commit -q -m "feat: feature C"

echo "=== develop 브랜치 로그 ==="
git log --oneline

# main 에서 hotfix 커밋만 cherry-pick
git switch main
HOTFIX_HASH=$(git log develop --oneline | grep "critical hotfix" | awk '{print $1}')
echo ""
echo "=== cherry-pick: $HOTFIX_HASH ==="
git cherry-pick "$HOTFIX_HASH"

echo ""
echo "=== main 로그 (hotfix 만 포함) ==="
git log --oneline

echo ""
echo "=== main 파일 목록 (hotfix.txt 만 추가됨) ==="
ls

rm -rf "$REPO"
