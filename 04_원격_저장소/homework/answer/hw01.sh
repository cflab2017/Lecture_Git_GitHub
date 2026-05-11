#!/usr/bin/env bash
set -euo pipefail

WORKDIR=$(mktemp -d)

git init --bare -b main "$WORKDIR/remote.git" -q

# repo_a
git clone "$WORKDIR/remote.git" "$WORKDIR/repo_a" -q
git -C "$WORKDIR/repo_a" config user.name "작업자A"
git -C "$WORKDIR/repo_a" config user.email "a@example.com"
git -C "$WORKDIR/repo_a" config commit.gpgsign false
echo "A의 파일" > "$WORKDIR/repo_a/a.txt"
git -C "$WORKDIR/repo_a" add .
git -C "$WORKDIR/repo_a" commit -q -m "feat: A's file"
git -C "$WORKDIR/repo_a" push origin main -q
echo "repo_a push 완료"

# repo_b: clone 후 A의 커밋 확인
git clone "$WORKDIR/remote.git" "$WORKDIR/repo_b" -q
git -C "$WORKDIR/repo_b" config user.name "작업자B"
git -C "$WORKDIR/repo_b" config user.email "b@example.com"
git -C "$WORKDIR/repo_b" config commit.gpgsign false

echo ""
echo "=== repo_b 에서 로그 (A의 커밋이 보여야 함) ==="
git -C "$WORKDIR/repo_b" log --oneline

echo "B의 파일" > "$WORKDIR/repo_b/b.txt"
git -C "$WORKDIR/repo_b" add .
git -C "$WORKDIR/repo_b" commit -q -m "feat: B's file"
git -C "$WORKDIR/repo_b" push origin main -q
echo "repo_b push 완료"

# repo_a: fetch + merge
git -C "$WORKDIR/repo_a" fetch origin -q
echo ""
echo "=== repo_a fetch + merge 후 ==="
git -C "$WORKDIR/repo_a" merge origin/main -q
git -C "$WORKDIR/repo_a" log --oneline

rm -rf "$WORKDIR"
