/* LSP: clangd
 * 테스트 방법:
 *   K           → hover (타입/문서 보기)
 *   gd          → go-to-definition
 *   <leader>ca  → code actions
 *   <leader>rn  → rename
 *   diagnostics → 오류/경고가 있는 줄에서 확인
 */

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ── 1. Struct & Hover (K) ───────────────────────────────────────
 * Point 또는 멤버 위에서 K → 타입 정보가 표시되어야 합니다.       */
typedef struct {
  double x;
  double y;
} Point;

/* ── 2. Go-to-definition (gd) ───────────────────────────────────
 * distance 호출 위에서 gd → 함수 정의로 이동해야 합니다.          */
static double distance(Point a, Point b) {
  double dx = a.x - b.x;
  double dy = a.y - b.y;
  return __builtin_sqrt(dx * dx + dy * dy);
}

/* ── 3. Pointer & malloc ─────────────────────────────────────────
 * malloc / free 위에서 K → 시그니처 확인                          */
static int *make_array(size_t n) {
  int *arr = (int *)malloc(n * sizeof(int));
  if (!arr) return NULL;
  for (size_t i = 0; i < n; i++) arr[i] = (int)i;
  return arr;
}

/* ── 4. Diagnostics (경고) ──────────────────────────────────────
 * 아래 unused 변수는 clangd가 경고를 표시해야 합니다.
 * (주석을 제거하면 경고 발생)                                      */
/* static void trigger_warning(void) { int unused_var = 0; } */

/* ── 5. String operations ────────────────────────────────────────
 * strlen / strncpy 위에서 K → 문서 확인                           */
static void demo_strings(void) {
  char buf[64];
  const char *src = "clangd LSP test";
  strncpy(buf, src, sizeof(buf) - 1);
  buf[sizeof(buf) - 1] = '\0';
  printf("len=%zu  str=%s\n", strlen(buf), buf);
}

int main(void) {
  Point p1 = {0.0, 0.0};
  Point p2 = {3.0, 4.0};
  printf("distance = %.2f\n", distance(p1, p2));

  int *arr = make_array(5);
  if (arr) {
    for (int i = 0; i < 5; i++) printf("%d ", arr[i]);
    printf("\n");
    free(arr);
  }

  demo_strings();
  return 0;
}
