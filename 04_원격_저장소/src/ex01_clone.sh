#!/usr/bin/env bash
set -euo pipefail

WORKDIR=$(mktemp -d)
echo "작업 디렉토리: $WORKDIR"

# 원격 역할의 bare 저장소 생성
git init --bare -b main "$WORKDIR/remote.git" -q
echo "bare 저장소 생성 완료"

# 최초 커밋 (local_a 에서 push)
git clone "$WORKDIR/remote.git" "$WORKDIR/local_a" -q
cd "$WORKDIR/local_a"
git config user.name "작업자A" && git config user.email "a@example.com"
    git config commit.gpgsign false
echo "# 원격 저장소 실습" > README.md
git add . && git commit -q -m "docs: initial README"
git push -u origin main -q
echo "local_a 에서 push 완료"

# local_b 에서 clone
echo ""
echo "=== git clone ==="
git clone "$WORKDIR/remote.git" "$WORKDIR/local_b"

cd "$WORKDIR/local_b"
echo ""
echo "=== clone 후 로그 ==="
git log --oneline

echo ""
echo "=== remote 확인 ==="
git remote -v

rm -rf "$WORKDIR"
