#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "관리자" && git config user.email "admin@example.com"
    git config commit.gpgsign false

mkdir -p .github src docs

cat > .github/CODEOWNERS << 'EOF'
*       @admin
src/    @backend
docs/   @writer
EOF

echo "def api(): pass" > src/api.py
echo "# API 문서" > docs/api.md

git add . && git commit -q -m "chore: initial project structure"

# Issue #12 수정
git switch -c fix/issue-12
echo "def api(version=1): pass" > src/api.py
git add .
git commit -m "fix: add version parameter to api

Closes #12"

echo "=== 커밋 메시지 ==="
git log -1 --format="%B"

echo "=== CODEOWNERS ==="
cat .github/CODEOWNERS

rm -rf "$REPO"
