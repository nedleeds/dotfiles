# Requirements

## 0. nvim 설치
- https://github.com/neovim/neovim/releases
- Assets 토글버튼 클릭
- nvim-win64.msi 다운로드
- 실행

## 0.1 nvim 설정 파일 다운로드 및 적용
```powershell
$time=Get-Date -Format "yyyyMMdd-HHmmss"; `
mv $env:LOCALAPPDATA\nvim "$env:LOCALAPPDATA\nvim-backup-$time" -ea SilentlyContinue; `
mv $env:LOCALAPPDATA\nvim-data "$env:LOCALAPPDATA\nvim-data-backup-$time" -ea SilentlyContinue; `
cd $env:TEMP; `
git clone https://github.com/nedleeds/dotfiles.git; `
mv "$env:TEMP\dotfiles\windows\nvim" $env:LOCALAPPDATA\; `
rm "$env:TEMP\dotfiles" -r -fo
```
## 1. fzf

#### 1-1) 사용자 bin 폴더 생성 (없으면 생성)
```powershell
mkdir $env:USERPROFILE\bin -ErrorAction Ignore
```

#### 1-2) GitHub Release 다운로드

a. https://github.com/junegunn/fzf/releases 이동
b. 최상단 버전 확인 > 하기 Assets 토글 버튼 클릭 > windows_amd62.zip 다운


#### 1-3) 압축 해제

a. windows_amd62.zip 압축해제 > fzf.exe 생성
b. bin 폴더 열기
```powershell
explorer $env:LOCALAPPDATA\bin
```
c. fzf.exe 를 bin 폴더로 이동


### 1-4) PATH 추가 (현재 사용자 영구 설정, 1회만 수행)

(ex. C:\Users\Admin\AppData\Local\bin)
```text
윈도우 키 → 시스템 환경 변수 → 사용자 변수 PATH → 편집 → 추가
```


### 1-5) powershell 종료

```powershell
exit
```

### 1-6) 새 PowerShell 열고 확인

```powershell
fzf --version
0.67.0 (2ab923f3) //버전이 출력되면 성공.
```

### 1-7) nvim 에서 확인

a. 터미널에서 test 파일을 nvim 으로 실행

```powershell
nvim test.md
```

b. 진입 후, 하기 순서대로 입력.

- `스페이스키` 입력 > 우측 상단 f (Find) 확인 후 `f키` 입력 > "Find: files" 에 해당하는 `f키` 재입력
- fzf.exe 를 활용한 파일 탐색 창이 뜨면 성공

----

## 2. opencode 설치

#### 2-1) powershell 에서 opencode 설치

```powershell
# 원클릭 설치 스크립트 실행
curl -fsSL https://opencode.ai/install | bash
```
#### 2-2) 터미널 재실행
#### 2-3) 설치 확인
```powershell
# 설치 확인
opencode --version
```

----


## 3. lsp servers

### 3.1 lua-language-servers

#### 3.1-1) 최신 lua-language-servers prebuilt 설치
a. https://github.com/LuaLS/lua-language-server/releases 이동
b. 최상단 버전의 Assets 토글 버튼 클릭
c. win32-x64.zip 다운
d. bin 폴더 열기
```powershell
explorer $env:LOCALAPPDATA\bin
```
#### 3.1-2) lua-language-server 폴더 생성 후 해당 폴더 안에 압축해제
#### 3.1-3) exe 가 있는 bin 폴더 PATH 변수에 등록

(ex. C:\Users\Admin\AppData\Local\bin\lua-language-server\bin)

```text
윈도우 키 → 시스템 환경 변수 → 사용자 변수 PATH → 편집 → 추가
```
#### 3.1-4) powershell 재실행
```powershell
exit
```

#### 3.1-5) 설치 확인

```powershell
lua-language-server --version
3.17.1 //버전이 출력되면 정상 설치
```

### 3.2 pyright, ruff(lint, formatter)

#### 3.2-1) pyright 설치하기

Node.js / npm 이 이미 설치되어 있는지 먼저 확인

```powershell
node -v
npm -v
```
- 버전이 출력되면 이미 설치된 상태
- 없다면 아래 명령으로 설치

```powershell
winget install OpenJS.NodeJS.LTS
```
- 이 명령도 안되면, 직접 사이트 들어가서 설치 파일로 설치.


```powershell
npm install -g pyright
```
#### 3.2-2) 설치 확인

```powershell
pyright --version
pyright 1.1.407
```

### 3.2-3) ruff 설치하기

```powershell
python -m pip install --user -U ruff
```

### 3.2-4) ruff 경로 확인하기

```powershell
dir "C:\Users\Admin\AppData\Roaming\Python\Python38\Scripts\ruff*"dir "$base\Scripts\ruff*"

Directory: C:\Users\Admin\AppData\Roaming\Python\Python38\Scripts

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---        2026-01-27 오전 11:05       24735232 ruff.exe
```

### 3.2-5) 4)에서 정상적으로 나오면 PATH 등록하기

(ex. C:\Users\Admin\AppData\Roaming\Python\Python38\Scripts)

```text
윈도우 키 → 시스템 환경 변수 → 사용자 변수 PATH → 편집 → 추가
```
### 3.2-6) 터미널 종료 후 재실행

### 3.2-7) 테스트 코드 확인

```python
"""
LSP 테스트용 Python 파일

확인 포인트:
1. pyright  → 타입 에러, 타입 추론
2. ruff    → lint (unused, import 정리, 스타일 경고)
3. ruff fmt → 자동 포맷
"""

import os  # ❌ ruff: unused import 경고 떠야 함
import sys  # ❌ ruff: unused import 경고


# ---------------------------
# 1️⃣ 타입 에러 (pyright 테스트)
# ---------------------------

def add(a: int, b: int) -> int:
    return a + b


x = add("1", 2)  # ❌ pyright: str -> int 타입 에러 떠야 정상


# ---------------------------
# 2️⃣ unused 변수 (ruff 테스트)
# ---------------------------

unused_value = 123  # ❌ ruff: F841 unused variable


# ---------------------------
# 3️⃣ 스타일/포맷 테스트 (ruff format)
# ---------------------------

def messy( a,b ):
    return{  "a":a,"b":b }  # ❌ 포맷 엉망 → ruff format 하면 자동 정렬


# ---------------------------
# 4️⃣ 타입 추론 테스트 (pyright hover)
# ---------------------------

def greet(name: str) -> str:
    return f"hello {name}"


msg = greet("world")
print(msg)  # hover 시: str 타입 표시돼야 정상


# ---------------------------
# 5️⃣ dead code (ruff)
# ---------------------------

def never_called():
    print("dead code")  # ❌ ruff: unused function 경고
```
- nvim test.py 로 진입 후, 상기 코드를 붙여넣는다.
- 붙여놓고, esc 를 두번 누른다음 하단 상태바에 "NORMAL" 모드 확인
- 그 상태에서 스페이스파 > b키 > b키 > 팝업 창 확인 (ruff, pyright 정적 분석 결과 확인)

### 3.3 clangd(llvm)

#### 3.3-1) 최신 LLVM(= clangd) prebuilt 설치

a. https://github.com/llvm/llvm-project/releases 이동
b. 최상단 버전 확인
c. Assets 토글 버튼 클릭
d. Windows x64용 zip 또는 installer 다운로드

(권장: zip → exe만 bin에 복사 방식)


#### 3.3-2) bin 폴더 열기

powershell 실행:

```powershell
explorer $env:LOCALAPPDATA\bin
```


### 3.3 clangd(llvm)

#### 3.3-1) 최신 LLVM(= clangd) 설치

a. https://github.com/llvm/llvm-project/releases 이동
b. 최상단 버전 확인
c. Assets 토글 버튼 클릭
d. Windows x64 Installer (.exe) 다운로드 (권장)

※ zip 방식 대신 Installer 권장
→ 자동으로 C:\Program Files\LLVM\bin 에 설치됨


#### 3.3-2) 설치 진행

다운로드한 LLVM Installer(.exe) 실행 후 기본 옵션 그대로 설치

기본 설치 경로:
```text
C:\Program Files\LLVM\bin
```


#### 3.3-3) clangd.exe 존재 확인

powershell:
```powershell
dir "C:\Program Files\LLVM\bin\clangd.exe"
```

정상 예시:

clangd.exe


#### 3.3-4) PATH 변수 등록

아래 경로를 사용자 PATH에 추가

C:\Program Files\LLVM\bin

등록 방법:
```text
윈도우 키 → 시스템 환경 변수 → 사용자 변수 PATH → 편집 → 추가
```


#### 3.3-5) PowerShell 종료

powershell:

```powershell
exit
```


#### 3.3-6) 설치 확인

새 PowerShell 실행 후:

powershell:

```powershell
where.exe clangd
clangd --version
```


정상 예시:
```powershell
C:\Program Files\LLVM\bin\clangd.exe
clangd version 18.x.x
```

버전이 출력되면 정상 설치 완료

#### 3.3-8) Visual Studio 2013 과 연동하기

회사/구형 MSVC/Windows SDK 환경에서
헤더(stdio.h, windows.h 등) 인식이 안 되는 경우 사용
clangd 실행 전에 INCLUDE 환경 변수를 강제로 세팅하기 위한 wrapper bat 파일 생성 방법


① clangd 설치 경로 이동

powershell:
```powershell
explorer "C:\Program Files\LLVM\bin"
```

② 새 파일 생성
- 빈 공간 우클릭 → 새로 만들기 → 텍스트 문서
- 파일명 변경:

clangd.exe.bat

(중요: 확장자 반드시 .bat)


③ 메모장으로 열기

powershell:
```powershell
notepad "C:\Program Files\LLVM\bin\clangd.exe.bat"
```

④ 아래 내용 그대로 붙여넣기 후 저장

```text
@echo off
set INCLUDE=C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\INCLUDE;C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\ATLMFC\INCLUDE;C:\Program Files (x86)\Windows Kits\8.1\include\shared;C:\Program Files (x86)\Windows Kits\8.1\include\um;C:\Program Files (x86)\Windows Kits\8.1\include\winrt;
clangd --cross-file-rename --background-index --clang-tidy --log=error %*
```

⑤ 저장 후 닫기

⑥ 동작 확인
powershell:
```
where.exe clangd.exe.bat
```
정상 예시:
```text
C:\Program Files\LLVM\bin\clangd.exe.bat
```

⑧ hi6_control_sw 폴더로 이동

cpp 파일을 nvim 으로 열어서 확인.

※ 참고

- 최신 Visual Studio(2019/2022) 사용 시 INCLUDE 경로는 버전에 맞게 수정 필요
- 가능하면 compile_commands.json 사용이 더 권장됨
- bat 방식은 레거시/회사 PC 대응용 보조 방법

### 3.4 ts-server (js 사용할 계획있는 사람만 선택적으로 진행)

### 3.4 ts-server (TypeScript / JavaScript)

#### 3.4-1) Node.js 설치 확인
Node.js / npm 이 이미 설치되어 있는지 먼저 확인

```powershell
node -v
npm -v
```

- 버전이 출력되면 이미 설치된 상태
- 없다면 아래 명령으로 설치

```powershell
winget install OpenJS.NodeJS.LTS
```


#### 3.4-2) TypeScript + ts language server 설치

TypeScript 컴파일러 + LSP 서버 함께 설치

```powershell
npm install -g typescript typescript-language-server
```

#### 3.4-3) 설치 확인

```powershell
tsc -v
typescript-language-server --version
where.exe typescript-language-server
```

정상 예시:

```text
Version 5.x.x
0.x.x
C:\Users\Admin\AppData\Roaming\npm\typescript-language-server.cmd
```

#### 3.4-4) npm global 경로 문제 발생 시 (권한/인식 안 될 때만)

npm 글로벌 설치 위치를 사용자 영역으로 변경

```powershell
npm config set prefix "$env:APPDATA\npm"
```

현재 세션 즉시 적용

```powershell
$env:PATH = "$env:APPDATA\npm;$env:PATH"
```

영구 적용 (새 터미널부터 적용)

```powershell
setx PATH "$([Environment]::GetEnvironmentVariable('Path','User'));$env:APPDATA\npm"
```


#### 3.4-5) PowerShell 종료 후 재실행

```powershell
exit
```

#### 3.4-6) nvim 동작 확인

테스트 파일 생성 후 실행

```powershell
nvim test.ts
```

nvim 내부에서:
:LspInfo

→ tsserver Attached 표시되면 정상

#### 3.4-7) 테스트 코드 예시 (타입 진단/자동완성 확인용)

```text
type User = {
  id: number;
  name: string;
};

function greet(u: User) {
  return "hello " + u.name;
}

const u: User = { id: 1, name: "kim" };

greet(u);
greet({ id: "1", name: "lee" }); // ❌ number → string 타입 에러 발생해야 정상
```

확인 포인트:

- id: "1" 부분에 빨간 진단 표시
- hover 시 타입 정보 표시
- 자동완성/정의 이동 동작하면 성공
