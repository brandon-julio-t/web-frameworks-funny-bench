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
