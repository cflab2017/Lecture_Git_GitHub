#!/usr/bin/env bash
set -euo pipefail

WORKDIR=$(mktemp -d)

git init --bare -b main "$WORKDIR/remote.git" -q

git clone "$WORKDIR/remote.git" "$WORKDIR/repo" -q
cd "$WORKDIR/repo"
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "초기 파일" > main.txt
git add . && git commit -q -m "init"
git push origin main -q

# feature 브랜치에서 WIP 커밋 후 push
git switch -c feature
echo "WIP 1" >> main.txt && git add . && git commit -q -m "wip: step 1"
echo "WIP 2" >> main.txt && git add . && git commit -q -m "wip: step 2"
echo "WIP 3" >> main.txt && git add . && git commit -q -m "wip: step 3"
git push origin feature -q

echo "=== push 전 로그 (WIP 커밋 3개) ==="
git log --oneline

# squash: WIP 3개 → 1개
git reset --soft HEAD~3
git commit -m "feat: complete feature"

echo ""
echo "=== squash 후 로그 (1개) ==="
git log --oneline

echo ""
echo "=== --force-with-lease 로 안전하게 push ==="
git push --force-with-lease origin feature

echo ""
echo "=== 원격 feature 브랜치 확인 ==="
git log origin/feature --oneline

rm -rf "$WORKDIR"
