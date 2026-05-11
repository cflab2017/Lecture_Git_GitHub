# 05. GitHub 협업

오픈 소스 프로젝트에 기여하거나 팀 프로젝트를 진행할 때
fork·PR(Pull Request)·Issue·Code Review가 협업의 핵심 흐름입니다.
이 단원에서는 GitHub의 UI 중심 기능들을 이해하고,
브랜치 보호 규칙과 CODEOWNERS 설정으로 코드 품질을 지키는 방법을 배웁니다.

## 학습 목표

- fork → 브랜치 → PR 흐름을 설명하고 직접 수행할 수 있다.
- Issue를 활용해 작업을 계획하고 PR과 연결할 수 있다.
- Code Review에서 댓글을 달고 요청한 변경을 반영할 수 있다.
- 브랜치 보호 규칙으로 main 브랜치를 직접 push로부터 보호할 수 있다.
- CODEOWNERS 파일로 특정 파일/디렉토리의 리뷰어를 자동 지정할 수 있다.

---

## 핵심 개념

### 1) Fork & PR 흐름

```
원본 저장소 (upstream)
    ↓  fork
내 저장소 (origin)
    ↓  clone
로컬 작업
    ↓  git switch -c feature/xxx
    ↓  커밋
    ↓  git push origin feature/xxx
GitHub UI에서 PR 생성
    ↓  upstream main ← feature/xxx
코드 리뷰 → 승인 → Merge
```

### 2) Issue 작성 및 PR 연결

Issue 번호(예: #42)를 PR 설명이나 커밋 메시지에 포함하면 자동 연결됩니다.

```
# PR 설명 예시
Closes #42

# 커밋 메시지 예시
fix: resolve login error (#42)
```

`Closes`, `Fixes`, `Resolves` 키워드 사용 시 PR 병합 시 Issue 자동 닫힘.

### 3) Code Review 단어 모음

| 약어 | 의미 |
|------|------|
| LGTM | Looks Good To Me (승인) |
| nit  | 사소한 개선 제안 |
| RFC  | Request for Comments |
| WIP  | Work In Progress |
| NB   | Nota Bene (주목) |

### 4) 브랜치 보호 규칙

GitHub 저장소 → Settings → Branches → Add rule

```
Branch name pattern: main
✅ Require a pull request before merging
✅ Require approvals: 1
✅ Dismiss stale pull request approvals
✅ Require status checks to pass
✅ Restrict who can push to matching branches
```

### 5) CODEOWNERS

`.github/CODEOWNERS` 파일:

```
# 전체 저장소 기본 소유자
*   @username

# docs 디렉토리는 technical-writers 팀
docs/   @org/technical-writers

# 보안 관련 파일
security.md   @security-team
```

---

## 예제로 보기

### 예제 1 — `ex01_fork.sh` : fork 워크플로우 시뮬레이션 (bare 저장소 사용)

```bash
#!/usr/bin/env bash
# GitHub fork 는 UI 작업이므로 로컬 bare 저장소로 흐름을 시뮬레이션합니다.
WORKDIR=$(mktemp -d)

git init --bare "$WORKDIR/upstream.git" -q
git init --bare "$WORKDIR/fork.git" -q       # 내 fork 역할

# upstream 초기화
git clone "$WORKDIR/upstream.git" "$WORKDIR/upstream_local" -q
cd "$WORKDIR/upstream_local"
git config user.name "메인테이너" && git config user.email "main@example.com"
echo "# 프로젝트" > README.md
git add . && git commit -q -m "init"
git push origin main -q

# fork 로 동기화 (GitHub의 fork = upstream clone push)
git clone "$WORKDIR/upstream.git" "$WORKDIR/my_fork" -q
cd "$WORKDIR/my_fork"
git config user.name "기여자" && git config user.email "contrib@example.com"
git remote add upstream "$WORKDIR/upstream.git"

# 기능 브랜치에서 작업
git switch -c feature/add-docs
echo "## 사용법" >> README.md
git add . && git commit -q -m "docs: add usage section"

echo "=== feature 브랜치 로그 ==="
git log --oneline --graph --all

rm -rf "$WORKDIR"
```

**실행 결과**

```
=== feature 브랜치 로그 ===
* a1b2c3d (HEAD -> feature/add-docs) docs: add usage section
* b2c3d4e (origin/main, main) init
```

핵심: fork 후 기능 브랜치에서 작업하고 PR로 upstream에 기여하는 것이 오픈 소스 흐름이다.

---

### 예제 2 — `ex02_pr.sh` : PR 시뮬레이션 (로컬 병합으로 대체)

```bash
#!/usr/bin/env bash
WORKDIR=$(mktemp -d)
git init --bare "$WORKDIR/origin.git" -q

git clone "$WORKDIR/origin.git" "$WORKDIR/repo" -q
cd "$WORKDIR/repo"
git config user.name "개발자" && git config user.email "dev@example.com"
echo "메인 기능" > main.py && git add . && git commit -q -m "init"
git push origin main -q

git switch -c feature/login
echo "def login(): pass" >> main.py
git add . && git commit -q -m "feat: add login function"
git push origin feature/login -q

echo "=== PR 시뮬레이션: feature/login → main 병합 ==="
git switch main
git merge --no-ff feature/login -m "merge: PR#1 add login function"
git push origin main -q

echo ""
echo "=== 병합 후 로그 ==="
git log --oneline --graph

rm -rf "$WORKDIR"
```

**실행 결과**

```
=== PR 시뮬레이션: feature/login → main 병합 ===

=== 병합 후 로그 ===
*   c3d4e5f merge: PR#1 add login function
|\
| * b2c3d4e feat: add login function
|/
* a1b2c3d init
```

핵심: PR은 브랜치를 직접 push하지 않고 리뷰 후 병합하는 안전 장치다.

---

### 예제 3 — `ex03_issue.sh` : Issue 번호를 커밋 메시지에 연결

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d)
cd "$REPO"
git init -q
git config user.name "개발자" && git config user.email "dev@example.com"

echo "앱 코드" > app.py && git add . && git commit -q -m "init"

# Issue #7: 로그인 버그 수정
git switch -c fix/issue-7
echo "# 버그 수정됨" >> app.py
git add .
git commit -m "fix: resolve login error

Closes #7"

echo "=== 커밋 메시지 확인 ==="
git log --oneline -n 1
git show HEAD --format="%B" --no-patch

rm -rf "$REPO"
```

**실행 결과**

```
=== 커밋 메시지 확인 ===
a1b2c3d fix: resolve login error

fix: resolve login error

Closes #7
```

핵심: `Closes #N` 을 PR 설명에 쓰면 병합 시 Issue가 자동으로 닫힌다.

---

### 예제 4 — `ex04_codeowners.sh` : CODEOWNERS 파일 생성

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d)
cd "$REPO"
git init -q
git config user.name "관리자" && git config user.email "admin@example.com"

mkdir -p .github docs src

cat > .github/CODEOWNERS << 'EOF'
# 기본 소유자: 모든 파일
*   @admin-user

# 문서 디렉토리
docs/   @tech-writer

# 소스 코드
src/    @backend-team

# CI/CD 설정
.github/workflows/   @devops-team
EOF

echo "앱 코드" > src/app.py
echo "문서" > docs/guide.md

git add .
git commit -m "chore: add CODEOWNERS and project structure"

echo "=== CODEOWNERS 내용 ==="
cat .github/CODEOWNERS

rm -rf "$REPO"
```

**실행 결과**

```
=== CODEOWNERS 내용 ===
# 기본 소유자: 모든 파일
*   @admin-user
...
```

핵심: CODEOWNERS는 PR 생성 시 지정된 팀/개인을 리뷰어로 자동 요청한다.

---

## 다른 시각으로 보기

| GitHub 기능 | 비유 |
|-------------|------|
| Issue | 할 일 메모 |
| PR | 상사에게 결재 요청 |
| Code Review | 결재 검토 |
| LGTM / Approve | 결재 도장 |
| Merge | 공식 반영 |
| CODEOWNERS | 부서별 담당자 목록 |

---

## 자주 하는 실수

1. **PR 없이 main에 직접 push** — 브랜치 보호 규칙이 없으면 팀원 리뷰를 건너뛰게 된다.
2. **Issue 없이 PR 생성** — 왜 이 작업이 필요한지 맥락이 없어 리뷰가 어렵다.
3. **PR 설명에 `Closes #N` 생략** — Issue가 자동으로 닫히지 않아 관리가 번거로워진다.
4. **fork 저장소에서 upstream 동기화 생략** — upstream 변경이 없어 충돌이 커진다.
5. **리뷰 댓글을 모두 Resolve 안 하고 Merge** — 해결되지 않은 피드백이 코드에 남는다.

---

## 정리

- fork → 기능 브랜치 → PR → 리뷰 → Merge 가 팀 협업의 표준 흐름이다.
- Issue와 PR을 `Closes #N`으로 연결하면 작업 추적이 자동화된다.
- 브랜치 보호 규칙으로 main 직접 push를 막고, 최소 리뷰어 수를 강제한다.
- CODEOWNERS 로 파일/디렉토리별 책임자를 지정해 자동 리뷰 요청을 받는다.

---

## 직접 해 보기

```bash
cd 05_GitHub_협업/src
chmod +x *.sh
./ex01_fork.sh
./ex02_pr.sh
./ex03_issue.sh
./ex04_codeowners.sh
```

응용:
1. 실제 GitHub 저장소를 fork해서 오타 수정 PR을 올려 보세요.
2. Issue 템플릿(`.github/ISSUE_TEMPLATE/`)을 만들어 버그 리포트 양식을 만들어 보세요.

---

## 다음 단원

[06_취소와_되돌리기](../06_취소와_되돌리기/) — reset·revert·restore·reflog·stash
