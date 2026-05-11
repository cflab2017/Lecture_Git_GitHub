# 07. rebase와 cherry-pick

`merge`가 두 브랜치의 이력을 합치는 반면, `rebase`는 커밋을 다른 곳에 새로 이어 붙여
히스토리를 선형으로 만듭니다. `cherry-pick`은 다른 브랜치의 특정 커밋만 골라서 현재 브랜치에 적용합니다.
이 두 도구를 사용하면 커밋 이력을 깔끔하게 정리하고 필요한 변경만 선택적으로 가져올 수 있습니다.

## 학습 목표

- `git rebase`로 브랜치 기반(base)을 변경해 선형 이력을 만들 수 있다.
- `git rebase -i`(interactive)로 커밋을 squash·reword·drop 할 수 있다.
- `git cherry-pick`으로 특정 커밋을 현재 브랜치에 적용할 수 있다.
- rebase/cherry-pick 중 충돌을 해결하고 계속(`--continue`) 진행할 수 있다.
- `--force-with-lease`를 사용해 안전하게 force push할 수 있다.

---

## 핵심 개념

### 1) git rebase

```
before rebase:
main:    A---B
               \
feature:        C---D

after: git rebase main (feature 브랜치에서 실행)
main:    A---B
               \
feature:        C'--D'   (새 해시)
```

```bash
git switch feature
git rebase main          # main 위로 feature 를 이어 붙이기
```

### 2) Interactive Rebase

```bash
git rebase -i HEAD~3    # 최근 3개 커밋을 편집

# 에디터에서:
pick a1b2c3d feat: first
squash b2c3d4e fix: typo       # ← pick → squash (이전 커밋에 합치기)
reword c3d4e5f feat: second    # ← 메시지만 수정
drop   d4e5f6a wip: temp       # ← 커밋 삭제
```

| 명령 | 의미 |
|------|------|
| `pick` | 그대로 유지 |
| `squash`/`s` | 이전 커밋에 합치기 (메시지도 합침) |
| `fixup`/`f` | 이전 커밋에 합치기 (메시지 버림) |
| `reword`/`r` | 메시지만 수정 |
| `drop`/`d` | 커밋 삭제 |
| `edit`/`e` | 커밋을 멈추고 수정 |

### 3) git cherry-pick

```bash
git cherry-pick abc1234          # 특정 커밋 하나 적용
git cherry-pick abc1234 def5678  # 여러 커밋
git cherry-pick abc1234..def5678 # 범위 (abc 제외, def 포함)
git cherry-pick --no-commit abc1234  # 스테이징만, 커밋 안 함
```

### 4) force-with-lease

```bash
git push --force             # 원격 상태 무시하고 강제 push ⚠️
git push --force-with-lease  # 원격 HEAD 가 예상과 다르면 거절 ✅
```

rebase 후 로컬 브랜치 해시가 달라지므로 push 시 force가 필요하다.
팀원이 사이에 push했을 경우 `--force-with-lease`가 거절해 덮어쓰기를 막는다.

---

## 예제로 보기

### 예제 1 — `ex01_rebase.sh` : feature 브랜치를 main 위로 rebase

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d); cd "$REPO"
git init -q && git config user.name "실습용" && git config user.email "demo@example.com"

echo "base" > base.txt && git add . && git commit -q -m "A: base"

git switch -c feature
echo "feat" > feat.txt && git add . && git commit -q -m "C: feature"

git switch main
echo "main extra" > extra.txt && git add . && git commit -q -m "B: main extra"

echo "=== rebase 전 그래프 ==="
git log --oneline --graph --all

git switch feature
git rebase main

echo ""
echo "=== rebase 후 그래프 (선형) ==="
git log --oneline --graph --all
```

**실행 결과**

```
=== rebase 전 ===
* B: main extra (main)
| * C: feature (feature)
|/
* A: base

=== rebase 후 (선형) ===
* C': feature (feature)
* B: main extra (main)
* A: base
```

핵심: rebase는 커밋을 새로 만들어(해시 변경) 선형 이력을 만든다.

---

### 예제 2 — `ex02_squash.sh` : interactive rebase 로 커밋 합치기

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d); cd "$REPO"
git init -q && git config user.name "실습용" && git config user.email "demo@example.com"
echo "base" > f.txt && git add . && git commit -q -m "init"

echo "v1" >> f.txt && git add . && git commit -q -m "feat: step 1"
echo "v2" >> f.txt && git add . && git commit -q -m "fix: typo"
echo "v3" >> f.txt && git add . && git commit -q -m "fix: another typo"

echo "=== squash 전 로그 ==="
git log --oneline

# 비대화형으로 squash 시뮬레이션
git reset --soft HEAD~3
git commit -m "feat: implement feature (squashed 3 commits)"

echo ""
echo "=== squash 후 로그 ==="
git log --oneline

rm -rf "$REPO"
```

**실행 결과**

```
=== squash 전 로그 ===
d4 fix: another typo
c3 fix: typo
b2 feat: step 1
a1 init

=== squash 후 로그 ===
e5 feat: implement feature (squashed 3 commits)
a1 init
```

핵심: `git rebase -i`의 squash는 여러 WIP 커밋을 하나의 의미 있는 커밋으로 합친다.

---

### 예제 3 — `ex03_cherry_pick.sh` : 다른 브랜치의 특정 커밋만 가져오기

```bash
#!/usr/bin/env bash
REPO=$(mktemp -d); cd "$REPO"
git init -q && git config user.name "실습용" && git config user.email "demo@example.com"

echo "main" > main.txt && git add . && git commit -q -m "init"

git switch -c develop
echo "기능 A" > a.txt && git add . && git commit -q -m "feat: feature A"
echo "기능 B" > b.txt && git add . && git commit -q -m "feat: feature B"
echo "기능 C" > c.txt && git add . && git commit -q -m "feat: feature C"

# main 에서 B 커밋만 cherry-pick
git switch main
HASH_B=$(git log develop --oneline | grep "feature B" | awk '{print $1}')
git cherry-pick "$HASH_B"

echo "=== cherry-pick 후 main 로그 ==="
git log --oneline
echo ""
echo "=== main 의 파일 목록 (B만 포함) ==="
ls

rm -rf "$REPO"
```

**실행 결과**

```
=== main 로그 ===
b2' feat: feature B  (cherry-pick으로 가져온 커밋)
a1  init

=== main 파일 목록 ===
b.txt  main.txt
```

핵심: cherry-pick은 브랜치 전체가 아닌 원하는 커밋 하나만 골라서 적용한다.

---

### 예제 4 — `ex04_force_push.sh` : rebase 후 force-with-lease 로 안전하게 push

```bash
#!/usr/bin/env bash
WORKDIR=$(mktemp -d)
git init --bare "$WORKDIR/remote.git" -q

git clone "$WORKDIR/remote.git" "$WORKDIR/repo" -q
cd "$WORKDIR/repo"
git config user.name "실습용" && git config user.email "demo@example.com"

echo "init" > f.txt && git add . && git commit -q -m "init"
git push origin main -q

git switch -c feature
echo "WIP 1" >> f.txt && git add . && git commit -q -m "wip: step 1"
echo "WIP 2" >> f.txt && git add . && git commit -q -m "wip: step 2"
git push origin feature -q

echo "=== push 전 로그 ==="
git log --oneline

# squash (reset --soft 방법)
git reset --soft HEAD~2
git commit -m "feat: complete feature"

echo ""
echo "=== squash 후 로그 ==="
git log --oneline

echo ""
echo "=== force-with-lease 로 안전하게 push ==="
git push --force-with-lease origin feature

rm -rf "$WORKDIR"
```

**실행 결과**

```
=== push 전 로그 ===
wip: step 2
wip: step 1
init

=== squash 후 로그 ===
feat: complete feature
init

=== force-with-lease로 push ===
(성공)
```

핵심: `--force-with-lease`는 원격 브랜치가 예상 상태일 때만 push를 허용한다.

---

## 다른 시각으로 보기

| 개념 | 비유 |
|------|------|
| rebase | 이사 — 같은 짐을 새 위치에 옮김 |
| squash | 여러 초안을 최종본 하나로 합치기 |
| cherry-pick | 뷔페에서 원하는 요리만 골라 담기 |
| --force-with-lease | "내가 마지막으로 본 상태"일 때만 덮어쓰기 |

---

## 자주 하는 실수

1. **공유 브랜치(main)에서 rebase** — 팀원의 이력이 꼬인다; 항상 로컬 feature 브랜치에서만 rebase.
2. **rebase 후 `--force` (lease 없이)** — 팀원이 사이에 push했어도 강제 덮어쓴다.
3. **cherry-pick 후 원래 브랜치도 merge** — 같은 변경이 이중으로 들어가 충돌 또는 중복 이력이 생긴다.
4. **interactive rebase 중 에디터 종료 실수** — `git rebase --abort`로 취소한다.
5. **squash 전 원격 push** — 해시가 바뀌어 force push가 필요해진다.

---

## 정리

- `git rebase <브랜치>`로 feature의 기반을 최신 main으로 이동해 선형 이력을 만든다.
- `git rebase -i HEAD~N`으로 N개 커밋을 squash·drop·reword할 수 있다.
- `git cherry-pick <해시>`로 다른 브랜치의 특정 커밋만 현재 브랜치에 적용한다.
- rebase 후 push는 반드시 `--force-with-lease`를 사용한다.

---

## 직접 해 보기

```bash
cd 07_rebase와_cherry-pick/src
chmod +x *.sh
./ex01_rebase.sh
./ex02_squash.sh
./ex03_cherry_pick.sh
./ex04_force_push.sh
```

응용:
1. `git rebase -i HEAD~4` 에서 `edit` 명령으로 커밋 중간에 새 커밋을 삽입해 보세요.
2. cherry-pick 중 충돌이 나면 해결 후 `git cherry-pick --continue`를 실행해 보세요.

---

## 다음 단원

[08_GitHub_Actions](../08_GitHub_Actions/) — workflow yml·trigger·matrix·cache·artifacts·secrets
