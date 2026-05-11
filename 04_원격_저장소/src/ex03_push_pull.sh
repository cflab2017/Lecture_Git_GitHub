#!/usr/bin/env bash
set -euo pipefail

WORKDIR=$(mktemp -d)

git init --bare -b main "$WORKDIR/remote.git" -q

setup_repo() {
    local path="$1" name="$2" email="$3"
    git clone "$WORKDIR/remote.git" "$path" -q
    git -C "$path" config user.name "$name"
    git -C "$path" config user.email "$email"
    git -C "$path" config commit.gpgsign false
}

# 저장소 A: 초기 커밋 + push
setup_repo "$WORKDIR/repo_a" "작업자A" "a@example.com"
cd "$WORKDIR/repo_a"
echo "A의 첫 커밋" > a.txt
git add . && git commit -q -m "feat: A's first commit"
git push origin main -q
echo "A → push 완료"

# 저장소 B: B에서 커밋 추가 + push
setup_repo "$WORKDIR/repo_b" "작업자B" "b@example.com"
cd "$WORKDIR/repo_b"
git pull origin main -q
echo "B의 커밋" > b.txt
git add . && git commit -q -m "feat: B's commit"
git push origin main -q
echo "B → push 완료"

# 저장소 A: pull 해서 B의 변경 받기
cd "$WORKDIR/repo_a"
echo ""
echo "=== A가 pull 전 로그 ==="
git log --oneline

git pull origin main -q
echo ""
echo "=== A가 pull 후 로그 (B의 커밋이 포함됨) ==="
git log --oneline

rm -rf "$WORKDIR"
