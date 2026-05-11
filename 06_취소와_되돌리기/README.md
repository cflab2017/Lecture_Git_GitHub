# 06. 취소와 되돌리기

Git의 가장 큰 장점 중 하나는 실수를 되돌릴 수 있다는 것입니다.
`reset`, `revert`, `restore`, `reflog`, `stash` — 다섯 가지 도구를 상황에 맞게 쓰면
잘못된 커밋, 잘못 스테이징된 파일, 임시 저장이 필요한 작업을 안전하게 처리할 수 있습니다.

## 학습 목표

- `git reset`의 soft·mixed·hard 세 모드 차이를 설명하고 올바른 상황에 적용할 수 있다.
- `git revert`로 공유 브랜치에 안전하게 커밋을 되돌릴 수 있다.
- `git restore`로 스테이징·워킹 디렉토리의 변경을 취소할 수 있다.
- `git reflog`로 reset/checkout 이후 잃어버린 커밋을 복구할 수 있다.
- `git stash`로 작업 중인 변경을 임시 저장하고 복원할 수 있다.

---

## 핵심 개념

### 1) git reset

```
HEAD  →  커밋 이력을 되돌린다.

--soft  : HEAD 이동 + 스테이징 유지 + 워킹 유지
--mixed : HEAD 이동 + 스테이징 취소 + 워킹 유지  (기본값)
--hard  : HEAD 이동 + 스테이징 취소 + 워킹 취소  ⚠️
```

```bash
git reset --soft  HEAD~1    # 커밋만 취소, 변경은 staged 상태
git reset --mixed HEAD~1    # 커밋 + 스테이징 취소
git reset --hard  HEAD~1    # 모두 취소 (워킹 디렉토리 변경 삭제)
```

### 2) git revert

```bash
git revert HEAD         # 최신 커밋을 되돌리는 새 커밋 생성
git revert abc123       # 특정 커밋을 되돌리는 새 커밋
git revert HEAD~2..HEAD # 범위 revert
```

push된 브랜치에서 이력을 보존해야 할 때 사용한다.

### 3) git restore

```bash
git restore 파일.txt             # 워킹 디렉토리 변경 취소 (스테이징 영향 없음)
git restore --staged 파일.txt   # 스테이징 취소 (워킹 유지)
git restore --staged --worktree 파일.txt  # 둘 다 취소
```

### 4) git reflog

```bash
git reflog              # HEAD 이동 기록 전체
git reflog --date=iso   # 날짜 포함
git reset --hard HEAD@{3}   # 3번 전 HEAD 위치로 복구
```

### 5) git stash

```bash
git stash               # 현재 변경 임시 저장
git stash push -m "메시지"
git stash list          # 목록
git stash pop           # 최근 stash 복원 + 삭제
git stash apply stash@{1}  # 특정 stash 적용 (삭제 안 함)
git stash drop stash@{0}   # 특정 stash 삭제
git stash clear         # 전체 삭제
```

---

## 예제로 보기

### 예제 1 — `ex01_reset.sh` : soft·mixed·hard reset 비교

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d); cd "$REPO"
git init -q && git config user.name "실습용" && git config user.email "demo@example.com"

for i in 1 2 3; do
    echo "v$i" > file.txt && git add . && git commit -q -m "commit $i"
done

echo "=== 초기 상태 ==="
git log --oneline

echo ""
echo "--- soft reset (HEAD~1) ---"
git reset --soft HEAD~1
git status --short
git log --oneline

echo ""
git add . && git commit -q -m "re-commit after soft"

echo "--- mixed reset (HEAD~1, 기본값) ---"
git reset HEAD~1
git status --short
git log --oneline
```

**실행 결과**

```
=== 초기 상태 ===
c3 commit 3 / b2 commit 2 / a1 commit 1

--- soft reset ---
M  file.txt    ← staged 상태 유지
b2 commit 2 / a1 commit 1

--- mixed reset ---
 M file.txt    ← unstaged
b2 commit 2 / a1 commit 1
```

핵심: `--soft`는 커밋만 취소, `--hard`는 모든 변경을 삭제한다.

---

### 예제 2 — `ex02_revert.sh` : push된 커밋을 revert로 안전하게 되돌리기

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d); cd "$REPO"
git init -q && git config user.name "실습용" && git config user.email "demo@example.com"

echo "정상 코드" > app.py && git add . && git commit -q -m "feat: good code"
echo "버그 코드" > app.py && git add . && git commit -q -m "feat: buggy code"
echo "다른 기능" > other.py && git add . && git commit -q -m "feat: other feature"

echo "=== revert 전 로그 ==="
git log --oneline

BUGGY_HASH=$(git log --oneline | grep "buggy" | awk '{print $1}')
git revert "$BUGGY_HASH" --no-edit

echo ""
echo "=== revert 후 로그 (새 revert 커밋 추가됨) ==="
git log --oneline

rm -rf "$REPO"
```

**실행 결과**

```
=== revert 전 로그 ===
c3 feat: other feature
b2 feat: buggy code
a1 feat: good code

=== revert 후 로그 ===
d4 Revert "feat: buggy code"
c3 feat: other feature
b2 feat: buggy code
a1 feat: good code
```

핵심: `revert`는 이력을 삭제하지 않고 반대 커밋을 추가한다.

---

### 예제 3 — `ex03_restore.sh` : restore 로 변경 취소

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d); cd "$REPO"
git init -q && git config user.name "실습용" && git config user.email "demo@example.com"

echo "원본" > file.txt && git add . && git commit -q -m "init"

echo "수정됨" > file.txt
git add file.txt

echo "=== 수정 + 스테이징 후 status ==="
git status --short

git restore --staged file.txt
echo ""
echo "=== --staged 취소 후 (unstaged) ==="
git status --short

git restore file.txt
echo ""
echo "=== 워킹 디렉토리 취소 후 ==="
git status --short
echo "파일 내용: $(cat file.txt)"

rm -rf "$REPO"
```

**실행 결과**

```
=== 수정 + 스테이징 후 ===
M  file.txt

=== --staged 취소 후 ===
 M file.txt

=== 워킹 디렉토리 취소 후 ===
(nothing)
파일 내용: 원본
```

핵심: `restore --staged`는 스테이징만, `restore`는 워킹 디렉토리만 취소한다.

---

### 예제 4 — `ex04_stash.sh` : stash 로 작업 임시 저장

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d); cd "$REPO"
git init -q && git config user.name "실습용" && git config user.email "demo@example.com"

echo "초기 코드" > app.py && git add . && git commit -q -m "init"

# 작업 중 긴급 버그 수정 요청
echo "WIP: 새 기능 개발 중" >> app.py
git stash push -m "WIP: 새 기능 개발"

echo "=== stash 후 status (clean) ==="
git status --short

echo ""
echo "=== stash list ==="
git stash list

# 긴급 수정
git switch -c hotfix/urgent
echo "긴급 수정" > hotfix.py && git add . && git commit -q -m "fix: urgent hotfix"
git switch main
git merge hotfix/urgent -q

# 원래 작업 복원
git stash pop

echo ""
echo "=== stash pop 후 status ==="
git status --short
echo "app.py 내용: $(cat app.py)"

rm -rf "$REPO"
```

**실행 결과**

```
=== stash 후 status ===
(clean)

=== stash list ===
stash@{0}: WIP: 새 기능 개발

=== stash pop 후 status ===
 M app.py
app.py 내용: 초기 코드
WIP: 새 기능 개발 중
```

핵심: `stash`로 임시 저장 후 다른 브랜치에서 작업하고 돌아와 복원할 수 있다.

---

## 다른 시각으로 보기

| 명령 | 일상 비유 | push 후 사용 |
|------|----------|--------------|
| `reset --hard` | 파일 영구 삭제 | ❌ 절대 안 됨 |
| `reset --soft` | 종이에 쓴 내용 지우개로 지우기 | ❌ 공유 전에만 |
| `revert` | 수정 사항을 반대로 덮어쓰기 | ✅ 안전 |
| `restore` | 마지막 저장 불러오기 | — |
| `stash` | 서랍에 잠깐 넣기 | — |

---

## 자주 하는 실수

1. **push된 브랜치에 `reset --hard`** — 팀원의 이력이 꼬이고 강제 push가 필요해진다.
2. **`reset`과 `revert` 혼동** — 공유 브랜치에서는 항상 `revert`를 사용한다.
3. **stash 후 잊어버리기** — `git stash list`로 주기적으로 확인하고 불필요한 것은 삭제한다.
4. **`restore` 후 복구 불가** — 스테이징되지 않은 변경을 `restore`하면 reflog로도 복구 불가능하다.
5. **reflog 기간 만료** — 기본 90일 후 reflog 항목이 삭제되므로 빠르게 복구해야 한다.

---

## 정리

- `reset --soft`: 커밋만 취소, `--mixed`: 스테이징도 취소, `--hard`: 모두 취소.
- push된 커밋은 `revert`로 되돌린다 — 이력이 보존된다.
- `restore --staged`로 스테이징 취소, `restore`로 워킹 디렉토리 변경 취소.
- `reflog`로 실수로 날린 커밋도 복구할 수 있다.
- `stash`는 커밋 없이 변경을 임시 저장하고 나중에 복원한다.

---

## 직접 해 보기

```bash
cd 06_취소와_되돌리기/src
chmod +x *.sh
./ex01_reset.sh
./ex02_revert.sh
./ex03_restore.sh
./ex04_stash.sh
```

응용:
1. `git reset --hard HEAD~3` 로 3개 커밋을 날린 뒤 `git reflog`로 복구해 보세요.
2. `git stash branch <브랜치명>`으로 stash를 새 브랜치로 바로 분리해 보세요.

---

## 다음 단원

[07_rebase와_cherry-pick](../07_rebase와_cherry-pick/) — interactive rebase·squash·cherry-pick·force-with-lease
