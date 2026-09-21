---
title: "Real-time Docker Log Viewer"
source: "https://dozzle.dev/"
author:
published:
created: 2026-08-11
description: "Dozzle is a lightweight, open-source log viewer for Docker, Swarm, and Kubernetes. Stream logs, watch live stats, and debug containers from your browser."
tags:
  - "clippings"
  - "kubernetes"
  - "containers"
  - "observability"
---
## DozzleSee what your containers are doing

Real-time Docker logs, stats, and debugging — in your browser.

[v10.7.1 released yesterday](https://github.com/amir20/dozzle/releases/tag/v10.7.1)

$ `docker run -d -v /var/run/docker.sock:/var/run/docker.sock -v dozzle_data:/data -p 8080:8080 amir20/dozzle:latest`

Then open http://localhost:8080. Prefer Compose, Swarm, or Kubernetes? See the [install guide](https://dozzle.dev/guide/getting-started).

## Why not just docker logs?

It works fine until you are tailing three containers on two hosts at 2am.

docker logs

- One container at a time, per host.
- Pipe to grep and start over when you get it wrong.
- JSON and stack traces arrive as a wall of text.
- Separate docker stats window for CPU and memory.
- SSH into each machine to look around.

Dozzle

- Follow many containers side by side, merged across every host you connect.
- Search, filter by level, and jump to a timestamp while the logs keep streaming.
- Structured logs get parsed into fields, multi-line traces stay grouped.
- Live CPU, memory, and network charts on the same screen as the logs.
- One browser tab over Docker, Swarm, and Kubernetes, with a shell when you need it.

## Start watching your containers

One command, no agent to install, no account to create.

$ `docker run -d -v /var/run/docker.sock:/var/run/docker.sock -v dozzle_data:/data -p 8080:8080 amir20/dozzle:latest`

MIT licensed and free forever.