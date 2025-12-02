import Elysia, { t } from "elysia";

const port = process.env.PORT || 3000;

new Elysia()
  .post(
    "/",
    ({ body }) => {
      return {
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
