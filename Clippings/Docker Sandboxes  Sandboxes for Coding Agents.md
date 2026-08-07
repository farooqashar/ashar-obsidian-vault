---
title: "Docker Sandboxes | Sandboxes for Coding Agents"
source: "https://www.docker.com/products/docker-sandboxes/?utm_campaign=2026-07-28-sbx-adp-01&utm_medium=email&utm_source=marketo&utm_content=low&mkt_tok=NzkwLVNTQi0zNzUAAAGjcdemVNtZW33LJSfhqBwuOZLvhI9bQtDcDqzQWbD6a4xIfSjfpG1QK8CcfRvmVyVAv9w7wMxXn05FLr5HKLzPwHVqxOFJNXtowAN7RyjAg6NyAx22"
author:
published: 2026-01-30
created: 2026-08-05
description: "Secure sandboxes for Claude Code, Gemini, Codex, and Kiro. Run coding agents with microVM-based isolation."
tags:
  - "clippings"
---
## Run AI agents safely in local sandboxes.

Disposable, isolated sandboxes for AI agents like **Claude Code, Gemini CLI, Copilot CLI, Codex, OpenCode,** and **Kiro** that need safe, unattended execution.

macOS

$ `brew trust docker/tap && brew install docker/tap/sbx`

[Copy](#)

Windows

\> winget install Docker.sbx

[Copy](#)

[Get started free](#get-started) [Watch demo](#demo)

![docker sandboxes agent workspace](https://www.docker.com/app/uploads/2026/03/docker-sandboxes-agent-workspace-2320x1205.png "- docker sandboxes agent workspace")

## Sandboxes in action.

Watch an agent install packages, run Docker, modify configs, and execute unattended. Then dispose of the sandbox in one command.

sbx-demo

Click "Run Demo" to start

![gray](https://www.docker.com/app/uploads/brand/background/gray.png "- gray")

## Get started in seconds.

macOS

$ `brew trust docker/tap && brew install docker/tap/sbx`

[Copy](#)

Windows

\> winget install Docker.sbx

[Copy](#)

[Read the docs](https://docs.docker.com/ai/sandboxes/)

## Give agents the autonomy they need to get work done, safely.

Agents do their best work when they have freedom. Sandboxes let them run fast without running wild, so speed and safety stop being a tradeoff.

Need to enforce these controls across your whole team?

## YOLO mode, safely.

Each agent runs inside a dedicated microVM with your dev environment and only your project workspace mounted in. Agents can install packages, modify configs, and spin up their own Docker containers. Your host stays untouched. No manual review, no permission prompts, no supervision required.

#### Customizable Safe Execution

Network and filesystem controls you define.

#### MicroVM Isolation

Hard security boundary from the host.  

#### Fast to Spin Up, Easy to Tear Down

Disposable by default. Faster than VMs.  

#### Agents Can Use Docker Too

Agents can spin up containers within Sandboxes.

#### Real Dev Environment

Install packages, run services, work unattended.

#### One Sandbox for All Your Coding Agents

Claude Code, Gemini CLI, Copilot CLI, Codex, Kiro, OpenCode.

Default –dangerously-skip-permissions Use permissive modes with confidence. In fact, that’s the default.

## Works with leading coding agents

![gray](https://www.docker.com/app/uploads/brand/background/gray.png "- gray")

#### Every team is about to have their own team of AI agents doing real work for them. The question is whether it can happen safely. NanoClaw was built on the principle that you don’t trust agents with security, you build walls around them. Docker has been ahead of the curve on exactly this. Docker Sandboxes is what that looks like at the infrastructure level, making it possible for organizations to get the full value from agents without compromising on security.

Gavriel Cohen

Creator of NanoClaw, NanoClaw

#### Docker Sandboxes let agents have the autonomy to do long-running tasks without compromising safety. We’re excited to integrate Sandboxes into Warp so that developers can run agents freely with a consistent environment, regardless of whether agents are running locally or in the cloud.

Ben Navetta

Engineering Lead, Warp

## Common questions.

### What is a sandbox for AI coding agents?

A sandbox is a microVM isolated environment that protects your filesystem and network from agents running inside it.

### Which coding agents are supported?

Out of the box we support Claude Code, Gemini CLI, Copilot CLI, Codex, OpenCode, Kiro. You can also create your own

### What does “YOLO mode” mean, and is it safe?

YOLO mode (`--dangerously-skip-permissions`) gives agents autonomy with no approval prompts. Essential for speed, but risky without guardrails. Sandboxes make it safe by isolating each agent inside a dedicated microVM.

### How is a sandbox different from a VM?

Sandboxes run fully isolated in microVMs, giving more isolation without paying the full cost of running a VM. This lets them do things that need more permissions safely, like running additional Docker containers.

### What safety controls can I configure?

To define these once and enforce them on every developer’s machine, see [Docker AI Governance](https://www.docker.com/products/ai-governance/).

### Do I need Docker Desktop to use sandboxes?

No.

### What if I need additional admin controls?

Installing Sandboxes covers core functionality. For centralized controls across a team such as network policies, filesystem rules, MCP governance: [Docker AI Governance](https://www.docker.com/products/ai-governance/).

### Need More Control Over Your Sandboxes?

With Docker Sandboxes, your developers get isolated environments to run agents freely and safely. When your team needs to go further with network access restrictions, filesystem policies, and centralized admin controls, we can help you configure the right setup.  
  
[Docker AI Governance](https://www.docker.com/products/ai-governance/) adds network access policies, filesystem controls, and org-wide MCP governance: defined once, enforced everywhere.  
  
Talk to us about:

- Network access policies for sandbox environments
- Filesystem access controls and restrictions
- Admin-level configuration for your team