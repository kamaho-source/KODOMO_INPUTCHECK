import { test, expect } from "@playwright/test";

test("DBコンポーネントの状態がUPである", async ({ request }) => {
  const res = await request.get("/actuator/health");
  expect(res.status()).toBe(200);

  const body = await res.json();
  expect(body.components.db.status).toBe("UP");
});
