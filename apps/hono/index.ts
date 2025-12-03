import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { z } from "zod";

const app = new Hono();

app.post(
  "/",
  zValidator(
    "json",
    z.object({
      name: z.string(),
    })
  ),
  (c) => {
    const body = c.req.valid("json");
    return c.json({
      data: `Hello, "${body.name}"!`,
    });
  }
);

Bun.serve({
  port: Number(process.env.PORT) || 3000,
  fetch: app.fetch,
});
