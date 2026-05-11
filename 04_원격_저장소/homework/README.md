# 과제 - 04. 원격 저장소

## 문제 1

로컬 bare 저장소를 "원격"으로 사용하는 두 저장소(repo_a, repo_b) 시나리오를 구현하세요.

- 파일명: `hw01.sh`
- 요구사항:
  1. `mktemp -d` 로 작업 디렉토리를 만든다.
  2. `git init --bare` 로 bare 저장소를 생성한다.
  3. `repo_a` 에서 clone → 파일 추가 → 커밋 → `git push` 를 수행한다.
  4. `repo_b` 에서 clone → `git log --oneline` 으로 repo_a 의 커밋이 보이는지 확인한다.
  5. `repo_b` 에서 파일 추가 → 커밋 → push 한다.
  6. `repo_a` 에서 `git fetch` 후 `git log --oneline --all` 로 원격 브랜치 확인 → `git merge` 로 반영한다.

```bash
# 예상 출력 (핵심)
=== repo_a fetch + merge 후 ===
b2c3d4e (HEAD -> main, origin/main) feat: B's file
a1b2c3d feat: A's file
```

## 문제 2

`git remote` 관리 스크립트를 작성하세요.

- 파일명: `hw02.sh`
- 요구사항:
  1. 빈 저장소를 초기화한다.
  2. `origin` 원격을 `https://github.com/example/project.git` 으로 추가한다.
  3. `backup` 원격을 `https://backup.example.com/project.git` 으로 추가한다.
  4. `git remote -v` 로 두 원격을 출력한다.
  5. `origin` URL을 `https://github.com/example/project-v2.git` 으로 변경한다.
  6. `backup` 원격을 삭제한다.
  7. 최종 `git remote -v` 를 출력한다.

## 정답 확인

직접 작성한 후 [`answer/`](./answer/) 폴더의 정답과 비교해 보세요.
