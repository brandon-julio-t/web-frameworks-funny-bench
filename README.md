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
| Rust         | 126,663      | 0.39 ms         | 0.36 ms         | 0.97 ms         |
| Go           | 103,712      | 0.48 ms         | 0.36 ms         | 2.29 ms         |
| Bun          | 78,268       | 0.64 ms         | 0.59 ms         | 1.26 ms         |
| Elysia       | 71,702       | 0.70 ms         | 0.64 ms         | 1.37 ms         |
| ASP.NET Core | 68,224       | 0.73 ms         | 0.66 ms         | 1.90 ms         |
| Hono         | 59,426       | 0.84 ms         | 0.77 ms         | 1.67 ms         |
| Fastify      | 46,444       | 1.08 ms         | 1.33 ms         | 2.29 ms         |
| Express      | 36,478       | 1.37 ms         | 1.71 ms         | 3.03 ms         |

_Benchmark run for 10 seconds with maximum concurrency. All frameworks achieved 100% success rate._
