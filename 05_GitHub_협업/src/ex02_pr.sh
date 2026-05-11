#!/usr/bin/env bash
set -euo pipefail

WORKDIR=$(mktemp -d)
git init --bare -b main "$WORKDIR/origin.git" -q

git clone "$WORKDIR/origin.git" "$WORKDIR/repo" -q
cd "$WORKDIR/repo"
git config user.name "개발자" && git config user.email "dev@example.com"
    git config commit.gpgsign false

echo "# 앱" > README.md
echo "def main(): pass" > app.py
git add . && git commit -q -m "init: project setup"
git push origin main -q

# PR 흐름: feature 브랜치 작성 → push → 병합
git switch -c feature/login
cat >> app.py << 'EOF'

def login(user, password):
    # 로그인 처리
    return user == "admin"
EOF
git add . && git commit -q -m "feat: implement login function

Closes #3"
git push origin feature/login -q

echo "=== PR 대상 브랜치 상태 ==="
git log --oneline --graph --all

# 리뷰 후 main 으로 병합 (--no-ff 로 병합 커밋 생성)
git switch main
git merge --no-ff feature/login -m "merge: PR#1 — feat: implement login"
git push origin main -q

echo ""
echo "=== PR 병합 후 로그 ==="
git log --oneline --graph

# 병합된 브랜치 정리
git branch -d feature/login
git push origin --delete feature/login -q
echo ""
echo "feature/login 브랜치 삭제 완료"

rm -rf "$WORKDIR"
