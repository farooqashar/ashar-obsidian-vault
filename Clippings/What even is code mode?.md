---
title: "What even is code mode?"
source: "https://polylane.com/blog/what-even-is-code-mode/"
author:
  - "[[Boris Tane]]"
published: 2026-11-04
created: 2026-11-13
description: "Code mode lets agents write code that calls tools. How it works, when it helps and where it fits alongside agents that call tools directly."
tags:
  - "clippings"
---
Nobody should be on-call.

Polylane finds issues in your app and fixes them for you before they become incidents.

[Get started for free](https://console.polylane.com/signup?ref=blog.what-even-is-code-mode&attribution=%7B%22source%22%3A%22direct%22%2C%22landingPage%22%3A%22%2Fblog%2Fwhat-even-is-code-mode%2F%22%2C%22blog%22%3A%22what-even-is-code-mode%22%2C%22signupPage%22%3A%22%2Fblog%2Fwhat-even-is-code-mode%2F%22%7D)

Code mode is a simple idea: instead of asking a model to call tools one at a time, you give it a single tool that runs code, and you expose all the other tools as functions it can call from that code. The model writes a small program, the program calls the tools, and only what the program returns goes back to the model.

![The model writes one script, the script calls the tools, and only its return value goes back to the model](https://polylane.com/diagrams/a7aae6cd.svg)

Over the last year, code mode has mostly been discussed as a better way to use MCP servers. This framing undersells it. Code mode has nothing to do with MCP, it’s a decision about where tool results go: either into the model’s context, or into the variables of a program the model wrote. Any agent can make that decision, and at [Polylane](https://polylane.com/), our agent makes it for most of its tool calls.

## Tool calling

In most agents, tool calling works the same way:

- the model asks for a tool
- the harness runs it
- the full result is appended to the conversation

The model reads the whole array of messages again, decides what to call next, and the loop goes round again.

Let’s say you’re using a coding agent and ask it why CI is failing on main. It calls the GitHub API, lists the last 15 workflow runs and gets back 15 full run objects. It then picks the failed ones from within its context, and makes multiple sequential tool calls, asking for the jobs of each failed run, one at a time.

Model

Context window

GitHub API

System prompt

Every tool definition

Why is CI failing on main?

Step 1

Call listWorkflowRuns

→list runs

15 full run objects

←runs

Step 2

Call getJobs for run 1

→get jobs

Full jobs payload

←jobs

Step 3

Call getJobs for run 2

→get jobs

Full jobs payload

←jobs

Step 4

Answer

GitHub API

4 model steps. Each step reads every entry above it.

Figure 1

Tool calling: every result lands in the context window

Block heights show roughly how much of the context each entry takes. Each model step reads the whole context window above it.

Every tool call is a full inference step, and every payload stays in the context for the rest of the conversation. The model only needed the run ID, the commit and the name of the failing job, but it paid for everything else too. In this setup the model is the glue between the tools, and it’s a very expensive glue.

## Code mode

With code mode, the glue is code the model writes. The same question becomes a single script:

```ts
// Simplified, modelled on scripts our agent writes.
async () => {
  const { data } = await tools.githubApi({
    method: "GET",
    path: "/repos/{owner}/{repo}/actions/runs",
    params: { owner: "acme", repo: "web", branch: "main", per_page: 15 },
  });
  const failed = data.workflow_runs.filter((r) => r.conclusion === "failure");

  return Promise.all(
    failed.map(async (run) => {
      try {
        const jobs = await tools.githubApi({
          method: "GET",
          path: "/repos/{owner}/{repo}/actions/runs/{run_id}/jobs",
          params: { owner: "acme", repo: "web", run_id: run.id },
        });
        return {
          id: run.id,
          sha: run.head_sha.slice(0, 7),
          failedJobs: jobs.data.jobs.filter((j) => j.conclusion === "failure").map((j) => j.name),
        };
      } catch (e) {
        return { id: run.id, error: String(e) };
      }
    }),
  );
};
```

The tool results land in variables instead of the context. The script filters the runs, fetches the jobs of the failed ones in parallel, and returns a handful of fields per run. That return value is the only thing the model sees.

Model

Context window

Isolate

System prompt

Tool index

Why is CI failing on main?

Step 1

Call executeCode with a script

→script

Failed runs, a few fields each

←result

Step 2

Answer

Isolate listWorkflowRuns getJobs, run 1 getJobs, run 2 ↕ GitHub API

2 model steps. Each step reads every entry above it.

Figure 2

Code mode: the tool calls happen in an isolate, and only the result lands in the context window

The same question as Figure 1. The API calls run inside the script, so the model takes two steps instead of four.

This is not only cheaper, it’s also faster. With tool calling, the model takes a full inference step for every call, and at each step it reads, and reasons about, a growing dump of JSON it mostly doesn’t need. With code mode, it writes one script, the calls inside it run in parallel, and the model gets its answer back from a single tool call. Fewer steps, less to read at each step, and less reasoning about irrelevant fields.

Code mode is also not limited to JavaScript. Any language that can be interpreted in an isolated environment works, and many agent frameworks use Python instead: the model writes a Python function that calls the tools, and the environment runs it.

### Where does the code run?

The beauty of code mode is that the model can write and execute arbitrary code. The scary part of code mode is that the model can write and execute arbitrary code. That code has to run somewhere it can’t do any damage.

Polylane’s agent has a tool called `executeCode` for this. Its only input is a string of JavaScript: an async function, like the script above. When the model wants to use code mode, it calls `executeCode` like any other tool:

```json
{
  "name": "executeCode",
  "input": {
    "code": "async () => { const { data } = await tools.githubApi({ ... }); return data.workflow_runs.length; }"
  }
}
```

Inside that code, the model has access to a single global object called `tools`. It has one async function per tool the agent can use, and each function takes the same input as the tool and returns its result:

```ts
// What the model can call from inside a script.
await tools.githubApi({ method: "GET", path: "/repos/{owner}/{repo}/pulls", params: { owner: "acme", repo: "web" } });
await tools.vercelListDeployments({ projectId: "prj_123", limit: 10 });
await tools.awsCloudWatchLogs({ action: "query", logGroupNames: ["/aws/lambda/checkout-api"], queryString: "..." });
await tools.sentryIssues({ action: "get", issueId: "4512" });
```

Each script runs in a fresh V8 isolate from [Dynamic Cloudflare Workers](https://developers.cloudflare.com/dynamic-workers/), with no network access at all. This is how `executeCode` starts one, trimmed:

```ts
const executor = new DynamicWorkerExecutor({
  loader: env.LOADER,
  timeout: EXECUTION_TIMEOUT_MS,
  globalOutbound: null, // fetch() and connect() throw inside the isolate
});

const { result, logs, error } = await executor.execute(code, [provider]);
```

The isolate has no network, so how does `tools.githubApi()` reach GitHub? That’s what the `provider` is for. It’s built outside the isolate, in a regular Cloudflare Worker, and maps every tool name to a function that runs the real tool:

```ts
// Simplified: one function per tool, running in a regular Worker, not in the isolate.
const provider = {
  name: "tools",
  fns: Object.fromEntries(Object.entries(agentTools).map(([name, tool]) => [name, (input) => tool.execute(input)])),
};
```

Inside the isolate, `tools` only holds stubs with the same names. When the script calls `tools.githubApi(input)`, the stub sends the name and the input over RPC to that regular Worker, which runs the real `githubApi` tool with the workspace’s credentials, and the result is sent back into the isolate. The only way the script can reach GitHub is through that tool, and it never sees a token.

![The script runs in an isolate with no network; its tool calls go to a regular Worker, which holds the credentials](https://polylane.com/diagrams/707baa66.svg)

An isolate starts in a few milliseconds, so there’s no pool of isolates to keep warm. Every script gets a new one, and it’s thrown away as soon as the script returns.

## You don’t need Cloudflare for this

We run code mode on Cloudflare because the rest of Polylane runs there, and isolates are a very good fit for it. But all you need is an isolated environment that can run code without network access, and a way to pass your tools into it. There are plenty of options, including:

- **Claude’s programmatic tool calling.** The Claude API has [programmatic tool calling](https://platform.claude.com/docs/en/agents-and-tools/tool-use/programmatic-tool-calling): Claude writes code that runs in Anthropic’s sandbox, and each call to one of your tools pauses the script and comes back to your application as a normal tool call.
- **pctx.** [pctx](https://github.com/portofcontext/pctx) is an open source code mode server: it sits in front of your MCP servers and runs the generated code in a Deno sandbox that can only reach the hosts you allow.
- **Pyodide in Deno.** Pydantic’s [mcp-run-python](https://github.com/pydantic/mcp-run-python) runs Python with Pyodide inside Deno, isolated from the host.
- **QuickJS in WebAssembly.** [quickjs-emscripten](https://github.com/justjake/quickjs-emscripten) gives you a small JavaScript engine in WebAssembly that you can embed in any Node.js process, with no network and no file system unless you pass them in.

## Code mode is not about MCP

Early implementations of code mode focused on converting MCP servers into TypeScript APIs, which is why most people think of code mode as a better way to use MCP. But if you look at what the isolate actually needs, it’s a list of functions with their types, and a way to call them. MCP is one source of those functions. The agent’s own tools are another, and for most agents they are by far the bigger one.

That’s how we use it. Polylane connects to everything you run in production: your clouds, your observability tools, your code, your error tracking, etc. It [investigates production issues and opens pull requests to fix them](https://polylane.com/use-cases/ticket-resolution/), and every provider it connects to comes with its own tools. That adds up to a few hundred tools, and describing all of them in full in the prompt would take close to 300,000 tokens before the conversation even starts.

### Tool descriptions in the prompt

tokens

Every tool definition, in full ~288k

Code mode index ~13k

Figure 3

Context it takes to describe Polylane's tools to the model

Estimated at four characters per token, for every tool definition in our codebase.

None of these tools go through MCP on their way into `executeCode`. They’re the agent’s own tools, passed into the isolate as functions.

## How Polylane uses code mode

### The prompt is an index, not a manual

Putting every tool signature in the prompt would cost more context than code mode saves. So we don’t. When we build `executeCode` ’s description, we generate a TypeScript declaration of the `tools` object with just the name of each tool and a one-line summary taken from its description:

```ts
// Part of the tool index in executeCode's description.
declare const tools: {
  awsCloudWatchLogs: ToolFn;
  datadogSearchLogs: ToolFn;
  sentryIssues: ToolFn;
  vercelListDeployments: ToolFn;
  // more tools, each with a one-line summary (omitted here)

  /** Look up instructions and TypeScript input/output types for tools by name. */
  __describe: (names: string[]) => Promise<Record<string, { input: string; output: string; description?: string }>>;
};
```

### Looking up a tool with tools.\_\_describe

For every tool, the model needs to know their input and output schema. `tools.__describe` is a function in the isolate like any other tool: it takes a list of tool names and returns their input type, their output type and their full instructions. The model usually calls it in a first script, reads the types, and writes the real script in the next step:

![The model reads the index, looks up the types of the tools it needs, then writes the script that calls them](https://polylane.com/diagrams/56151714.svg)

Here’s what the model gets back for `vercelListDeployments`:

```ts
await tools.__describe(["vercelListDeployments"]);

// {
//   vercelListDeployments: {
//     input: "{ projectId?: string; limit?: number; sinceMs?: number }",
//     output: "{ items: Array<{ uid: string; projectId: string; target: null | string; state: string; url: string;
//               branch: null | string; sha: null | string; createdAt: number; ready: number }>; count: number }",
//     description: "List recent Vercel deployments for a project (or across the team) ... ",
//   }
// }
```

The output type matters as much as the input type. With plain tool calling, the model reads whatever comes back and figures out its shape. In code mode, it has to write `items.filter((d) => d.state === "ERROR")` before it has seen a single result, so it needs to know that `items` and `state` exist. We generate output types for our tools at build time for exactly this reason.

### Teaching the model to write defensive scripts

The last piece is the instructions in `executeCode` ’s description. A tool call that throws inside a script throws for the whole script, unless the model catches it, so the description tells the model to wrap every tool call in its own `try/catch`, and to run independent calls with `Promise.all`:

```ts
// The fan-out pattern the description asks for: partial results instead of one failure losing everything.
await Promise.all(
  items.map(async (it) => {
    try {
      return { it, data: await tools.someTool(args) };
    } catch (e) {
      return { it, error: String(e) };
    }
  }),
);
```

It also tells the model to never return a raw API payload: pick the fields you need, aggregate inside the isolate, and return a summary.

## What the data says

We record every tool call our agent makes in our data lake, tagged with how it was called, either as a direct tool call or through code mode. I’m using data from the past 30 days to illustrate how code mode changes the behaviour of agents. Almost all of those calls were made by the same model, so this shows how code mode behaves in our setup, not how models compare with each other.

More than 70% of the agent’s tool calls ran inside `executeCode`, and that share was pretty stable throughout the 30 days.

<svg viewBox="0 0 680 250" style="direction: ltr" role="img" aria-label="Share of the agent's tool calls made inside a script, per day. Share inside code per day from 5 Oct to 3 Nov, ." tabindex="0" data-astro-cid-nicuegke=""><g data-astro-cid-nicuegke=""><line x1="50" x2="628" y1="220" y2="220" data-astro-cid-nicuegke="" stroke="currentColor" stroke-opacity="0.2"></line><text x="42" y="220" dy="0.35em" text-anchor="end" data-astro-cid-nicuegke="" fill="currentColor">0% </text></g><g data-astro-cid-nicuegke=""><line x1="50" x2="628" y1="172.5" y2="172.5" data-astro-cid-nicuegke="" stroke="currentColor" stroke-opacity="0.2"></line><text x="42" y="172.5" dy="0.35em" text-anchor="end" data-astro-cid-nicuegke="" fill="currentColor">25% </text></g><g data-astro-cid-nicuegke=""><line x1="50" x2="628" y1="125" y2="125" data-astro-cid-nicuegke="" stroke="currentColor" stroke-opacity="0.2"></line><text x="42" y="125" dy="0.35em" text-anchor="end" data-astro-cid-nicuegke="" fill="currentColor">50% </text></g><g data-astro-cid-nicuegke=""><line x1="50" x2="628" y1="77.5" y2="77.5" data-astro-cid-nicuegke="" stroke="currentColor" stroke-opacity="0.2"></line><text x="42" y="77.5" dy="0.35em" text-anchor="end" data-astro-cid-nicuegke="" fill="currentColor">75% </text></g><g data-astro-cid-nicuegke=""><line x1="50" x2="628" y1="30" y2="30" data-astro-cid-nicuegke="" stroke="currentColor" stroke-opacity="0.2"></line><text x="42" y="30" dy="0.35em" text-anchor="end" data-astro-cid-nicuegke="" fill="currentColor">100% </text></g><text x="59.63" y="240" text-anchor="middle" data-astro-cid-nicuegke="" fill="currentColor">5 Oct </text><text x="136.7" y="240" text-anchor="middle" data-astro-cid-nicuegke="" fill="currentColor">9 Oct </text><text x="213.77" y="240" text-anchor="middle" data-astro-cid-nicuegke="" fill="currentColor">13 Oct </text><text x="290.83" y="240" text-anchor="middle" data-astro-cid-nicuegke="" fill="currentColor">17 Oct </text><text x="367.9" y="240" text-anchor="middle" data-astro-cid-nicuegke="" fill="currentColor">21 Oct </text><text x="444.97" y="240" text-anchor="middle" data-astro-cid-nicuegke="" fill="currentColor">25 Oct </text><text x="522.03" y="240" text-anchor="middle" data-astro-cid-nicuegke="" fill="currentColor">29 Oct </text><text x="599.1" y="240" text-anchor="middle" data-astro-cid-nicuegke="" fill="currentColor">2 Nov </text><path data-i="0" d="M53.66 220 V80.66 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="1" d="M72.93 220 V76.89 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="2" d="M92.2 220 V74.21 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="3" d="M111.46 220 V84.9 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="4" d="M130.73 220 V84.54 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="5" d="M150 220 V72.57 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="6" d="M169.26 220 V72.32 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="7" d="M188.53 220 V79.54 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="8" d="M207.8 220 V77.82 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="9" d="M227.06 220 V80.76 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="10" d="M246.33 220 V83.79 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="11" d="M265.6 220 V85.51 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="12" d="M284.86 220 V81.82 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="13" d="M304.13 220 V77.45 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="14" d="M323.4 220 V78.76 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="15" d="M342.66 220 V81.51 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="16" d="M361.93 220 V101.02 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="17" d="M381.2 220 V95.3 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="18" d="M400.46 220 V102.64 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="19" d="M419.73 220 V92.04 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="20" d="M439 220 V95.7 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="21" d="M458.26 220 V97.55 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="22" d="M477.53 220 V96.33 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="23" d="M496.8 220 V98.79 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="24" d="M516.06 220 V96.03 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="25" d="M535.33 220 V93.83 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="26" d="M554.6 220 V93.22 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="27" d="M573.86 220 V96.5 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="28" d="M593.13 220 V106.77 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><path data-i="29" d="M612.4 220 V91.64 a4 4 0 0 1 4 -4 h3.95 a4 4 0 0 1 4 4 V220 Z" data-astro-cid-nicuegke="" fill="none"></path><text x="175.23" y="62.31999999999999" text-anchor="middle" data-astro-cid-nicuegke="" fill="currentColor">80%</text><line x1="0" x2="0" y1="30" y2="220" data-astro-cid-nicuegke="" stroke="currentColor" stroke-opacity="0.2"></line></svg>

Figure 4

Share of the agent's tool calls made inside a script, per day

Completed tool calls from agent threads. The dip from 21 October comes from an unrelated architecture change.

Most code mode scripts don’t fan out very far: a typical script makes two or three tool calls. Almost a third of them make a single call, which sounds like a waste of code mode until you look at what they do.

Figure 5

Tool calls per successful script

Scripts that ran without error over 30 days, by how many tools they called.

They call one tool and do the filtering in code, because the model knows it only needs a few rows out of a large payload. Logs are the typical case. Here’s a script our agent wrote during an investigation. It asks for the error count of every distinct error message over a week, then throws away the rows that aren’t real errors (request lines, stack frames, generic “exception” messages) before returning anything:

```ts
async () => {
  const r = await tools.cloudflareRunTelemetryQuery({
    datasets: ["cloudflare-workers", "otel"],
    timeframe: { reference: "2026-11-01T16:45:00Z", offset: "-7d" },
    view: "calculations",
    filters: [{ key: "$metadata.level", operation: "eq", type: "string", value: "error" }],
    calculations: [{ operator: "count", alias: "n" }],
    groupBys: [
      { type: "string", value: "$metadata.service" },
      { type: "string", value: "$metadata.message" },
    ],
    orderBy: { value: "n", order: "desc" },
    limit: 300,
  });
  const rows = (r.calculations?.[0]?.aggregates || []).map((g) => ({ g: g.groupKey, n: g.value }));
  const isUrl = (s) => /^(GET|POST|PUT|DELETE|PATCH|HEAD) https?:/.test(s);
  const noise = (s) => s === "exception" || s.endsWith(" ERROR") || s.startsWith("    at ");
  const real = rows.filter((x) => {
    const m = x.g.split(" ⬤ ")[1] || "";
    return !isUrl(m) && !noise(m);
  });
  return { totalRows: rows.length, real: real.slice(0, 60) };
};
```

One tool call, up to 300 groups of log messages in, and the 60 most frequent real errors out. With a direct tool call, all 300 rows would have landed in the model context, and the model would have done the same filtering using inference.

The scripts that make no tool calls at all are pure computation, like parsing a log line, date arithmetic, or reshaping JSON the model already has.

Across all scripts, the difference in context is large. Only a small fraction of the tool output produced inside scripts made it back to the model, and even the scripts that called 50 tools or more returned about 1,700 tokens each on average.

Figure 6

14x

less tool output in the model's context

Estimated token savings using code mode, over 30 days.

### Failures are cheaper inside code

Calling third-party APIs from tools can fail, and most harnesses have a lot of plumbing to recover from this. What matters is what a failure costs. A failed direct call costs a full round trip: the model reads the error, thinks about it, and tries again. A failed call inside a script is a `catch` block. More than 95% of the failed calls inside scripts happened in a script that still finished and returned a result, with the error sitting next to the items that succeeded.

Overall, code mode scripts ran with a 98.8% success rate, which means the model has to reason about far fewer tool failures.

![A failed direct call costs a model step; a failed call in a script is caught and the script carries on](https://polylane.com/diagrams/597f5d2e.svg)

## What other agents do

We have an MCP server that gives coding agents access to everything Polylane can access (logs, metrics, traces, the context graph, etc.) from a single MCP server instead of connecting all providers MCPs. For instance, if you use Claude Code, your agent can reason about your Cloudflare Workers and your Vercel projects through the same MCP server.

Our MCP server offers coding agents both options: either call tools directly with a `runTool` tool, or use `runCode` to execute arbitrary JavaScript against the same tools. Over the same 30 days, most coding agents chose to write code when they had the choice. Codex is the exception, it mostly calls tools one by one.

Figure 7

How coding agents call Polylane's tools

Share of each client's tool calls on the Polylane MCP server over 30 days. Client names are what each client reports when it connects.

For the agents that use both options a lot, calls made from code failed about as often as direct ones, and in Amp’s case far less often.

### Amp

% of calls failed

Called directly 4.0%

Called from code 1.2%

### Claude Code

% of calls failed

Called directly 6.0%

Called from code 6.4%

### Codex

% of calls failed

Called directly 1.3%

Called from code 1.0%

Figure 8

Failure rate of tool calls on the Polylane MCP, by coding agent

Over 30 days, for the clients that call tools both ways.

## Where code mode falls short

Code mode isn’t free, and we’ve hit most of its edges:

- **Writes.** A tool call made from a script doesn’t show up in the conversation as its own step: the transcript only contains the script. That’s fine for reads, but for a change to someone’s systems we want every operation to be its own visible step, with its exact input. So `executeCode` refuses state-changing calls when a person is in the conversation, and the model makes them one at a time as normal tool calls.
- **Timeouts.** A script has a single timeout, and every call inside it draws on it. A slow telemetry query can starve the calls after it, so we give each kind of tool its own slice of the budget, and tell the model to run independent calls in parallel.
- **Binary data.** Whatever a script returns comes back to the model as text, serialised as JSON. Images, screenshots and files don’t survive that well, so tools that return them are better called directly, where the harness can hand the image to the model as an image.

## Code mode for any agent

If you’re building an agent with more than a handful of tools, you don’t need MCP to get the benefits of code mode:

- **Put your tools behind one code tool.** An index of the tools in the prompt, and their types on demand.
- **Generate output types.** The model writes code against a result before it has seen it, so it needs to know its shape.
- **Run the code with no network.** Pass the tools in, so credentials never enter the isolate.
- **Teach the model to write defensive scripts.** Catch errors per call, run calls in parallel, and return only what’s needed.

Code mode is a better way for agents to use tools.

## Nobody should be on-call. Polylane watches your infra, investigates, and fixes what breaks.

[Get started for free](https://console.polylane.com/signup?ref=blog.what-even-is-code-mode&attribution=%7B%22source%22%3A%22direct%22%2C%22landingPage%22%3A%22%2Fblog%2Fwhat-even-is-code-mode%2F%22%2C%22blog%22%3A%22what-even-is-code-mode%22%2C%22signupPage%22%3A%22%2Fblog%2Fwhat-even-is-code-mode%2F%22%7D)