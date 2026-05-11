#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

for i in 1 2 3; do
    echo "v$i" > version.txt
    git add version.txt
    git commit -q -m "chore: version $i"
done

echo "=== git log --oneline ==="
git log --oneline

echo ""
echo "=== git log --oneline -n 2 ==="
git log --oneline -n 2

echo ""
echo "=== git log --oneline --stat ==="
git log --oneline --stat

echo ""
echo "=== git diff HEAD~2 HEAD (두 커밋 전 vs 현재) ==="
git diff HEAD~2 HEAD

rm -rf "$REPO"
