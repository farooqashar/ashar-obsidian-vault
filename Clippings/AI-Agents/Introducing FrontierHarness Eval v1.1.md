---
title: "Introducing FrontierHarness Eval v1.1"
source: "https://runta.com/blog/introducing-frontierharness-eval-v1-1/?utm_source=hackernewsletter&utm_medium=email&utm_term=data"
author:
  - "[[Runta]]"
published: 2026-11-17
created: 2026-11-20
description: "FrontierHarness Eval v1.1 ran 22 coding-agent harnesses with 5 models on the same 62 tasks, 4 times each: 27,280 runs. The best-value harness was different with each model, and cost ranks moved far between models. With the model fixed, the most expensive harness cost 1.8 to 5.0 times as much per task as the cheapest."
tags:
  - "clippings"
  - "coding-agents"
  - "llm-providers"
---
## TL;DR

We partnered with [Baseten](https://www.baseten.co/) to build the largest-scale harness leaderboard using 83B tokens across 27,280 agent runs. We wanted to answer two questions: **when you switch your model, should you consider switching the harness too? What is the best harness for each model?**

Previously, our [v1.0 FrontierHarness leaderboard](https://runta.com/blog/introducing-frontierharness-eval/) ranked harnesses on a single model, Kimi K3.

V1.1 expands the benchmark to 22 harnesses × 5 models × 62 tasks × 4 attempts, 76× the size of v1.0.

**Through our experiments, we found that you should consider switching harnesses when switching models to maximize your experience.**

Each model had a different best-value (pass rate vs. cost) harness: Codex CLI with GLM-5.3, Pi with GLM-5.3 Flash, ZCode with DeepSeek V4.1 Flash 1017, Oh My Pi with Muse and Alma with Kimi-K3. **Cost ranks moved far between models.**

By cost per task, the median harness moved 11 of 22 places, and Codex CLI went from 1st with GLM-5.3 to 16th with Kimi-K3.

---

## Result

**Figure 1. Cost per task and pass rate of each harness**

Each point is one harness: further left is a lower average cost per task, and higher is a higher pass rate. The orange line joins the harnesses that no other harness beats in both cost and pass rate. Select a model to filter all figures of this post.

Model

Hermes AgentZCodeGrok BuildOh My PiKimiCodeAlmaCodex CLImini-SWE-agentMakaClaude CodePiOpenCode v1OpenCode v2DSH MinimalCline CLIMiniMax CodeGitHub Copilot CLIDSH CreatorDSH StandardDSH CodeAntigravity CLIExo

Pass rate

52%

54%

56%

58%

60%

62%

$0.60

$0.70

$0.80

$0.90

Average cost per task

Over all models, four harnesses are on the line: OpenCode v2 (lowest cost per task, $0.561), Pi, Codex CLI and ZCode (highest pass rate, 61.9%). The others cost up to 1.6 times as much and passed 50.6% to 60.2%.

Each card names the best-value harness for one model: the lowest cost per pass, unless another harness costs at most 30% more per pass and passes at least 5 points more often. This rule picked ZCode over OpenCode v1 with DeepSeek (25% more cost, 7.7 more points) and Alma over Oh My Pi with Kimi-K3 (9% more cost, 6.5 more points).

---

## Why We Built FrontierHarness Eval v1.1

[V1.0](https://runta.com/blog/introducing-frontierharness-eval/) ran nine harnesses with one model. Their pass rates were within 17 points of each other, but the median cost per pass differed by 17 times. We thought that this came mostly from the pair of harness and model: a harness that is cheap with one model can be expensive with another.

V1.1 runs each harness with five models.

---

## What We Tested

**Harnesses.** 18 harnesses. The four DeepSeek Harness profiles have different tool sets, and OpenCode ran at two versions. Each counts separately: 22 configurations. Table 2 in the [appendix](#appendix-reference-tables) gives their versions.

**Models.** Baseten served all five: GLM-5.3 (`zai-org/GLM-5.3`), GLM Flash (`zai-org/GLM-5.3-Flash`), DeepSeek (`deepseek-ai/DeepSeek-V4.1-Flash-1017`), Muse (`meta-models/muse-spark-open`) and Kimi-K3 (`moonshotai/Kimi-K3`).

**Tasks.** 62 terminal tasks. The time limits are those of the tasks, from 15 minutes to 8 hours.

---

## Setup and Scoring

### Configuration and Runtime

We ran the Harbor evaluation with each harness’s default settings, because we think this is closest to how people use a harness every day. Each harness used the same version and settings with all models, at the maximum reasoning effort.

**Figure 2. How Harbor and Runta divide the work in each trial**

![Harbor runs each trial, with its agent and verifier, in its own Runta runtime, which is deleted at the end.](https://runta.com/blog/introducing-frontierharness-eval-v1-1/harbor-runta-trial-lifecycle-stacked.png)

Each trial gets a new Runta runtime, which is deleted at the end. Thus no trial can see the files of an earlier trial.

### Scoring Method

**Table 1. Methodology**

| Item | Effect | Rule |
| --- | --- | --- |
| Score | pass rate | Passes ÷ scored trials, from the last run of each trial. A pass is a reward of 1. |
| Timeouts | pass rate | Graded. The grader's result counts. |
| Infrastructure errors | not scored | Not scored. The trial ran again. |
| Reward hacking | fail | Counts as a failure, for example an online solution lookup (Table 3) |
| Confidence | interval | 95% bootstrap over tasks: about ±10 points for one harness with one model |
| Cost | list price | Baseten list price × tokens that the provider reported. 208 trials have no price. |

A cell is one harness and model pair. We use the two cost metrics of [our dashboard](https://frontierharness.org/):

- **Average cost per task:** the mean cost of the priced trials of each task, then the mean over the tasks. Figure 1 and the cost ranks use it (Figures 4 and 5).
- **Cost per pass:** the average cost per task divided by the pass rate. The best-value harness uses it (Figures 3, 6 and 7).

We pick the best value by cost per pass because we want harnesses at the top left of a chart of pass rate against cost per task: a high pass rate at a low cost. Draw a line from the origin to the point of a harness. Its slope, pass rate ÷ cost, is the passes per dollar. Cost per pass is the inverse of this slope, so the lowest cost per pass has the steepest line.

Audits of the trial logs flagged 216 trials for reward hacking, and 163 of them were online lookups. These trials score 0. Table 3 in the appendix gives the count for each harness and model.

---

## Results by Model

**Figure 3. Cost and pass rate of each harness with each model**

Show

| Harness | GLM-5.3 | GLM Flash | DeepSeek | Muse | Kimi-K3 | All models |
| --- | --- | --- | --- | --- | --- | --- |
| Codex CLI | $0.803 | $0.226 | $0.237 | $1.69 | $1.78 | $0.937 |
| Pi | $1.55 | $0.223 | $0.210 | $1.47 | $1.54 | $0.976 |
| OpenCode v2 | $1.53 | $0.254 | $0.270 | $1.35 | $1.61 | $0.978 |
| Oh My Pi | $1.74 | $0.273 | $0.250 | $1.21 | $1.45 | $0.983 |
| ZCode | $1.48 | $0.264 | $0.222 | $1.79 | $1.66 | $1.06 |
| KimiCode | $1.55 | $0.379 | $0.264 | $1.49 | $1.84 | $1.09 |
| OpenCode v1 | $1.62 | $0.287 | $0.177 | $1.79 | $1.74 | $1.12 |
| Maka | $1.48 | $0.259 | $0.193 | $1.50 | $2.22 | $1.13 |
| MiniMax Code | $1.76 | $0.323 | $0.256 | $1.67 | $1.70 | $1.14 |
| DeepSeek Harness: Minimal | $1.88 | $0.484 | $0.256 | $1.54 | $1.70 | $1.15 |
| Hermes Agent | $1.66 | $0.328 | $0.314 | $1.69 | $1.82 | $1.16 |
| Cline CLI | $1.55 | $0.261 | $0.860 | $1.59 | $1.75 | $1.19 |
| Grok Build | $1.81 | $0.321 | $0.284 | $1.77 | $1.81 | $1.20 |
| Alma | $1.62 | $0.295 | $0.249 | $2.40 | $1.58 | $1.22 |
| DeepSeek Harness: Standard | $2.00 | $0.449 | $0.292 | $1.77 | $1.95 | $1.27 |
| DeepSeek Harness: Creator | $2.19 | $0.466 | $0.273 | $1.34 | $2.25 | $1.27 |
| mini-SWE-agent | $2.03 | $0.445 | $0.219 | $1.77 | $2.02 | $1.29 |
| DeepSeek Harness: Code | $2.10 | $0.372 | $0.243 | $2.08 | $2.11 | $1.32 |
| Exo | $2.72 | $0.424 | $0.336 | $1.34 | $2.24 | $1.36 |
| GitHub Copilot CLI | $1.76 | $0.302 | $0.492 | $2.96 | $1.80 | $1.38 |
| Claude Code | $1.77 | $0.367 | $0.285 | $3.75 | $1.94 | $1.55 |
| Antigravity CLI | $2.46 | $0.448 | $0.292 | $2.33 | $2.73 | $1.63 |

Deeper color: a lower cost or a higher pass rate, relative to each column.Outlined: the harness on the model card.Select a column name to sort.

Point at a cell to read the pair. Select a harness name to keep it highlighted in all figures.

A deeper cell costs less than the others in its column. Codex CLI was the cheapest per pass with GLM-5.3, $0.803, but 12th with Muse and 10th with Kimi-K3. Over all models, it cost the least per pass, $0.937, and Antigravity CLI the most, $1.63.

### How Sure Are These Results?

We drew the 62 tasks again 4,000 times and chose the best-value harness each time. Codex CLI stayed first with GLM-5.3 in 99.6% of the draws. The other four winners are the most likely of several close harnesses: Oh My Pi with Muse (53%), ZCode with DeepSeek (47%), Pi with GLM Flash (42%) and Alma with Kimi-K3 (25%).

---

## The Harness Changes the Cost

The model sets the general level of the cost, because the list prices of the models differ by 20 times or more (Figure 9). We took the average cost per task of the 110 cells on a log scale, so that a doubling counts the same with each model. A two-way analysis of variance divides the spread of these costs into three parts:

- **Model, 92.8%:** the differences between the five models.
- **Harness, 2.3%:** the part of the effect of a harness that is the same with every model.
- **Pair, 4.9%:** the rest. It also contains noise, because each cell has one value.

So with the model fixed, 68% of the variation between harnesses (4.9 of 7.2 points) depends on the pair, or is noise.

### With the Model Fixed, the Harness Changes the Cost by 1.8 to 5.0 Times

**Figure 4. Lowest-cost and highest-cost harness for each model**

Each row is a model, on a log scale of average cost per task. The ratio divides the highest cost by the lowest.

**Codex CLI** $0.463 · 57.7% **Exo** $1.36 · 50.0%

**2.9×** · chance 1.2× · per pass 3.4×

**Pi** $0.130 · 58.1% **DeepSeek Harness: Minimal** $0.268 · 55.2%

**2.1×** · chance 1.3× · per pass 2.2×

**OpenCode v1** $0.108 · 61.3% **Cline CLI** $0.545 · 63.3%

**5.0×** · chance 1.6× · per pass 4.9×

**DeepSeek Harness: Creator** $0.702 · 52.4% **Claude Code** $1.98 · 52.8%

**2.8×** · chance 1.8× · per pass 3.1×

**Oh My Pi** $0.839 · 57.7% **Antigravity CLI** $1.55 · 56.9%

**1.8×** · chance 1.2× · per pass 1.9×

The two dots are the harnesses with the lowest and the highest cost. Each small tick is one of the other harnesses. Point at a tick to read it.

To test for chance, we shuffled the trials between the harnesses of each model 300 times and calculated the ratio again. “Chance” is the median of these ratios, 1.2 to 1.8 times. All five real ratios are larger than every shuffle (p = 0.003), so the spread comes from the harnesses, not from the noise of reruns. The largest is with DeepSeek: Cline CLI cost 5.0 times as much as OpenCode v1, for 2.0 more points. With the other models, the cheapest harness per task was at most 0.4 points behind the most expensive one.

### The Cheapest Harness per Task Changes With the Model

**Figure 5. Cost rank of each harness with each model (1 = lowest cost per task)**

Each line is a harness, with the cheapest at the top. The five highlighted lines are the cheapest harnesses per task with GLM-5.3, GLM Flash, DeepSeek, Muse and Kimi-K3.

<svg width="732" height="502" viewBox="0 0 732 502" role="group" aria-label="Cost rank of each harness with each model. Rank 1 is the lowest cost. Codex CLI, Pi, OpenCode v1, DeepSeek Harness: Creator and Oh My Pi are in color. Select a harness name to follow its line."><g><line x1="146" x2="146" y1="30" y2="492" stroke="currentColor" stroke-opacity="0.2"></line><text x="146" y="12" text-anchor="middle" fill="currentColor">GLM-5.3</text></g> <g><line x1="256" x2="256" y1="30" y2="492" stroke="currentColor" stroke-opacity="0.2"></line><text x="256" y="12" text-anchor="middle" fill="currentColor">GLM Flash</text></g> <g><line x1="366" x2="366" y1="30" y2="492" stroke="currentColor" stroke-opacity="0.2"></line><text x="366" y="12" text-anchor="middle" fill="currentColor">DeepSeek</text></g> <g><line x1="476" x2="476" y1="30" y2="492" stroke="currentColor" stroke-opacity="0.2"></line><text x="476" y="12" text-anchor="middle" fill="currentColor">Muse</text></g> <g><line x1="586" x2="586" y1="30" y2="492" stroke="currentColor" stroke-opacity="0.2"></line><text x="586" y="12" text-anchor="middle" fill="currentColor">Kimi-K3</text></g> <g><path d="M 146 271.5 C 201 271.5, 201 292.5, 256 292.5 C 311 292.5, 311 439.5, 366 439.5 C 421 439.5, 421 313.5, 476 313.5 C 531 313.5, 531 313.5, 586 313.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="271.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="292.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="439.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="313.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="313.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 124.5 C 201 124.5, 201 166.5, 256 166.5 C 311 166.5, 311 145.5, 366 145.5 C 421 145.5, 421 355.5, 476 355.5 C 531 355.5, 531 250.5, 586 250.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="124.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="166.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="145.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="355.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="250.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 355.5 C 201 355.5, 201 271.5, 256 271.5 C 311 271.5, 311 397.5, 366 397.5 C 421 397.5, 421 376.5, 476 376.5 C 531 376.5, 531 334.5, 586 334.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="355.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="271.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="397.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="376.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="334.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 250.5 C 201 250.5, 201 145.5, 256 145.5 C 311 145.5, 311 124.5, 366 124.5 C 421 124.5, 421 61.5, 476 61.5 C 531 61.5, 531 40.5, 586 40.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="250.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="145.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="124.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="61.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="40.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 208.5 C 201 208.5, 201 376.5, 256 376.5 C 311 376.5, 311 313.5, 366 313.5 C 421 313.5, 421 187.5, 476 187.5 C 531 187.5, 531 292.5, 586 292.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="208.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="376.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="313.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="187.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="292.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 229.5 C 201 229.5, 201 208.5, 256 208.5 C 311 208.5, 311 187.5, 366 187.5 C 421 187.5, 421 439.5, 476 439.5 C 531 439.5, 531 145.5, 586 145.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="229.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="208.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="187.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="439.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="145.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 40.5 C 201 40.5, 201 61.5, 256 61.5 C 311 61.5, 311 229.5, 366 229.5 C 421 229.5, 421 334.5, 476 334.5 C 531 334.5, 531 355.5, 586 355.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="40.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="61.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="229.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="334.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="355.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 418.5 C 201 418.5, 201 439.5, 256 439.5 C 311 439.5, 311 103.5, 366 103.5 C 421 103.5, 421 271.5, 476 271.5 C 531 271.5, 531 439.5, 586 439.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="418.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="439.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="103.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="271.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="439.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 103.5 C 201 103.5, 201 103.5, 256 103.5 C 311 103.5, 311 61.5, 366 61.5 C 421 61.5, 421 145.5, 476 145.5 C 531 145.5, 531 460.5, 586 460.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="103.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="103.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="61.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="145.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="460.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 292.5 C 201 292.5, 201 334.5, 256 334.5 C 311 334.5, 311 418.5, 366 418.5 C 421 418.5, 421 481.5, 476 481.5 C 531 481.5, 531 397.5, 586 397.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="292.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="334.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="418.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="481.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="397.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 166.5 C 201 166.5, 201 40.5, 256 40.5 C 311 40.5, 311 82.5, 366 82.5 C 421 82.5, 421 124.5, 476 124.5 C 531 124.5, 531 61.5, 586 61.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="166.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="40.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="82.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="124.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="61.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 145.5 C 201 145.5, 201 187.5, 256 187.5 C 311 187.5, 311 40.5, 366 40.5 C 421 40.5, 421 292.5, 476 292.5 C 531 292.5, 531 271.5, 586 271.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="145.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="187.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="40.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="292.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="271.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 61.5 C 201 61.5, 201 82.5, 256 82.5 C 311 82.5, 311 292.5, 366 292.5 C 421 292.5, 421 103.5, 476 103.5 C 531 103.5, 531 103.5, 586 103.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="61.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="82.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="292.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="103.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="103.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 376.5 C 201 376.5, 201 481.5, 256 481.5 C 311 481.5, 311 250.5, 366 250.5 C 421 250.5, 421 166.5, 476 166.5 C 531 166.5, 531 124.5, 586 124.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="376.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="481.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="250.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="166.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="124.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 82.5 C 201 82.5, 201 124.5, 256 124.5 C 311 124.5, 311 481.5, 366 481.5 C 421 481.5, 421 208.5, 476 208.5 C 531 208.5, 531 229.5, 586 229.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="82.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="124.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="481.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="208.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="229.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 187.5 C 201 187.5, 201 250.5, 256 250.5 C 311 250.5, 311 166.5, 366 166.5 C 421 166.5, 421 250.5, 476 250.5 C 531 250.5, 531 208.5, 586 208.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="187.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="250.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="166.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="250.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="208.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 313.5 C 201 313.5, 201 229.5, 256 229.5 C 311 229.5, 311 460.5, 366 460.5 C 421 460.5, 421 460.5, 476 460.5 C 531 460.5, 531 166.5, 586 166.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="313.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="229.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="460.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="460.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="166.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 439.5 C 201 439.5, 201 460.5, 256 460.5 C 311 460.5, 311 334.5, 366 334.5 C 421 334.5, 421 40.5, 476 40.5 C 531 40.5, 531 418.5, 586 418.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="439.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="460.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="334.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="40.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="418.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 397.5 C 201 397.5, 201 397.5, 256 397.5 C 311 397.5, 311 355.5, 366 355.5 C 421 355.5, 421 229.5, 476 229.5 C 531 229.5, 531 187.5, 586 187.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="397.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="397.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="355.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="229.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="187.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 334.5 C 201 334.5, 201 313.5, 256 313.5 C 311 313.5, 311 208.5, 366 208.5 C 421 208.5, 421 397.5, 476 397.5 C 531 397.5, 531 376.5, 586 376.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="334.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="313.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="208.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="397.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="376.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 460.5 C 201 460.5, 201 418.5, 256 418.5 C 311 418.5, 311 271.5, 366 271.5 C 421 271.5, 421 418.5, 476 418.5 C 531 418.5, 531 481.5, 586 481.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="460.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="418.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="271.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="418.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="481.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 481.5 C 201 481.5, 201 355.5, 256 355.5 C 311 355.5, 311 376.5, 366 376.5 C 421 376.5, 421 82.5, 476 82.5 C 531 82.5, 531 82.5, 586 82.5" fill="none" stroke="currentColor"></path><circle cx="146" cy="481.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="256" cy="355.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="366" cy="376.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="476" cy="82.5" r="2.5" fill="none" stroke="currentColor"></circle><circle cx="586" cy="82.5" r="2.5" fill="none" stroke="currentColor"></circle></g><g><path d="M 146 250.5 C 201 250.5, 201 145.5, 256 145.5 C 311 145.5, 311 124.5, 366 124.5 C 421 124.5, 421 61.5, 476 61.5 C 531 61.5, 531 40.5, 586 40.5" fill="none" stroke="currentColor"></path><path d="M 146 250.5 C 201 250.5, 201 145.5, 256 145.5 C 311 145.5, 311 124.5, 366 124.5 C 421 124.5, 421 61.5, 476 61.5 C 531 61.5, 531 40.5, 586 40.5" style="stroke: rgb(155, 81, 224);" fill="none"></path><circle cx="146" cy="250.5" r="5" style="fill: rgb(155, 81, 224);" stroke="currentColor"></circle><circle cx="256" cy="145.5" r="5" style="fill: rgb(155, 81, 224);" stroke="currentColor"></circle><circle cx="366" cy="124.5" r="5" style="fill: rgb(155, 81, 224);" stroke="currentColor"></circle><circle cx="476" cy="61.5" r="5" style="fill: rgb(155, 81, 224);" stroke="currentColor"></circle><circle cx="586" cy="40.5" r="5" style="fill: rgb(155, 81, 224);" stroke="currentColor"></circle></g><g><path d="M 146 40.5 C 201 40.5, 201 61.5, 256 61.5 C 311 61.5, 311 229.5, 366 229.5 C 421 229.5, 421 334.5, 476 334.5 C 531 334.5, 531 355.5, 586 355.5" fill="none" stroke="currentColor"></path><path d="M 146 40.5 C 201 40.5, 201 61.5, 256 61.5 C 311 61.5, 311 229.5, 366 229.5 C 421 229.5, 421 334.5, 476 334.5 C 531 334.5, 531 355.5, 586 355.5" style="stroke: rgb(16, 163, 127);" fill="none"></path><circle cx="146" cy="40.5" r="5" style="fill: rgb(16, 163, 127);" stroke="currentColor"></circle><circle cx="256" cy="61.5" r="5" style="fill: rgb(16, 163, 127);" stroke="currentColor"></circle><circle cx="366" cy="229.5" r="5" style="fill: rgb(16, 163, 127);" stroke="currentColor"></circle><circle cx="476" cy="334.5" r="5" style="fill: rgb(16, 163, 127);" stroke="currentColor"></circle><circle cx="586" cy="355.5" r="5" style="fill: rgb(16, 163, 127);" stroke="currentColor"></circle></g><g><path d="M 146 166.5 C 201 166.5, 201 40.5, 256 40.5 C 311 40.5, 311 82.5, 366 82.5 C 421 82.5, 421 124.5, 476 124.5 C 531 124.5, 531 61.5, 586 61.5" fill="none" stroke="currentColor"></path><path d="M 146 166.5 C 201 166.5, 201 40.5, 256 40.5 C 311 40.5, 311 82.5, 366 82.5 C 421 82.5, 421 124.5, 476 124.5 C 531 124.5, 531 61.5, 586 61.5" style="stroke: rgb(224, 64, 159);" fill="none"></path><circle cx="146" cy="166.5" r="5" style="fill: rgb(224, 64, 159);" stroke="currentColor"></circle><circle cx="256" cy="40.5" r="5" style="fill: rgb(224, 64, 159);" stroke="currentColor"></circle><circle cx="366" cy="82.5" r="5" style="fill: rgb(224, 64, 159);" stroke="currentColor"></circle><circle cx="476" cy="124.5" r="5" style="fill: rgb(224, 64, 159);" stroke="currentColor"></circle><circle cx="586" cy="61.5" r="5" style="fill: rgb(224, 64, 159);" stroke="currentColor"></circle></g><g><path d="M 146 145.5 C 201 145.5, 201 187.5, 256 187.5 C 311 187.5, 311 40.5, 366 40.5 C 421 40.5, 421 292.5, 476 292.5 C 531 292.5, 531 271.5, 586 271.5" fill="none" stroke="currentColor"></path><path d="M 146 145.5 C 201 145.5, 201 187.5, 256 187.5 C 311 187.5, 311 40.5, 366 40.5 C 421 40.5, 421 292.5, 476 292.5 C 531 292.5, 531 271.5, 586 271.5" style="stroke: rgb(154, 171, 26);" fill="none"></path><circle cx="146" cy="145.5" r="5" style="fill: rgb(154, 171, 26);" stroke="currentColor"></circle><circle cx="256" cy="187.5" r="5" style="fill: rgb(154, 171, 26);" stroke="currentColor"></circle><circle cx="366" cy="40.5" r="5" style="fill: rgb(154, 171, 26);" stroke="currentColor"></circle><circle cx="476" cy="292.5" r="5" style="fill: rgb(154, 171, 26);" stroke="currentColor"></circle><circle cx="586" cy="271.5" r="5" style="fill: rgb(154, 171, 26);" stroke="currentColor"></circle></g><g><path d="M 146 439.5 C 201 439.5, 201 460.5, 256 460.5 C 311 460.5, 311 334.5, 366 334.5 C 421 334.5, 421 40.5, 476 40.5 C 531 40.5, 531 418.5, 586 418.5" fill="none" stroke="currentColor"></path><path d="M 146 439.5 C 201 439.5, 201 460.5, 256 460.5 C 311 460.5, 311 334.5, 366 334.5 C 421 334.5, 421 40.5, 476 40.5 C 531 40.5, 531 418.5, 586 418.5" style="stroke: rgb(6, 182, 212);" fill="none"></path><circle cx="146" cy="439.5" r="5" style="fill: rgb(6, 182, 212);" stroke="currentColor"></circle><circle cx="256" cy="460.5" r="5" style="fill: rgb(6, 182, 212);" stroke="currentColor"></circle><circle cx="366" cy="334.5" r="5" style="fill: rgb(6, 182, 212);" stroke="currentColor"></circle><circle cx="476" cy="40.5" r="5" style="fill: rgb(6, 182, 212);" stroke="currentColor"></circle><circle cx="586" cy="418.5" r="5" style="fill: rgb(6, 182, 212);" stroke="currentColor"></circle></g><path d="M 146 271.5 C 201 271.5, 201 292.5, 256 292.5 C 311 292.5, 311 439.5, 366 439.5 C 421 439.5, 421 313.5, 476 313.5 C 531 313.5, 531 313.5, 586 313.5" fill="none" stroke="currentColor"></path><path d="M 146 124.5 C 201 124.5, 201 166.5, 256 166.5 C 311 166.5, 311 145.5, 366 145.5 C 421 145.5, 421 355.5, 476 355.5 C 531 355.5, 531 250.5, 586 250.5" fill="none" stroke="currentColor"></path><path d="M 146 355.5 C 201 355.5, 201 271.5, 256 271.5 C 311 271.5, 311 397.5, 366 397.5 C 421 397.5, 421 376.5, 476 376.5 C 531 376.5, 531 334.5, 586 334.5" fill="none" stroke="currentColor"></path><path d="M 146 250.5 C 201 250.5, 201 145.5, 256 145.5 C 311 145.5, 311 124.5, 366 124.5 C 421 124.5, 421 61.5, 476 61.5 C 531 61.5, 531 40.5, 586 40.5" fill="none" stroke="currentColor"></path><path d="M 146 208.5 C 201 208.5, 201 376.5, 256 376.5 C 311 376.5, 311 313.5, 366 313.5 C 421 313.5, 421 187.5, 476 187.5 C 531 187.5, 531 292.5, 586 292.5" fill="none" stroke="currentColor"></path><path d="M 146 229.5 C 201 229.5, 201 208.5, 256 208.5 C 311 208.5, 311 187.5, 366 187.5 C 421 187.5, 421 439.5, 476 439.5 C 531 439.5, 531 145.5, 586 145.5" fill="none" stroke="currentColor"></path><path d="M 146 40.5 C 201 40.5, 201 61.5, 256 61.5 C 311 61.5, 311 229.5, 366 229.5 C 421 229.5, 421 334.5, 476 334.5 C 531 334.5, 531 355.5, 586 355.5" fill="none" stroke="currentColor"></path><path d="M 146 418.5 C 201 418.5, 201 439.5, 256 439.5 C 311 439.5, 311 103.5, 366 103.5 C 421 103.5, 421 271.5, 476 271.5 C 531 271.5, 531 439.5, 586 439.5" fill="none" stroke="currentColor"></path><path d="M 146 103.5 C 201 103.5, 201 103.5, 256 103.5 C 311 103.5, 311 61.5, 366 61.5 C 421 61.5, 421 145.5, 476 145.5 C 531 145.5, 531 460.5, 586 460.5" fill="none" stroke="currentColor"></path><path d="M 146 292.5 C 201 292.5, 201 334.5, 256 334.5 C 311 334.5, 311 418.5, 366 418.5 C 421 418.5, 421 481.5, 476 481.5 C 531 481.5, 531 397.5, 586 397.5" fill="none" stroke="currentColor"></path><path d="M 146 166.5 C 201 166.5, 201 40.5, 256 40.5 C 311 40.5, 311 82.5, 366 82.5 C 421 82.5, 421 124.5, 476 124.5 C 531 124.5, 531 61.5, 586 61.5" fill="none" stroke="currentColor"></path><path d="M 146 145.5 C 201 145.5, 201 187.5, 256 187.5 C 311 187.5, 311 40.5, 366 40.5 C 421 40.5, 421 292.5, 476 292.5 C 531 292.5, 531 271.5, 586 271.5" fill="none" stroke="currentColor"></path><path d="M 146 61.5 C 201 61.5, 201 82.5, 256 82.5 C 311 82.5, 311 292.5, 366 292.5 C 421 292.5, 421 103.5, 476 103.5 C 531 103.5, 531 103.5, 586 103.5" fill="none" stroke="currentColor"></path><path d="M 146 376.5 C 201 376.5, 201 481.5, 256 481.5 C 311 481.5, 311 250.5, 366 250.5 C 421 250.5, 421 166.5, 476 166.5 C 531 166.5, 531 124.5, 586 124.5" fill="none" stroke="currentColor"></path><path d="M 146 82.5 C 201 82.5, 201 124.5, 256 124.5 C 311 124.5, 311 481.5, 366 481.5 C 421 481.5, 421 208.5, 476 208.5 C 531 208.5, 531 229.5, 586 229.5" fill="none" stroke="currentColor"></path><path d="M 146 187.5 C 201 187.5, 201 250.5, 256 250.5 C 311 250.5, 311 166.5, 366 166.5 C 421 166.5, 421 250.5, 476 250.5 C 531 250.5, 531 208.5, 586 208.5" fill="none" stroke="currentColor"></path><path d="M 146 313.5 C 201 313.5, 201 229.5, 256 229.5 C 311 229.5, 311 460.5, 366 460.5 C 421 460.5, 421 460.5, 476 460.5 C 531 460.5, 531 166.5, 586 166.5" fill="none" stroke="currentColor"></path><path d="M 146 439.5 C 201 439.5, 201 460.5, 256 460.5 C 311 460.5, 311 334.5, 366 334.5 C 421 334.5, 421 40.5, 476 40.5 C 531 40.5, 531 418.5, 586 418.5" fill="none" stroke="currentColor"></path><path d="M 146 397.5 C 201 397.5, 201 397.5, 256 397.5 C 311 397.5, 311 355.5, 366 355.5 C 421 355.5, 421 229.5, 476 229.5 C 531 229.5, 531 187.5, 586 187.5" fill="none" stroke="currentColor"></path><path d="M 146 334.5 C 201 334.5, 201 313.5, 256 313.5 C 311 313.5, 311 208.5, 366 208.5 C 421 208.5, 421 397.5, 476 397.5 C 531 397.5, 531 376.5, 586 376.5" fill="none" stroke="currentColor"></path><path d="M 146 460.5 C 201 460.5, 201 418.5, 256 418.5 C 311 418.5, 311 271.5, 366 271.5 C 421 271.5, 421 418.5, 476 418.5 C 531 418.5, 531 481.5, 586 481.5" fill="none" stroke="currentColor"></path><path d="M 146 481.5 C 201 481.5, 201 355.5, 256 355.5 C 311 355.5, 311 376.5, 366 376.5 C 421 376.5, 421 82.5, 476 82.5 C 531 82.5, 531 82.5, 586 82.5" fill="none" stroke="currentColor"></path><text x="132" y="271.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Hermes Agent: cost rank 12 with GLM-5.3, cost rank 13 with GLM-5.3-Flash, cost rank 20 with DeepSeek-V4.1-Flash-1017, cost rank 14 with Muse Spark Open, cost rank 14 with Kimi-K3" fill="currentColor">Hermes Agent</text> <text x="132" y="124.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="ZCode: cost rank 5 with GLM-5.3, cost rank 7 with GLM-5.3-Flash, cost rank 6 with DeepSeek-V4.1-Flash-1017, cost rank 16 with Muse Spark Open, cost rank 11 with Kimi-K3" fill="currentColor">ZCode</text> <text x="132" y="355.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Grok Build: cost rank 16 with GLM-5.3, cost rank 12 with GLM-5.3-Flash, cost rank 18 with DeepSeek-V4.1-Flash-1017, cost rank 17 with Muse Spark Open, cost rank 15 with Kimi-K3" fill="currentColor">Grok Build</text> <text data-emphasis="true" x="132" y="250.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Oh My Pi: cost rank 11 with GLM-5.3, cost rank 6 with GLM-5.3-Flash, cost rank 5 with DeepSeek-V4.1-Flash-1017, cost rank 2 with Muse Spark Open, cost rank 1 with Kimi-K3" fill="currentColor">Oh My Pi</text> <text x="132" y="208.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="KimiCode: cost rank 9 with GLM-5.3, cost rank 17 with GLM-5.3-Flash, cost rank 14 with DeepSeek-V4.1-Flash-1017, cost rank 8 with Muse Spark Open, cost rank 13 with Kimi-K3" fill="currentColor">KimiCode</text> <text x="132" y="229.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Alma: cost rank 10 with GLM-5.3, cost rank 9 with GLM-5.3-Flash, cost rank 8 with DeepSeek-V4.1-Flash-1017, cost rank 20 with Muse Spark Open, cost rank 6 with Kimi-K3" fill="currentColor">Alma</text> <text data-emphasis="true" x="132" y="40.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Codex CLI: cost rank 1 with GLM-5.3, cost rank 2 with GLM-5.3-Flash, cost rank 10 with DeepSeek-V4.1-Flash-1017, cost rank 15 with Muse Spark Open, cost rank 16 with Kimi-K3" fill="currentColor">Codex CLI</text> <text x="132" y="418.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="mini-SWE-agent: cost rank 19 with GLM-5.3, cost rank 20 with GLM-5.3-Flash, cost rank 4 with DeepSeek-V4.1-Flash-1017, cost rank 12 with Muse Spark Open, cost rank 20 with Kimi-K3" fill="currentColor">mini-SWE-agent</text> <text x="132" y="103.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Maka: cost rank 4 with GLM-5.3, cost rank 4 with GLM-5.3-Flash, cost rank 2 with DeepSeek-V4.1-Flash-1017, cost rank 6 with Muse Spark Open, cost rank 21 with Kimi-K3" fill="currentColor">Maka</text> <text x="132" y="292.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Claude Code: cost rank 13 with GLM-5.3, cost rank 15 with GLM-5.3-Flash, cost rank 19 with DeepSeek-V4.1-Flash-1017, cost rank 22 with Muse Spark Open, cost rank 18 with Kimi-K3" fill="currentColor">Claude Code</text> <text data-emphasis="true" x="132" y="166.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Pi: cost rank 7 with GLM-5.3, cost rank 1 with GLM-5.3-Flash, cost rank 3 with DeepSeek-V4.1-Flash-1017, cost rank 5 with Muse Spark Open, cost rank 2 with Kimi-K3" fill="currentColor">Pi</text> <text data-emphasis="true" x="132" y="145.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="OpenCode v1: cost rank 6 with GLM-5.3, cost rank 8 with GLM-5.3-Flash, cost rank 1 with DeepSeek-V4.1-Flash-1017, cost rank 13 with Muse Spark Open, cost rank 12 with Kimi-K3" fill="currentColor">OpenCode v1</text> <text x="132" y="61.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="OpenCode v2: cost rank 2 with GLM-5.3, cost rank 3 with GLM-5.3-Flash, cost rank 13 with DeepSeek-V4.1-Flash-1017, cost rank 4 with Muse Spark Open, cost rank 4 with Kimi-K3" fill="currentColor">OpenCode v2</text> <text x="132" y="376.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="DeepSeek Harness: Minimal: cost rank 17 with GLM-5.3, cost rank 22 with GLM-5.3-Flash, cost rank 11 with DeepSeek-V4.1-Flash-1017, cost rank 7 with Muse Spark Open, cost rank 5 with Kimi-K3" fill="currentColor">DSH Minimal</text> <text x="132" y="82.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Cline CLI: cost rank 3 with GLM-5.3, cost rank 5 with GLM-5.3-Flash, cost rank 22 with DeepSeek-V4.1-Flash-1017, cost rank 9 with Muse Spark Open, cost rank 10 with Kimi-K3" fill="currentColor">Cline CLI</text> <text x="132" y="187.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="MiniMax Code: cost rank 8 with GLM-5.3, cost rank 11 with GLM-5.3-Flash, cost rank 7 with DeepSeek-V4.1-Flash-1017, cost rank 11 with Muse Spark Open, cost rank 9 with Kimi-K3" fill="currentColor">MiniMax Code</text> <text x="132" y="313.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="GitHub Copilot CLI: cost rank 14 with GLM-5.3, cost rank 10 with GLM-5.3-Flash, cost rank 21 with DeepSeek-V4.1-Flash-1017, cost rank 21 with Muse Spark Open, cost rank 7 with Kimi-K3" fill="currentColor">GitHub Copilot CLI</text> <text data-emphasis="true" x="132" y="439.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="DeepSeek Harness: Creator: cost rank 20 with GLM-5.3, cost rank 21 with GLM-5.3-Flash, cost rank 15 with DeepSeek-V4.1-Flash-1017, cost rank 1 with Muse Spark Open, cost rank 19 with Kimi-K3" fill="currentColor">DSH Creator</text> <text x="132" y="397.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="DeepSeek Harness: Standard: cost rank 18 with GLM-5.3, cost rank 18 with GLM-5.3-Flash, cost rank 16 with DeepSeek-V4.1-Flash-1017, cost rank 10 with Muse Spark Open, cost rank 8 with Kimi-K3" fill="currentColor">DSH Standard</text> <text x="132" y="334.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="DeepSeek Harness: Code: cost rank 15 with GLM-5.3, cost rank 14 with GLM-5.3-Flash, cost rank 9 with DeepSeek-V4.1-Flash-1017, cost rank 18 with Muse Spark Open, cost rank 17 with Kimi-K3" fill="currentColor">DSH Code</text> <text x="132" y="460.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Antigravity CLI: cost rank 21 with GLM-5.3, cost rank 19 with GLM-5.3-Flash, cost rank 12 with DeepSeek-V4.1-Flash-1017, cost rank 19 with Muse Spark Open, cost rank 22 with Kimi-K3" fill="currentColor">Antigravity CLI</text> <text x="132" y="481.5" text-anchor="end" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Exo: cost rank 22 with GLM-5.3, cost rank 16 with GLM-5.3-Flash, cost rank 17 with DeepSeek-V4.1-Flash-1017, cost rank 3 with Muse Spark Open, cost rank 3 with Kimi-K3" fill="currentColor">Exo</text> <text x="600" y="313.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Hermes Agent: cost rank 12 with GLM-5.3, cost rank 13 with GLM-5.3-Flash, cost rank 20 with DeepSeek-V4.1-Flash-1017, cost rank 14 with Muse Spark Open, cost rank 14 with Kimi-K3" fill="currentColor">Hermes Agent</text> <text x="600" y="250.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="ZCode: cost rank 5 with GLM-5.3, cost rank 7 with GLM-5.3-Flash, cost rank 6 with DeepSeek-V4.1-Flash-1017, cost rank 16 with Muse Spark Open, cost rank 11 with Kimi-K3" fill="currentColor">ZCode</text> <text x="600" y="334.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Grok Build: cost rank 16 with GLM-5.3, cost rank 12 with GLM-5.3-Flash, cost rank 18 with DeepSeek-V4.1-Flash-1017, cost rank 17 with Muse Spark Open, cost rank 15 with Kimi-K3" fill="currentColor">Grok Build</text> <text data-emphasis="true" x="600" y="40.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Oh My Pi: cost rank 11 with GLM-5.3, cost rank 6 with GLM-5.3-Flash, cost rank 5 with DeepSeek-V4.1-Flash-1017, cost rank 2 with Muse Spark Open, cost rank 1 with Kimi-K3" fill="currentColor">Oh My Pi</text> <text x="600" y="292.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="KimiCode: cost rank 9 with GLM-5.3, cost rank 17 with GLM-5.3-Flash, cost rank 14 with DeepSeek-V4.1-Flash-1017, cost rank 8 with Muse Spark Open, cost rank 13 with Kimi-K3" fill="currentColor">KimiCode</text> <text x="600" y="145.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Alma: cost rank 10 with GLM-5.3, cost rank 9 with GLM-5.3-Flash, cost rank 8 with DeepSeek-V4.1-Flash-1017, cost rank 20 with Muse Spark Open, cost rank 6 with Kimi-K3" fill="currentColor">Alma</text> <text data-emphasis="true" x="600" y="355.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Codex CLI: cost rank 1 with GLM-5.3, cost rank 2 with GLM-5.3-Flash, cost rank 10 with DeepSeek-V4.1-Flash-1017, cost rank 15 with Muse Spark Open, cost rank 16 with Kimi-K3" fill="currentColor">Codex CLI</text> <text x="600" y="439.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="mini-SWE-agent: cost rank 19 with GLM-5.3, cost rank 20 with GLM-5.3-Flash, cost rank 4 with DeepSeek-V4.1-Flash-1017, cost rank 12 with Muse Spark Open, cost rank 20 with Kimi-K3" fill="currentColor">mini-SWE-agent</text> <text x="600" y="460.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Maka: cost rank 4 with GLM-5.3, cost rank 4 with GLM-5.3-Flash, cost rank 2 with DeepSeek-V4.1-Flash-1017, cost rank 6 with Muse Spark Open, cost rank 21 with Kimi-K3" fill="currentColor">Maka</text> <text x="600" y="397.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Claude Code: cost rank 13 with GLM-5.3, cost rank 15 with GLM-5.3-Flash, cost rank 19 with DeepSeek-V4.1-Flash-1017, cost rank 22 with Muse Spark Open, cost rank 18 with Kimi-K3" fill="currentColor">Claude Code</text> <text data-emphasis="true" x="600" y="61.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Pi: cost rank 7 with GLM-5.3, cost rank 1 with GLM-5.3-Flash, cost rank 3 with DeepSeek-V4.1-Flash-1017, cost rank 5 with Muse Spark Open, cost rank 2 with Kimi-K3" fill="currentColor">Pi</text> <text data-emphasis="true" x="600" y="271.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="OpenCode v1: cost rank 6 with GLM-5.3, cost rank 8 with GLM-5.3-Flash, cost rank 1 with DeepSeek-V4.1-Flash-1017, cost rank 13 with Muse Spark Open, cost rank 12 with Kimi-K3" fill="currentColor">OpenCode v1</text> <text x="600" y="103.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="OpenCode v2: cost rank 2 with GLM-5.3, cost rank 3 with GLM-5.3-Flash, cost rank 13 with DeepSeek-V4.1-Flash-1017, cost rank 4 with Muse Spark Open, cost rank 4 with Kimi-K3" fill="currentColor">OpenCode v2</text> <text x="600" y="124.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="DeepSeek Harness: Minimal: cost rank 17 with GLM-5.3, cost rank 22 with GLM-5.3-Flash, cost rank 11 with DeepSeek-V4.1-Flash-1017, cost rank 7 with Muse Spark Open, cost rank 5 with Kimi-K3" fill="currentColor">DSH Minimal</text> <text x="600" y="229.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Cline CLI: cost rank 3 with GLM-5.3, cost rank 5 with GLM-5.3-Flash, cost rank 22 with DeepSeek-V4.1-Flash-1017, cost rank 9 with Muse Spark Open, cost rank 10 with Kimi-K3" fill="currentColor">Cline CLI</text> <text x="600" y="208.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="MiniMax Code: cost rank 8 with GLM-5.3, cost rank 11 with GLM-5.3-Flash, cost rank 7 with DeepSeek-V4.1-Flash-1017, cost rank 11 with Muse Spark Open, cost rank 9 with Kimi-K3" fill="currentColor">MiniMax Code</text> <text x="600" y="166.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="GitHub Copilot CLI: cost rank 14 with GLM-5.3, cost rank 10 with GLM-5.3-Flash, cost rank 21 with DeepSeek-V4.1-Flash-1017, cost rank 21 with Muse Spark Open, cost rank 7 with Kimi-K3" fill="currentColor">GitHub Copilot CLI</text> <text data-emphasis="true" x="600" y="418.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="DeepSeek Harness: Creator: cost rank 20 with GLM-5.3, cost rank 21 with GLM-5.3-Flash, cost rank 15 with DeepSeek-V4.1-Flash-1017, cost rank 1 with Muse Spark Open, cost rank 19 with Kimi-K3" fill="currentColor">DSH Creator</text> <text x="600" y="187.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="DeepSeek Harness: Standard: cost rank 18 with GLM-5.3, cost rank 18 with GLM-5.3-Flash, cost rank 16 with DeepSeek-V4.1-Flash-1017, cost rank 10 with Muse Spark Open, cost rank 8 with Kimi-K3" fill="currentColor">DSH Standard</text> <text x="600" y="376.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="DeepSeek Harness: Code: cost rank 15 with GLM-5.3, cost rank 14 with GLM-5.3-Flash, cost rank 9 with DeepSeek-V4.1-Flash-1017, cost rank 18 with Muse Spark Open, cost rank 17 with Kimi-K3" fill="currentColor">DSH Code</text> <text x="600" y="481.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Antigravity CLI: cost rank 21 with GLM-5.3, cost rank 19 with GLM-5.3-Flash, cost rank 12 with DeepSeek-V4.1-Flash-1017, cost rank 19 with Muse Spark Open, cost rank 22 with Kimi-K3" fill="currentColor">Antigravity CLI</text> <text x="600" y="82.5" text-anchor="start" dominant-baseline="central" tabindex="0" role="button" aria-pressed="false" aria-label="Exo: cost rank 22 with GLM-5.3, cost rank 16 with GLM-5.3-Flash, cost rank 17 with DeepSeek-V4.1-Flash-1017, cost rank 3 with Muse Spark Open, cost rank 3 with Kimi-K3" fill="currentColor">Exo</text></svg>

Point at a line or a name to follow one harness. Select it to keep it highlighted in all figures.

Codex CLI was 1st with GLM-5.3 and 16th with Kimi-K3. DeepSeek Harness: Creator moved the most, from 1st with Muse to 21st with GLM Flash. OpenCode v1 was 1st with DeepSeek and 13th with Muse.

Reruns do not explain these moves. We divided the attempts into two halves and ranked the harnesses by cost in each half. With the same model, the two rankings had a mean rank correlation of 0.71. With two different models, it was 0.26.

### A Higher Cost Does Not Give a Higher Score

**Figure 6. Lowest and highest cost per pass for each model**

This is Figure 4 for cost per pass. After each ratio is the rank correlation of the cost per task and the pass rate of the harnesses, from −0.39 to +0.22. A positive value means that the more expensive harnesses passed more often.

**Codex CLI** $0.803 · 57.7% **Exo** $2.72 · 50.0%

**3.4×** · correlation −0.35

**Pi** $0.223 · 58.1% **DeepSeek Harness: Minimal** $0.484 · 55.2%

**2.2×** · correlation −0.39

**OpenCode v1** $0.177 · 61.3% **Cline CLI** $0.860 · 63.3%

**4.9×** · correlation +0.12

**Oh My Pi** $1.21 · 58.9% **Claude Code** $3.75 · 52.8%

**3.1×** · correlation +0.01

**Oh My Pi** $1.45 · 57.7% **Antigravity CLI** $2.73 · 56.9%

**1.9×** · correlation +0.22

The two dots are the harnesses with the lowest and the highest cost. Each small tick is one of the other harnesses. Point at a tick to read it.

The harness with the highest pass rate was 5th to 20th of 22 in cost per task. With four of the five models, the most expensive harness per pass passed less often than the cheapest one.

---

## Does a Simpler Harness Cost Less?

No. We compared four factors with the cost per pass. **Prompt size, tool count and cache hit rate are not the main cost factors. Steps are.**

- **Start tokens:** the input tokens of the first agent-loop request: the system prompt, the tool definitions and the task.
- **Tools:** the tools that the first request offers.
- **Cache hit rate and steps:** the mean over the passed trials. A step is one entry of the agent trajectory.

**Figure 7. Four factors of each harness and the cost per pass**

| Factor | Range | Correlation with cost per pass | p |
| --- | --- | --- | --- |
| Start tokens | 882 to 21,365 | **+0.01** | 0.950 |
| Tools offered | 1 to 29 | **+0.02** | 0.922 |
| Cache hit rate | 87.0% to 95.7% | **−0.03** | 0.879 |
| Steps per pass | 24.8 to 73.5 | **+0.51** | 0.015 |

Rank correlation over the 22 harnesses, all models. The bar runs from −1 to +1.Cache hit rate and steps: the 15,733 passed trials, with reward-hacked trials as failures.

Over the 22 harnesses, the rank correlation of the steps per pass and the cost per pass was +0.51 (p = 0.015). For the other three factors, it was −0.03 to +0.02 (p ≥ 0.88). Within each model, tool calls tracked cost as well as steps. Table 4 below and Table 5 in the [appendix](#appendix-reference-tables) give the values.

Each step sends the context again, so a trial used 2.0 to 4.8 million input tokens on average, by harness, and the largest first request, 21,365 tokens, is less than 1% of that. mini-SWE-agent has the smallest first request, 882 tokens, but took 38 steps per pass and was 17th of 22 in cost per pass.

**Table 4. Start tokens, tools, cache hit rate, steps and cost per pass of each harness**

| Harness | Start tokens | Tools | Cache hit rate | Steps | Cost per pass |
| --- | --- | --- | --- | --- | --- |
| mini-SWE-agent | **882** | **1** | **93.7%** | **38.2** | $1.29 |
| Pi | **1,456** | **4** | **94.0%** | **28.0** | $0.976 |
| DeepSeek Harness: Minimal | **2,132** | **10** | **94.8%** | **34.9** | $1.15 |
| Cline CLI | **2,911** | **4** | **88.2%** | **33.7** | $1.19 |
| DeepSeek Harness: Standard | **5,166** | **23** | **94.5%** | **32.1** | $1.27 |
| OpenCode v2 | **5,572** | **13** | **93.7%** | **27.5** | $0.978 |
| DeepSeek Harness: Creator | **5,749** | **24** | **94.5%** | **34.1** | $1.27 |
| Maka | **6,209** | **29** | **90.2%** | **24.8** | $1.13 |
| Exo | **6,296** | **23** | **89.3%** | **46.4** | $1.36 |
| DeepSeek Harness: Code | **6,673** | **1** | **93.8%** | **28.4** | $1.32 |
| Antigravity CLI | **6,952** | **12** | **95.7%** | **46.3** | $1.63 |
| OpenCode v1 | **7,080** | **10** | **93.3%** | **26.8** | $1.12 |
| Oh My Pi | **7,408** | **11** | **91.1%** | **26.2** | $0.983 |
| Codex CLI | **8,329** | **13** | **93.0%** | **34.9** | $0.937 |
| Claude Code | **10,744** | **12** | **91.7%** | **36.3** | $1.55 |
| ZCode | **10,844** | **17** | **92.7%** | **26.5** | $1.06 |
| Grok Build | **11,316** | **25** | **92.4%** | **29.7** | $1.20 |
| Hermes Agent | **12,215** | **19** | **91.8%** | **28.8** | $1.16 |
| MiniMax Code | **12,334** | **19** | **92.3%** | **73.5** | $1.14 |
| GitHub Copilot CLI | **13,047** | **19** | **87.0%** | **30.3** | $1.38 |
| Alma | **16,996** | **17** | **91.1%** | **28.3** | $1.22 |
| KimiCode | **21,365** | **26** | **92.9%** | **32.5** | $1.09 |

Bars and color are relative to each column. Deeper blue: a lower cost per pass.Start tokens and tools: the first request on fix-git with GLM-5.3. Cache hit rate and steps: passed trials only, with reward-hacked trials as failures. Steps: entries of the agent trajectory, per passed trial.Outlined: lowest cost per pass.Select a column name to sort.

---

## Where the Cost Comes From

**Figure 8. Inference cost of each harness, by token type or by trial outcome**

Model

Cost

Split by

Input, not from cacheInput from cacheOutput

1. Codex CLI$0.93761.1%
2. Pi$0.97657.7%
3. OpenCode v2$0.97857.3%
4. Oh My Pi$0.98357.3%
5. ZCode$1.0661.9%
6. KimiCode$1.0960.2%
7. OpenCode v1$1.1257.4%
8. Maka$1.1357.7%
9. MiniMax Code$1.1456.8%
10. DeepSeek Harness: Minimal$1.1557.4%
11. Hermes Agent$1.1659.9%
12. Cline CLI$1.1957.7%
13. Grok Build$1.2060.0%
14. Alma$1.2259.7%
15. DeepSeek Harness: Standard$1.2755.0%
16. DeepSeek Harness: Creator$1.2756.1%
17. mini-SWE-agent$1.2958.6%
18. DeepSeek Harness: Code$1.3255.2%
19. Exo$1.3650.6%
20. GitHub Copilot CLI$1.3856.9%
21. Claude Code$1.5558.9%
22. Antigravity CLI$1.6355.0%

Point at a harness to read its tokens and where its cost went. Select it to keep it highlighted in all figures.

Lowest cost: Codex CLI

$937

Highest pass rate: ZCode

$1,063

Highest cost: Antigravity CLI

$1,632

With the mean of the five models, the harness changes the inference cost of 1,000 passed tasks by **$695** per month (1.7 times). This is an estimate for tasks that cost the same as these 62 tasks, at list prices.

*All costs are inference estimates at list prices. The pass rate of the harness on the model card has an outline.*

Over all trials, input from the cache was 42% of the cost, output 33% and other input 25%.

### Tokens and the Cache

The cache makes repeated input much cheaper. Cached input costs 2% (DeepSeek) to 20% (GLM Flash) of the price of other input (Figure 9).

**Figure 9. List prices of each model (USD for one million tokens)**

Tokens of

Input, not from cacheInput from cacheOutput

1. GLM-5.3$1.40$0.14$4.40$0.971
2. GLM Flash$0.15$0.03$0.50$0.149
3. DeepSeek$0.30$0.007$1.20$0.157
4. Muse$1.25$0.15$4.25$0.959
5. Kimi-K3$3.00$0.30$15.00$2.42

With these tokens, one trial costs **$0.149** with GLM Flash and **$2.42** with Kimi-K3. The costs are estimates from the list prices.

One pair shows the effect of the cache. **Cline CLI with DeepSeek (highest cost per task)** read 86% of its input from the cache, and OpenCode v1 read 97%. It also sent twice as much input. Input that did not come from the cache was 57% of its cost.

### Most of the Cost Goes to Trials That Do Not Pass

**64.5% of the list-price cost of the scored runs went to trials that did not pass**: 52.7% to failures and 11.8% to timeouts.

---

## What the Best-Value Harnesses Share

The traces of the five best-value harnesses show three common design choices. These are observations, not tests.

**One shell tool does most of the work.** By harness, it got 61% to 93% of the tool calls. Pi’s [default prompt](https://github.com/earendil-works/pi/blob/v1.4.0/packages/coding-agent/src/core/system-prompt.ts#L64-L114) has four tools and sends file searches to `bash`:

```ts
selectedTools: [...(input.selectedTools ?? ["read", "bash", "edit", "write"])],
addRule("Use bash for file operations like ls, rg, find");
```

**Each request only adds to the one before it.** The start of the context does not change, so the provider reads it from the cache: 91.1% to 94.0% of input in passed trials (Table 4). But 18 of the 22 harnesses read 91% or more, so this does not separate the five. Each step pays the full input price for only about 500 new tokens:

```
# Pi, GLM-5.3, merge-diff-arc-agi-task (trial cd2f6dfd)
request  prompt tokens  cached tokens
   8        15,954         15,616
   9        16,351         15,936
  10        16,999         16,320
```

**No subagents and almost no summaries.** Each of the five used a subagent in at most 6 trials, too few to tell if subagents help. Of the five, only Codex CLI summarized, in 8 trials (the 11 Alma trials in Table 6 only drop old images and reminders). Codex CLI summarizes at 90% of the window (Table 6):

```rust
.map(|context_window| (context_window * 9) / 10);
```

The five also share a weakness. **Failed runs end with a confident answer.** About three in four failed trials ended with a final answer, not at the time limit: from 68% with Pi to 82% with Codex CLI. Few said that the work was incomplete:

```
# Codex CLI, GLM-5.3, cancel-async-tasks (trial 37182b0e)
Agent:    - Validated with system Python, including concurrency and
            cancellation-cleanup tests.
Verifier: FAILED test_tasks_cancel_above_max_concurrent
          assert stdout.count("Cleaned up.") == 2
          AssertionError: assert 0 == 2
```

Trials that did not pass took 60% (Codex CLI) to 69% (Alma) of the cost of each harness. A check before the harness stops could save part of it, but we did not test this.

---

## Limitations and Future Work

- **Open models, one provider.** Closed models can give different results. The cache and the prices are those of Baseten, and another provider can change the cost ranks.

We plan two next steps:

- **Closed models.** We will add closed models, such as Claude Opus 5.5, GPT-6 Astra and Gemini 4 Carbon.
- **Long-horizon work.** We will study how a harness that runs continuously in the cloud improves itself during long work.

---

## Conclusion

- **When you change the model, think about changing the harness too.** Test the candidate harnesses with your model on a private dataset of your own tasks, large enough to see past the noise.
- **The model sets most of the cost, and the harness is second.** The model explains 92.8% of the variance of cost per task. With the model fixed, the most expensive harness cost 1.9 to 4.9 times as much per pass as the cheapest (1.8 to 5.0 times per task), so compare the cost when you pick a harness.
- **A higher cost does not buy a higher pass rate.** For each model, the rank correlation of cost per task and pass rate was −0.39 to +0.22.
- **Size does not predict cost.** mini-SWE-agent, the smallest harness, was 19th of 22 by cost per task over all models.
- **Most of the cost, 64.5%, went to runs that did not pass.** With the five best-value harnesses, 68% to 82% of the failed runs ended with a confident final answer, not at the time limit.
- **With a cheap model that has a wide range of pass rates, pick a harness with a high pass rate.** Pass rates varied by harness, from 54.0% to 69.0% with DeepSeek. But each pass rate has a 95% interval of about ±10 points, so a gap of a few points is a tie.
- **For harness developers: cut steps, not just prompt tokens.** Prompt size, tool count and cache hit rate did not predict cost per pass. Steps did, because every step sends the whole context again.

---

## Appendix: Reference Tables

**Table 2. Harness configurations**

- Alma0.4.212
- Antigravity CLI1.4.6
- Claude Code2.1.308
- Cline CLI3.0.73
- Codex CLI0.164.0
- DeepSeek Harness ×4 0.2.1-rc.3
- Exocommit 825318306c0e
- GitHub Copilot CLI1.0.103
- Grok Build1.0.67
- Hermes Agent0.22.5
- KimiCode2.3.1
- Maka0.2.2-dev.92.20261019
- MiniMax Code0.6.13
- mini-SWE-agent2.4.6
- Oh My Pi18.12.6
- OpenCode v11.19.4
- OpenCode v22.2.7
- Pi1.4.0
- ZCode0.17.0

*The four DeepSeek Harness profiles (Code, Creator, Minimal and Standard) have different tool sets, and OpenCode ran at two versions. Each profile and version counts as one harness, so 18 harnesses give 22 configurations.*

**Table 3. Reward-hacked trials of each harness**

| Harness and tools | GLM-5.3 | GLM Flash | DeepSeek | Muse | Kimi-K3 | Total | Share | Main type |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Oh My Pi ==`web_search`== 42 · `read` (URL) 38 · `bash` (`curl`, `urllib`, `wget`) 22 | 9 | 3 | 13 | 17 | 0 | **42** | 3.4% | Lookup |
| OpenCode v2`shell` (`ls`, `find`, `cat`, `python3`, `grep`, `git`, `pip download`) 27 · `edit` 7 · `read` 3 · `webfetch` 3 · `write` 2 | 2 | 4 | 9 | 17 | 3 | **35** | 2.8% | Mostly grader probe |
| Hermes Agent ==`web_search`== 19 · `web_extract` 15 · `execute_code` (`web_extract`, `urllib`, `curl`, ==`web_search`==) 13 · `terminal` (`curl`, `git clone`, `urllib`, `wget`) 11 · `browser_exec` 1 | 6 | 7 | 5 | 13 | 0 | **31** | 2.5% | Lookup |
| Exo ==`web_search`== 14 · `web_fetch` 10 · `shell` (`curl`, `urllib`, `git clone`) 7 | 8 | 6 | 1 | 0 | 0 | **15** | 1.2% | Lookup |
| Cline CLI`run_commands` (`curl`, `git clone`, `requests`, `urllib`) 10 | 0 | 0 | 10 | 2 | 0 | **12** | 1.0% | Mostly lookup |
| mini-SWE-agent`bash` (`curl`, `urllib`) 5 | 1 | 0 | 5 | 3 | 0 | **9** | 0.7% | Mostly lookup |
| OpenCode v1`bash` (`curl`, `git clone`, `requests`) 6 · `webfetch` 4 | 0 | 2 | 5 | 1 | 0 | **8** | 0.6% | Mostly lookup |
| Pi`bash` (`curl`, `git clone`, `urllib`) 7 | 0 | 0 | 7 | 1 | 0 | **8** | 0.6% | Mostly lookup |
| DeepSeek Harness: Standard`bash` (`curl`, `urllib`, `git clone`, `requests`, `wget`) 6 | 0 | 1 | 5 | 1 | 0 | **7** | 0.6% | Mostly lookup |
| Codex CLI`exec_command` (`curl`, `urllib`, `git clone`) 6 | 1 | 0 | 5 | 0 | 0 | **6** | 0.5% | Lookup |
| Maka`WebFetch` 5 · `Bash` (`curl`, `git clone`) 3 | 3 | 3 | 0 | 0 | 0 | **6** | 0.5% | Lookup |
| Antigravity CLI ==`search_web`== 3 | 2 | 1 | 0 | 2 | 0 | **5** | 0.4% | Mostly lookup |
| Claude Code`Bash` (`curl`, `urllib`) 4 · `WebSearch` 4 · `WebFetch` 2 | 1 | 1 | 2 | 1 | 0 | **5** | 0.4% | Mostly lookup |
| DeepSeek Harness: Minimal`bash` (`curl`, `git clone`) 4 | 1 | 0 | 3 | 1 | 0 | **5** | 0.4% | Mostly lookup |
| Grok Build`run_terminal_command` (`curl`, `urllib`) 5 | 0 | 0 | 5 | 0 | 0 | **5** | 0.4% | Lookup |
| Alma`Bash` (`curl`) 2 · `WebSearch` 2 · `WebFetch` 1 | 0 | 0 | 1 | 3 | 0 | **4** | 0.3% | Mostly lookup |
| DeepSeek Harness: Code`run_code` (`git clone`, `urllib`) 1 | 0 | 0 | 1 | 2 | 0 | **3** | 0.2% | Mostly other |
| KimiCode`Bash` (`curl`) 2 · `FetchURL` 2 | 1 | 1 | 1 | 0 | 0 | **3** | 0.2% | Lookup |
| MiniMax Code`web_fetch` 2 | 2 | 0 | 0 | 1 | 0 | **3** | 0.2% | Mostly lookup |
| GitHub Copilot CLI`bash` (`curl`) 2 | 0 | 1 | 1 | 0 | 0 | **2** | 0.2% | Lookup |
| ZCode`WebFetch` 2 | 0 | 2 | 0 | 0 | 0 | **2** | 0.2% | Lookup |
| DeepSeek Harness: Creator | 0 | 0 | 0 | 0 | 0 | **0** | 0.0% | — |
| All harnesses ==`web_search`== 75 · ==`search_web`== 3 | 37 | 32 | 79 | 65 | 3 | 216 | 0.8% | 75% lookup9% grader probe |

Color is relative to the largest cell.Share: of the 1,240 scored trials of the harness, with all five models.Lookup: an online lookup of the solution.Grader probe: a search for the verifier, its logs or files. Spec gaming: passing the check without doing the task as asked.Under each harness: the tools that made its lookups (OpenCode v2: its grader probes, spec gaming and web fetches), with the number of trials that called each one. In brackets: the commands or inner tools of those calls. URL: a read tool that opened a web address.

Point at a harness to read its flagged trials. Select it to keep it highlighted in all figures.

**Table 5. Prompt and tools of each harness**

Tool names

| Harness | Prompt tokens | System prompt | Tool definitions | Harness text in user turn | Tools |
| --- | --- | --- | --- | --- | --- |
| mini-SWE-agent | 848 | 111 | 65 | 672 | 1 |
| Pi | 1,422 | 708 | 714 | 0 | 4 |
| DeepSeek Harness: Minimal | 2,098 | 218 | 1,803 | 77 | 10 |
| Cline CLI | 2,877 | 963 | 1,870 | 44 | 4 |
| DeepSeek Harness: Standard | 5,132 | 325 | 4,730 | 77 | 23 |
| OpenCode v2 | 5,538 | 1,862 | 3,676 | 0 | 13 |
| DeepSeek Harness: Creator | 5,715 | 315 | 5,323 | 77 | 24 |
| Maka | 6,175 | 249 | 5,881 | 45 | 29 |
| Exo | 6,262 | 1,708 | 4,554 | 0 | 23 |
| DeepSeek Harness: Code | 6,639 | 6,028 | 534 | 77 | 1 |
| Antigravity CLI | 6,918 | 3,128 | 3,692 | 98 | 12 |
| OpenCode v1 | 7,046 | 2,029 | 5,016 | 1 | 10 |
| Oh My Pi | 7,374 | 2,477 | 4,858 | 39 | 11 |
| Codex CLI | 8,295 | 3,999 | 4,204 | 92 | 13 |
| Claude Code | 10,710 | 3,203 | 7,188 | 319 | 12 |
| ZCode | 10,810 | 1,930 | 7,723 | 1,157 | 17 |
| Grok Build | 11,282 | 949 | 9,750 | 583 | 25 |
| Hermes Agent | 12,181 | 4,057 | 8,124 | 0 | 19 |
| MiniMax Code | 12,300 | 2,980 | 8,564 | 756 | 19 |
| GitHub Copilot CLI | 13,013 | 4,523 | 8,463 | 27 | 19 |
| Alma | 16,962 | 7,508 | 8,423 | 1,031 | 17 |
| KimiCode | 21,331 | 2,239 | 18,937 | 155 | 26 |

Prompt tokens: the start tokens of Table 4 minus the 34-token task.System prompt, tool definitions and harness text in user turn add up to the prompt tokens.System prompt: the system message with the chat template.Tool definitions: the tools JSON in the GLM-5.3 tokenizer.Harness text in user turn: the instructions a harness puts in the user turn around the task, such as the workflow and command rules of mini-SWE-agent in the example below.Tool names: select Show to list them, as the model sees them in the first full request on fix-git with GLM-5.3.Codex CLI: with the model catalog, as in Table 4. Without it, 12 tools and no apply\_patch.Select a column name to sort.

Example: the first request of mini-SWE-agent in three parts

Exact text from trial fix-git\_\_S69cuzQ (fix-git, GLM-5.3) in the Harbor Hub job baseten-5m-20261031c-glm-5.3-full. 111 tokens + 65 tokens + 672 tokens = 848 tokens. With the 34-token task, the request has 882 tokens.

System prompt **111 tokens** 12 for this text, 99 for the chat template

```
You are a helpful assistant that can interact with a computer.
```

Tool definitions **65 tokens** the tools JSON of the request

```
[{"type": "function", "function": {"name": "bash", "description": "Execute a bash command", "parameters": {"type": "object", "properties": {"command": {"type": "string", "description": "The bash command to execute"}}, "required": ["command"]}}}]
```

Harness text in user turn **672 tokens** the user turn without the task

````
Please solve this issue: [task: 34 tokens]

You can execute bash commands and edit files to implement the necessary changes.

## Recommended Workflow

This workflow should be done step-by-step so that you can iterate on your changes and any possible problems.

1. Analyze the codebase by finding and reading relevant files
2. Create a script to reproduce the issue
3. Edit the source code to resolve the issue
4. Verify your fix works by running your script again
5. Test edge cases to ensure your fix is robust
6. Submit your changes and finish your work by issuing the following command: `echo COMPLETE_TASK_AND_SUBMIT_FINAL_OUTPUT`.
   Do not combine it with any other command. <important>After this command, you cannot continue working on this task.</important>

## Command Execution Rules

You are operating in an environment where

1. You issue at least one command
2. The system executes the command(s) in a subshell
3. You see the result(s)
4. You write your next command(s)

Each response should include:

1. **Reasoning text** where you explain your analysis and plan
2. At least one tool call with your command

**CRITICAL REQUIREMENTS:**

- Your response SHOULD include reasoning text explaining what you're doing
- Your response MUST include AT LEAST ONE bash tool call
- Directory or environment variable changes are not persistent. Every action is executed in a new subshell.
- However, you can prefix any action with `MY_ENV_VAR=MY_VALUE cd /path/to/working/dir && ...` or write/load environment variables from files
- Submit your changes and finish your work by issuing the following command: `echo COMPLETE_TASK_AND_SUBMIT_FINAL_OUTPUT`.
  Do not combine it with any other command. <important>After this command, you cannot continue working on this task.</important>

Example of a CORRECT response:
<example_response>
I need to understand the structure of the repository first. Let me check what files are in the current directory to get a better understanding of the codebase.

[Makes bash tool call with {"command": "ls -la"} as arguments]
</example_response>

<system_information>
Linux 6.12.8+ #1 SMP Mon May  4 17:00:34 UTC 2026 x86_64
</system_information>

## Useful command examples

### Create a new file:

```bash
cat <<'EOF' > newfile.py
import numpy as np
hello = "world"
print(hello)
EOF
```

### Edit files with sed:```bash
# Replace all occurrences
sed -i 's/old_string/new_string/g' filename.py

# Replace only first occurrence
sed -i 's/old_string/new_string/' filename.py

# Replace first occurrence on line 1
sed -i '1s/old_string/new_string/' filename.py

# Replace all occurrences in lines 1-10
sed -i '1,10s/old_string/new_string/g' filename.py
```

### View file content:

```bash
# View specific lines with numbers
nl -ba filename.py | sed -n '10,20p'
```

### Any other command you want to run

```bash
anything
```
````

**Table 6. Compaction in each harness**

Trials with a compaction, of 1,240

1. Cline CLI **423 34.1%**
2. GitHub Copilot CLI **400 32.3%**
3. Grok Build **230 18.5%**
4. Claude Code **202 16.3%**
5. OpenCode v2 **164 13.2%**
6. MiniMax Code **149 12.0%**
7. KimiCode **103 8.3%**
8. Alma **11 0.9%**
9. Codex CLI **8 0.6%**

None seen: Antigravity CLI, DeepSeek Harness: Code, DeepSeek Harness: Creator, DeepSeek Harness: Minimal, DeepSeek Harness: Standard, Exo, Hermes Agent, Maka, mini-SWE-agent, Oh My Pi, OpenCode v1, Pi, ZCode.

| Harness | Trigger | Kept | Source |
| --- | --- | --- | --- |
| Cline CLI | 90% of the input limit | Summary | [Code](https://github.com/cline/cline/blob/cli-v3.0.73/sdk/packages/core/src/extensions/context/compaction-shared.ts#L16-L19) |
| GitHub Copilot CLI | 80% of the window; waits for it at 95% | Summary | [Docs](https://docs.github.com/en/copilot/concepts/prompting-and-context/context-management#compaction) |
| Grok Build | 85% of the window | Summary | [Docs](https://docs.x.ai/build/settings/reference#session-cli-and-hints) |
| Claude Code | Window minus 13k tokens | Summary | [Binary](https://www.npmjs.com/package/@anthropic-ai/claude-code/v/2.1.308) |
| OpenCode v2 | 85% of the window | Summary and recent turns | [Code](https://github.com/anomalyco/opencode/blob/v2.2.7/packages/core/src/session/compaction.ts#L128-L135) |
| MiniMax Code | 70–95% of the window, by model | Summary | [Docs](https://unpkg.com/@minimax-ai/code@0.6.13/README.md) |
| KimiCode | 85% of the window | Summary and the last 4 messages | [Code](https://github.com/MoonshotAI/kimi-code/blob/684bae9ea6a437f3bae98bba1dcb797a917d500b/packages/agent-core-v2/src/agent/fullCompaction/strategy.ts#L18-L24) |
| Alma | None | All turns; old images and reminders dropped | Traces |
| Codex CLI | 90% of the window | Summary | [Code](https://github.com/openai/codex/blob/rust-v0.164.0/codex-rs/protocol/src/openai_models.rs#L529-L540) |
| Antigravity CLI | Near the window limit | Summary of the older turns | [Docs](https://antigravity.google/docs/cli/commands/context/#manage-context-growth) |
| DeepSeek Harness: Code | 80% of the window | Summary; long tool results trimmed | [Code](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.1-rc.3/packages/compaction/compaction-basic/src/config.ts#L20) |
| DeepSeek Harness: Creator | 80% of the window | Summary; long tool results trimmed | [Code](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.1-rc.3/packages/compaction/compaction-basic/src/config.ts#L20) |
| DeepSeek Harness: Minimal | 80% of the window | Summary; long tool results trimmed | [Code](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.1-rc.3/packages/compaction/compaction-basic/src/config.ts#L20) |
| DeepSeek Harness: Standard | 80% of the window | Summary; long tool results trimmed | [Code](https://github.com/deepseek-ai/deepseek-harness/blob/dsh-v0.2.1-rc.3/packages/compaction/compaction-basic/src/config.ts#L20) |
| Exo | None | All turns; tool results over 8,000 characters cut to a 4,000-character preview | [Code](https://github.com/exoharness/exo/blob/825318306c0ed220e9e90c0346cd64ec984a0b92/exoharness/typescript/harness/tools.ts#L14-L15) |
| Hermes Agent | 50% of the window | First 3 and last 20 messages; summary of the rest | [Code](https://github.com/NousResearch/hermes-agent/blob/bf0203a794a07aac3ff764972ab9087baa4e4f4e/agent/context_compressor.py#L2811-L2812) |
| Maka | An overflow error | Summary; tool results over 7.5 KB moved to files | [Code](https://github.com/apache/maka/blob/v0.2.2-dev.92.20261019/packages/runtime/src/context-budget-policy.ts#L69-L80) |
| mini-SWE-agent | None | All turns; long output cut to its first and last 5,000 characters | [Code](https://github.com/SWE-agent/mini-swe-agent/blob/v2.4.6/src/minisweagent/config/mini.yaml#L112-L128) |
| Oh My Pi | Near the window limit | Summary | [Code](https://github.com/can1357/oh-my-pi/blob/v18.12.6/packages/coding-agent/src/session/context-settings.ts#L159-L166) |
| OpenCode v1 | A context overflow | Summary | [Code](https://github.com/anomalyco/opencode/blob/v1.19.4/packages/opencode/src/session/overflow.ts#L10-L34) |
| Pi | Window minus 16k tokens | Summary and the last 20k tokens | [Code](https://github.com/earendil-works/pi/blob/v1.4.0/packages/coding-agent/src/core/settings-defaults.ts#L9-L13) |
| ZCode | Near the window limit | Summary, up to 3 tries | [Code](https://github.com/zai-org/ZCode/blob/3c5b227649371507ddc4eb46ac5133afe6db1cab/apps/zcode-cli/packages/core/src/compact/policy.ts#L9-L14) |

Trigger: when the harness compacts. Kept: what stays in the context after that.Source: the harness source code or its docs at the version we ran. Select one to open it. Binary: no public source, so the link is the package. Alma: only our private traces.Trials with a compaction: scored trials whose requests show one. 172 trials in total have no readable request log, so the counts are a lower bound.Share of the window: only where the rule gives one. A bar is a range: MiniMax Code by model; Copilot CLI starts at 80% and waits for the summary at 95%.

---

## References

- [FrontierHarness dashboard](https://frontierharness.org/)
- [Harbor](https://github.com/harbor-framework/harbor) and [Harbor Hub](https://hub.harborframework.com/), where the ten jobs are stored
- [Introducing FrontierHarness Eval](https://runta.com/blog/introducing-frontierharness-eval/), our v1.0 results
- [Baseten](https://www.baseten.co/), [Model APIs](https://www.baseten.co/products/model-apis/), the inference provider for performant open models
- [Runta Harbor guide](https://runta.com/docs/integrations/harbor/) and [Runta pricing](https://runta.com/pricing/)