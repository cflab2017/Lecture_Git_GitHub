# Git·GitHub 심화 강의

Git과 GitHub를 처음 접하는 입문자부터 실무에 적용하려는 개발자까지를 대상으로 한 8단원 한국어 실습 강의입니다.
명령줄 도구 `git`과 `bash`만으로 모든 예제를 실행할 수 있어 별도의 개발 환경 설정이 필요 없습니다.

---

## 학습 목표

- 버전 관리의 원리와 Git의 내부 구조를 이해한다.
- 혼자 혹은 팀에서 GitHub를 통해 협업하는 전체 흐름을 익힌다.
- rebase, cherry-pick, GitHub Actions 등 실무에서 자주 쓰는 고급 기능을 자신 있게 사용한다.

---

## 개발 환경

| 항목 | 권장 버전 |
|------|----------|
| Git  | 2.40 이상 |
| Bash | 5.x (macOS 기본 셸은 zsh이지만 bash로 실행 가능) |
| GitHub 계정 | 무료 계정으로 충분 |

### 운영체제별 Git 설치

```bash
# macOS (Homebrew)
brew install git

# Ubuntu / Debian
sudo apt update && sudo apt install git

# Windows — Git for Windows 설치 후 Git Bash 사용
# https://git-scm.com/download/win
```

### 최초 설정 (설치 후 반드시 실행)

```bash
git config --global user.name  "홍길동"
git config --global user.email "gildong@example.com"
git config --global core.editor "code --wait"   # VS Code 사용 시
```

### GitHub 계정

1. [github.com](https://github.com) 접속 → Sign up
2. Personal Access Token(PAT) 또는 SSH 키 설정 (→ 04단원 참고)

---

## 디렉토리 구조

```
Lecture_Git_GitHub/
├── README.md
├── 01_시작하기/
│   ├── README.md
│   ├── src/
│   └── homework/
│       └── answer/
├── 02_일상_작업/
├── 03_브랜치와_병합/
├── 04_원격_저장소/
├── 05_GitHub_협업/
├── 06_취소와_되돌리기/
├── 07_rebase와_cherry-pick/
└── 08_GitHub_Actions/
```

---

## 단원 인덱스

| # | 폴더 | 주제 |
|---|------|------|
| 01 | [01_시작하기](./01_시작하기/) | Git 설치·config·첫 init·첫 commit·GitHub 가입 |
| 02 | [02_일상_작업](./02_일상_작업/) | add·commit·log·diff·.gitignore·alias·HEAD |
| 03 | [03_브랜치와_병합](./03_브랜치와_병합/) | branch·switch·merge·FF vs 3-way·conflict 해결 |
| 04 | [04_원격_저장소](./04_원격_저장소/) | clone·push·pull·fetch·remote·PAT/SSH |
| 05 | [05_GitHub_협업](./05_GitHub_협업/) | fork·PR·Issue·Review·CODEOWNERS |
| 06 | [06_취소와_되돌리기](./06_취소와_되돌리기/) | reset·revert·restore·reflog·stash |
| 07 | [07_rebase와_cherry-pick](./07_rebase와_cherry-pick/) | rebase -i·squash·cherry-pick·force-with-lease |
| 08 | [08_GitHub_Actions](./08_GitHub_Actions/) | workflow·trigger·matrix·cache·artifacts·secrets |

---

## 학습 순서

1주 1단원 페이스를 권장합니다.

```
1주차  01_시작하기       ← Git 첫걸음
2주차  02_일상_작업      ← 매일 쓰는 명령
3주차  03_브랜치와_병합  ← 협업의 핵심
4주차  04_원격_저장소    ← GitHub 연동
5주차  05_GitHub_협업    ← 팀 워크플로우
6주차  06_취소와_되돌리기 ← 실수 대처
7주차  07_rebase와_cherry-pick ← 히스토리 정리
8주차  08_GitHub_Actions ← 자동화
```

---

## 각 단원 실습 방법

```bash
cd NN_단원명/src
chmod +x *.sh
./ex01_*.sh
```

---

## 라이선스

MIT License — 자유롭게 사용·수정·배포할 수 있습니다.
