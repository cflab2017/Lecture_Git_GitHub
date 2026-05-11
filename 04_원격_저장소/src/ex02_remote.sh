#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "=== remote 추가 ==="
git remote add origin  https://github.com/example/my-repo.git
git remote add upstream https://github.com/original/my-repo.git
git remote -v

echo ""
echo "=== origin URL 변경 ==="
git remote set-url origin https://github.com/example/new-name.git
git remote -v

echo ""
echo "=== upstream 이름 → source 로 변경 ==="
git remote rename upstream source
git remote -v

echo ""
echo "=== source 제거 ==="
git remote remove source
git remote -v

rm -rf "$REPO"
