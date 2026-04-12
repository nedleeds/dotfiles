// LSP: clangd (C++)
// 테스트 방법:
//   K           → hover (타입/문서 보기)
//   gd          → go-to-definition
//   <leader>ca  → code actions
//   <leader>rn  → rename
//   diagnostics → 오류/경고가 있는 줄에서 확인

#include <algorithm>
#include <iostream>
#include <memory>
#include <optional>
#include <string>
#include <vector>

// ── 1. Class & Hover (K) ─────────────────────────────────────────
// Shape / area() 위에서 K → 메서드 시그니처가 표시되어야 합니다.
class Shape {
public:
  virtual ~Shape()          = default;
  virtual double area() const = 0;
  virtual std::string name() const = 0;
};

class Circle : public Shape {
public:
  explicit Circle(double radius) : radius_(radius) {}
  double area() const override { return 3.14159265358979 * radius_ * radius_; }
  std::string name() const override { return "Circle"; }

private:
  double radius_;
};

class Rectangle : public Shape {
public:
  Rectangle(double w, double h) : w_(w), h_(h) {}
  double area() const override { return w_ * h_; }
  std::string name() const override { return "Rectangle"; }

private:
  double w_, h_;
};

// ── 2. Go-to-definition (gd) ─────────────────────────────────────
// print_area 호출 위에서 gd → 함수 정의로 이동해야 합니다.
static void print_area(const Shape &s) {
  std::cout << s.name() << ": area = " << s.area() << "\n";
}

// ── 3. Template & completion ─────────────────────────────────────
template <typename T>
T clamp(T value, T lo, T hi) {
  return std::max(lo, std::min(value, hi));
}

// ── 4. std::optional (hover로 타입 확인) ─────────────────────────
std::optional<int> safe_divide(int a, int b) {
  if (b == 0) return std::nullopt;
  return a / b;
}

// ── 5. Diagnostics (오류) ─────────────────────────────────────────
// 아래는 의도적 타입 에러 → clangd가 진단을 표시해야 합니다.
// (주석을 제거하면 에러 발생)
// int bad = "string type mismatch";

// ── 6. Smart pointer & vector ────────────────────────────────────
int main() {
  std::vector<std::unique_ptr<Shape>> shapes;
  shapes.push_back(std::make_unique<Circle>(5.0));
  shapes.push_back(std::make_unique<Rectangle>(4.0, 6.0));

  for (const auto &s : shapes) {
    print_area(*s);
  }

  // clamp 위에서 K → 템플릿 인스턴스 타입 확인
  std::cout << clamp(15, 0, 10) << "\n";

  // optional 결과 처리
  if (auto result = safe_divide(10, 3)) {
    std::cout << "10 / 3 = " << *result << "\n";
  }

  return 0;
}
