# 02. 일상 작업

Git을 매일 사용하려면 `add`, `commit`, `log`, `diff` 네 명령을 손에 익혀야 합니다.
여기에 `.gitignore`로 추적에서 제외할 파일을 관리하고,
반복 명령을 `alias`로 단축하며, `HEAD`가 무엇을 가리키는지 이해하면
하루 종일 터미널을 떠나지 않아도 편안하게 작업할 수 있습니다.

## 학습 목표

- `git add`의 다양한 옵션(`-p`, `-u`, `.`)을 상황에 맞게 사용할 수 있다.
- `git log`의 형식 옵션(`--oneline`, `--graph`, `--since`)을 활용할 수 있다.
- `git diff`로 워킹 디렉토리·스테이징·커밋 간 차이를 비교할 수 있다.
- `.gitignore` 파일을 작성하고 이미 추적 중인 파일을 제외할 수 있다.
- 자주 쓰는 명령을 `git alias`로 등록하고 사용할 수 있다.
- `HEAD`, `HEAD~1`, `HEAD^` 표기법을 이해하고 활용할 수 있다.

---

## 핵심 개념

### 1) git add 옵션

```bash
git add .           # 현재 디렉토리 이하 모든 변경
git add -u          # 추적 중인 파일의 수정·삭제만 (새 파일 제외)
git add -p          # 변경 덩어리(hunk)를 하나씩 선택해서 스테이징
git add src/        # 특정 디렉토리만
```

### 2) git commit 옵션

```bash
git commit -m "메시지"         # 한 줄 메시지로 즉시 커밋
git commit                     # 에디터 열어 메시지 작성
git commit --amend             # 마지막 커밋 메시지 수정 (push 전에만)
git commit -am "메시지"        # add -u + commit 한 번에 (새 파일 제외)
```

### 3) git log 옵션

```bash
git log --oneline              # 한 줄 요약
git log --oneline --graph      # 브랜치 그래프
git log --since="2 weeks ago"  # 기간 필터
git log -n 5                   # 최근 5개만
git log --author="홍길동"      # 작성자 필터
git log -- src/main.py         # 특정 파일 이력
```

### 4) git diff

```bash
git diff                       # 워킹 디렉토리 vs 스테이징
git diff --staged              # 스테이징 vs 최신 커밋
git diff HEAD~1 HEAD           # 두 커밋 간 비교
git diff main feature          # 두 브랜치 비교
```

### 5) .gitignore

```
# 빌드 산출물
*.o
*.class
build/

# 환경 설정
.env
.env.local

# OS 메타파일
.DS_Store
Thumbs.db

# IDE
.idea/
.vscode/
```

이미 추적 중인 파일을 나중에 무시하려면:

```bash
git rm --cached 파일명
echo "파일명" >> .gitignore
git commit -m "chore: ignore 파일명"
```

### 6) git alias

```bash
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.lg "log --oneline --graph --all"
git config --global alias.aa "add --all"
```

이후 `git lg` 처럼 단축어로 사용.

### 7) HEAD 이해

```
HEAD → main → (최신 커밋 해시)
```

| 표기 | 의미 |
|------|------|
| `HEAD` | 현재 체크아웃된 커밋 |
| `HEAD~1` | 한 단계 이전 |
| `HEAD~2` | 두 단계 이전 |
| `HEAD^` | 첫 번째 부모 (`~1`과 동일) |

---

## 예제로 보기

### 예제 1 — `ex01_add_commit.sh` : add -p 로 부분 스테이징

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d); cd "$REPO"
git init -q
git config user.name "실습용" && git config user.email "demo@example.com"

echo -e "line1\nline2\nline3" > file.txt
git add file.txt && git commit -q -m "init"

# 여러 영역을 동시에 수정
echo "line4" >> file.txt          # 워킹 디렉토리 변경
git add file.txt                   # 스테이징

echo "line5" >> file.txt          # 스테이징 후 추가 변경

echo "=== diff (워킹 vs 스테이징) ==="
git diff

echo ""
echo "=== diff --staged (스테이징 vs HEAD) ==="
git diff --staged

rm -rf "$REPO"
```

**실행 결과**

```
=== diff (워킹 vs 스테이징) ===
+line5

=== diff --staged (스테이징 vs HEAD) ===
+line4
```

핵심: `git diff`와 `git diff --staged`는 서로 다른 비교 대상을 가진다.

---

### 예제 2 — `ex02_log_diff.sh` : 다양한 log 옵션 비교

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d); cd "$REPO"
git init -q
git config user.name "실습용" && git config user.email "demo@example.com"

for i in 1 2 3; do
    echo "v$i" > version.txt
    git add version.txt
    git commit -q -m "chore: version $i"
done

echo "=== --oneline ==="
git log --oneline

echo ""
echo "=== --oneline --stat ==="
git log --oneline --stat

echo ""
echo "=== -n 2 ==="
git log --oneline -n 2

rm -rf "$REPO"
```

**실행 결과**

```
=== --oneline ===
c3d4e5f chore: version 3
b2c3d4e chore: version 2
a1b2c3d chore: version 1

=== --oneline --stat ===
c3d4e5f chore: version 3
 version.txt | 2 +-
...
```

핵심: `git log`는 옵션 조합으로 원하는 수준의 정보를 선택적으로 볼 수 있다.

---

### 예제 3 — `ex03_gitignore.sh` : .gitignore 작성 및 캐시 제거

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d); cd "$REPO"
git init -q
git config user.name "실습용" && git config user.email "demo@example.com"

echo "secret" > .env
echo "code" > main.py
git add . && git commit -q -m "init: add files"

# 이제 .env 를 무시하고 싶을 때
echo ".env" > .gitignore
git rm --cached .env
git add .gitignore
git commit -m "chore: ignore .env"

echo "=== 추적 파일 목록 ==="
git ls-files

echo ""
echo "=== status ==="
git status

rm -rf "$REPO"
```

**실행 결과**

```
=== 추적 파일 목록 ===
.gitignore
main.py

=== status ===
On branch main
nothing to commit, working tree clean
```

핵심: `git rm --cached`는 파일을 디스크에서 삭제하지 않고 추적에서만 제외한다.

---

### 예제 4 — `ex04_alias.sh` : alias 등록 및 사용

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d); cd "$REPO"
git init -q
git config user.name "실습용" && git config user.email "demo@example.com"

# 로컬 저장소에만 alias 등록 (전역 설정 오염 방지)
git config alias.lg "log --oneline --graph --all"
git config alias.st "status --short"

echo "첫 파일" > a.txt
git add a.txt && git commit -q -m "first"

echo "=== git st (alias) ==="
git st

echo ""
echo "=== git lg (alias) ==="
git lg

rm -rf "$REPO"
```

**실행 결과**

```
=== git st (alias) ===
   (nothing)

=== git lg (alias) ===
* a1b2c3d first
```

핵심: `git config alias.<이름>`으로 복잡한 명령을 단축어로 만들 수 있다.

---

## 다른 시각으로 보기

| Git 명령 | 일상 비유 |
|----------|----------|
| `git add -p` | 장바구니에 상품 하나씩 담기 |
| `git commit` | 결제 완료 |
| `git log` | 영수증 목록 보기 |
| `git diff` | 주문 전후 가격 비교 |
| `.gitignore` | 쇼핑 금지 목록 |

---

## 자주 하는 실수

1. **`git add .` 으로 불필요한 파일까지 추가** — `.gitignore`를 먼저 설정하거나 `git add -p`를 사용한다.
2. **커밋 메시지 없이 `-m ""`** — 빈 메시지로 커밋하면 히스토리 파악이 어렵다.
3. **`--amend`로 push된 커밋 수정** — 강제 push가 필요해 팀원의 이력이 꼬인다.
4. **`.env` 파일을 실수로 커밋** — 민감 정보가 공개 저장소에 노출된다; 즉시 `git rm --cached`.
5. **`HEAD~1`과 `HEAD^1` 혼동** — 병합 커밋에서는 `^2`가 두 번째 부모를 가리킨다.

---

## 정리

- `git add -p`로 변경 덩어리를 선택해 커밋을 작게 유지한다.
- `git diff`는 워킹·스테이징 비교, `git diff --staged`는 스테이징·커밋 비교다.
- `.gitignore`에 패턴을 추가하고, 이미 추적된 파일은 `git rm --cached`로 제거한다.
- `alias`로 자주 쓰는 명령을 단축해 생산성을 높인다.
- `HEAD~N`으로 N단계 이전 커밋을 참조한다.

---

## 직접 해 보기

```bash
cd 02_일상_작업/src
chmod +x *.sh
./ex01_add_commit.sh
./ex02_log_diff.sh
./ex03_gitignore.sh
./ex04_alias.sh
```

응용:
1. `git log --since="1 week ago" --author="$(git config user.name)"` 로 내 최근 커밋을 필터링해 보세요.
2. `git config --global alias.undo "reset HEAD~1 --mixed"` 로 마지막 커밋을 되돌리는 alias를 만들어 보세요.

---

## 다음 단원

[03_브랜치와_병합](../03_브랜치와_병합/) — branch·switch·merge·conflict 해결
