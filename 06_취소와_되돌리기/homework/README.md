# 과제 - 06. 취소와 되돌리기

## 문제 1

`git reset` 세 가지 모드를 직접 비교하는 스크립트를 작성하세요.

- 파일명: `hw01.sh`
- 요구사항:
  1. 임시 저장소를 초기화하고 `a.txt`, `b.txt`, `c.txt`를 각각 커밋한다 (총 3개 커밋).
  2. `git reset --soft HEAD~1` 로 마지막 커밋을 취소하고 `git status` 를 출력한다.
     (기대: `c.txt`가 staged 상태)
  3. `git reset HEAD~1` 로 한 단계 더 취소하고 `git status` 를 출력한다.
     (기대: `b.txt`와 `c.txt`가 unstaged)
  4. `git add . && git commit -m "re-commit b and c"` 로 다시 커밋한다.
  5. `git reset --hard HEAD~1` 로 취소하고 `git status`와 `ls` 를 출력한다.
     (기대: clean status, `b.txt` `c.txt` 파일 없음)

## 문제 2

`git stash`로 작업을 임시 저장하고 복원하는 시나리오를 구현하세요.

- 파일명: `hw02.sh`
- 요구사항:
  1. 임시 저장소를 초기화하고 `main.py` 를 커밋한다.
  2. `main.py` 에 "WIP 작업" 을 추가한 뒤 `git stash push -m "WIP"` 로 저장한다.
  3. `fix/patch` 브랜치를 만들어 `patch.py` 를 추가하고 커밋한다.
  4. `main` 으로 돌아와 `fix/patch` 를 병합한다.
  5. `git stash pop` 으로 작업을 복원하고 `main.py` 내용을 출력한다.
  6. `git stash list` 가 비어 있음을 확인한다.

## 정답 확인

직접 작성한 후 [`answer/`](./answer/) 폴더의 정답과 비교해 보세요.
