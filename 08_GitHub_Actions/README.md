# 08. GitHub Actions

GitHub Actions는 코드 push, PR 생성, 일정 시간 등 이벤트에 반응해
자동으로 빌드·테스트·배포를 실행하는 CI/CD 플랫폼입니다.
YAML 파일 하나로 복잡한 파이프라인을 정의할 수 있으며,
오픈 소스 액션을 재사용해 빠르게 구성할 수 있습니다.

## 학습 목표

- GitHub Actions 워크플로우 YAML의 기본 구조를 이해하고 작성할 수 있다.
- `push`·`pull_request` 트리거와 수동 트리거(`workflow_dispatch`)를 설정할 수 있다.
- 매트릭스(matrix)로 여러 OS/버전 조합에서 병렬 테스트를 실행할 수 있다.
- 의존성 캐시로 워크플로우 실행 시간을 단축할 수 있다.
- artifacts로 빌드 산출물을 저장하고, secrets로 민감 정보를 안전하게 사용할 수 있다.

---

## 핵심 개념

### 1) 워크플로우 구조

```yaml
name: 워크플로우 이름

on:                      # 트리거
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  job-name:
    runs-on: ubuntu-latest    # 실행 환경
    steps:
      - uses: actions/checkout@v4           # 액션 사용
      - name: 단계 이름
        run: echo "Hello"                   # 셸 명령
```

### 2) 트리거 종류

```yaml
on:
  push:                         # push 이벤트
    branches: [main, develop]
    paths: ['src/**']           # 특정 경로 변경 시만
  pull_request:
    types: [opened, synchronize, reopened]
  schedule:
    - cron: '0 9 * * 1'        # 매주 월요일 09:00 UTC
  workflow_dispatch:            # 수동 실행 (UI 버튼)
    inputs:
      environment:
        type: choice
        options: [staging, production]
```

### 3) 매트릭스 전략

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, windows-latest, macos-latest]
    node: [18, 20, 22]
  fail-fast: false       # 하나 실패해도 나머지 계속 실행

runs-on: ${{ matrix.os }}
steps:
  - uses: actions/setup-node@v4
    with:
      node-version: ${{ matrix.node }}
```

### 4) 캐시

```yaml
- uses: actions/cache@v4
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-
```

### 5) Artifacts

```yaml
- uses: actions/upload-artifact@v4
  with:
    name: build-output
    path: dist/
    retention-days: 7

# 다운로드
- uses: actions/download-artifact@v4
  with:
    name: build-output
```

### 6) Secrets

```yaml
env:
  API_KEY: ${{ secrets.API_KEY }}
  DB_URL: ${{ secrets.DATABASE_URL }}

# GitHub → 저장소 Settings → Secrets and variables → Actions → New repository secret
```

---

## 예제로 보기

### 예제 1 — `ex01_hello.yml` : push 시 "Hello" 출력

```yaml
name: Hello World

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  greet:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Say Hello
        run: |
          echo "Hello, GitHub Actions!"
          echo "Repo: ${{ github.repository }}"
          echo "Branch: ${{ github.ref_name }}"
          echo "Actor: ${{ github.actor }}"
```

**실행 결과 (Actions 탭에서 확인)**

```
Hello, GitHub Actions!
Repo: username/my-repo
Branch: main
Actor: username
```

핵심: `github` 컨텍스트로 저장소·브랜치·사용자 정보를 가져올 수 있다.

---

### 예제 2 — `ex02_test.yml` : Node.js 프로젝트 CI

```yaml
name: Node.js CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install dependencies
        run: npm ci

      - name: Run linter
        run: npm run lint

      - name: Run tests
        run: npm test

      - name: Build
        run: npm run build
```

핵심: `npm ci`는 `package-lock.json`을 기준으로 정확히 설치해 재현성을 보장한다.

---

### 예제 3 — `ex03_matrix.yml` : OS·Node 버전 매트릭스

```yaml
name: Matrix Build

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ${{ matrix.os }}

    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        node-version: [18, 20, 22]
        exclude:
          - os: windows-latest
            node-version: 18   # 특정 조합 제외

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}

      - name: Install and test
        run: |
          npm ci
          npm test
```

핵심: 3 × 3 = 9개(제외 1개 포함 시 8개) 조합이 병렬로 실행된다.

---

### 예제 4 — `ex04_cache.yml` : 캐시로 설치 시간 단축 + artifacts 저장

```yaml
name: Build with Cache

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'          # 내장 캐시 (actions/cache 자동 설정)

      - name: Install dependencies
        run: npm ci

      - name: Build
        run: npm run build

      - name: Upload build artifacts
        uses: actions/upload-artifact@v4
        with:
          name: dist-${{ github.sha }}
          path: dist/
          retention-days: 7

  deploy:
    needs: build                 # build 완료 후 실행
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'

    steps:
      - name: Download artifact
        uses: actions/download-artifact@v4
        with:
          name: dist-${{ github.sha }}
          path: dist/

      - name: Deploy
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}
        run: echo "Deploying with secret key (masked)"
```

핵심: `needs`로 job 간 순서를 지정하고, secrets으로 민감 정보를 안전하게 전달한다.

---

## 다른 시각으로 보기

| Actions 개념 | 비유 |
|-------------|------|
| workflow | 공장 생산 라인 설계도 |
| job | 생산 라인의 각 작업장 |
| step | 작업장에서의 세부 작업 |
| action (`uses`) | 기성품 도구 |
| matrix | 여러 공장에서 동시 생산 |
| artifact | 완성품 포장 박스 |
| secrets | 금고에 잠긴 열쇠 |

---

## 자주 하는 실수

1. **`actions/checkout` 없이 코드 접근** — 워크플로우는 코드를 자동으로 가져오지 않는다.
2. **secrets를 `echo`로 출력** — GitHub가 마스킹하지만 로그에 남을 수 있다.
3. **캐시 key를 고정** — 의존성이 바뀌어도 캐시가 갱신되지 않는다; `hashFiles`로 동적 키를 사용한다.
4. **`fail-fast: true` 기본값 방치** — 하나 실패하면 모든 matrix job이 취소된다.
5. **`on: push` 없이 `workflow_dispatch` 만 설정** — 자동 실행이 되지 않는다.

---

## 정리

- 워크플로우는 `.github/workflows/*.yml` 에 저장하며 이벤트 → job → step 구조다.
- 매트릭스로 여러 환경 조합을 병렬 실행해 테스트 커버리지를 높인다.
- `cache`로 의존성 설치 시간을 단축하고, `artifact`로 빌드 결과물을 저장한다.
- `secrets`는 GitHub UI에서 설정하고, 워크플로우에서 `${{ secrets.NAME }}`으로 참조한다.
- `needs`로 job 간 의존 관계를 설정해 순서를 제어한다.

---

## 직접 해 보기

```bash
# Actions yml 파일은 GitHub 저장소에서 실행됩니다.
# 아래 명령으로 파일을 워크플로우 디렉토리에 복사하세요.
mkdir -p .github/workflows
cp 08_GitHub_Actions/src/ex01_hello.yml .github/workflows/
git add .github/workflows/ex01_hello.yml
git commit -m "ci: add hello workflow"
git push
# → GitHub 저장소 Actions 탭에서 결과를 확인하세요.
```

응용:
1. `workflow_dispatch` 에 `input` 파라미터를 추가해 수동 실행 시 환경을 선택하게 해 보세요.
2. `schedule` 트리거로 매일 자정에 실행되는 워크플로우를 만들어 보세요.
