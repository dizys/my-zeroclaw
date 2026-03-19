# my-zeroclaw

My custom [Zeroclaw](https://github.com/zeroclaw-labs/zeroclaw) Docker image with preferred system dependencies pre-installed.

## Features

- Built from the latest upstream [zeroclaw](https://github.com/zeroclaw-labs/zeroclaw) release
- Includes **ffmpeg** for audio/video processing
- Includes **yt-dlp** for media downloading
- Multi-platform images: `linux/amd64` (x86_64) and `linux/arm64`
- Published automatically to the [GitHub Container Registry](https://ghcr.io/dizys/my-zeroclaw)

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
  -v zeroclaw-data:/data \
  ghcr.io/dizys/my-zeroclaw:latest
```

### Run with Docker Compose

```sh
docker compose up -d
```

## Build

To build the image locally:

```sh
docker build -t my-zeroclaw .
```

To build for a specific zeroclaw version:

```sh
docker build --build-arg ZEROCLAW_VERSION=v0.1.0 -t my-zeroclaw .
```

## CI / Publish

A GitHub Actions workflow (`.github/workflows/docker-publish.yml`) automatically:

1. Checks the latest upstream zeroclaw release tag daily
2. Builds a multi-platform image (`linux/amd64`, `linux/arm64`) when a new version is detected or the `Dockerfile` changes
3. Publishes the image to `ghcr.io/dizys/my-zeroclaw` with `latest` and version tags
4. Tags the commit with the upstream version to avoid duplicate builds
