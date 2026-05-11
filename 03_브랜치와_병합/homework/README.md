# 과제 - 03. 브랜치와 병합

## 문제 1

두 브랜치에서 서로 다른 파일을 수정해 fast-forward merge 가 아닌
3-way merge가 발생하는 시나리오를 구현하세요.

- 파일명: `hw01.sh`
- 요구사항:
  1. 임시 저장소를 초기화하고 `base.txt` 를 커밋한다.
  2. `feature/a` 브랜치를 만들어 `a.txt` 를 추가하고 커밋한다.
  3. `main` 으로 돌아와 `b.txt` 를 추가하고 커밋한다.
  4. `git merge feature/a -m "merge: feature/a"` 를 실행한다.
  5. `git log --oneline --graph --all` 로 병합 커밋이 생겼음을 확인한다.

```bash
# 예상 출력 (핵심 부분)
*   병합 커밋 해시 (HEAD -> main) merge: feature/a
|\
| * 해시 (feature/a) ...
* | 해시 ...
|/
* 해시 init
```

## 문제 2

두 브랜치에서 동일 파일의 동일 줄을 수정해 충돌을 발생시키고,
직접 해결 후 병합 커밋을 남기는 스크립트를 작성하세요.

- 파일명: `hw02.sh`
- 요구사항:
  1. 임시 저장소를 초기화하고 `conflict.txt` 에 "공통 내용"을 작성·커밋한다.
  2. `feature/b` 브랜치에서 `conflict.txt` 를 "feature 내용"으로 덮어쓰고 커밋한다.
  3. `main` 에서 `conflict.txt` 를 "main 내용"으로 덮어쓰고 커밋한다.
  4. `git merge feature/b` 를 시도해 충돌을 유도한다.
  5. 충돌 파일 내용을 "해결된 내용"으로 교체하고 `git add` → `git commit` 한다.
  6. 최종 로그를 `--graph` 옵션으로 출력한다.

## 정답 확인

직접 작성한 후 [`answer/`](./answer/) 폴더의 정답과 비교해 보세요.
