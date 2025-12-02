import Fastify from "fastify";
import { z } from "zod";

const fastify = Fastify({
  logger: false,
});

const bodySchema = z.object({
  name: z.string(),
});

fastify.post("/", async (request, reply) => {
  const result = bodySchema.safeParse(request.body);

  if (!result.success) {
    return reply.status(400).send({ error: "Invalid request body" });
  }

  return {
    data: `Hello, "${result.data.name}"!`,
  };
});

const port = process.env.PORT || 3003;
fastify.listen({ port: Number(port) }, (err) => {
  if (err) {
    fastify.log.error(err);
    process.exit(1);
  }
  console.log(`Fastify server running on port ${port}`);
});
