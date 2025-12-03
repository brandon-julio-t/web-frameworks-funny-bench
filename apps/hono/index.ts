import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { z } from "zod";

const app = new Hono();

app.post(
  "/:id",
  zValidator(
    "json",
    z.object({
      name: z.string(),
    })
  ),
  (c) => {
    const body = c.req.valid("json");
    const id = c.req.param("id");
    const signature = c.req.query("signature");
    return c.json({
      id,
      signature,
      data: `Hello, "${body.name}"!`,
    });
  }
);

Bun.serve({
  port: Number(process.env.PORT) || 3000,
  fetch: app.fetch,
});
