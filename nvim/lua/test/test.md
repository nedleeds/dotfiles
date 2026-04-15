# 🛠️ Multi-Language Syntax Highlighting Test

이 파일의 모든 코드 블럭이 각 언어에 맞는 색상으로 보인다면 Tree-sitter 인젝션 설정이 완벽한 상태입니다.


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

### 주의

해당 배치 파일은, nvim 0.13.0. dev 기준으로 테스트한 버전입니다.

### 💡 만약 특정 언어만 색이 안 나온다면?
- 사외망인 경우
    1. **해당 파서 설치 여부 확인:** `:TSInstall <언어명>` (예: `:TSInstall zig`)
    2. **인젝션 확인:** 해당 블럭 위에 커서를 두고 `:Inspect`를 입력했을 때 `@language <언어명>`이 뜨는지 확인하세요.
    3. **전체 업데이트:** `:TSUpdate`를 실행하여 모든 파서와 쿼리를 최신화하세요.
- 사내망인 경우
    - 사내 보안망으로 인해 `curl`이 차단되어 parser 자동 설치가 실패합니다.
    - 해결 방법
        1. `ts-parser-install.bat` 실행 전 준비
            nvim에서 설치할 parser 소스를 먼저 다운로드합니다.
            ```vim
            :TSInstall yaml bash html python zig rust cpp css javascript
            ```
            > 에러가 나도 괜찮습니다. 소스 파일만 받아지면 됩니다.
        2. `ts-parser-install.bat` 실행
           같은 폴더에 있는 `ts-parser-install.bat` 을 실행합니다.
            ```
            ts-parser-install.bat
            ```
            각 parser가 순서대로 컴파일되고 복사됩니다.
        3. nvim 재시작
            ```vim
            :qa
            ```
            재시작 후 색상이 정상적으로 나오면 완료입니다.
        4. 새로운 parser를 추가하고 싶을 때
            1. `ts-parser-install.bat` 을 메모장으로 열어 `PARSERS` 항목에 추가
            ```bat
            set PARSERS=yaml bash html python zig rust cpp css javascript 새언어
            ```
            2. nvim에서 소스 다운로드
            ```vim
            :TSInstall 새언어
            ```
            3. `ts-parser-install.bat` 다시 실행

    - nvim-treesitter 업데이트 후
      업데이트 시 `install.lua` 가 초기화되므로 아래 파일에 `--ssl-no-revoke` 를 다시 추가해야 합니다.
        ```
        C:\Users\Admin\AppData\Local\nvim-data\lazy\nvim-treesitter\lua\nvim-treesitter\install.lua
        ```

      curl 호출 부분을 찾아 `'--ssl-no-revoke'` 를 추가합니다.

        ```lua
        local r = system({
          'curl',
          '--silent',
          '--ssl-no-revoke',  -- 이 줄 추가
          '--fail',
          ...
        })
        ```

      이후 `ts-parser-install.bat` 을 다시 실행합니다.
