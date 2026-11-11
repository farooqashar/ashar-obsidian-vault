---
title: "More Confidence, Not More Code Review"
source: "https://codetelemetry.com/blog/more-confidence-not-more-code-review"
author:
published: 2026-11-02
created: 2026-11-11
description: "Turn AGENTS.md and skills into automated validation checks. Code Telemetry’s Grader evaluates recorded evidence before your AI-generated pull requests merge."
tags:
  - "clippings"
---
![I Am Devloper’s code review meme: 10 lines of code = 10 issues; 500 lines of code = looks fine.](https://cdn.sanity.io/images/ttn9kqd2/production/b954a4713525c2c896bc7f38ae655a78a2fa9f5f-560x450.png?w=1520&auto=format)

*Checking the code is one job. Checking how it was validated is another.*

*I Am Devloper (@iamdevloper), November 5, 2013. [Original post](https://x.com/iamdevloper/status/397664295875805184).*

Ahh, a meme from 2013, a sweet simpler time. You never know you're in the good ole' days until they've passed you by. Now with agentic coding this sort of thing is a constant, and no longer funny.

When an agent can produce another change while we're still reviewing the last one, the question is no longer just how quickly we can write code. It’s how we decide which changes deserve confidence. The risk is a growing queue of pull requests that nobody has had time to properly understand.

“Add more validation” sounds reasonable. But validation can mean several different things, and those differences matter.

## What are we actually validating?

I find it useful to organize the options by the questions they help answer.

| Category | Question it helps answer | Evidence it contributes |
| --- | --- | --- |
| [AI code review](https://docs.coderabbit.ai/) | What bugs, design issues, or missed conventions can a reviewing agent identify? | Review findings informed by the diff and repository context |
| [Static analysis and code quality](https://www.sonarsource.com/products/sonarqube/) | Does the change violate defined correctness or maintainability rules? | Rule violations and quality-gate results |
| [Security and supply-chain checks](https://snyk.io/product/) | Does the change introduce vulnerabilities, exposed secrets, or risky dependencies? | Security findings and dependency reports |
| [Tests and coverage](https://docs.codecov.com/docs/pull-request-comments) | Did the tested scenarios pass, and which changed code was exercised? | Test results, failure reports, and coverage |
| [Integration and runtime validation](https://www.signadot.com/) | How does the change behave with realistic dependencies or production-derived inputs? | Environment-based test results and runtime-informed findings |

### Some of the tools working on these questions

| Category | Companies and products | Relevant capabilities |
| --- | --- | --- |
| **AI code review** | [**CodeRabbit**](https://www.coderabbit.ai/) · [**Greptile**](https://www.greptile.com/) · [**Codex (OpenAI)**](https://developers.openai.com/codex/integrations/github) | CodeRabbit provides context-aware reviews. Greptile reviews changes using codebase context. Codex can review GitHub PRs against repository guidance. |
| **Static analysis and code quality** | [**Sonar**](https://www.sonarsource.com/products/sonarqube/) · [**DeepSource**](https://deepsource.com/) | Sonar and DeepSource analyze code for quality and security issues and support PR quality gates. |
| **Security and supply-chain checks** | [**Snyk**](https://snyk.io/platform/) · [**GitGuardian**](https://www.gitguardian.com/ggshield) | Snyk covers application and dependency security. GitGuardian detects exposed credentials, including through its ggshield CLI. |
| **Tests and coverage** | [**Codecov**](https://docs.codecov.com/docs/pull-request-comments) · [**Trunk**](https://trunk.io/flaky-tests) | Codecov reports coverage changes in pull requests. Trunk detects and helps manage flaky tests. |
| **Integration and runtime validation** | [**Signadot**](https://www.signadot.com/) · [**Lightrun**](https://lightrun.com/blog/best-pr-review-tools/) | Signadot provides isolated environments and test execution against real dependencies. Lightrun describes PR verification using production samples and offline simulation. |

These are overlapping capabilities, not rankings or a list of native Code Telemetry integrations.

## AI review has a cost, too

CodeRabbit, Greptile, and Codex review offer another AI assessment of a change. That can be useful (I use these techniques in developing Code Telemetry). But it also means **paying again to understand the implementation**, the code changes make a u-turn back to an LLM.

The reviewer needs the change and enough surrounding context to judge it. Repository indexing, incremental review, and cached inputs can reduce that work or its cost; they do not make a second assessment the same thing as reusing an existing result. I’m not claiming every review doubles the bill or reloads the entire repository. I’m pointing out that another review is another investment. ([CodeRabbit architecture](https://docs.coderabbit.ai/overview/architecture), [Greptile’s approach](https://www.greptile.com/), [prompt caching](https://developers.openai.com/api/docs/guides/prompt-caching).)

That raises a reasonable question: **what would the review AI catch that the implementation AI would not, and why?**

The answer might be a fresh perspective, a different objective, better context, or additional validation tools. Reviewing a completed change is also a different task from creating one. Those are good reasons for a second opinion.

But a finding is not necessarily a prevented defect. The useful outcome is not that another agent found *something* to say. It is that the additional pass exposed a meaningful problem or increased our confidence for a defensible reason. Practically I've found pinging `@codex` on medium sizes changes can sometimes net a 20+ round trip of successive p1s that maybe should have been scoped to other work.

I’m not arguing against AI review. I’m questioning whether another comprehensive review should be the automatic response to every change.

**Before paying again to understand the implementation, what can we learn from the validation work already performed?**

## Did the agent actually use the tools we gave it?

That is the question behind [Code Telemetry’s Grader](https://codetelemetry.com/docs/integrations/github-pr-gate#how-the-gate-works).

The grader evaluates recorded session activity against a published workspace policy. It connects three things: **expected work, recorded evidence, and a merge decision**. The [GitHub PR gate](https://codetelemetry.com/docs/integrations/github-pr-gate) can bring that evaluation into the pull request.

### Expected work: from AGENTS.md to Grader configuration

An agent’s instructions might say to run the relevant tests, check formatting, or validate a service change in a sandbox. **The Code Telemetry MCP can now help turn those instructions into Grader configuration**, rather than asking you to re-enter every check by hand.

From your repository, ask your coding agent:

Use AGENTS.md and our security-review skill to configure the Code Telemetry Grader for unit tests, lint, and security-review invocation. Ignore writing-style rules. Preserve unrelated checks and save a draft for me to review.

For example, an instruction to run `npm run test:unit` can become a check for a successful execution of the repository’s `test:unit` script; an instruction to run lint can become a separate successful-command check. A skill requirement can become a check for its observable invocation, where that evidence is captured.

The workflow is:

**AGENTS.md + selected skills + project tasks → agent-selected checks → Grader draft → human review and publication.**

`seed_grader_config` reads the local instructions and task definitions and returns source material and candidate checks. The agent uses your requested focus to choose and refine those checks, reads the existing draft with `get_grader_config`, and saves the selected changes through `update_grader_config`. Unmentioned checks are preserved.

The draft and your requested grading focus appear on the [Grader page](https://codetelemetry.com/app/validation). You review and publish there before the new policy applies to scoring. Saving a draft leaves the published policy and gate settings unchanged.

The agent handles the interpretation during setup; the Grader then evaluates recorded evidence against the published rules. A skill-invocation check establishes that invocation was observed, not that every sentence of the skill was followed. [See the worked MCP setup example](https://codetelemetry.com/docs/integrations/github-pr-gate#agents-md-to-grader-config).

### Recorded evidence

The distinction I care about is between an agent saying it validated a change and a session containing evidence of the expected operations and their results.

Take [Signadot's "validate" skill](https://www.signadot.com/blog/introducing-signadot-validate-skill/). A company could give all their developers access to sandbox environments for their applications, and configure a SKILL.md file recommending the validate process, but what if the agent chooses to ignore it? Or what if the agent pushes to the sandbox environment, but doesn't run validation against it? Merely opening the tool should not satisfy a requirement to exercise the application. That is the purpose of the grader’s [composite validation checks](https://codetelemetry.com/docs/integrations/github-pr-gate#4-add-custom-validation--prove-the-agent-showed-its-work).

![Code Telemetry Grader showing a score of 76.9/100, passed test checks, and Signadot validation marked Not proven despite sandbox readiness, with an incomplete-evidence warning.](https://cdn.sanity.io/images/ttn9kqd2/production/bc7648d04617a642fabdd7d626dddf53a6bf2b4d-2000x1270.png)

*Sandbox ready does not mean validation complete. Here, the captured evidence does not prove a targeted test or successful validation; the Grader also flags incomplete telemetry.*

### A merge decision

When GitHub reports a relevant pull request event, Code Telemetry matches the PR to recorded coding sessions, evaluates their validation evidence against the workspace policy, and posts a `codetelemetry/validation` commit status on the PR’s head commit. GitHub can require that status before merge. The status links back to the deciding session so the evidence can be inspected. ([How the gate works](https://codetelemetry.com/docs/integrations/github-pr-gate).)

The point is to make an important expectation visible at handoff, rather than leave it buried in a prompt nobody checks again.

## This is not a replacement for CI

Imagine two sessions that produce the same diff. One agent runs an integration test, discovers a bad assumption, fixes the implementation, and reruns the test. The other edits the code and opens the PR.

Both changes might eventually pass CI. But only the first session used that test result as feedback while developing the change.

I want independent checks against the submitted code. I also want the implementing agent to use validation while it still has an opportunity to investigate and correct its work. Those are complementary expectations, not competing ones.

A passing grade means the **available evidence satisfied the configured policy**. It does not certify correctness, establish that the tests were sufficient, or by itself prove that every recorded check covered the final PR revision. Missing telemetry is not proof that an operation never happened, either. The gate therefore makes [missing-score behavior explicit](https://codetelemetry.com/docs/integrations/github-pr-gate#what-happens-when-there-is-no-score).

I would start by observing a few meaningful checks, inspecting their evidence, and only then deciding which ones should block a merge. The goal is to improve the workflow, not manufacture another green checkmark.

More radically, I would also consider using the grader as the gate to a trunk branch, and then consolidating heavier (re)tests in that trunk branch. CICD is not free, and while humans have fallen over keeping up with review, Jenkins/GHActions/CircleCI goes brrrr 💸.

## I miss the suspense of reading code

I wanted to close this (now lengthy) blog post with another funny image. This is your reward for getting to the bottom!

[![An Abstruse Goose comic depicts reading code as an expedition through overgrowth, unexplained structures, and baffling machinery.](https://cdn.sanity.io/images/ttn9kqd2/production/3ed8ab82af7c76d043be6db51e6ec02045f10794-744x612.png)](https://craftofcoding.wordpress.com/2023/02/17/what-it-feels-like-to-read-other-peoples-code-sometimes/)

*Comic by Abstruse Goose, via [The Craft of Coding](https://craftofcoding.wordpress.com/2023/02/17/what-it-feels-like-to-read-other-peoples-code-sometimes/).*

I’ve always really liked that story, but I never agreed with the ending. I love reading other people’s code.

It often feels like I can read between the lines into how they felt about the problem they were trying to solve. What they found interesting. What they struggled with. Where they found an approach that made everything fit together. You can almost tell, *"ah they started with this function, and when that didn't cover everything, they added this helper"* without actually knowing their order of authorship.

There’s suspense in following the logic. *How is this going to work?* You investigate, follow a few calls, work backward from a result. Eventually something clicks, and you get to appreciate how another person approached the problem.

With AI-generated code, I feel that suspense much less often. So much of it looks suspiciously perfect.

Sometimes there’s still a moment of, *“Oh, I wouldn’t have been able to implement that so clearly in three lines. Very nice.”* But more often, it feels like reading the textbook definition of correct, which is sorta boring.

Which is good! I want clear code. I’m not asking for a more confusing implementation just to keep myself entertained. I just don’t enjoy reading code as much as I used to.

The important word, though, is *looks*. “This reads clearly” and “this has been adequately validated” are different judgments. An implementation can be easy to follow while still depending on an assumption nobody checked.

My enjoyment of reading it was never a validation strategy. But losing some of that enjoyment has made me think harder about where my confidence in a change actually comes from.

**Reading the final answer is one way to assess the work. Understanding how that answer was checked is another.**

AI codingCode reviewValidationGitHub