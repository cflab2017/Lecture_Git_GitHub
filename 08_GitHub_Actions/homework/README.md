# 과제 - 08. GitHub Actions

## 문제 1

push 시 bash 스크립트를 실행하고 결과를 artifact로 저장하는 워크플로우를 작성하세요.

- 파일명: `hw01.yml`
- 요구사항:
  - 트리거: `main` 브랜치 push, `workflow_dispatch`
  - 단계:
    1. `actions/checkout@v4` 로 코드를 체크아웃한다.
    2. `date`, `uname -a`, `git log --oneline -5` 를 실행하고 `report.txt` 에 저장한다.
    3. `actions/upload-artifact@v4` 로 `report.txt` 를 `ci-report` 이름으로 업로드한다.
  - 보존 기간: 3일

```yaml
# 예시 구조
name: CI Report
on:
  push:
    branches: [main]
  workflow_dispatch:
jobs:
  report:
    runs-on: ubuntu-latest
    steps:
      ...
```

## 문제 2

Python 프로젝트를 위한 매트릭스 CI 워크플로우를 작성하세요.

- 파일명: `hw02.yml`
- 요구사항:
  - 트리거: `push` (main, develop), `pull_request` (main)
  - 매트릭스:
    - OS: `ubuntu-latest`, `macos-latest`
    - Python 버전: `3.10`, `3.11`, `3.12`
  - 단계:
    1. checkout
    2. `actions/setup-python@v5` 로 Python 설정
    3. `pip install -r requirements.txt` (파일 없으면 `echo "no requirements"`)
    4. `python -m pytest --if-present || echo "no tests"`
  - `fail-fast: false` 설정

## 정답 확인

직접 작성한 후 [`answer/`](./answer/) 폴더의 정답과 비교해 보세요.
