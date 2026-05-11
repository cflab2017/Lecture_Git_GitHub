# 04. 원격 저장소

로컬 Git은 혼자만의 버전 관리입니다.
GitHub 같은 원격 저장소를 연결하면 코드를 안전하게 백업하고,
어디서든 내려받을 수 있으며, 팀원과 함께 작업할 수 있습니다.
이 단원에서는 `clone`, `push`, `pull`, `fetch`의 차이를 명확히 구분하고
PAT(Personal Access Token)와 SSH 키 인증까지 설정합니다.

## 학습 목표

- `git clone`으로 원격 저장소를 복제할 수 있다.
- `git push`·`git pull`·`git fetch`의 동작 차이를 설명할 수 있다.
- `git remote add/rename/remove`로 원격 연결을 관리할 수 있다.
- GitHub PAT 또는 SSH 키로 인증을 설정할 수 있다.
- 로컬 브랜치와 원격 브랜치(`origin/main`)의 관계를 이해한다.

---

## 핵심 개념

### 1) git clone

```bash
git clone https://github.com/user/repo.git         # HTTPS
git clone git@github.com:user/repo.git             # SSH
git clone https://github.com/user/repo.git mydir   # 다른 이름으로
git clone --depth=1 https://github.com/user/repo.git  # 얕은 복제
```

### 2) push / pull / fetch

```
로컬                    원격(origin)
main ──push──▶  origin/main
main ◀──pull──  origin/main  (fetch + merge)
     ──fetch──▶ origin/main  (로컬 브랜치에 영향 없음)
```

```bash
git push origin main          # 로컬 main → 원격 main
git push -u origin main       # 업스트림 설정 후 push (이후 git push 만으로 가능)
git pull origin main          # fetch + merge
git fetch origin              # 원격 정보만 업데이트, 병합 안 함
git fetch origin main         # 특정 브랜치만
```

### 3) remote 관리

```bash
git remote -v                     # 원격 목록 + URL 확인
git remote add origin URL         # 원격 추가
git remote rename origin upstream # 이름 변경
git remote remove origin          # 원격 삭제
git remote set-url origin NEW_URL # URL 변경
```

### 4) 원격 브랜치 추적

```bash
git branch -vv              # 로컬 브랜치와 원격 추적 브랜치 확인
git switch -c feature origin/feature  # 원격 브랜치를 로컬로 체크아웃
git push origin --delete feature      # 원격 브랜치 삭제
```

### 5) 자격증명 설정

**PAT (Personal Access Token) — HTTPS 방식**

```bash
# GitHub → Settings → Developer settings → Personal access tokens → Generate
# 클론/push 시 비밀번호 대신 토큰 입력
git config --global credential.helper store  # 저장 (평문 주의)
```

**SSH 키 방식**

```bash
ssh-keygen -t ed25519 -C "your@email.com"   # 키 생성
cat ~/.ssh/id_ed25519.pub                    # 공개 키 복사
# GitHub → Settings → SSH and GPG keys → New SSH key
ssh -T git@github.com                        # 연결 테스트
```

---

## 예제로 보기

### 예제 1 — `ex01_clone.sh` : 로컬 bare 저장소를 clone 해 두 저장소 시뮬레이션

```bash
#!/usr/bin/env bash
# GitHub 실습은 네트워크가 필요하므로 로컬 bare 저장소로 시뮬레이션합니다.
WORKDIR=$(mktemp -d)
cd "$WORKDIR"

# "원격" 역할의 bare 저장소 생성
git init --bare remote.git
echo "bare 저장소 생성: $WORKDIR/remote.git"

# 로컬 작업 저장소 생성 후 push
git init local_a
cd local_a
git config user.name "작업자A" && git config user.email "a@example.com"
echo "Hello" > README.md
git add . && git commit -q -m "init"
git remote add origin "$WORKDIR/remote.git"
git push -u origin main

echo ""
echo "=== clone ==="
cd "$WORKDIR"
git clone remote.git local_b
cd local_b
git log --oneline

rm -rf "$WORKDIR"
```

**실행 결과**

```
bare 저장소 생성: /tmp/tmp.XXX/remote.git

=== clone ===
Cloning into 'local_b'...
a1b2c3d init
```

핵심: `git clone`은 원격 저장소의 전체 이력을 복사하고 `origin` 원격을 자동 설정한다.

---

### 예제 2 — `ex02_remote.sh` : remote 추가·확인·변경

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d)
cd "$REPO"
git init -q
git config user.name "실습용" && git config user.email "demo@example.com"

echo "=== remote 추가 ==="
git remote add origin https://github.com/example/repo.git
git remote add upstream https://github.com/original/repo.git

echo ""
echo "=== remote 목록 ==="
git remote -v

echo ""
echo "=== origin URL 변경 ==="
git remote set-url origin https://github.com/example/new-repo.git
git remote -v

echo ""
echo "=== upstream 제거 ==="
git remote remove upstream
git remote -v

rm -rf "$REPO"
```

**실행 결과**

```
=== remote 추가 ===

=== remote 목록 ===
origin    https://github.com/example/repo.git (fetch)
origin    https://github.com/example/repo.git (push)
upstream  https://github.com/original/repo.git (fetch)
...

=== origin URL 변경 ===
origin    https://github.com/example/new-repo.git (fetch)
...
```

핵심: `git remote -v` 로 연결된 모든 원격 저장소와 URL을 확인할 수 있다.

---

### 예제 3 — `ex03_push_pull.sh` : 로컬 bare 저장소로 push/pull 시뮬레이션

```bash
#!/usr/bin/env bash
WORKDIR=$(mktemp -d)

git init --bare "$WORKDIR/remote.git" -q

# 저장소 A
git clone "$WORKDIR/remote.git" "$WORKDIR/repo_a" -q
cd "$WORKDIR/repo_a"
git config user.name "작업자A" && git config user.email "a@example.com"
echo "A의 파일" > a.txt
git add . && git commit -q -m "feat: A adds file"
git push origin main -q

# 저장소 B
git clone "$WORKDIR/remote.git" "$WORKDIR/repo_b" -q
cd "$WORKDIR/repo_b"
git config user.name "작업자B" && git config user.email "b@example.com"

echo "=== B에서 pull 전 로그 ==="
git log --oneline

git pull origin main -q
echo ""
echo "=== B에서 pull 후 로그 ==="
git log --oneline

rm -rf "$WORKDIR"
```

**실행 결과**

```
=== B에서 pull 전 로그 ===
(없음)

=== B에서 pull 후 로그 ===
a1b2c3d feat: A adds file
```

핵심: `git pull`은 `fetch` + `merge`를 한 번에 수행한다.

---

### 예제 4 — `ex04_credentials.sh` : SSH 키 생성 및 안내

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "=== SSH 키 생성 방법 안내 ==="
echo ""
echo "1. 키 생성:"
echo "   ssh-keygen -t ed25519 -C \"your@email.com\""
echo ""
echo "2. 공개 키 확인:"
echo "   cat ~/.ssh/id_ed25519.pub"
echo ""
echo "3. GitHub 등록:"
echo "   GitHub → Settings → SSH and GPG keys → New SSH key"
echo "   위에서 복사한 공개 키 붙여넣기"
echo ""
echo "4. 연결 테스트:"
echo "   ssh -T git@github.com"
echo "   # Hi username! You've successfully authenticated..."
echo ""

if [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
    echo "=== 현재 공개 키 ==="
    cat "$HOME/.ssh/id_ed25519.pub"
else
    echo "(~/.ssh/id_ed25519.pub 파일이 없습니다. 위 1번 명령으로 생성하세요)"
fi
```

**실행 결과**

```
=== SSH 키 생성 방법 안내 ===
1. 키 생성: ssh-keygen -t ed25519 ...
...
(~/.ssh/id_ed25519.pub 파일이 없습니다. 위 1번 명령으로 생성하세요)
```

핵심: SSH 키 방식은 매번 PAT를 입력할 필요 없이 안전하게 인증할 수 있다.

---

## 다른 시각으로 보기

| Git 명령 | 비유 |
|----------|------|
| `git clone` | 원본 문서를 USB에 복사 |
| `git push` | 내 수정본을 서버에 업로드 |
| `git fetch` | 서버 변경 내역을 미리보기 |
| `git pull` | 서버 변경 내역 받아서 즉시 적용 |
| `origin` | 내 저장소와 연결된 서버 별명 |

---

## 자주 하는 실수

1. **`git push` 실패 후 `--force` 남용** — 팀원의 커밋이 사라질 수 있다; `--force-with-lease`를 사용한다.
2. **`git pull` 대신 `git fetch` 잊기** — fetch 후 diff를 확인하면 예상치 못한 충돌을 줄일 수 있다.
3. **HTTPS URL에 비밀번호 사용** — 2021년 8월부터 GitHub는 비밀번호 인증을 지원하지 않는다; PAT 또는 SSH를 사용한다.
4. **원격 브랜치 삭제 후 로컬에 남은 추적 브랜치** — `git fetch --prune`으로 정리한다.
5. **`-u` 없이 첫 push** — 업스트림이 설정되지 않아 이후 `git push`가 동작하지 않는다.

---

## 정리

- `git clone URL`으로 원격 저장소를 복제하고 `origin`이 자동 설정된다.
- `git push -u origin <브랜치>`로 업스트림을 설정하면 이후 `git push`만 입력해도 된다.
- `git fetch`는 로컬 브랜치를 변경하지 않고, `git pull`은 fetch + merge를 한 번에 한다.
- SSH 키 방식이 HTTPS PAT보다 편리하고 안전하다.

---

## 직접 해 보기

```bash
cd 04_원격_저장소/src
chmod +x ex01_clone.sh ex02_remote.sh ex03_push_pull.sh ex04_credentials.sh
./ex01_clone.sh
./ex02_remote.sh
./ex03_push_pull.sh
./ex04_credentials.sh
```

응용:
1. `git fetch origin` 후 `git diff HEAD origin/main` 으로 원격과의 차이를 확인해 보세요.
2. `git push origin --delete <브랜치명>` 으로 원격 브랜치를 삭제해 보세요.

---

## 다음 단원

[05_GitHub_협업](../05_GitHub_협업/) — fork·PR·Issue·Review·CODEOWNERS
