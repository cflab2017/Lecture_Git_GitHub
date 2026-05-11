#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

# 로컬 저장소 alias 등록
git config alias.lg "log --oneline --graph --all --decorate"
git config alias.st "status --short --branch"
git config alias.aa "add --all"
git config alias.cm "commit -m"

for i in 1 2; do
    echo "file$i" > "file$i.txt"
    git aa
    git cm "chore: add file$i"
done

echo "=== git st (status --short --branch) ==="
git st

echo ""
echo "=== git lg (log --oneline --graph --all) ==="
git lg

echo ""
echo "=== 등록된 alias 목록 ==="
git config --list | grep "^alias\."

rm -rf "$REPO"
