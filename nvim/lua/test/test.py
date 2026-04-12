# LSP: pyright
# 테스트 방법:
#   K           → hover (타입/문서 보기)
#   gd          → go-to-definition
#   <leader>ca  → code actions
#   <leader>rn  → rename
#   diagnostics → 오류/경고가 있는 줄에서 확인

from __future__ import annotations

import os
from typing import Optional

# ── 1. Hover (K) ─────────────────────────────────────────────────
# os.path.join 위에서 K → 함수 시그니처와 docstring이 표시되어야 합니다.
home = os.path.join(os.path.expanduser("~"), ".config", "nvim")


# ── 2. Go-to-definition (gd) ─────────────────────────────────────
class Point:
    def __init__(self, x: float, y: float) -> None:
        self.x = x
        self.y = y

    def distance(self, other: "Point") -> float:
        return ((self.x - other.x) ** 2 + (self.y - other.y) ** 2) ** 0.5


# Point 위에서 gd → 클래스 정의로 이동해야 합니다.
p1 = Point(0.0, 0.0)
p2 = Point(3.0, 4.0)
dist = p1.distance(p2)


# ── 3. Type annotations & completion ─────────────────────────────
def greet(name: str, times: int = 1) -> list[str]:
    """Return a list of greeting strings."""
    return [f"Hello, {name}!" for _ in range(times)]


# greet( 를 입력하면 파라미터 힌트가 표시되어야 합니다.
messages = greet("neovim", 3)


# ── 4. Diagnostics (오류) ─────────────────────────────────────────
def add(a: int, b: int) -> int:
    return a + b


# 아래는 의도적 타입 에러 → pyright가 진단을 표시해야 합니다.
# (주석을 제거하면 경고 발생)
# result: int = add("not", "numbers")


# ── 5. Optional 처리 ─────────────────────────────────────────────
def find_config(key: str) -> Optional[str]:
    data = {"editor": "neovim", "theme": "tokyonight"}
    return data.get(key)


value = find_config("editor")
# value 는 Optional[str] → None 체크 없이 쓰면 pyright가 경고해야 합니다.
if value is not None:
    print(value.upper())
