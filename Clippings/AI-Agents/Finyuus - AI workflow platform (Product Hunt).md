---
title: "mariusndini/Finyuus at producthunt"
source: "https://github.com/mariusndini/Finyuus?ref=producthunt#quick-start"
author:
published:
created: 2026-08-07
description: "Finyuus is a code-first platform for building, running, and governing AI workflows. It introduces a small indentation-based DSL for composing agents, tools, guards, human approvals, and nested workflows — then runs them. - mariusndini/Finyuus at producthunt"
tags:
  - "clippings"
  - "saas-products"
  - "startups"
---
## Finyuus

Finyuus is a code-first platform for building, running, and governing durable AI workflows.

It provides a focused, indentation-based language for composing agents, tools, guards, human approvals, structured data operations, and nested workflows. Finyuus runs these workflows using Temporal and gives teams a centralized environment for versioning, observing, auditing, and operating them.

## Contents

## Documentation

- [DSL Reference](https://github.com/mariusndini/Finyuus/blob/main/docs/dsl-reference.md)
- [Local Development](https://github.com/mariusndini/Finyuus/blob/main/docs/local-development.md)
- [Environment Files](https://github.com/mariusndini/Finyuus/blob/main/docs/environment-files.md)
- [Object Storage](https://github.com/mariusndini/Finyuus/blob/main/docs/object-storage.md)
- [CLI Runner](https://github.com/mariusndini/Finyuus/blob/main/docs/cli-runner.md)
- [CLI Package](https://github.com/mariusndini/Finyuus/blob/main/packages/cli/README.md)
- [CLI Examples](https://github.com/mariusndini/Finyuus/blob/main/docs/cli/README.md)
- [Server-Sent Events](https://github.com/mariusndini/Finyuus/blob/main/docs/server-sent-events.md)
- [Run Lifecycle](https://github.com/mariusndini/Finyuus/blob/main/docs/run-lifecycle.txt)
- [Agent Tool Loop](https://github.com/mariusndini/Finyuus/blob/main/docs/agent-tool-loop.txt)
- [Architecture Notes](https://github.com/mariusndini/Finyuus/blob/main/docs/architecture.txt)

## Quick Start

### Prerequisites

- Node.js 22 or later.
- pnpm 10 or later.
- Docker Desktop with the Docker engine running for the full local platform.
- At least one LLM provider key for agent and guard examples:
	- `OPENAI_API_KEY`
		- `ANTHROPIC_API_KEY`
- Optional: `SEC_USER_AGENT` for SEC EDGAR demo tools.
- Optional: AWS S3 app object storage. Local development uses MinIO automatically; set these only when you want app uploads and pipeline artifacts stored in S3:
	- `OBJECT_STORAGE_PROVIDER=s3`
		- `OBJECT_STORAGE_BUCKET`
		- `OBJECT_STORAGE_PREFIX` if files should live under a bucket prefix
		- `OBJECT_STORAGE_REGION`
		- `OBJECT_STORAGE_ACCESS_KEY_ID`
		- `OBJECT_STORAGE_SECRET_ACCESS_KEY`

### Run Locally

#### Try The CLI

Use the CLI runner when you want to test `.fy` pipeline files without starting Temporal, ClickHouse, MinIO, Redis, or Langfuse:

```
npx @finyuus/cli run docs/cli/08-tables-and-branches/pipeline.fy --json
```

For agent or guard examples, export an LLM provider key first:

```
export OPENAI_API_KEY=...
npx @finyuus/cli run docs/cli/01-hello-world/pipeline.fy
```

See the [CLI Package](https://github.com/mariusndini/Finyuus/blob/main/packages/cli/README.md) and [CLI Examples](https://github.com/mariusndini/Finyuus/blob/main/docs/cli/README.md) docs for local agents, guards, tools, schemas, child pipelines, files, tables, and HTTP calls.

#### Run The Full Platform

1. Install dependencies:
```
pnpm install
```
2. Copy the environment template:
```
cp .env.local.example .env.local
```
3. Add at least one LLM provider key to `.env.local`. Leave object storage unset for local MinIO, or add the S3 variables above before running `make init`.
4. Generate local infrastructure secrets and application env files:
```
make init
```
5. Start local infrastructure:
```
make up
```
6. Optional: seed demo tools, schemas, agents, and pipelines:
```
make demos
```

Fresh installs start empty by default. Use `make demos` only when you want sample objects to explore the product.

7. Build and start the web app:
```
pnpm build-web
pnpm start-web
```
8. In a second terminal, start the worker:
```
pnpm start-worker
```

Use `pnpm dev` instead when actively editing code and you want watch mode. The production-like web server above is usually faster for navigating the app.

9. Open the dashboard:
```
http://localhost:3001
```

### Local Services

| Service | Local URL |
| --- | --- |
| finyuus | `http://localhost:3001` |
| Langfuse | `http://localhost:3000` |
| Temporal UI | `http://localhost:8080` |
| MinIO Console | `http://localhost:9001` |
| Redis Insight | `http://localhost:5540` |

Langfuse credentials and project keys are generated into `infra/.env` by `make init`.

## Example Workflow

```
q = "Prepare a customer-specific financial plan."

# Validate the user's request before invoking the agent
input_check = guard:financial_advice -message q
  pass: # The user input passed the guard
    ai = agent:_ # Agents can be defined inline
      -model "gpt-5"
      -instructions "You are a financial educator. Rewrite requests as general education."
      -tools [use_tool1, use_tool2, use_tool3]
      -reasoning high
      -message "Rewrite as general education: {q}"

    # Validate the agent's output before requesting human approval
    output_check = guard:fin_ai_advice -message ai.text
      pass: # The agent output passed the guard
        # The pipeline pauses until a human resolves the approval
        approval:compliance_review
          -message ai.text
          -assigned-to "compliance"
          -timeout 1h

          approved: # Executed when a human approves
            return {
              "status": "approved",
              "plan": ai.text
            }

          rejected: # Executed when a human rejects
            return {
              "status": "rejected",
              "stage": "human_review",
              "reason": message
            }

      block: # The agent output failed the guard
        return {
          "status": "blocked",
          "stage": "agent_output",
          "reason": output_check.message
        }

  block: # The user input failed the guard
    return {
      "status": "blocked",
      "stage": "user_input",
      "reason": input_check.message
    }
```

## Developer Motivation

👋 While building AI applications, I repeatedly found myself embedding AI logic directly into the application itself.

For example, while developing an iPhone app, I was defining buttons, screens, and iOS interactions in the same codebase where I was also maintaining system prompts that were hundreds of lines long. Over time, this became difficult to manage, test, and maintain. Even a small change to the AI’s behavior meant rebuilding and redeploying the entire application.

There is a useful parallel with SQL/database management and app-dev. Applications generally interact with databases through a clear interface (SQL), allowing data logic and infrastructure to be developed independently from the application code.

**Finyuus brings that same separation to AI development.**

It allows teams to define, version, operate, and modify agents, prompts, tools, guards, approvals, and AI workflows independently from the applications that use them.

Other platforms address parts of this problem. Finyuus is designed to address it as an integrated, production system, with an emphasis on durable execution, governance, observability, and enterprise-scale operation.

## Overview

Finyuus consists of two primary layers:

## The Finyuus Language

Finyuus includes a small, indentation-based domain-specific language designed specifically for defining AI workflows.

The language provides first-class statements for:

- Agent and model calls
- Native, HTTP, and pipeline-backed tools
- Guards and policy checks
- Human approvals
- Variables and expressions
- Conditions, loops, routes, and parallel branches
- Child pipelines
- File and table operations
- Structured returns

## The Finyuus Platform

The Finyuus platform provides the runtime and control plane used to manage workflows throughout their lifecycle.

The platform includes:

- Durable execution through Temporal
- Versioned agents, tools, guards, schemas, and pipelines
- Human approval workflows
- Run history and nested workflow visibility
- Langfuse tracing and model-cost reporting
- Structured application data in ClickHouse
- Artifact storage through configurable object storage (local MinIO or S3)
- API publishing, authentication, rate limiting, and event streaming
- A dashboard for authoring, running, and reviewing workflows

Together, the Finyuus language and platform allow teams to manage AI behavior as an independent system rather than as a collection of prompts, model calls, and workflow logic embedded throughout application code.

## Why Finyuus

Many teams begin with prompt chains, scripts, notebooks, visual workflow builders, and model calls written directly inside their applications. These approaches work well for prototypes, but become difficult to operate as AI systems grow in complexity and importance.

### AI behavior becomes coupled to application code

Prompts, tool calls, retries, conditions, loops, policies, and approval waits often become distributed across application services. This makes the resulting system difficult to understand, test, modify, and audit.

Finyuus places this behavior in explicit, versioned workflow definitions.

### Prompt chains are difficult to productionize

Basic prompt chains frequently lack durable state, reliable retries, cancellation, replayability, long-running execution, and clear failure handling.

Finyuus uses Temporal to provide durable workflow state, retries, cancellation, long-running execution, and child-workflow orchestration.

### Visual workflows become difficult to review at scale

Visual builders make prototypes approachable, but large workflows can become difficult to compare, reuse, and review.

Finyuus workflows are stored as text, enabling Git-based version history, pull requests, code review, reusable abstractions, and readable diffs.

### Agent behavior is difficult to govern

Models and users can both produce unexpected input and output. Production systems need more than prompts to control behavior.

Finyuus makes guards, structured outputs, tool permissions, version pins, human approvals, and execution history first-class concepts.

### Nested workflows need consistent execution semantics

As AI systems grow, one workflow frequently needs to invoke another. Child execution should preserve version information, run history, inputs, outputs, cancellation, and observability.

Finyuus supports saved pipelines as both direct child workflows and agent-callable tools.

### Observability is fragmented

Model traces, token usage, costs, tool calls, approval decisions, guard outcomes, and data writes often live in separate systems.

Finyuus uses Langfuse traces, Temporal workflow history, run events, and its operational dashboard.

## Highlights

- **Pipeline DSL** — Define AI workflows using a focused, indentation-based language.
- **Durable runtime** — Temporal manages workflow state, retries, cancellation, child workflows, and approval waits.
- **Reusable agents** — Configure models, prompts, tools, reasoning effort, tool policies, streaming, versions, and structured outputs.
- **Tool registry** — Use native, HTTP, and pipeline-backed tools.
- **Guardrails** — Route execution through policy checks, confidence thresholds, and explicit pass or block branches.
- **Human approvals** — Pause workflows for dashboard or API-based review, with assignees, timeouts, and timeout actions.
- **Pipeline API** — Publish workflows as authenticated HTTP endpoints with validation, idempotency, rate limiting, and server-sent events.
- **Observability** — Inspect model traces, costs, tool calls, workflow history, guards, approvals, and run events.
- **Object versioning** — Version and pin agents, guards, tools, schemas, pipelines, and pipeline-backed tools.

## Screenshots

Click any thumbnail to open the full-size image.

<table><tbody><tr><td width="50%"><a href="https://github.com/mariusndini/Finyuus/blob/main/docs/images/screenshots/dashboard.png"><img src="https://github.com/mariusndini/Finyuus/raw/main/docs/images/screenshots/dashboard.png" width="100%"></a><br><strong>Dashboard</strong></td><td width="50%"><a href="https://github.com/mariusndini/Finyuus/blob/main/docs/images/screenshots/pipelines.png"><img src="https://github.com/mariusndini/Finyuus/raw/main/docs/images/screenshots/pipelines.png" width="100%"></a><br><strong>Pipelines</strong></td></tr><tr><td width="100%" colspan="2"><a href="https://github.com/mariusndini/Finyuus/blob/main/docs/images/screenshots/pipeline-editor.png"><img src="https://github.com/mariusndini/Finyuus/raw/main/docs/images/screenshots/pipeline-editor.png" width="100%"></a><br><strong>Pipeline Editor (DSL)</strong> — the compliance workflow with guards, tools, agents, and human approvals.</td></tr><tr><td width="50%"><a href="https://github.com/mariusndini/Finyuus/blob/main/docs/images/screenshots/pipelines-runs.png"><img src="https://github.com/mariusndini/Finyuus/raw/main/docs/images/screenshots/pipelines-runs.png" width="100%"></a><br><strong>Pipeline Runs</strong></td><td width="50%"><a href="https://github.com/mariusndini/Finyuus/blob/main/docs/images/screenshots/pipelines-endpoints.png"><img src="https://github.com/mariusndini/Finyuus/raw/main/docs/images/screenshots/pipelines-endpoints.png" width="100%"></a><br><strong>Published Endpoints</strong></td></tr><tr><td width="50%"><a href="https://github.com/mariusndini/Finyuus/blob/main/docs/images/screenshots/approvals.png"><img src="https://github.com/mariusndini/Finyuus/raw/main/docs/images/screenshots/approvals.png" width="100%"></a><br><strong>Approvals</strong></td><td width="50%"><a href="https://github.com/mariusndini/Finyuus/blob/main/docs/images/screenshots/data.png"><img src="https://github.com/mariusndini/Finyuus/raw/main/docs/images/screenshots/data.png" width="100%"></a><br><strong>Data Browser</strong></td></tr><tr><td width="50%"><a href="https://github.com/mariusndini/Finyuus/blob/main/docs/images/screenshots/ai-tools-agents-new.png"><img src="https://github.com/mariusndini/Finyuus/raw/main/docs/images/screenshots/ai-tools-agents-new.png" width="100%"></a><br><strong>Agents</strong></td><td width="50%"><a href="https://github.com/mariusndini/Finyuus/blob/main/docs/images/screenshots/ai-tools-tools-new.png"><img src="https://github.com/mariusndini/Finyuus/raw/main/docs/images/screenshots/ai-tools-tools-new.png" width="100%"></a><br><strong>Tools</strong></td></tr><tr><td width="50%"><a href="https://github.com/mariusndini/Finyuus/blob/main/docs/images/screenshots/ai-tools-guards-new.png"><img src="https://github.com/mariusndini/Finyuus/raw/main/docs/images/screenshots/ai-tools-guards-new.png" width="100%"></a><br><strong>Guards</strong></td><td width="50%"><a href="https://github.com/mariusndini/Finyuus/blob/main/docs/images/screenshots/ai-tools-schemas-new.png"><img src="https://github.com/mariusndini/Finyuus/raw/main/docs/images/screenshots/ai-tools-schemas-new.png" width="100%"></a><br><strong>Schemas</strong></td></tr></tbody></table>

## Core Concepts

### Pipeline DSL

The DSL is indentation-based and intentionally focused on AI workflow orchestration. It provides a small set of statements for composing agents, tools, policies, approvals, data operations, and control flow.

| Statement | Purpose |
| --- | --- |
| `agent:key` / `agent:_` | Call a saved or inline LLM agent |
| `guard:key` / `guard:_` | Run a saved or inline policy guard |
| `tool:key` | Call a registered native, HTTP, or pipeline-backed tool |
| `pipeline:key` | Call a saved pipeline directly as a child workflow |
| `approval:key` | Pause for human approval |
| `http:get/post/put/patch/delete` | Make an HTTP request |
| `read:file` / `save:file` | Read or write object-storage-backed files |
| `read:table` / `save:table` | Read or write ClickHouse-backed tables |
| `if` / `else` | Conditional branching |
| `for` | Iterate over collections or counts |
| `parallel:` | Run branches concurrently with fail-fast behavior |
| `route` | Match a value against route cases |
| `print` | Write to the run console |
| `return` | Return a final value and stop execution |

### Agents

Agents are reusable, model-driven components configured with instructions, models, tools, reasoning effort, iteration limits, tool-choice policies, streaming behavior, structured output schemas, and version history.

```
result = agent:research_analyst
  -message "Analyze NVDA"
  -model "gpt-5"
  -reasoning high
  -tools [get_yahoo_quote, get_company_facts]
  -max-iterations 8
  -tool-choice auto
  -output-schema demo_research_report_schema

return result.thesis
```

### Tools

The tool registry supports:

- Native TypeScript tools.
- Custom HTTP tools configured in the dashboard.
- Pipeline-backed tools that execute saved pipeline versions.

Tools can be called directly from the DSL or by agents during their tool loop.

```
quote = tool:get_yahoo_quote -symbol "NVDA"

facts = tool:get_company_facts -tickerOrCik "NVDA"

summary = tool:custom_http_tool -url "https://api.example.com/news" -method GET

report = agent:research_analyst
  -message "Analyze {quote.symbol}: {facts} News: {summary.body}"

return report
```

### Guards

Guards are LLM-based policy checks. A guard returns fields such as `allowed`, `confidence`, `message`, and `reason`. Guard branches can use plain pass/block logic or confidence thresholds:

```
q = "Should I sell covered calls on NVDA?"

check = guard:financial_advice -message q
  pass:
    answer = agent:finance_educator
      -message "Rewrite as general education: {q}"
    return answer.text
  block:
    return {
      "status": "blocked",
      "message": check.message,
      "confidence": check.confidence
    }
```

### Approvals

Approvals pause execution until a human reviewer resolves the request. They support assignees, dashboard resolution, API resolution, timeouts, and timeout actions.

```
q = "Generate a trading plan for a client."

risk = guard:financial_advice -message q
  pass:
    draft = agent:finance_educator
      -message "Draft a plan for: {q}"

    approval:compliance_review
      -message draft.text
      -assigned-to "compliance"
      -timeout 1h
      approved:
        return {
          "status": "approved",
          "plan": draft.text,
          "reviewer": reviewer
        }
      rejected:
        return {
          "status": "rejected",
          "message": message
        }
  block:
    return {
      "status": "blocked",
      "message": risk.message
    }
```

### Publishing Pipelines as APIs

Pipelines can be published as HTTP endpoints. The API supports:

- Bearer-token authentication.
- Redis-backed rate limiting.
- Idempotency keys.
- Input validation.
- Server-Sent Events for run updates.
- Approval events for workflows that require human review.

Example:

```
curl -X POST http://localhost:3001/api/v1/responses/my-pipeline-slug \
  -H "Authorization: Bearer $PIPELINE_API_TOKEN" \
  -H "Idempotency-Key: request-001" \
  -H "Content-Type: application/json" \
  -d '{"input": {"query": "example"}}'
```

## Example Pipeline

```
company = tool:get_company_facts -ticker "NVDA"

research = pipeline:company_research@v3
  -company company

report = agent:research_analyst@v2
  -message "Prepare an investment research summary from: {research}"
  -output-schema research_report

output_check = guard:publication_policy -message report.text
  pass:
    return report

  block:
    return {
      "status": "blocked",
      "reason": output_check.message
    }
```

Pipelines can also call saved pipelines directly:

```
poem = pipeline:poem_pipe@v2
  -topic "apples"

return poem
```

### Versioning

Saved agents, guards, tools, schemas, and pipelines can be referenced using immutable version pins:

```
report = pipeline:company_research@v2
```

## Architecture

```
flowchart TB
  CLIENT["Users + API Clients"]

  subgraph CONTROL["Control Plane"]
    WEB["Next.js Web + API<br/>Dashboard, editor, approvals,<br/>published endpoints"]
    PG["Postgres<br/>Definitions, versions, runs,<br/>approvals, API endpoints"]
    REDIS["Redis<br/>SSE run events<br/>rate limits"]
  end

  subgraph EXECUTION["Execution Plane"]
    TEMPORAL["Temporal Server<br/>Durable workflow state<br/>scheduling + retries"]
    WORKER["Temporal Worker<br/>Pipeline execution<br/>activities + child workflows"]
  end

  subgraph RUNTIME["Pipeline Runtime"]
    DSL["@finyuus/pipelines<br/>DSL parser + runtime types"]
    AGENTS["@finyuus/agents<br/>AgentRunner + tool loop"]
    TOOLS["@finyuus/tools<br/>Native, HTTP,<br/>pipeline-backed tools"]
    LLM["@finyuus/llm<br/>Provider abstraction"]
  end

  subgraph EXTERNAL["External Services"]
    OPENAI["OpenAI"]
    ANTHROPIC["Anthropic"]
    CH["ClickHouse<br/>Application data<br/>pipeline tables"]
    OBJ["Object Storage<br/>MinIO local or S3<br/>files + artifacts"]
    LANGFUSE["Langfuse<br/>Traces, tokens, costs"]
    TUI["Temporal UI<br/>Workflow timeline"]
  end

  CLIENT -->|dashboard + REST API| WEB
  WEB <--> PG
  WEB <--> REDIS
  WEB -->|start / cancel run| TEMPORAL
  TEMPORAL -->|dispatch tasks| WORKER

  WORKER -->|load + update run state| PG
  WORKER -->|emit live events| REDIS
  WORKER -->|read/write tables| CH
  WORKER -->|store artifacts| OBJ

  WORKER -->|parse + execute| DSL
  WORKER -->|run agent steps| AGENTS
  WORKER -->|execute tools| TOOLS
  AGENTS -->|model calls| LLM
  LLM --> OPENAI
  LLM --> ANTHROPIC
  LLM -->|OTel traces| LANGFUSE
  TEMPORAL --> TUI
```

## Monorepo Structure

| Path | Description |
| --- | --- |
| `apps/web` | Next.js dashboard, pipeline editor, approvals inbox, and API server |
| `apps/worker` | Temporal worker for pipeline execution |
| `packages/agents` | Agent runner, generic agent loop, and run recording |
| `packages/llm` | LLM abstraction over OpenAI and Anthropic with Langfuse tracing |
| `packages/pipelines` | DSL parser, AST types, runtime helpers, and expression evaluator |
| `packages/tools` | Native tools, HTTP tools, tool metadata, and pipeline-backed tools |
| `packages/market-data` | Example SEC EDGAR and Yahoo Finance providers |
| `packages/storage` | ClickHouse and object-storage client factories |
| `packages/redis` | Redis client utilities |
| `infra` | Local Docker infrastructure for Postgres, ClickHouse, Redis, MinIO, Temporal, and Langfuse |

## Local Infrastructure

| Service | Purpose |
| --- | --- |
| Postgres | Definitions, versions, runs, approvals, API endpoints, and idempotency keys |
| ClickHouse | Application data, pipeline tables, and Langfuse analytics |
| Redis | Rate limiting, SSE forwarding & serving, and Langfuse queues |
| MinIO | Local S3-compatible app object storage and Langfuse media/event storage |
| Temporal | Durable workflow orchestration |
| Langfuse | LLM tracing, token usage, and model costs |

Services bind to `127.0.0.1` for local development.

## Configuration

### Required Application Variables

| Variable | Required | Purpose |
| --- | --- | --- |
| `OPENAI_API_KEY` | One provider required | OpenAI model access |
| `ANTHROPIC_API_KEY` | One provider required | Anthropic model access |
| `PIPELINE_API_TOKEN` | Required for public pipeline API access | Bearer token for `/api/v1/responses/*` |
| `SEC_USER_AGENT` | Optional | Required only for SEC EDGAR tools |

### Tracing

Set `LLM_TRACING_ENABLED=false` or `LLM_TRACING_ENABLED=0` to disable Langfuse tracing globally.

### Object Storage

The app uses object storage for uploaded files and large pipeline artifacts. Local development defaults to MinIO through `OBJECT_STORAGE_PROVIDER=local`; AWS S3 uses `OBJECT_STORAGE_PROVIDER=s3`. Existing `MINIO_*` variables remain supported as local fallbacks, and Langfuse keeps its separate MinIO configuration.

| Variable | Default | Purpose |
| --- | --- | --- |
| `OBJECT_STORAGE_PROVIDER` | `local` | `local` or `s3` |
| `OBJECT_STORAGE_BUCKET` | `MINIO_BUCKET` fallback for `local` | App file/artifact bucket. For S3, use `s3://my-bucket` or `s3://my-bucket/app-prefix`; the app splits this into bucket plus prefix. |
| `OBJECT_STORAGE_PREFIX` | none | Optional prefix inside the bucket |
| `OBJECT_STORAGE_REGION` | `auto` for `local` | S3-compatible storage region |
| `OBJECT_STORAGE_ENDPOINT` | `MINIO_ENDPOINT` fallback for `local` | Required for `local`; usually omitted for AWS S3 |
| `OBJECT_STORAGE_ACCESS_KEY_ID` | `MINIO_ACCESS_KEY` fallback for `local` | Local credentials, or S3 credentials when not using IAM/default AWS credentials |
| `OBJECT_STORAGE_SECRET_ACCESS_KEY` | `MINIO_SECRET_KEY` fallback for `local` | Secret for the access key |
| `OBJECT_STORAGE_FORCE_PATH_STYLE` | `true` for `local`, `false` for `s3` | S3 addressing mode |

When `OBJECT_STORAGE_PROVIDER=s3`, `OBJECT_STORAGE_ENDPOINT` is usually omitted for AWS S3. The app can use explicit access keys or the default AWS credential chain if credentials are available in the runtime environment.

### Pipeline API Rate Limiting

| Variable | Default | Purpose |
| --- | --- | --- |
| `PIPELINE_API_RATE_LIMIT_ENABLED` | `true` | Enable rate limiting |
| `PIPELINE_API_RATE_LIMIT_REQUESTS_PER_MINUTE` | `300` | Global requests per minute |
| `PIPELINE_API_RATE_LIMIT_ENDPOINT_REQUESTS_PER_MINUTE` | `120` | Per-endpoint requests per minute |
| `PIPELINE_API_RATE_LIMIT_STREAM_REQUESTS_PER_MINUTE` | `60` | SSE stream requests per minute |

### Custom HTTP Tool Secrets

HTTP tools can reference server-side environment variables in URLs and headers:

```
{"Authorization": "Bearer {{env.MY_API_KEY}}"}
```

Add secrets to `.env.local`, then run `make init` to sync generated app env files. Secret values are resolved on the server and are not stored in Postgres.

## Development

### Common Commands

| Command | Purpose |
| --- | --- |
| `pnpm build-web` | Build the web app for the fastest local app experience |
| `pnpm start-web` | Start the built web app on port `3001` |
| `pnpm start-worker` | Start the Temporal worker without watch mode |
| `pnpm dev` | Run web app and worker together in watch mode while actively developing |
| `pnpm typecheck` | Typecheck the workspace |
| `pnpm --filter @finyuus/web typecheck` | Typecheck the web app |
| `pnpm --filter @finyuus/worker typecheck` | Typecheck the Temporal worker |
| `make init` | Generate local secrets and env files |
| `make up` | Start local infrastructure |
| `make demos` | Seed optional demo tools, schemas, agents, and pipelines |
| `make down` | Stop local infrastructure and keep data |
| `make logs` | Follow infrastructure logs |
| `make verify` | Check local service health |
| `make reset` | Destroy local service data |
| `make temporal` | Open Temporal UI |
| `make minio` | Open MinIO console |

### Adding a Native Tool

1. Add metadata to `packages/tools/src/metadata.ts`.
2. Add a factory function to `packages/tools/src/registry.ts`.
3. Implement the tool in `packages/tools/src/`.
4. Run typechecks for the affected packages.

### Adding a Pipeline Statement

1. Add the AST type to `packages/pipelines/src/types.ts`.
2. Add parser support in `packages/pipelines/src/parser.ts`.
3. Add workflow execution logic in `apps/worker/src/workflows.ts`.
4. Add activities in `apps/worker/src/activities.ts` when the statement has side effects.
5. Add editor intelligence and autocomplete support in `apps/web/src/lib/pipeline-intelligence.ts` and `apps/web/src/components/pipeline/pipeline-completions.ts`.

## Contributing

Issues and pull requests are welcome. Before opening a pull request:

1. Create a branch from `main`.
2. Keep changes focused.
3. Run relevant typechecks.
4. Describe the behavior change and any migration/reset requirements.

## License

Licensed under the [Apache License, Version 2.0](https://github.com/mariusndini/Finyuus/blob/main/LICENSE).