#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "def main(): pass" > main.py
git add . && git commit -q -m "init: main.py"

echo "# WIP 작업" >> main.py
git stash push -m "WIP"
echo "stash 후 status: $(git status --short | wc -l) 변경 (0이어야 함)"

git switch -c fix/patch -q
echo "def patch(): pass" > patch.py
git add . && git commit -q -m "fix: add patch"
git switch main -q
git merge fix/patch -q

echo ""
echo "병합 후 로그:"
git log --oneline

git stash pop

echo ""
echo "stash pop 후 main.py:"
cat main.py

echo ""
echo "stash list (비어 있어야 함):"
git stash list

rm -rf "$REPO"
