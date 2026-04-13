# nvim 사내 보안망 환경 설정 가이드

사내 보안망으로 인해 `curl` SSL 인증서 폐기 확인이 차단되는 환경에서
nvim-treesitter parser와 blink.cmp 바이너리를 수동으로 설치하는 방법입니다.

---

## 전제 조건

| 항목 | 버전 | 비고 |
|------|------|------|
| Windows | x86_64 | - |
| Neovim | 0.13.0+ (nightly) | - |
| LLVM (clang) | 21.x 이상 권장 | [LLVM 다운로드](https://github.com/llvm/llvm-project/releases) |
| git | 최신 버전 | PATH 등록 필요 |
| curl | Windows 내장 | 별도 설치 불필요 |
| lazy.nvim | 최신 버전 | 플러그인 매니저 |
| nvim-treesitter | main 브랜치 | lazy.nvim으로 설치 |
| blink.cmp | v1.x | lazy.nvim으로 설치 |

> clang 설치 후 반드시 PATH에 등록되어 있어야 합니다.
> PowerShell에서 `clang --version` 으로 확인하세요.

---

## 사전 설정 (최초 1회)

### PowerShell 실행 정책 설정

PowerShell을 열고 아래 명령어를 실행합니다.

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

---

## 스크립트 사용법

### ts-build.ps1 — nvim-treesitter parser 설치

nvim-treesitter parser를 다운로드, 컴파일, 설치합니다.

**실행 전**: nvim에서 아래 명령어로 parser 소스를 먼저 다운로드합니다.

```vim
:TSInstall yaml bash html python cpp css javascript rust zig powershell
```

> 에러가 발생해도 괜찮습니다. 소스 파일만 받아지면 됩니다.

**스크립트 실행**:

```powershell
.\ts-build.ps1
```

**자동으로 처리되는 작업:**
- `install.lua` 에 `--ssl-no-revoke` 옵션 자동 추가
- 각 parser 소스를 GitHub에서 다운로드
- clang으로 컴파일
- `parser.so` 파일을 parser 디렉토리에 복사

**parser 목록 추가/제거**: 스크립트 상단의 `$PARSERS` 항목을 수정합니다.

```powershell
$PARSERS = @(
    "yaml", "bash", "html", "python", "cpp",
    "css", "javascript", "rust", "zig"
)
```

---

### blink-build.ps1 — blink.cmp 바이너리 설치

blink.cmp의 사전 빌드된 Windows 바이너리를 다운로드하여 설치합니다.

```powershell
.\blink-build.ps1
```

**자동으로 처리되는 작업:**
- 현재 설치된 blink.cmp 버전을 git tag로 자동 감지
- GitHub Releases에서 `x86_64-pc-windows-msvc.dll` 다운로드
- SHA256 체크섬 파일 다운로드 및 형식 자동 수정
- version 파일 삭제 (매 실행 시 다운로드 시도 방지)

---

## 업데이트 후 재설치

### nvim-treesitter 업데이트 시

nvim-treesitter를 업데이트하면 `install.lua` 가 초기화됩니다.
`ts-build.ps1` 을 다시 실행하면 자동으로 재적용됩니다.

```powershell
.\ts-build.ps1
```

### blink.cmp 업데이트 시

blink.cmp 버전이 바뀌면 바이너리도 새로 받아야 합니다.
`blink-build.ps1` 을 다시 실행하면 됩니다.

```powershell
.\blink-build.ps1
```

---

## 문제 해결

### parser 색상이 안 나올 때

`ts-build.ps1` 실행 후 nvim 재시작 후 parser 인식 여부 확인:

```vim
:lua print(vim.treesitter.language.inspect('yaml'))
```

`table: 0x...` 형태로 출력되면 정상입니다.

### blink.cmp 가 매번 다운로드를 시도할 때

`blink-build.ps1` 을 다시 실행합니다.

### curl 에러가 날 때

아래 에러는 사내 보안망으로 인한 SSL 문제입니다.

```
curl: (35) schannel: next InitializeSecurityContext failed: CRYPT_E_NO_REVOCATION_CHECK
```

`ts-build.ps1` 은 `--ssl-no-revoke` 옵션을 자동으로 적용하므로 스크립트를 통해 설치하면 됩니다.
단, GitHub 도메인이 사내 보안 정책에 등록되어 있어야 합니다.

---

## 사전 설정 (최초 1회)

### 1. PowerShell 실행 정책 설정

PowerShell을 관리자 권한으로 열고 실행합니다.

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

### 2. nvim-treesitter 설정

`lua/plugins/nvim-treesitter.lua` 에 아래 내용을 추가합니다.

```lua
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    -- clang 컴파일러 지정
    require("nvim-treesitter.install").compilers = { "clang" }

    -- runtime/queries 경로 runtimepath 에 추가
    vim.opt.runtimepath:append(vim.fn.stdpath('data') .. '/lazy/nvim-treesitter/runtime')

    require("nvim-treesitter.config").setup({
      ensure_installed = {
        "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
        "html", "yaml", "css", "javascript", "bash", "python",
        "cpp", "rust", "zig"
      },
      auto_install = false, -- 보안망 환경에서는 false 권장
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })
  end,
}
```

> `auto_install = false` 로 설정하지 않으면 파일을 열 때마다 자동 설치를 시도하여 에러가 발생할 수 있습니다.

### 3. blink.cmp 설정

`lua/plugins/blink-cmp.lua` 에서 `fuzzy` 설정을 확인합니다.

```lua
fuzzy = { implementation = "prefer_rust" },
```

> `prefer_rust` 로 설정되어 있어야 ps1 스크립트로 설치한 바이너리를 사용합니다.

---

## 스크립트 사용법

### ts-build.ps1 — nvim-treesitter parser 설치

nvim-treesitter parser를 다운로드, 컴파일, 설치합니다.

**실행 전**: nvim에서 아래 명령어로 parser 소스를 먼저 다운로드합니다.

```vim
:TSInstall yaml bash html python cpp css javascript rust zig
```

> 에러가 발생해도 괜찮습니다. 소스 파일만 받아지면 됩니다.

**스크립트 실행**:

```powershell
.\ts-build.ps1
```

**자동으로 처리되는 작업:**
- `install.lua` 에 `--ssl-no-revoke` 옵션 자동 추가
- 각 parser 소스를 GitHub에서 다운로드
- clang으로 컴파일
- `parser.so` 파일을 parser 디렉토리에 복사

**parser 목록 추가/제거**: 스크립트 상단의 `$PARSERS` 항목을 수정합니다.

```powershell
$PARSERS = @(
    "yaml", "bash", "html", "python", "cpp",
    "css", "javascript", "rust", "zig"
)
```

---

### blink-build.ps1 — blink.cmp 바이너리 설치

blink.cmp의 사전 빌드된 Windows 바이너리를 다운로드하여 설치합니다.

```powershell
.\blink-build.ps1
```

**자동으로 처리되는 작업:**
- 현재 설치된 blink.cmp 버전을 git tag로 자동 감지
- GitHub Releases에서 `x86_64-pc-windows-msvc.dll` 다운로드
- SHA256 체크섬 파일 다운로드 및 형식 자동 수정
- version 파일 삭제 (매 실행 시 다운로드 시도 방지)

---

## 업데이트 후 재설치

### nvim-treesitter 업데이트 시

nvim-treesitter를 업데이트하면 `install.lua` 가 초기화됩니다.
`ts-build.ps1` 을 다시 실행하면 자동으로 재적용됩니다.

```powershell
.\ts-build.ps1
```

### blink.cmp 업데이트 시

blink.cmp 버전이 바뀌면 바이너리도 새로 받아야 합니다.
`blink-build.ps1` 을 다시 실행하면 됩니다.

```powershell
.\blink-build.ps1
```

---

## 문제 해결

### parser 색상이 안 나올 때

1. `ts-build.ps1` 실행 후 nvim 재시작
2. nvim에서 parser 인식 여부 확인:

```vim
:lua print(vim.treesitter.language.inspect('yaml'))
```

`table: 0x...` 형태로 출력되면 정상입니다.

### blink.cmp 가 매번 다운로드를 시도할 때

`blink-build.ps1` 을 다시 실행합니다.

### curl 에러가 날 때

아래 에러는 사내 보안망으로 인한 SSL 문제입니다.

```
curl: (35) schannel: next InitializeSecurityContext failed: CRYPT_E_NO_REVOCATION_CHECK
```

`ts-build.ps1` 은 `--ssl-no-revoke` 옵션을 자동으로 적용하므로 스크립트를 통해 설치하면 됩니다.
GitHub 도메인이 사내 보안 정책에 등록되어 있어야 합니다.
