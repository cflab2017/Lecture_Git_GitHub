#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "실습용" && git config user.email "demo@example.com"
    git config commit.gpgsign false

echo "원본 내용" > file.txt
git add . && git commit -q -m "init"

# 수정 + 스테이징
echo "수정된 내용" > file.txt
git add file.txt

echo "[1] 수정 + 스테이징 후 status"
git status --short
echo "파일 내용: $(cat file.txt)"

# 스테이징만 취소 (워킹 디렉토리는 유지)
git restore --staged file.txt
echo ""
echo "[2] restore --staged 후 (unstaged, 내용 유지)"
git status --short
echo "파일 내용: $(cat file.txt)"

# 워킹 디렉토리도 취소
git restore file.txt
echo ""
echo "[3] restore 후 (clean, 원본으로 복원)"
git status --short
echo "파일 내용: $(cat file.txt)"

echo ""
echo "=== 새 파일에 restore 적용 불가 예시 ==="
echo "신규 파일" > newfile.txt
git restore newfile.txt 2>&1 || echo "→ untracked 파일은 restore 불가 (rm 으로 삭제)"

rm -rf "$REPO"
