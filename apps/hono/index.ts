import { Hono } from "hono";
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";
import { serve } from "@hono/node-server";

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

serve({
  ...app,
  port: Number(process.env.PORT) || 3000,
});
