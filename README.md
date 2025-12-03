# Web Frameworks Funny Bench

## Getting Started

1. Make sure [mise](https://mise.jdx.dev) and [PM2](https://pm2.keymetrics.io) are installed
2. `./bench.sh`
3. Make Coffee
4. Praise Rust, Bun, and Elysia

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

- **Platform**: Docker (Linux)
- **OS**: Ubuntu 24.04
- **Test Duration**: 10 seconds per framework
- **All frameworks achieved 100% success rate**

## Results

### 4 CPU / 2GB Memory

| Framework    | Requests/sec | Average Latency | 50th percentile | 99th percentile |
| ------------ | ------------ | --------------- | --------------- | --------------- |
| Rust         | 132,329      | 0.38 ms         | 0.21 ms         | 0.99 ms         |
| Bun          | 111,424      | 0.45 ms         | 0.17 ms         | 2.35 ms         |
| Elysia       | 110,720      | 0.45 ms         | 0.18 ms         | 1.76 ms         |
| Hono         | 93,045       | 0.54 ms         | 0.20 ms         | 2.34 ms         |
| Go           | 70,725       | 0.70 ms         | 0.28 ms         | 5.41 ms         |
| Fastify      | 62,470       | 0.80 ms         | 0.22 ms         | 7.35 ms         |
| Express      | 32,968       | 1.51 ms         | 0.28 ms         | 47.71 ms        |
| ASP.NET Core | 32,644       | 1.53 ms         | 0.80 ms         | 15.28 ms        |

### 8 CPU / 4GB Memory

| Framework    | Requests/sec | Average Latency | 50th percentile | 99th percentile |
| ------------ | ------------ | --------------- | --------------- | --------------- |
| Bun          | 236,588      | 0.21 ms         | 0.14 ms         | 1.33 ms         |
| Elysia       | 200,108      | 0.25 ms         | 0.15 ms         | 1.63 ms         |
| Rust         | 161,061      | 0.31 ms         | 0.25 ms         | 1.12 ms         |
| Hono         | 120,714      | 0.41 ms         | 0.15 ms         | 4.42 ms         |
| Fastify      | 119,708      | 0.42 ms         | 0.16 ms         | 4.51 ms         |
| Express      | 103,357      | 0.48 ms         | 0.20 ms         | 3.48 ms         |
| Go           | 69,818       | 0.71 ms         | 0.25 ms         | 7.40 ms         |
| ASP.NET Core | 64,500       | 0.77 ms         | 0.48 ms         | 4.53 ms         |

_Benchmark run for 10 seconds with maximum concurrency. All frameworks achieved 100% success rate._

## Docker Benchmark

> Source: https://bun.com/docs/guides/http/cluster

For consistent results across different environments, you can run the benchmark in a Docker container using `./bench-in-docker.sh`. This script:

- Builds a Docker image with all necessary dependencies
- Runs the benchmark in a container with resource limits
- Copies results back to a directory named based on the CPU and memory configuration (e.g., `./results-8cpu-4g/`)

### Configuring CPU and Memory Limits

To change the Docker container's CPU and memory limits, edit the configuration variables at the top of `bench-in-docker.sh`:

```bash
CPU_LIMIT="8"        # Number of CPUs (e.g., "4", "8")
MEMORY_LIMIT="4g"    # Memory limit (e.g., "2g", "4g", "8g")
```

**Examples:**

- For 4 CPUs and 2GB memory: `CPU_LIMIT="4"` and `MEMORY_LIMIT="2g"` → results saved to `./results-4cpu-2g/`
- For 8 CPUs and 4GB memory: `CPU_LIMIT="8"` and `MEMORY_LIMIT="4g"` → results saved to `./results-8cpu-4g/`

The results directory name is automatically generated based on your configuration, making it easy to compare benchmarks across different resource allocations.

**Important Note**: The Docker benchmark runs on Linux, which enables the `reusePort` option for optimal performance. On Windows and macOS, the `reusePort` option is ignored due to operating system limitations with `SO_REUSEPORT`. This means benchmarks run directly on macOS/Windows may show different performance characteristics compared to the Docker (Linux) environment.
