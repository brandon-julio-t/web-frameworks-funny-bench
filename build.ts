import Bun, { $ } from "bun";

const apps = ["elysia", "hono", "express", "fastify"];

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
    await $`mise use dotnet-core && cd apps/aspnet-core && dotnet build -c Release -o ../../bin/aspnet-core`;
  })(),

  (async () => {
    await $`mise use go && cd apps/go && go build -o ../../bin/go main.go`;
  })(),

  (async () => {
    await $`mise use rust && cd apps/rust && cargo build --release`;
    await $`mise use rust && cp apps/rust/target/release/rust-server bin/rust`;
  })(),
]);
