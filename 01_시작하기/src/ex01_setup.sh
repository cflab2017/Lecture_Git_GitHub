#!/usr/bin/env bash
set -euo pipefail

echo "=== Git 버전 확인 ==="
git --version

echo ""
echo "=== 현재 전역 사용자 설정 ==="
NAME=$(git config --global user.name 2>/dev/null || true)
EMAIL=$(git config --global user.email 2>/dev/null || true)

if [ -z "$NAME" ]; then
    echo "user.name: (미설정)"
else
    echo "user.name: $NAME"
fi

if [ -z "$EMAIL" ]; then
    echo "user.email: (미설정)"
else
    echo "user.email: $EMAIL"
fi

echo ""
echo "=== 설정 방법 안내 ==="
echo "  git config --global user.name  \"홍길동\""
echo "  git config --global user.email \"gildong@example.com\""
