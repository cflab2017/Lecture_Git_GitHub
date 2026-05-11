# 과제 - 07. rebase와 cherry-pick

## 문제 1

feature 브랜치를 main 위로 rebase 해 선형 이력을 만드는 스크립트를 작성하세요.

- 파일명: `hw01.sh`
- 요구사항:
  1. 임시 저장소를 초기화하고 `base.txt` 를 커밋한다.
  2. `feature/work` 브랜치에서 `work.txt` 를 커밋한다.
  3. `main` 으로 돌아와 `hotfix.txt` 를 커밋한다 (브랜치 분기 상태).
  4. `feature/work` 에서 `git rebase main` 을 실행한다.
  5. `git log --oneline --graph --all` 로 선형 이력이 됐음을 확인한다.
  6. `git switch main && git merge feature/work` 로 fast-forward merge 한다.
  7. 최종 로그를 출력한다 (직선이어야 함).

## 문제 2

develop 브랜치의 특정 커밋만 main 에 cherry-pick 하는 스크립트를 작성하세요.

- 파일명: `hw02.sh`
- 요구사항:
  1. 임시 저장소를 초기화한다.
  2. `develop` 브랜치에서 다음 순서로 커밋을 만든다:
     - `"feat: add login"`
     - `"fix: security patch"`
     - `"feat: add dashboard"`
  3. `main` 에서 `"fix: security patch"` 커밋만 cherry-pick 한다.
  4. `git log --oneline` 으로 main 이력을 출력한다 (security patch 만 있어야 함).
  5. `ls` 로 파일 목록을 출력한다.

## 정답 확인

직접 작성한 후 [`answer/`](./answer/) 폴더의 정답과 비교해 보세요.
