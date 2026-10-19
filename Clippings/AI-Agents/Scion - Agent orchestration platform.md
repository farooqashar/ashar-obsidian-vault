---
title: "Scion Overview"
source: "https://googlecloudplatform.github.io/scion/overview/"
author:
published:
created: 2026-10-17
description: "An open foundation for agent collaboration, from local experiments to hosted teams."
tags:
  - "clippings"
  - "agent-infra"
  - "coding-agents"
---
Scion is an open-source orchestration platform for teams of AI agents and the people working with them. Bring your choice of harnesses and models, define specialized roles, and let agents delegate tasks, exchange findings, and work in parallel on code, research, or other project files.

Scion provides execution environments, messaging, reusable skills, and visibility into the work. You shape how the team collaborates through instructions and tools. It is a practical testbed for emerging agent patterns, with open interfaces for the systems you want to build around it.

The same agents and the same `scion` CLI work whether you are running alone on a laptop with no server, or operating a hosted platform for a team. What changes is **how much infrastructure sits behind the agents** — captured by Scion’s [run modes](https://googlecloudplatform.github.io/scion/choosing-a-mode/).

## Choosing a mode

Scion’s run modes form a **spine of increasing infrastructure**:

**Workstation → Single-node hosted → HA hosted**

- **Workstation** — a single-tenant combo server (Hub + Runtime Broker + Web) on your own machine. The CLI and the web dashboard both run agents through it.
- **Single-node hosted** — a cheap, networked Hub on one node with an embedded SQLite database.
- **HA hosted** — a Hub replicated behind a load balancer, backed by external Postgres and object storage, for durable always-on operation.

Start with **[Choosing a Mode](https://googlecloudplatform.github.io/scion/choosing-a-mode/)** to pick the one that fits your use case.

## Architecture

Scion separates the **control plane** (the Hub) from the **execution layer** (runtime brokers and the agent containers they manage):

- **`scion` CLI** — a host-side CLI that drives the lifecycle of agents and manages templates (`scion templates`), projects, and configuration.
- **Hub** — the control plane. It owns identity, auth, project registration, and state, exposes the APIs and notifications that agents and users interact with, and **dispatches** commands to runtime brokers. Present in every mode: the CLI always runs agents through a Hub.
- **Runtime Broker** — a *service* (not a machine) that manages the lifecycle of containerized agents on behalf of the Hub: provisioning workspaces, hydrating templates, and delegating container operations to a pluggable runtime (Docker, Podman, Apple Container, Kubernetes).
- **Agents** — isolated containers running vendor-supplied harness software such as Claude Code, Gemini CLI, or OpenAI Codex.

In **Workstation mode** the Hub, a Runtime Broker, and the Web dashboard run together as a *combo server* on loopback. In **hosted** modes the Hub is networked and dispatches to standalone or embedded brokers.

![Diagram](https://googlecloudplatform.github.io/scion/d2/docs/overview-0.svg)

Some agents skip the broker layer entirely: a [**Managed Agent**](https://googlecloudplatform.github.io/scion/hosted/single-node/managed-agents/) is run directly by the Hub through a cloud provider API, with no container or workspace.

## Configuration

Scion uses a layered configuration system based on **Profiles**, **Runtimes**, and **Harnesses**, so you can define different environments (e.g. local Docker vs. remote Kubernetes) and switch between them.

- **Global settings**: `~/.scion/settings.yaml` (machine-wide defaults)
- **Project settings**: `.scion/settings.yaml` (per-project overrides)

Scion accepts settings in either **YAML or JSON**. `scion init` writes `settings.yaml`, and YAML is preferred when multiple files are present (the loader looks for `settings.yaml`, then `settings.yml`, then `settings.json`). Both validate against the [settings JSON schema](https://github.com/GoogleCloudPlatform/scion/blob/main/pkg/config/schemas/settings-v1.schema.json).

For details, see the [Configuration Overview](https://googlecloudplatform.github.io/scion/reference/scion-config-reference/), [Orchestrator Settings Reference](https://googlecloudplatform.github.io/scion/reference/orchestrator-settings/), and [Agent Configuration Reference](https://googlecloudplatform.github.io/scion/reference/agent-config/). For the agent tools Scion drives, see [Supported Harnesses](https://googlecloudplatform.github.io/scion/supported-harnesses/).

## Getting started

1. **Install** — follow the [Installation Guide](https://googlecloudplatform.github.io/scion/getting-started/install/).
2. **Initialize** — run `scion init` in your project root to create a `.scion` marker.
3. **Start an agent** — `scion start <agent-name> "<task>"`.
4. **Interact** — `scion attach <agent-name>` to join its session, or `scion look <agent-name>` / `scion logs <agent-name>` to view output.
5. **Resume** — `scion resume <agent-name>` to restart a stopped agent, preserving its state.