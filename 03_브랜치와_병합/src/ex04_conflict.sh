#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "공통 내용" > shared.txt
git add . && git commit -q -m "init"

# feature 브랜치: shared.txt 수정
git switch -c feature/conflict
echo "feature 의 내용" > shared.txt
git add . && git commit -q -m "feat: update shared (feature)"

# main 브랜치: 같은 파일 다른 내용으로 수정
git switch main
echo "main 의 내용" > shared.txt
git add . && git commit -q -m "chore: update shared (main)"

echo "=== 충돌 발생 병합 시도 ==="
git merge feature/conflict 2>&1 || true

echo ""
echo "=== 충돌 마커 확인 ==="
cat shared.txt

echo ""
echo "=== 충돌 해결: main 버전 채택 ==="
echo "충돌 해결 완료 — main 버전" > shared.txt
git add shared.txt
git commit -m "merge: resolve conflict in shared.txt"

echo ""
echo "=== 최종 로그 ==="
git log --oneline --graph --all

rm -rf "$REPO"
