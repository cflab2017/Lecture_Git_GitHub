#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q -b main
git config user.name "개발자" && git config user.email "dev@example.com"
    git config commit.gpgsign false

echo "def app(): pass" > app.py
git add . && git commit -q -m "init"

echo "=== Issue 연동 커밋 메시지 예시 ==="
echo ""
echo "Issue #7: 로그인 시 빈 비밀번호 허용 버그"
echo ""

# fix/issue-7 브랜치에서 버그 수정
git switch -c fix/issue-7

cat > app.py << 'EOF'
def login(user, password):
    if not password:
        raise ValueError("Password cannot be empty")
    return True
EOF

git add .
git commit -m "fix: prevent empty password login

- 빈 비밀번호 입력 시 ValueError 발생
- 관련 테스트 케이스 추가 예정

Closes #7"

echo "=== 커밋 로그 ==="
git log --oneline

echo ""
echo "=== 최신 커밋 전체 메시지 ==="
git log -1 --format="%B"

echo ""
echo "=== GitHub UI에서의 자동 연동 ==="
echo "PR 설명 또는 커밋에 'Closes #7' 이 있으면"
echo "PR 병합 시 Issue #7 이 자동으로 닫힙니다."

rm -rf "$REPO"
