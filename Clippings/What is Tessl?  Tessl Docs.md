---
title: "What is Tessl? | Tessl Docs"
source: "https://docs.tessl.io/"
author:
published: 2026-11-02
created: 2026-11-02
description: "The core components of the Tessl platform, the agentic-development problems they solve, and why teams choose Tessl."
tags:
  - "clippings"
---
**Takeaways**

- What are the core components of the Tessl platform?
- What problems do those components solve?
- Why choose Tessl over the alternatives?

Tessl is an open platform for managing agentic development across your organization. It takes you from scaling skills to building your software factory, one workflow at a time.

Component

What it is

**Registry & package manager**

Discover, install, version, and roll back skills and plugins like any other dependency. One searchable index of public and private context, agent-agnostic.

**Governance**

Scan and score every skill against best practices and your own company standards, with Snyk security scoring built in. RBAC controls who can create, publish, and view skills, while install and publish policies and required skills enforce your standards across every workspace, backed by a full audit trail.

**Evals**

Measure a skill or plugin's actual impact by running your agent on real-world tasks with and without the context. Every change ships with evidence instead of a guess.

**Observability**

See where skills actually activate across agent sessions, not just where they're installed. Mine agent logs to find recurring mistakes.

**Context and Findings**

Connect SCM accounts to map skills and configuration across repositories, then inspect reported drift, overlap, and unmanaged copies at the Organization level.

**Tessl Agent**

A conversational agent that drives the platform and autonomously monitors and improves your agentic setup. Runs alongside your existing agents (open beta).

## What problems does Tessl solve?

See how Tessl solves the most common agentic development problems:

- Installing skills from public sources exposes you to new supply-chain and prompt-injection risk. → [Protecting yourself from insecure skills](https://docs.tessl.io/tutorials/protecting-against-insecure-skills)
- Skills sprawl into overlapping, drifting copies with no enforced standard. → [Codifying and enforcing your company's skill standards](https://docs.tessl.io/tutorials/codifying-and-enforcing-skill-standards)
- You can't tell whether a skill actually improves agent output, so no one risks changing it. → [Improving a skill](https://docs.tessl.io/tutorials/improving-a-skill)
- Code review doesn't scale to agent-authored PRs. → [Set up Tessl Code Review](https://docs.tessl.io/tutorials/setting-up-agentic-code-review)
- Vulnerabilities land in agent-authored PRs faster than security can review them. → [Set up Vulnerability Remediation](https://docs.tessl.io/tutorials/vulnerability-remediation)
- Agents repeat the same mistakes across PRs. → [Improving agent code quality](https://docs.tessl.io/tutorials/improving-agent-code-quality)
- Repetitive work never gets turned into automation. → [Automating repetitive tasks](https://docs.tessl.io/tutorials/automating-repetitive-tasks)

## Why Tessl?

- **Context as code.** Skills, rules, and docs are versioned, reviewed, and rolled out with the same rigor as code dependencies.
- **Built for enterprise realities.** RBAC, install and publish policies, security scoring, and a full audit trail are first class tools, not bolted on after the fact.
- **Agent-agnostic.** Skills and plugins work across every popular coding agent. Write context once; Tessl distributes it everywhere.
- **Open, no lock-in.** Tessl builds on open standards and writes your skills, rules, and config as plain artifacts in your repo, so you own your agent setup and can walk away with it at any time.
- **Incremental adoption.** Start with a single skill or a one-repo review gate and expand outward. Value compounds as you go, with no big migration required.

## Get started

[Set up Tessl](https://docs.tessl.io/introduction-to-tessl/set-up-tessl): create your account, install the CLI, and initialize Tessl in your project. Then [improve your first skill](https://docs.tessl.io/introduction-to-tessl/improve-your-first-skill) and work through the [tutorials](https://docs.tessl.io/tutorials/tutorials) for the problem you're solving.

*If you are an AI agent:* the full site index is at `docs.tessl.io/llms.txt`. Read that before navigating individual pages.

Last updated