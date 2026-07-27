# 🛠️ Multi-Language Syntax Highlighting Test

이 파일의 모든 코드 블럭이 각 언어에 맞는 색상으로 보인다면 Tree-sitter 인젝션 설정이 완벽한 상태입니다.
각 언어에 맞는 색상들이 보이지 않을 경우, 하단의 nvim-treesiiter 설정 메뉴얼을 따라 진행하세요.

---

### 1. Web Stack (HTML, CSS, JS)
```html
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Neovim Test</title>
    <style>
        body { background-color: #282c34; color: white; }
        .highlight { color: #61afef; font-weight: bold; }
    </style>
</head>
```

```css
/* CSS Highlight Check */
@media (max-width: 600px) {
    main.container {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 10px;
    }
}
```

```javascript
// JavaScript Arrow Function & Template Literals
const checkStatus = (plugin) => {
    const message = `Plugin ${plugin} is active!`;
    console.log(message);
    return { status: 200, active: true };
};
```

---

### 2. Systems Programming (C, C++, Rust, Zig)
```c
/* Standard C */
#include <stdio.h>

int main(void) {
    char *msg = "Hello Neovim 0.13.0.dev";
    printf("%s\n", msg);
    return 0;
}
```

```cpp
// C++ Containers & Auto
#include <iostream>
#include <vector>
#include <string>

int main() {
    std::vector<std::string> tools = {"Treesitter", "LSP", "DAP"};
    for (const auto& tool : tools) {
        std::cout << "Using: " << tool << std::endl;
    }
    return 0;
}
```

```rust
// Rust Pattern Matching & Macros
fn main() {
    let result = Some(42);
    match result {
        Some(n) => println!("The answer is {}", n),
        None => println!("No answer found"),
    }
}
```

```zig
// Zig Language
const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Zig {s} is working!\n", .{"highlighting"});
}
```

---

### 3. Config & Scripting (YAML, Bash, Python)
```yaml
# YAML Configuration
neovim_version: "0.13.0.dev"
features:
  treesitter: true
  lsp: true
  render_markdown:
    enabled: true
    theme: "dark"
```

```bash
#!/bin/bash
# Check if a directory exists
TARGET_DIR="$HOME/.config/nvim"
if [ -d "$TARGET_DIR" ]; then
    echo "Neovim config found at $TARGET_DIR"
fi
```

```python
# Python Decorators & Typing
from typing import List

def debug(func):
    def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__}")
        return func(*args, **kwargs)
    return wrapper

@debug
def greet(names: List[str]) -> None:
    for name in names:
        print(f"Hello, {name}!")
```


# nvim-treesitter 설정 (Windows / Neovim 0.12 / vim.pack)

Windows에서 nvim-treesitter를 처음부터 설정하는 절차. 핵심은 **컴파일러 지정(`CC=clang`)** 이다. 이걸 빼면 파서 빌드가 `cl.exe not found`로 실패한다.

---

## 0. 사전 요구사항

### clang 설치

tree-sitter CLI는 Windows에서 기본적으로 MSVC(`cl.exe`)를 찾는다.
`cl.exe`는 Developer Command Prompt에서만 PATH에 잡히므로, 일반 PowerShell에서 nvim을 실행하면 빌드가 실패한다.
clang을 쓰면 이 문제를 우회할 수 있다.

```powershell
winget install LLVM.LLVM
```

설치 확인:

```powershell
clang --version
```

버전이 출력되지 않으면 PATH를 확인한다. 보통 `C:\Program Files\LLVM\bin`.

### git 확인

`vim.pack`은 git으로 플러그인을 clone한다.

```powershell
git --version
```

---

## 1. `CC` 환경변수 지정 (가장 중요)

`init.lua` **최상단**에 추가한다.

```lua
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.env.CC = "clang"          -- tree-sitter 파서 빌드용
```

`vim.env.CC`는 nvim이 띄우는 자식 프로세스(= tree-sitter CLI)의 환경변수를 설정한다.
이게 없으면 tree-sitter가 `cl.exe`를 찾다가 `Error: program not found`로 죽는다.

적용 확인 (nvim 재시작 후):

```vim
:lua vim.print(vim.env.CC)
```

`clang`이 출력되어야 한다. `nil`이면 아래를 의심한다.

- 해당 줄이 실제로 파일에 있는지
- 그 파일이 `init.lua`에서 `require` 되고 있는지

```powershell
Select-String -Path "$env:LOCALAPPDATA\nvim\init.lua","$env:LOCALAPPDATA\nvim\lua\**\*.lua" -Pattern "vim.env.CC"
```

---

## 2. 플러그인 설치 및 setup

`lua\config\treesitter.lua` 생성:

```lua
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })

-- main 브랜치는 쿼리 파일이 runtime/queries/ 아래에 있다.
-- setup()이 이 경로를 runtimepath에 등록해준다. 생략하면 injection이 동작하지 않는다.
require("nvim-treesitter").setup()

-- 파서가 있어도 자동으로 켜지지 않는다. 버퍼마다 start()를 호출해야 한다.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "python", "lua", "json", "yaml", "html", "markdown", "javascript", "java", "zig", "rust" },
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
```

`init.lua`에 등록:

```lua
require("config.treesitter")
```

> **`require` 누락 주의.** 파일만 만들고 `init.lua`에 추가하지 않으면 아무 일도 일어나지 않는다. 가장 흔한 실수.

---

## 3. 파서 설치

nvim 재시작 후:

```vim
:lua require("nvim-treesitter").install({ "c", "cpp", "python", "json", "yaml", "html", "markdown", "markdown_inline" })
```

또는:

```vim
:TSInstall cpp
```

### markdown 코드 블록 하이라이팅

마크다운 안의 ` ```cpp ` 블록에 색을 입히려면 **세 가지가 모두** 필요하다.

| 필요한 것 | 없으면 |
|---|---|
| `markdown` + `markdown_inline` 파서 | 마크다운 자체가 파싱 안 됨 |
| injection 쿼리 (`runtime/queries/markdown/injections.scm`) | 코드 블록이 raw 텍스트 덩어리로만 인식됨 |
| 해당 언어 파서 (`cpp`, `html` 등) | 그 블록만 색이 안 입혀짐 |

즉 `markdown`만 설치하면 코드 블록은 밋밋하게 나온다. 블록에서 쓸 언어를 전부 설치해야 한다.

---

## 4. 설치 확인

### 파서 파일

```powershell
ls "$env:LOCALAPPDATA\nvim-data\site\pack\core\opt\nvim-treesitter\parser"
```

**확장자는 반드시 `.so`.** Windows에서도 마찬가지다. 실제 내용은 DLL이지만 nvim은 `.so`만 인식한다. 수동으로 빌드한 `.dll`이 있다면 이름을 바꾼다.

```powershell
$dir = "$env:LOCALAPPDATA\nvim-data\site\pack\core\opt\nvim-treesitter\parser"
Get-ChildItem $dir -Filter "*.dll" | ForEach-Object {
  Rename-Item $_.FullName ($_.BaseName + ".so")
}
```

### 쿼리 파일 (main 브랜치)

```powershell
ls "$env:LOCALAPPDATA\nvim-data\site\pack\core\opt\nvim-treesitter\runtime\queries\markdown"
```

`injections.scm`, `highlights.scm`이 보여야 한다. 없다면 clone이 불완전한 것.

> 예전 `master` 브랜치는 최상위 `queries/`를 썼다. `main`은 `runtime/queries/`로 옮겼고, 이 경로는 `setup()`이 등록해준다.

### nvim 내부 확인

```vim
:lua vim.print(vim.api.nvim_get_runtime_file("parser/*", true))   " 인식된 파서 목록
:lua print(pcall(vim.treesitter.language.add, "cpp"))             " 파서 로딩 가능한지
:checkhealth vim.treesitter
```

`vim.treesitter.language.add`가 `false`를 반환하면 뒤따르는 에러 메시지를 본다. ABI 불일치면 파서를 다시 빌드해야 한다.

---

## 5. 동작 확인

C++ 파일을 열고:

```vim
:Inspect
```

`@keyword.cpp`, `@function.call` 같은 treesitter 캡처가 나오면 정상.

마크다운의 코드 블록 안에서:

```vim
:InspectTree
```

injected language(`cpp` 등)가 트리에 표시되면 injection이 동작 중이다.

---

## 문제 해결

### `Error: program not found` (cl.exe)

`vim.env.CC = "clang"`이 적용되지 않은 것. 1번 항목 재확인.

대안: **Developer Command Prompt for VS**에서 nvim을 실행하면 `cl.exe`가 PATH에 잡힌다. 파서는 한 번만 빌드하면 되므로, 빌드할 때만 그 셸을 쓰고 이후엔 일반 PowerShell로 돌아와도 된다.

### C/Lua/Vim만 하이라이팅됨

nvim이 이 몇 개는 파서를 내장하고 기본 활성화한다. 나머지는 파서 설치 + `vim.treesitter.start()` 호출이 모두 필요하다. 2번의 `FileType` autocmd가 로드되고 있는지 확인:

```vim
:autocmd FileType cpp
```

### 파서는 로드되는데 색이 안 나옴

`vim.treesitter.start()`를 수동 실행해본다.

```vim
:lua vim.treesitter.start()
```

이걸로 색이 들어오면 autocmd 문제. 안 들어오면 쿼리(`highlights.scm`) 문제.

### 사내망에서 clone/download 실패

git이 무한 대기하는 것을 막는다.

```powershell
git config --global http.lowSpeedLimit 1000
git config --global http.lowSpeedTime 20
git config --global http.sslBackend schannel
```

---

## 요약

```lua
-- init.lua 최상단
vim.env.CC = "clang"

-- lua/config/treesitter.lua
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })
require("nvim-treesitter").setup()
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "python", "lua", "json", "yaml", "html", "markdown" },
  callback = function(args) pcall(vim.treesitter.start, args.buf) end,
})
```

```vim
:lua require("nvim-treesitter").install({ "c", "cpp", "python", "json", "yaml", "html", "markdown", "markdown_inline" })
```

세 가지만 기억하면 된다. **`CC=clang`**, **`setup()` 호출**, **`FileType` autocmd로 `start()`**.
