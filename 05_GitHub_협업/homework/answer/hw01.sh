#!/usr/bin/env bash
set -euo pipefail

WORKDIR=$(mktemp -d)

git init --bare -b main "$WORKDIR/upstream.git" -q

# upstream 초기화
git clone "$WORKDIR/upstream.git" "$WORKDIR/upstream_local" -q
git -C "$WORKDIR/upstream_local" config user.name "메인테이너"
git -C "$WORKDIR/upstream_local" config user.email "main@example.com"
git -C "$WORKDIR/upstream_local" config commit.gpgsign false
echo "# 프로젝트" > "$WORKDIR/upstream_local/README.md"
git -C "$WORKDIR/upstream_local" add .
git -C "$WORKDIR/upstream_local" commit -q -m "init"
git -C "$WORKDIR/upstream_local" push origin main -q

# fork
git clone "$WORKDIR/upstream.git" "$WORKDIR/my_fork" -q
git -C "$WORKDIR/my_fork" config user.name "기여자"
git -C "$WORKDIR/my_fork" config user.email "contrib@example.com"
git -C "$WORKDIR/my_fork" config commit.gpgsign false
git -C "$WORKDIR/my_fork" remote add upstream "$WORKDIR/upstream.git"

cd "$WORKDIR/my_fork"
git switch -c feature/new-page
echo "# 새 페이지" > new_page.md
git add . && git commit -q -m "docs: add new page"

# upstream에 직접 push (fork 시뮬레이션)
git push upstream feature/new-page -q

# upstream에서 PR 병합
cd "$WORKDIR/upstream_local"
git fetch origin -q
git merge --no-ff origin/feature/new-page -m "merge: PR — add new page"

echo "=== 최종 이력 ==="
git log --oneline --graph --all

rm -rf "$WORKDIR"
