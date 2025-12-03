import { z } from "zod";

const bodySchema = z.object({
  name: z.string(),
});

const port = Number(process.env.PORT) || 3000;

const server = Bun.serve({
  port,
  routes: {
    // Dynamic route for POST requests to /:id
    "/:id": {
      POST: async (req) => {
        const id = req.params.id;
        const url = new URL(req.url);
        const signature = url.searchParams.get("signature");

        try {
          const body = await req.json();
          const result = bodySchema.safeParse(body);

          if (!result.success) {
            return Response.json(
              { error: "Invalid request body" },
              { status: 400 }
            );
          }

          return Response.json({
            id,
            signature,
            data: `Hello, "${result.data.name}"!`,
          });
        } catch (error) {
          return Response.json({ error: "Invalid JSON" }, { status: 400 });
        }
      },
    },
  },
  // Fallback for unmatched routes
  fetch(req) {
    return new Response("Not Found", { status: 404 });
  },
});

console.log(`Bun server running at ${server.url}`);
