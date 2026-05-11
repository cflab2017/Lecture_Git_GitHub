#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

git remote add origin https://github.com/example/project.git
git remote add backup https://backup.example.com/project.git

echo "=== 초기 remote 목록 ==="
git remote -v

git remote set-url origin https://github.com/example/project-v2.git
git remote remove backup

echo ""
echo "=== 최종 remote 목록 ==="
git remote -v

rm -rf "$REPO"
