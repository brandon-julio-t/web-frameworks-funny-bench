#!/bin/bash

# Web Frameworks Benchmark - Docker Runner
# 
# This script runs the web frameworks benchmark in a Docker container
# with specified resource constraints (4 CPU, 2GB memory).
# 
# Usage:
#   ./run-docker-bench.sh
# 
# Requirements:
#   - Docker installed and running
#   - Sufficient disk space for Docker image (~2-3GB)
# 
# The script will:
#   1. Create a Dockerfile with all necessary dependencies
#   2. Build a Docker image with the benchmark environment
#   3. Run the benchmark in a container with resource limits
#   4. Copy results back to ./results-{cpu}cpu-{mem}g/ directory
#   5. Display a summary of the results

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
IMAGE_NAME="bench-frameworks"
CONTAINER_NAME="bench-runner"
CPU_LIMIT="8"
MEMORY_LIMIT="4g"

# Extract memory value (remove unit suffix like 'g', 'm', etc.)
MEMORY_VALUE=$(echo "${MEMORY_LIMIT}" | sed 's/[^0-9]//g')

# Build results directory name based on CPU and memory config
RESULTS_DIR="./results-${CPU_LIMIT}cpu-${MEMORY_VALUE}g"

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed or not in PATH${NC}"
    echo "Please install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    echo -e "${RED}Error: Docker daemon is not running${NC}"
    echo "Please start Docker and try again"
    exit 1
fi

echo -e "${GREEN}=== Web Frameworks Benchmark - Docker Edition ===${NC}"
echo -e "CPU Limit: ${CPU_LIMIT}"
echo -e "Memory Limit: ${MEMORY_LIMIT}"
echo ""

# Cleanup function
cleanup() {
    echo -e "\n${YELLOW}Cleaning up...${NC}"
    docker rm -f "${CONTAINER_NAME}" 2>/dev/null || true
    # Optionally remove Dockerfile if it was created by this script
    # Uncomment the next line if you want to auto-cleanup Dockerfile
    # rm -f Dockerfile
}

trap cleanup EXIT

# Create Dockerfile
echo -e "${GREEN}Creating Dockerfile...${NC}"
cat > Dockerfile << 'EOF'
FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Install system dependencies
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    wget \
    git \
    build-essential \
    ca-certificates \
    gnupg \
    lsb-release \
    pkg-config \
    libssl-dev \
    libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# Install mise (tool version manager)
RUN curl https://mise.run | sh
ENV PATH="/root/.local/bin:/root/.mise/shims:$PATH"
ENV MISEFILE=/bench/mise.toml

# Install oha (HTTP load testing tool) - detect architecture
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
        OHA_ARCH="arm64"; \
    else \
        OHA_ARCH="amd64"; \
    fi && \
    wget -q "https://github.com/hatoo/oha/releases/latest/download/oha-linux-${OHA_ARCH}" \
    && chmod +x "oha-linux-${OHA_ARCH}" \
    && mv "oha-linux-${OHA_ARCH}" /usr/local/bin/oha

# Set working directory
WORKDIR /bench

# Copy mise configuration
COPY mise.toml ./

# Install tools via mise (trust config first)
RUN cd /bench && mise trust && mise install

# Install pm2 globally (using mise-managed node)
RUN bash -c "export PATH=\"/root/.local/bin:/root/.mise/shims:\$PATH\" && \
    cd /bench && \
    mise use node && \
    eval \"\$(mise env)\" && \
    npm install -g pm2"

# Copy package files
COPY package.json bun.lock ./
COPY tsconfig.json ./

# Install dependencies using mise exec
RUN export PATH="/root/.local/bin:/root/.mise/shims:\$PATH" && \
    cd /bench && \
    mise exec -- bun install

# Copy build script
COPY build.ts ./

# Copy ecosystem config
COPY ecosystem.config.js ./

# Copy apps directory
COPY apps/ ./apps/

# Copy benchmark script
COPY bench.sh ./

# Make scripts executable
RUN chmod +x bench.sh

# Set environment variables
ENV PATH="/root/.local/bin:/root/.mise/shims:$PATH"

# Note: Container is run with 'tail -f /dev/null' to keep it alive
# Benchmark is executed via 'docker exec' - see run-docker-bench.sh
EOF

# Build Docker image
echo -e "${GREEN}Building Docker image (this may take a few minutes)...${NC}"
if ! docker build -t "${IMAGE_NAME}" .; then
    echo -e "${RED}Failed to build Docker image${NC}"
    echo -e "${YELLOW}Tip: Make sure Docker is running and you have sufficient disk space${NC}"
    exit 1
fi

# Remove existing container if it exists
docker rm -f "${CONTAINER_NAME}" 2>/dev/null || true

# Run container with resource limits
echo -e "${GREEN}Starting container with ${CPU_LIMIT} CPU(s) and ${MEMORY_LIMIT} memory...${NC}"
docker run -d \
    --name "${CONTAINER_NAME}" \
    --cpus="${CPU_LIMIT}" \
    --memory="${MEMORY_LIMIT}" \
    --memory-swap="${MEMORY_LIMIT}" \
    "${IMAGE_NAME}" \
    tail -f /dev/null || {
    echo -e "${RED}Failed to start container${NC}"
    exit 1
}

# Wait for container to be ready
sleep 2

# Execute benchmark inside container
echo -e "${GREEN}Running benchmark inside container...${NC}"
echo -e "${YELLOW}This may take several minutes...${NC}"
echo ""

if ! docker exec "${CONTAINER_NAME}" /bin/bash -c "
    set -euo pipefail
    cd /bench
    
    # Ensure results directory exists
    mkdir -p results
    
    # Activate mise environment (bench.sh already handles mise setup)
    export PATH=\"/root/.local/bin:/root/.mise/shims:\$PATH\"
    ./bench.sh
"; then
    echo -e "${RED}Benchmark failed${NC}"
    echo -e "${YELLOW}Checking container logs (last 50 lines)...${NC}"
    docker logs "${CONTAINER_NAME}" | tail -50
    echo ""
    echo -e "${YELLOW}To debug, you can exec into the container with:${NC}"
    echo -e "  docker exec -it ${CONTAINER_NAME} /bin/bash"
    exit 1
fi

# Copy results back to host
echo -e "\n${GREEN}Copying results from container...${NC}"
mkdir -p "${RESULTS_DIR}"
docker cp "${CONTAINER_NAME}:/bench/results/." "${RESULTS_DIR}/" || {
    echo -e "${YELLOW}Warning: Could not copy results directory${NC}"
}

# Display results summary
echo -e "\n${GREEN}=== Benchmark Complete ===${NC}"
echo -e "Results are available in: ${RESULTS_DIR}/"
echo ""
echo "Summary of results:"
for result_file in "${RESULTS_DIR}"/*.txt; do
    if [ -f "$result_file" ]; then
        framework=$(basename "$result_file" .txt)
        echo -e "${YELLOW}${framework}:${NC}"
        # Extract key metrics from oha output
        if grep -q "Requests/sec" "$result_file"; then
            grep "Requests/sec" "$result_file" | head -1
        fi
        if grep -q "Average" "$result_file"; then
            grep "Average" "$result_file" | head -1
        fi
        echo ""
    fi
done

echo -e "${GREEN}Done!${NC}"

