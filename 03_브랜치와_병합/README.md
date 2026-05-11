# 03. 브랜치와 병합

브랜치는 Git의 가장 강력한 기능입니다.
메인 코드를 건드리지 않고 새 기능을 실험하거나 버그를 수정할 수 있으며,
완성되면 병합(merge)으로 합칩니다.
브랜치를 자유롭게 다루면 혼자 개발할 때도 여러 아이디어를 동시에 진행할 수 있습니다.

## 학습 목표

- `git branch`·`git switch`로 브랜치를 만들고 전환할 수 있다.
- fast-forward merge와 3-way merge의 차이를 설명할 수 있다.
- 충돌(conflict)이 발생했을 때 직접 수정하고 해결할 수 있다.
- `git branch -d`로 병합된 브랜치를 안전하게 삭제할 수 있다.

---

## 핵심 개념

### 1) 브랜치 만들기·전환하기

```bash
git branch feature/login        # 브랜치 생성
git switch feature/login        # 브랜치 전환

# 생성 + 전환 한 번에
git switch -c feature/login

# 목록 확인
git branch                      # 로컬
git branch -a                   # 로컬 + 원격
```

### 2) Fast-forward Merge

```
main:    A---B
               \
feature:        C---D

git merge feature → main: A---B---C---D  (직선)
```

- `main`이 앞으로 나아가기만 하면 된다 (분기점 없음).
- 병합 커밋이 생기지 않아 이력이 깔끔하다.

```bash
git switch main
git merge feature/login         # fast-forward (기본)
git merge --no-ff feature/login # 병합 커밋 강제 생성
```

### 3) 3-way Merge

```
main:    A---B---E
               \   \
feature:        C---D

git merge feature → main: A---B---E---M  (M = 병합 커밋)
```

- `main`과 `feature` 양쪽이 각자 커밋을 진행한 경우.
- 공통 조상(B) + 두 브랜치 끝(E, D)을 비교해 병합한다.

### 4) 충돌(Conflict) 해결

```bash
# 충돌 발생 시 git status 가 conflict 파일을 표시
git status
# both modified: src/app.py

# 파일 열면 충돌 마커가 삽입됨
<<<<<<< HEAD
현재 브랜치의 내용
=======
병합 대상 브랜치의 내용
>>>>>>> feature/login

# 1. 마커 제거 후 원하는 내용 남기기
# 2. git add <파일>
# 3. git commit
```

---

## 예제로 보기

### 예제 1 — `ex01_branch.sh` : 브랜치 생성·전환·목록 확인

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d); cd "$REPO"
git init -q && git config user.name "실습용" && git config user.email "demo@example.com"
echo "main" > main.txt && git add . && git commit -q -m "init"

git switch -c feature/hello
echo "hello" > hello.txt && git add . && git commit -q -m "feat: hello"

echo "=== 브랜치 목록 ==="
git branch

git switch main
echo "=== HEAD 위치 ==="
git log --oneline --all --graph
```

**실행 결과**

```
=== 브랜치 목록 ===
* feature/hello
  main

=== HEAD 위치 ===
* a1b2c3d (feature/hello) feat: hello
* b2c3d4e (HEAD -> main) init
```

핵심: `*`가 현재 체크아웃된 브랜치를 가리킨다.

---

### 예제 2 — `ex02_merge_ff.sh` : Fast-forward Merge

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d); cd "$REPO"
git init -q && git config user.name "실습용" && git config user.email "demo@example.com"
echo "init" > README.md && git add . && git commit -q -m "init"

git switch -c feature/ff
echo "FF 기능" > feature.txt && git add . && git commit -q -m "feat: FF feature"

git switch main
git merge feature/ff

echo "=== 병합 후 로그 (직선) ==="
git log --oneline --graph
```

**실행 결과**

```
=== 병합 후 로그 (직선) ===
* a1b2c3d (HEAD -> main, feature/ff) feat: FF feature
* b2c3d4e init
```

핵심: fast-forward는 병합 커밋 없이 포인터만 이동한다.

---

### 예제 3 — `ex03_merge_3way.sh` : 3-way Merge

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d); cd "$REPO"
git init -q && git config user.name "실습용" && git config user.email "demo@example.com"
echo "init" > README.md && git add . && git commit -q -m "init"

git switch -c feature/3way
echo "기능 A" > feature.txt && git add . && git commit -q -m "feat: feature A"

git switch main
echo "main 추가 작업" > main_extra.txt && git add . && git commit -q -m "chore: main extra"

git merge feature/3way -m "merge: feature/3way into main"

echo "=== 병합 후 로그 (병합 커밋 있음) ==="
git log --oneline --graph
```

**실행 결과**

```
=== 병합 후 로그 (병합 커밋 있음) ===
*   c3d4e5f (HEAD -> main) merge: feature/3way into main
|\
| * a1b2c3d (feature/3way) feat: feature A
* | b2c3d4e chore: main extra
|/
* 9a8b7c6 init
```

핵심: 양쪽이 각자 커밋했을 때 Git이 자동으로 병합 커밋을 만든다.

---

### 예제 4 — `ex04_conflict.sh` : 충돌 만들기 및 해결

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d); cd "$REPO"
git init -q && git config user.name "실습용" && git config user.email "demo@example.com"

echo "공통 내용" > shared.txt && git add . && git commit -q -m "init"

git switch -c feature/conflict
echo "feature 의 수정" > shared.txt && git add . && git commit -q -m "feat: modify shared"

git switch main
echo "main 의 수정" > shared.txt && git add . && git commit -q -m "chore: modify shared on main"

echo "=== 충돌 병합 시도 ==="
if ! git merge feature/conflict -m "merge" 2>/dev/null; then
    echo "충돌 발생! shared.txt 내용:"
    cat shared.txt
    # 충돌 해결: main 버전을 채택
    echo "충돌 해결: main 버전 채택" > shared.txt
    git add shared.txt
    git commit -m "merge: resolve conflict in shared.txt"
    echo ""
    echo "=== 충돌 해결 후 로그 ==="
    git log --oneline --graph
fi

rm -rf "$REPO"
```

**실행 결과**

```
충돌 발생! shared.txt 내용:
<<<<<<< HEAD
main 의 수정
=======
feature 의 수정
>>>>>>> feature/conflict

=== 충돌 해결 후 로그 ===
*   d4e5f6a (HEAD -> main) merge: resolve conflict in shared.txt
|\
| * c3d4e5f (feature/conflict) feat: modify shared
* | b2c3d4e chore: modify shared on main
|/
* a1b2c3d init
```

핵심: 충돌 마커를 직접 편집하고 `git add` → `git commit`으로 병합을 완료한다.

---

## 다른 시각으로 보기

| Git 개념 | 일상 비유 |
|----------|----------|
| 브랜치 | 평행 우주 |
| merge | 두 우주를 하나로 합치기 |
| fast-forward | 타임라인을 앞으로 감기 |
| conflict | 두 우주에서 같은 물체를 다르게 수정 |
| 병합 커밋 | 두 우주가 만나는 교차점 |

---

## 자주 하는 실수

1. **main에서 직접 작업** — 항상 기능 브랜치를 만들어 작업한다.
2. **충돌 마커를 파일에 남긴 채 커밋** — `<<<`, `===`, `>>>` 가 남아 있으면 빌드가 깨진다.
3. **`-d` 대신 `-D` 로 병합 안 된 브랜치 삭제** — 커밋이 유실된다.
4. **병합 전 `git pull` 생략** — 원격 변경을 가져오지 않아 충돌이 더 커진다.
5. **fast-forward를 강제(`--no-ff`)해야 할 때 생략** — PR 이력이 사라져 추적이 어려워진다.

---

## 정리

- `git switch -c <브랜치>` 로 브랜치를 만들고 전환한다.
- fast-forward는 직선 이력, 3-way는 병합 커밋을 생성한다.
- 충돌은 마커를 편집 → `git add` → `git commit` 순으로 해결한다.
- 병합 완료된 브랜치는 `git branch -d`로 정리한다.

---

## 직접 해 보기

```bash
cd 03_브랜치와_병합/src
chmod +x *.sh
./ex01_branch.sh
./ex02_merge_ff.sh
./ex03_merge_3way.sh
./ex04_conflict.sh
```

응용:
1. `git log --oneline --graph --all` 로 병합 전후 그래프가 어떻게 바뀌는지 비교해 보세요.
2. `git merge --abort` 를 사용해 충돌 병합을 중단하는 시나리오를 만들어 보세요.

---

## 다음 단원

[04_원격_저장소](../04_원격_저장소/) — clone·push·pull·fetch와 PAT/SSH 인증
