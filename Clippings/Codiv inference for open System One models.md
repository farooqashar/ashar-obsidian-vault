---
title: "Codiv: inference for open System One models"
source: "https://codiv.ai/"
author:
published:
created: 2026-09-26
description: "Codiv serves open System One models: typed answers with calibrated confidence in milliseconds. Jev-compatible API. Start free with OpenJev and 100M input tokens."
tags:
  - "clippings"
---
![Codiv](https://codiv.ai/icons/codiv-icon-animated.svg) [LiveOpenJev 0.1Free public experiment](https://codiv.ai/docs/models)

Typed answers with calibrated confidence, in milliseconds. Codiv serves OpenJev through a Jev-compatible API. Every account gets 100M input tokens free.

codiv

$

## Decisions, not tokens

A System One model reads your data once and answers every question with a probability, like a fast intuition you can measure.

### Typed answers

Ask yes/no, choice and score questions. Every answer fits your schema by construction, because nothing is generated or parsed.

### Calibrated confidence

Each answer is a full probability distribution with a confidence score, so thresholds actually mean something.

### Milliseconds

One denoising step answers a whole set of questions. A typical request takes tens of milliseconds of model time.

### Jev-compatible

The same wire API as TypeSafe's Jev. Their Python and TypeScript SDKs work unchanged; change the base URL.

### Open all the way down

Open weights and an Apache-2.0 server. Anything you build on Codiv, you can also run on your own GPU.

### Free to start

100M input tokens for every account while the experiment runs. No card required.

## Try it in the browser

Typed questions, photos, chess, gomoku and chat, with every probability on screen. Sign in and run them on your free quota.

Any state and questions, with every request option.

- urgentnoulNeeds a reply within the hour?
- teamchoiceoutage · billing · feature
- tonescorecalm · annoyed · furious

urgentno

yes1%

no99%

teambillingconf 0.94

billing99%

outage1%

feature<1%

tonecalmconf 0.67

calm90%

annoyed9%

furious1%

one denoising step · 38 ms

A replay of typical answers. The playground runs the real API on your free quota.

## Open models, served fast

### OpenJev 0.1

Live

DiffusionGemma 26B-A4B turned into a System One model: the answer template goes onto the diffusion canvas and one denoising step reads a distribution for every answer.

Model id

`openjev-latest`

Question types

noul · choice · score

Base model

DiffusionGemma 26B-A4B, NVFP4

Modified by

mmastrac / razorback16

License

Apache-2.0, weights and server

### Laya 1.0

Live

by [Nandakishor M / Convai Innovations](https://github.com/NandhaKishorM/laya)

A 421M ModernBERT-large encoder, fine-tuned on typed-decision workflows. Text only, about 10 ms per request.

Model id `laya-1.0`

### Verdict 1.4

Live

by [Heman10x](https://github.com/Heman10x-NGU/Verdict-open-jev)

A 151M ModernBERT encoder with a GLiClass head, calibrated per option count. Text only, up to 24 choices, about 7 ms per request.

Model id `verdict-1.4`

### CLM 0.1

Live

by [Contrastive-LM](https://github.com/Contrastive-LM/CLM)

Contrastive state and action heads over Qwen3-8B embeddings: every option is scored against the state. Text only, 2,048 tokens, about 100 ms per request.

Model id `clm-v0.1`

### JevK5 0.2

Live

by [Alibi Serikbay](https://github.com/allebee/jevk5)

Qwen3.5-4B with a LoRA distilled from a thinking teacher, read from its answer letters' logits. Text only, 16,384 tokens, about 80 ms per question.

Model id `jevk5-0.2`

## Already using Jev? Change one line.

Codiv speaks the same API as TypeSafe's Jev, down to the error shapes and request ids. Point the official SDKs at Codiv and your code keeps working.

[Compatibility notes →](https://codiv.ai/docs/guides/jev-compatibility)

```
# Python or TypeScript: the official TypeSafe SDKs
export TYPESAFE_BASE_URL=https://api.codiv.ai
export TYPESAFE_API_KEY=sk-codiv-…
```

## Free for everyone

### Free

Available now

$0

No card required

- 100M System One tokens per account
- 10M text-generation tokens
- All models, including OpenJev
- 60 requests per minute per key
- Usage dashboard and up to 10 keys

## Roadmap

1. ### OpenJev 0.1 public experiment
	Live
	DiffusionGemma 26B-A4B as a System One model, served free on api.codiv.ai.
2. ### Dashboard, keys & usage
	Live
	Sign in with Google, GitHub or email. Track tokens per day.
3. ### Image input
	Live
	Ask typed questions about up to 8 images per request, alongside the state.
4. ### Text generation
	Live
	The same DiffusionGemma at an OpenAI-compatible /v1/chat/completions, with its own free quota.
5. ### Playground
	Live
	Try reads, photos, chess, gomoku and chat in the browser, with every probability shown.
6. ### Laya and Verdict
	Live
	Two small, fast open System One models from other authors, on the same API: laya-1.0 and verdict-1.4.
7. ### CLM and JevK5
	Live
	Two more open System One models from other authors, served from a second GPU box: clm-v0.1 and jevk5-0.2.
8. ### OpenJev 1.0
	Planned
	A new model of our own, built to raise the bar for fast, calibrated decisions. We think it will surprise you. Coming soon.
9. ### Batch mode
	Planned
	Send thousands of states in one call and collect the answers when they're ready. Built for backfills and nightly jobs.
10. ### More open System One models
	Planned
	More open models and sizes, from us and from the community.