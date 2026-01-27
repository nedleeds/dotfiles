
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
