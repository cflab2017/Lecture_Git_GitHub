#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name  "실습용"
git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "파일1" > a.txt

echo "[1] 파일 추가 후 status (Untracked)"
git status

git add a.txt
echo ""
echo "[2] git add 후 status (Staged)"
git status

git commit -q -m "add a.txt"
echo ""
echo "[3] 커밋 후 status (Clean)"
git status

echo "수정된 내용" >> a.txt
echo ""
echo "[4] 파일 수정 후 status (Modified)"
git status

rm -rf "$REPO"
