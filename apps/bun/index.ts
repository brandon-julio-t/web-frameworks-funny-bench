import { z } from "zod";

const bodySchema = z.object({
  name: z.string(),
});

const port = Number(process.env.PORT) || 3000;

Bun.serve({
  port,
  async fetch(request) {
    // Only handle POST requests to root path
    if (request.method !== "POST" || new URL(request.url).pathname !== "/") {
      return new Response("Not Found", { status: 404 });
    }

    try {
      const body = await request.json();
      const result = bodySchema.safeParse(body);

      if (!result.success) {
        return Response.json(
          { error: "Invalid request body" },
          { status: 400 }
        );
      }

      return Response.json({
        data: `Hello, "${result.data.name}"!`,
      });
    } catch (error) {
      return Response.json({ error: "Invalid JSON" }, { status: 400 });
    }
  },
});

console.log(`Bun server running on port ${port}`);
