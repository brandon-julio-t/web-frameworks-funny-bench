import Bun, { $ } from "bun";

const apps = ["elysia", "hono", "express", "fastify", "bun"];

await $`rm -rf bin`;

await Promise.all([
  ...apps.map((app) => {
    return Bun.build({
      entrypoints: [`apps/${app}/server.ts`],
      outdir: `bin/${app}`,
      target: "bun",
      bytecode: true,
      compile: true,
    });
  }),

  (async () => {
    await $`cd apps/aspnet-core && dotnet build -c Release -o ../../bin/aspnet-core`;
  })(),

  (async () => {
    await $`cd apps/go && go build -o ../../bin/go main.go`;
  })(),

  (async () => {
    await $`cd apps/rust && cargo build --release`;
    await $`cp apps/rust/target/release/rust-server bin/rust`;
  })(),
]);
