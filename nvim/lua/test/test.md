요청하신 대로 Neovim에서 `render-markdown.nvim`과 **Tree-sitter**의 인젝션이 모든 언어에서 정상 작동하는지 한 번에 테스트할 수 있는 마크다운 소스 코드입니다.

아래 블록 전체를 복사해서 `.md` 파일에 붙여넣어 보세요.

```markdown
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
```

### 💡 만약 특정 언어만 색이 안 나온다면?
1. **해당 파서 설치 여부 확인:** `:TSInstall <언어명>` (예: `:TSInstall zig`)
2. **인젝션 확인:** 해당 블럭 위에 커서를 두고 `:Inspect`를 입력했을 때 `@language <언어명>`이 뜨는지 확인하세요.
3. **전체 업데이트:** `:TSUpdate`를 실행하여 모든 파서와 쿼리를 최신화하세요.
