#!/usr/bin/env bash
set -euo pipefail

WORKDIR=$(mktemp -d)
echo "작업 디렉토리: $WORKDIR"

# upstream 역할 bare 저장소
git init --bare -b main "$WORKDIR/upstream.git" -q

# upstream 초기화
git clone "$WORKDIR/upstream.git" "$WORKDIR/upstream_local" -q
cd "$WORKDIR/upstream_local"
git config user.name "메인테이너" && git config user.email "main@example.com"
    git config commit.gpgsign false
echo "# 오픈소스 프로젝트" > README.md
echo "기능 A" > feature_a.py
git add . && git commit -q -m "init: initial commit"
git push origin main -q
echo "upstream 초기화 완료"

# 기여자가 fork (= upstream 복제)
git clone "$WORKDIR/upstream.git" "$WORKDIR/my_fork" -q
cd "$WORKDIR/my_fork"
git config user.name "기여자" && git config user.email "contributor@example.com"
git remote add upstream "$WORKDIR/upstream.git"

echo ""
echo "=== fork 저장소의 remote 목록 ==="
git remote -v

# 기능 브랜치 생성 후 작업
git switch -c feature/improve-docs
echo "## 사용법" >> README.md
echo "1. 설치" >> README.md
git add . && git commit -q -m "docs: add usage section (#1)"

echo ""
echo "=== 기여자 브랜치 로그 ==="
git log --oneline --graph --all

echo ""
echo "=== (GitHub UI에서는 여기서 PR을 생성합니다) ==="
echo "git push origin feature/improve-docs"
echo "→ GitHub에서 upstream:main ← origin:feature/improve-docs 로 PR 생성"

rm -rf "$WORKDIR"
