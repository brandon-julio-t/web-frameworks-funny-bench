import Elysia, { t } from "elysia";

const port = process.env.PORT || 3000;

new Elysia()
  .post(
    "/:id",
    ({ body, params, query }) => {
      return {
        id: params.id,
        signature: query.signature,
        data: `Hello, "${body.name}"!`,
      };
    },
    {
      body: t.Object({
        name: t.String(),
      }),
    }
  )
  .listen(port);

console.log(`Elysia server running on port ${port}`);
