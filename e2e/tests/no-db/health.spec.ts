import { test, expect } from "@playwright/test";

test("アプリが起動し health エンドポイントが200を返す", async ({ request }) => {
  const res = await request.get("/actuator/health");
  expect(res.status()).toBe(200);

  const body = await res.json();
  expect(body.status).toBe("UP");
});
