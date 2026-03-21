# my-zeroclaw

My custom [Zeroclaw](https://github.com/zeroclaw-labs/zeroclaw) Docker image with preferred system dependencies pre-installed.

## Features

- Built from the latest upstream [zeroclaw](https://github.com/zeroclaw-labs/zeroclaw) release
- Web dashboard included (built and embedded at compile time)
- Browser automation support (Chromium + agent-browser)
- Published automatically to the [GitHub Container Registry](https://ghcr.io/dizys/my-zeroclaw)

### Pre-installed Tools

| Category | Packages |
|----------|----------|
| **Core** | curl, wget, git, openssh-client, rsync, gnupg |
| **Languages & Runtimes** | python3, pip, nodejs, npm |
| **Build** | build-essential (gcc, g++, make) |
| **Media** | ffmpeg, yt-dlp, imagemagick, mediainfo |
| **Documents** | pandoc, poppler-utils (pdftotext, etc.), tesseract-ocr |
| **Data** | jq, sqlite3, postgresql-client (psql), default-mysql-client (mysql), redis-tools (redis-cli) |
| **Search** | ripgrep |
| **Visualization** | graphviz |
| **Browser** | chromium, fonts-liberation |
| **Archive** | zip, unzip, tar, xz-utils |
| **System** | htop, procps, less, file, bc, tree, socat, dnsutils, net-tools, patch |

## Usage

### Pull the image

```sh
docker pull ghcr.io/dizys/my-zeroclaw:latest
```

### Run with Docker

```sh
docker run -d \
  --name zeroclaw \
  -p 42617:42617 \
  -v zeroclaw-config:/data/.zeroclaw \
  -v zeroclaw-workspace:/data/workspace \
  ghcr.io/dizys/my-zeroclaw:latest
```

### Run with Docker Compose

```sh
docker compose up -d
```

### Persisted Volumes

| Volume | Container Path | Purpose |
|--------|---------------|---------|
| `zeroclaw-config` | `/data/.zeroclaw` | Config, secrets, knowledge DB, skills, plugins, npm global packages |
| `zeroclaw-workspace` | `/data/workspace` | Workspace files (MEMORY.md, BOOTSTRAP.md, sessions) |

## Build

To build the image locally:

```sh
docker build -t my-zeroclaw .
```

To build for a specific zeroclaw version:

```sh
docker build --build-arg ZEROCLAW_VERSION=v0.5.0 -t my-zeroclaw .
```

## CI / Publish

A GitHub Actions workflow (`.github/workflows/docker-publish.yml`) automatically:

1. Checks the latest upstream zeroclaw release tag daily
2. Builds a `linux/amd64` image when a new version is detected or the `Dockerfile` changes
3. Publishes the image to `ghcr.io/dizys/my-zeroclaw` with `latest` and version tags
4. Tags the commit with the upstream version to avoid duplicate builds
