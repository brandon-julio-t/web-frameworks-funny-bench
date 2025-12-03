module.exports = {
  apps: [
    {
      name: "elysia",
      script: "./bin/elysia/server",
      env: {
        PORT: 3000,
        NODE_ENV: "production",
      },
    },
    {
      name: "hono",
      script: "bun run apps/hono/server.ts",
      // script: "./bin/hono/server",
      env: {
        PORT: 3001,
        NODE_ENV: "production",
      },
    },
    {
      name: "express",
      script: "./bin/express/server",
      env: {
        PORT: 3002,
        NODE_ENV: "production",
      },
    },
    {
      name: "fastify",
      script: "./bin/fastify/server",
      env: {
        PORT: 3003,
        NODE_ENV: "production",
      },
    },
    {
      name: "aspnet-core",
      script: "dotnet ./bin/aspnet-core/aspnet-core.dll",
      env: {
        PORT: 3004,
        NODE_ENV: "production",
      },
    },
    {
      name: "go",
      script: "./bin/go",
      env: {
        PORT: 3005,
        NODE_ENV: "production",
      },
    },
    {
      name: "rust",
      script: "./bin/rust",
      env: {
        PORT: 3006,
        NODE_ENV: "production",
      },
    },
    {
      name: "bun",
      script: "./bin/bun/server",
      env: {
        PORT: 3007,
        NODE_ENV: "production",
      },
    },
  ],
};
