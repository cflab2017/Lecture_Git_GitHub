#!/usr/bin/env bash
set -euo pipefail

# 전역 user.name · user.email 설정 후 확인
git config --global user.name  "홍길동"
git config --global user.email "gildong@example.com"

echo "=== 전역 Git 설정 확인 ==="
git config --list --global | grep -E "^user\."
