# 과제 - 05. GitHub 협업

## 문제 1

fork → 기능 브랜치 → PR 병합 전체 흐름을 로컬 bare 저장소로 시뮬레이션하세요.

- 파일명: `hw01.sh`
- 요구사항:
  1. `upstream.git` (bare) 저장소를 만들고 초기 커밋을 push한다.
  2. `my_fork/` 디렉토리로 clone해 `upstream` remote를 추가한다.
  3. `feature/new-page` 브랜치를 만들어 `new_page.md` 를 추가하고 커밋한다.
  4. fork 저장소 자체의 bare 저장소(또는 upstream 직접)에 push한다.
  5. upstream 에서 `--no-ff` 병합으로 PR 병합을 시뮬레이션한다.
  6. `git log --oneline --graph --all` 로 최종 이력을 출력한다.

## 문제 2

CODEOWNERS 파일과 Issue 연동 커밋 메시지를 포함한 저장소를 만드세요.

- 파일명: `hw02.sh`
- 요구사항:
  1. 임시 저장소를 초기화한다.
  2. 아래 구조로 디렉토리와 파일을 만든다:
     ```
     .github/CODEOWNERS
     src/api.py
     docs/api.md
     ```
  3. CODEOWNERS에 `src/` → `@backend`, `docs/` → `@writer` 를 설정한다.
  4. `fix/issue-12` 브랜치에서 `src/api.py` 를 수정하고
     `Closes #12` 를 포함한 커밋 메시지로 커밋한다.
  5. `git log -1 --format="%B"` 로 커밋 메시지를 출력한다.

## 정답 확인

직접 작성한 후 [`answer/`](./answer/) 폴더의 정답과 비교해 보세요.
