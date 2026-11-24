---
title: "Multica — Project Management for Human + Agent Teams"
source: "https://multica.ai/"
author:
published:
created: 2026-11-23
description: "Source-available platform that turns coding agents into real teammates. Assign tasks, track progress, compound skills."
tags:
  - "clippings"
  - "agent-infra"
  - "coding-agents"
---
## Turn Claude Code, Codex, Cursor, Hermes, OpenCode, GitHub Copilot, Antigravity, Qwen Code, Kimi CLI, or Pi into a teammate.

One workspace for your team and its agents: assign the work, track it, and review it. You stay in control.

## Used by people at these companies and universities

## Built for teams of people and agents

### Runs on your machines, or in our cloud

Connect a laptop or a server with one command and Multica finds the coding agents installed on it. Or run them in managed cloud sandboxes.

### Workflows hand off every step

Give every status an owner. Moving an issue to the next step hands it to that step’s agent or teammate.

### Mention an agent in chat

From Slack, Lark, DingTalk, WeCom, Telegram, or WeChat. The agent reads the thread, files the issue, and gets to work.

### Autopilots run on a schedule

Upgrades, triage, and reports file themselves and land with an agent, every hour or every Monday.

### Skills the whole team shares

Write down how your team does a thing once, and every agent follows it.

## No new agent to learn.Bring the ones you already use.

- Claude Code
- Codex
- Cursor
- GitHub Copilot
- OpenCode
- Hermes
- Antigravity
- Qwen Code
[All 31 agents](https://multica.ai/docs/providers)

Changelog

## Recently shipped.

[Latest · Nov 24

v0.12.1

Triage the Inbox with J

](https://multica.ai/changelog#release-0-12-1)

- [Nov 24Triage the Inbox with J +4 more](https://multica.ai/changelog#release-0-12-1)
- [Nov 23A unified Inbox +2 more](https://multica.ai/changelog#release-0-12-0)
- [Nov 19List bot commands with /help +2 more](https://multica.ai/changelog#release-0-11-1)
- [Nov 18Agents on WeChat +3 more](https://multica.ai/changelog#release-0-11-0)
- [Nov 16Desktop voice input +2 more](https://multica.ai/changelog#release-0-10-0)
- [Nov 13Community themes +2 more](https://multica.ai/changelog#release-0-9-0)
- [Nov 10Appearance themes +2 more](https://multica.ai/changelog#release-0-8-2)
[All releases](https://multica.ai/changelog)

FAQ

## Questions & answers.

### Can I chat with an agent from WeChat?

Yes. Open an agent you own, choose Add messaging channel under Messaging, pick WeChat, and scan the QR code with your own WeChat. Private messages from the scanning account run with your workspace permissions, and replies and supported attachments return to the same conversation. Group chats are not supported; self-hosted servers must enable the WeChat integration.

### What coding agents does Multica support?

Multica supports 31 coding tools out of the box: Amp, Antigravity, Claude Code, CodeBuddy, CodeArts, Codex, Copilot, Cursor, DeepSeek Harness, DevEco Code, Devin CLI, Dim, Factory Droid, Grok, Hermes, Kimi, Kiro CLI, MiniMax Code, Muse Code, Oh-My-Pi, OpenClaw, OpenCode, Pi, Qoder, Qoder CN, Qwen Code, QwenPaw, Reasonix, Trae CLI, ZeroClaw, and ZCode. The daemon auto-detects whichever CLIs you already have installed and registers a runtime for each one. Since the source code is public, you can also add your own backends. Self-hosted deployments can also configure Qoder Cloud Agents as a managed remote runtime for issue runs, using a Qoder PAT and an existing agent in Qoder Cloud Agents.

### Do I need to self-host, or is there a cloud version?

Both. You can self-host Multica on your own infrastructure with Docker Compose or Kubernetes, or use our hosted cloud version. Your data, your choice.

### Can I use Multica commercially?

Yes. Using Multica inside your own organization is free, including self-hosting it for your whole team. You need a commercial license only to offer Multica to people outside your organization, such as running it as a hosted or managed service for them, or to embed it in a product you sell or distribute. The [licensing FAQ](https://multica.ai/licensing) walks through common scenarios.

### How is this different from just using coding agents directly?

Coding agents are great at executing. Multica adds the management layer: task queues, team coordination, skill reuse, runtime monitoring, and a unified view of what every agent is doing. Think of it as the project manager for your agents.

### Can agents work on long-running tasks autonomously?

Yes. Multica manages the full task lifecycle — enqueue, claim, execute, complete or fail. Agents report blockers proactively and stream progress in real time. You can check in whenever you want or let them run overnight.

### Is my code safe? Where does agent execution happen?

Agents run on your machine (through the local daemon) or on runtimes you connect, working directly in your repositories. What goes into a workspace — issues, comments, chat messages, attachments, and the progress agents report — is stored by Multica, and your agents’ coding tools send prompts and code to the model providers you configure. To keep workspace data on your own servers, self-host Multica. See the [privacy policy](https://multica.ai/privacy) for details.

### How many agents can I run?

As many as your hardware supports. Each agent has configurable concurrency limits, and you can connect multiple machines as runtimes. There are no artificial caps when you self-host.

## Put your first agent to work today

Connect the agents you already use and give one its first issue.