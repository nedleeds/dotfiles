// LSP: eslint (+ tsserver if installed)
// 테스트 방법:
//   K           → hover (타입/문서 보기)
//   gd          → go-to-definition
//   <leader>ca  → code actions
//   <leader>rn  → rename
//   diagnostics → 오류/경고가 있는 줄에서 확인

// ── 1. Interface & Hover (K) ─────────────────────────────────────
// Point 인터페이스 위에서 K → 타입 정보가 표시되어야 합니다.
interface Point {
  x: number;
  y: number;
}

interface Config {
  host: string;
  port: number;
  debug?: boolean;
}

// ── 2. Go-to-definition (gd) ─────────────────────────────────────
function distance(a: Point, b: Point): number {
  return Math.sqrt((a.x - b.x) ** 2 + (a.y - b.y) ** 2);
}

// distance 위에서 gd → 함수 정의로 이동해야 합니다.
const d = distance({ x: 0, y: 0 }, { x: 3, y: 4 });
console.log(d);

// ── 3. Generic & type completion ─────────────────────────────────
function identity<T>(value: T): T {
  return value;
}

// identity( 를 입력하면 타입 파라미터 힌트가 표시되어야 합니다.
const num = identity<number>(42);
const str = identity<string>("hello");

// ── 4. Diagnostics (오류) ─────────────────────────────────────────
const cfg: Config = {
  host: "localhost",
  port: 8080,
};

// 아래는 의도적 타입 에러 → tsserver/eslint가 진단을 표시해야 합니다.
// (주석을 제거하면 에러 발생)
// const bad: Config = { host: 42, port: "wrong" };

// ── 5. Async / Promise ────────────────────────────────────────────
async function fetchData(url: string): Promise<{ status: number }> {
  const res = await fetch(url);
  return { status: res.status };
}

// ── 6. Enum ───────────────────────────────────────────────────────
enum Direction {
  Up    = "UP",
  Down  = "DOWN",
  Left  = "LEFT",
  Right = "RIGHT",
}

// Direction. 을 입력하면 열거값이 자동완성되어야 합니다.
const move = Direction.Up;
console.log(move, num, str, cfg);
