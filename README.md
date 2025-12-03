# Web Frameworks Funny Bench

## Getting Started

1. Make sure [mise](https://mise.jdx.dev) is installed
2. `./bench.sh`
3. Make Coffee
4. Praise Rust, Go, Bun, and Elysia

## Methodology

This benchmark compares the performance of various web frameworks using the following methodology:

- **Load Testing Tool**: [oha](https://github.com/hatoo/oha) - a modern HTTP load testing tool
- **Test Duration**: 10 seconds per framework
- **Request Type**: POST requests to `/:id?signature=...` with JSON payload (`{"name": "John Doe"}`) - designed to test:
  - Request body JSON serde and validation
  - URL params (path parameters)
  - Search/query params
  - Response JSON serde
- **Concurrency**: Maximum concurrency (default oha settings)
- **Process Management**: Each framework is run using PM2 to ensure consistent process management
- **JavaScript/TypeScript/Bun Frameworks**:
  - Built using Bun's build system (`build.ts`) with compiled bytecode (`bytecode: true`, `compile: true`)
  - Served using Node.js cluster mode with workers equal to `os.availableParallelism()` for optimal CPU utilization
- **Metrics Collected**:
  - Requests per second
  - Average latency
  - 50th percentile (median) latency
  - 99th percentile latency
  - Success rate (all frameworks achieved 100%)

Each framework runs on a dedicated port and is tested individually to ensure fair comparison. The benchmark is executed sequentially to avoid resource contention between frameworks.

## Test Environment

- **CPU**: Apple M1 Pro
- **Cores**: 8 physical cores
- **Memory**: 16 GB
- **OS**: macOS 15.7.2 (Build 24G325)

## Results

| Framework    | Requests/sec | Average Latency | 50th percentile | 99th percentile |
| ------------ | ------------ | --------------- | --------------- | --------------- |
| Rust         | 134,701      | 0.37 ms         | 0.35 ms         | 0.72 ms         |
| Go           | 99,289       | 0.50 ms         | 0.36 ms         | 2.44 ms         |
| Bun          | 73,557       | 0.68 ms         | 0.63 ms         | 1.33 ms         |
| Elysia       | 68,556       | 0.73 ms         | 0.67 ms         | 1.44 ms         |
| ASP.NET Core | 66,952       | 0.75 ms         | 0.65 ms         | 1.85 ms         |
| Hono         | 56,054       | 0.89 ms         | 0.82 ms         | 1.78 ms         |
| Fastify      | 44,107       | 1.13 ms         | 1.39 ms         | 2.41 ms         |
| Express      | 34,392       | 1.45 ms         | 1.78 ms         | 3.15 ms         |

_Benchmark run for 10 seconds with maximum concurrency. All frameworks achieved 100% success rate._

> Elysia and ASP.NET Core rankings may change, sometimes Elysia win, sometimes ASP.NET Core wins.
> But Elysia has better DX, so yes sir glory to Elysia.
