# 과제 - 01. 시작하기

## 문제 1

터미널에서 자신의 이름과 이메일을 Git 전역 설정으로 저장하고,
설정이 올바르게 저장되었는지 확인하는 스크립트를 작성하세요.

- 파일명: `hw01.sh`
- 요구사항:
  - `git config --global user.name` 에 본인 이름(또는 닉네임)을 설정한다.
  - `git config --global user.email` 에 이메일을 설정한다.
  - 설정 후 `git config --list --global` 로 결과를 출력한다.

```bash
# 예상 출력 (이름·이메일은 본인 것으로)
user.name=홍길동
user.email=gildong@example.com
```

## 문제 2

임시 디렉토리에 새 Git 저장소를 만들고, `README.md` 파일을 작성한 뒤
첫 번째 커밋을 남기고 `git log`로 확인하는 스크립트를 작성하세요.

- 파일명: `hw02.sh`
- 요구사항:
  1. `mktemp -d` 로 임시 디렉토리를 생성한다.
  2. `git init` 으로 저장소를 초기화한다.
  3. `README.md` 에 `# 나의 첫 번째 저장소` 를 작성한다.
  4. `git add README.md` → `git commit -m "docs: initial README"` 를 실행한다.
  5. `git log --oneline` 으로 커밋을 확인한다.
  6. 스크립트 종료 전에 임시 디렉토리를 삭제한다.

```bash
# 예상 출력
Initialized empty Git repository in /tmp/tmp.XXXXX/.git/
a1b2c3d docs: initial README
```

## 정답 확인

직접 작성한 후 [`answer/`](./answer/) 폴더의 정답과 비교해 보세요.
