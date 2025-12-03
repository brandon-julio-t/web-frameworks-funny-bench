// Bun doesn't use Node.js cluster module, but we can use Bun's built-in
// concurrency handling. For consistency with other benchmarks, we'll
// use the same pattern but Bun handles concurrency natively.
import cluster from "node:cluster";
import os from "node:os";
import process from "node:process";

if (cluster.isPrimary) {
  for (let i = 0; i < os.availableParallelism(); i++) cluster.fork();
} else {
  import("./index.ts").then(() => {
    console.log(`Worker ${process.pid} started`);
  });
}
