#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "secret_password" > .env
echo "print('hello')" > main.py
git add .
git commit -q -m "init: add files (including .env by mistake)"

echo "=== 실수로 커밋된 파일 목록 ==="
git ls-files

# 이제 .env 를 추적에서 제외
echo ".env" > .gitignore
git rm --cached .env
git add .gitignore
git commit -m "chore: stop tracking .env"

echo ""
echo "=== 수정 후 추적 파일 목록 ==="
git ls-files

echo ""
echo "=== .env 파일은 디스크에 그대로 존재 ==="
ls -la .env

rm -rf "$REPO"
