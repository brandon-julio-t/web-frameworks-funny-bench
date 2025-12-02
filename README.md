# Web Frameworks Funny Bench

## Getting Started

1. Make sure [mise](https://mise.jdx.dev) and [pm2](https://pm2.keymetrics.io) are installed
2. `./bench.sh`
3. Make Coffee
4. Praise Rust, Go, and Elysia

## Methodology

This benchmark compares the performance of various web frameworks using the following methodology:

- **Load Testing Tool**: [oha](https://github.com/hatoo/oha) - a modern HTTP load testing tool
- **Test Duration**: 10 seconds per framework
- **Request Type**: POST requests with JSON payload (`{"name": "John Doe"}`) - designed to test JSON request deserialization, request validation, and JSON response serialization
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

## Results

| Framework    | Requests/sec | Average Latency | 50th percentile | 99th percentile |
| ------------ | ------------ | --------------- | --------------- | --------------- |
| Rust         | 133,282      | 0.37 ms         | 0.35 ms         | 0.78 ms         |
| Go           | 101,561      | 0.49 ms         | 0.37 ms         | 2.43 ms         |
| Elysia       | 70,652       | 0.71 ms         | 0.65 ms         | 1.39 ms         |
| ASP.NET Core | 65,478       | 0.76 ms         | 0.64 ms         | 2.35 ms         |
| Fastify      | 43,870       | 1.14 ms         | 1.34 ms         | 2.58 ms         |
| Express      | 34,904       | 1.43 ms         | 1.74 ms         | 3.16 ms         |
| Hono         | 24,673       | 2.03 ms         | 2.53 ms         | 4.67 ms         |

_Benchmark run for 10 seconds with maximum concurrency. All frameworks achieved 100% success rate._
