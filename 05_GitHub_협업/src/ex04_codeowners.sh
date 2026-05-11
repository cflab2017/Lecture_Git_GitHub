#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "관리자" && git config user.email "admin@example.com"
    git config commit.gpgsign false

mkdir -p .github/workflows docs src/backend src/frontend

cat > .github/CODEOWNERS << 'EOF'
# CODEOWNERS — PR 생성 시 자동으로 리뷰어를 지정합니다.

# 기본: 모든 파일
*   @admin-user

# 문서
docs/   @tech-writer @admin-user

# 백엔드 소스
src/backend/   @backend-team

# 프론트엔드 소스
src/frontend/  @frontend-team

# CI/CD 워크플로우 — 보안상 DevOps 팀만
.github/workflows/   @devops-team
EOF

echo "백엔드" > src/backend/server.py
echo "프론트엔드" > src/frontend/index.html
echo "문서" > docs/guide.md
echo "Hello" > .github/workflows/ci.yml

git add .
git commit -m "chore: add CODEOWNERS and project skeleton"

echo "=== CODEOWNERS 파일 ==="
cat .github/CODEOWNERS

echo ""
echo "=== 저장소 파일 구조 ==="
git ls-files

rm -rf "$REPO"
