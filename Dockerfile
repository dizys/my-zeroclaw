# Stage 1: Build zeroclaw from source
FROM rust:slim AS builder

ARG ZEROCLAW_VERSION

RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config \
    libssl-dev \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN if [ -n "${ZEROCLAW_VERSION:-}" ]; then \
        cargo install \
            --locked \
            --git https://github.com/zeroclaw-labs/zeroclaw.git \
            --tag "${ZEROCLAW_VERSION}" \
            zeroclawlabs; \
    else \
        cargo install \
            --locked \
            --git https://github.com/zeroclaw-labs/zeroclaw.git \
            zeroclawlabs; \
    fi

# Stage 2: Runtime image
FROM debian:trixie-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    git \
    tini \
    python3 \
    python3-pip \
    python3-venv \
    ffmpeg \
    jq \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install yt-dlp in an isolated virtual environment (supports both amd64 and arm64)
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir yt-dlp

ENV PATH="/opt/venv/bin:${PATH}"

# Copy the built zeroclaw binary
COPY --from=builder /usr/local/cargo/bin/zeroclaw /usr/local/bin/zeroclaw

RUN mkdir -p /data/workspace

ENV ZEROCLAW_WORKSPACE=/data/workspace
ENV SHELL=/bin/bash
ENV HOME=/data

WORKDIR /data

EXPOSE 42617

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:42617/health || exit 1

ENTRYPOINT ["tini", "--"]
CMD ["zeroclaw", "daemon", "--host", "0.0.0.0"]
