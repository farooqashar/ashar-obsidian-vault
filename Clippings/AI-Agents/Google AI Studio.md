---
title: "Google AI Studio"
source: "https://aistudio.google.com/managed-agents"
author:
published:
created: 2026-11-04
description: "The fastest path from prompt to production with Gemini"
tags:
  - "clippings"
  - "llm-providers"
  - "agent-infra"
---
### One API call to fully managed agent

Skip the infrastructure setup. A single API call gives your agent instructions, tools, and a remote Linux environment to reason and execute code.

### Persistent, stateful environments

Set up your environment once. Your Git repos, packages, inline assets, and GCS objects persist across sessions.

### Antigravity agent that powers Google’s own

Build on the same production-grade agentic harness, co-optimized with Gemini models, that powers many of Google’s own agents.

<video src="https://www.gstatic.com/aistudio-static/editorial/managed-agents/managed-agents_01.mp4" controls=""></video>

### One API call to fully managed agent

Skip the infrastructure setup. A single API call gives your agent instructions, tools, and a remote Linux environment to reason and execute code.

<video src="https://www.gstatic.com/aistudio-static/editorial/managed-agents/managed-agents_02.mp4" controls=""></video>

### Persistent, stateful environments

Set up your environment once. Your Git repos, packages, inline assets, and GCS objects persist across sessions.

<video src="https://www.gstatic.com/aistudio/managed-agents/agents_03.mp4" controls=""></video>

### Antigravity agent that powers Google’s own

Build on the same production-grade agentic harness, co-optimized with Gemini models, that powers many of Google’s own agents.

## What developers are building

“The real shift with Managed Agents is that the agent runtime moves into the platform. With the sandbox, infrastructure, and execution loop managed for you, developers can focus on productizing the agent’s domain-specific behavior and iterating at a different pace.”

René Sultan, Ramp

“The API’s intelligence allows us to handle complex workflows with remarkable precision, yet it remains intuitive to implement. Balancing high-level reasoning with true ease of use enables our team to deploy advanced automation faster than ever.”

Givi Beridze, Klipy

“Prompt to autonomous agent in a single API call feels magical. We had two real agents running on Google’s stack the day we got access. The harness owning tools, sandbox, and state across turns makes the orchestration layer disappear. We can focus on the agent instead of the environment running them.”

Zohaib Ahmed, Resemble AI

“The real shift with Managed Agents is that the agent runtime moves into the platform. With the sandbox, infrastructure, and execution loop managed for you, developers can focus on productizing the agent’s domain-specific behavior and iterating at a different pace.”

René Sultan, Ramp

“The API’s intelligence allows us to handle complex workflows with remarkable precision, yet it remains intuitive to implement. Balancing high-level reasoning with true ease of use enables our team to deploy advanced automation faster than ever.”

Givi Beridze, Klipy

## Get started

### Quickstart

Set up your environment and make your first API request in minutes

6 min

```
from google import genai
client = genai.Client()
interaction = client.interactions.create(
    agent="antigravity-preview-09-2026",
    input="Plot the growth of solar energy generation globally and make some slides in HTML",
)
print(interaction.output_text)
```