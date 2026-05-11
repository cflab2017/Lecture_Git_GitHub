# 01. 시작하기

버전 관리 없이 코드를 수정하면 "최최최최종.zip"처럼 파일이 쌓이는 경험을 누구나 해 봤을 것입니다.
Git은 변경 이력을 스냅샷으로 저장해 언제든 과거로 돌아갈 수 있게 해 주는 도구이며,
GitHub는 이 이력을 인터넷에 올려 여러 사람이 함께 작업할 수 있게 해 주는 플랫폼입니다.

## 학습 목표

- Git을 설치하고 `user.name`·`user.email`을 전역으로 설정할 수 있다.
- `git init`으로 새 저장소를 만들고 첫 번째 커밋을 남길 수 있다.
- `git status`·`git log`·`git show`로 저장소 상태를 확인할 수 있다.
- GitHub 계정을 만들고 원격 저장소를 생성하는 흐름을 이해한다.

---

## 왜 Git인가

코드는 시간이 지나면서 계속 바뀝니다.
Git은 "무엇을, 언제, 왜 바꿨는지"를 커밋 단위로 기록하기 때문에
실수를 되돌리거나 두 가지 아이디어를 동시에 실험하는 일이 쉬워집니다.

---

## 핵심 개념

### 1) Git 설치

```bash
# macOS
brew install git

# Ubuntu / Debian
sudo apt update && sudo apt install git

# Windows — https://git-scm.com/download/win 에서 설치
```

설치 후 버전 확인:

```bash
git --version
# git version 2.44.0
```

### 2) 전역 사용자 설정

모든 커밋에 남는 작성자 정보를 설정합니다.

```bash
git config --global user.name  "홍길동"
git config --global user.email "gildong@example.com"

# 확인
git config --list --global
```

| 옵션 | 범위 |
|------|------|
| `--global` | 현재 사용자의 모든 저장소 |
| `--local` | 현재 저장소만 (`.git/config`) |
| `--system` | 시스템 전체 |

### 3) 저장소 초기화 (`git init`)

```bash
mkdir my-project
cd my-project
git init
# Initialized empty Git repository in .../my-project/.git/
```

`.git/` 폴더가 생기면 Git이 이 디렉토리를 관리하기 시작합니다.

### 4) 첫 번째 커밋

```
워킹 디렉토리 → (git add) → 스테이징 영역 → (git commit) → 저장소
```

```bash
echo "# My Project" > README.md
git add README.md
git commit -m "docs: add README"
```

### 5) 세 가지 영역

| 영역 | 설명 |
|------|------|
| 워킹 디렉토리 | 실제 파일이 있는 곳 |
| 스테이징 영역 | 커밋할 변경을 모아두는 임시 공간 |
| 저장소(`.git`) | 커밋 스냅샷이 영구 저장되는 곳 |

---

## 예제로 보기

### 예제 1 — `ex01_setup.sh` : Git 버전 확인 및 사용자 설정 출력

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "=== Git 버전 확인 ==="
git --version

echo ""
echo "=== 현재 전역 사용자 설정 ==="
git config --global user.name  || echo "(user.name 미설정)"
git config --global user.email || echo "(user.email 미설정)"
```

**실행 결과**

```
=== Git 버전 확인 ===
git version 2.44.0

=== 현재 전역 사용자 설정 ===
홍길동
gildong@example.com
```

핵심: `git config --global`로 저장된 값을 언제든 조회할 수 있다.

---

### 예제 2 — `ex02_init.sh` : 임시 디렉토리에서 저장소 초기화 후 첫 커밋

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
echo "작업 디렉토리: $REPO"
cd "$REPO"

git init
git config user.name  "실습용"
git config user.email "demo@example.com"

echo "# Hello Git" > README.md
git add README.md
git commit -m "chore: initial commit"

echo ""
echo "=== 커밋 목록 ==="
git log --oneline
```

**실행 결과**

```
작업 디렉토리: /tmp/tmp.XyZ123
Initialized empty Git repository in /tmp/tmp.XyZ123/.git/
[main (root-commit) a1b2c3d] chore: initial commit
 1 file changed, 1 insertion(+)
 create mode 100644 README.md

=== 커밋 목록 ===
a1b2c3d chore: initial commit
```

핵심: `git init` → `git add` → `git commit` 세 단계가 Git의 기본 사이클이다.

---

### 예제 3 — `ex03_status.sh` : 워킹 디렉토리·스테이징·커밋 상태 관찰

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q
git config user.name "실습용" && git config user.email "demo@example.com"

echo "파일1" > a.txt
echo "[1] 파일 추가 후 status"
git status

git add a.txt
echo ""
echo "[2] git add 후 status"
git status

git commit -q -m "add a.txt"
echo ""
echo "[3] 커밋 후 status"
git status
```

**실행 결과**

```
[1] 파일 추가 후 status
On branch main
Untracked files:
  a.txt

[2] git add 후 status
On branch main
Changes to be committed:
  new file:   a.txt

[3] 커밋 후 status
On branch main
nothing to commit, working tree clean
```

핵심: `git status`는 세 영역 중 파일이 어디에 있는지 알려 준다.

---

### 예제 4 — `ex04_inspect.sh` : 커밋 로그와 내용 확인

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO=$(mktemp -d)
cd "$REPO"
git init -q
git config user.name "실습용" && git config user.email "demo@example.com"

echo "첫 번째 내용" > file.txt
git add file.txt && git commit -q -m "feat: first file"

echo "두 번째 줄 추가" >> file.txt
git add file.txt && git commit -q -m "feat: add second line"

echo "=== git log --oneline ==="
git log --oneline

echo ""
echo "=== git show HEAD ==="
git show HEAD
```

**실행 결과**

```
=== git log --oneline ===
b2c3d4e feat: add second line
a1b2c3d feat: first file

=== git show HEAD ===
commit b2c3d4e...
Author: 실습용 <demo@example.com>
Date:   ...

    feat: add second line

diff --git a/file.txt b/file.txt
...
+두 번째 줄 추가
```

핵심: `git log`는 역순 커밋 목록, `git show HEAD`는 최신 커밋의 diff를 보여 준다.

---

## 다른 시각으로 보기

| Git 개념 | 일상 비유 |
|----------|----------|
| 저장소 | 사진첩 |
| 커밋 | 한 장의 사진 |
| 스테이징 영역 | 인화 대기 트레이 |
| `git add` | 트레이에 사진 올리기 |
| `git commit` | 사진첩에 붙이기 |

---

## 자주 하는 실수

1. **`git add` 없이 `git commit`** — 스테이징에 아무것도 없어 "nothing to commit" 오류가 난다.
2. **user.name/email 미설정** — 커밋 시 "Please tell me who you are" 오류가 발생한다.
3. **`git init`을 홈 디렉토리에서 실행** — 모든 파일이 추적 대상이 되어 `.git`이 거대해진다.
4. **커밋 메시지를 비워두기** — `-m` 없이 실행하면 에디터가 열리고 빈 메시지로 저장 시 커밋이 취소된다.
5. **`--global`과 `--local` 혼동** — 회사 PC에서 개인 이메일로 커밋되는 문제가 생길 수 있다.

---

## 정리

- `git config --global user.name/email` 로 작성자를 등록한다.
- `git init` → `git add` → `git commit` 이 기본 사이클이다.
- `git status`로 세 영역의 상태를, `git log`로 커밋 이력을 확인한다.
- `git show <커밋>` 으로 특정 커밋의 변경 내용을 볼 수 있다.

---

## 직접 해 보기

```bash
cd 01_시작하기/src
chmod +x ex01_*.sh ex02_*.sh ex03_*.sh ex04_*.sh
./ex01_setup.sh
./ex02_init.sh
./ex03_status.sh
./ex04_inspect.sh
```

응용:
1. `git config --global core.editor "vim"` 으로 에디터를 변경해 보세요.
2. `git log --oneline --graph --all` 옵션을 추가해 그래프 형태로 출력해 보세요.

---

## 다음 단원

[02_일상_작업](../02_일상_작업/) — 매일 쓰는 add·commit·log·diff와 .gitignore·alias 설정
