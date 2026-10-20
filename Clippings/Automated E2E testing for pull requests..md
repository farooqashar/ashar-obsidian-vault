---
title: "Automated E2E testing for pull requests."
source: "https://trycase.dev/"
author:
published:
created: 2026-10-19
description: "Your AI QA agent tests each pull request end to end and reports bugs, verdicts, and supporting evidence on GitHub."
tags:
  - "clippings"
---
## Automated E2E testing.For every pull request.

Your AI QA agent runs your app, tests the journeys each pull request touches, and reports verdicts with video on GitHub.

## Your code changes.See what happens.

Watch a pull request go in and a real walkthrough of the app come back. No browser test suite to write or maintain.

One PR. The whole picture.

Your coding agents work in parallel. Your testing should too.

1. **Open a pull request.** With your repository connected, a PR ready for review gets TryCase started.
2. **Find what needs testing.** TryCase reads the changes and picks the user journeys to check.
3. **Try it like a user.** The bot opens your app, clicks through each journey, and records what happens.
4. **Review the proof.** A verdict, captioned video, and screenshot arrive on the pull request.

Evidence in hand. You decide what ships.

## Use the AI you already pay for.

Bring the ChatGPT subscription or OpenRouter key you already pay for and every pull request costs less, because TryCase no longer has to run the model for you. Claude subscription support is coming soon.

### Codex

Subscription

Use the ChatGPT subscription you already have.

### OpenRouter

API key

Connect your API key and choose a supported model.

### Claude

Coming soon

Claude subscription support is coming soon.

## Common questions.

The short version of how TryCase runs, what it needs from you, and what it costs.

[Pricing and billing details](https://trycase.dev/faq) [Docs](https://trycase.dev/docs) [Pricing](https://trycase.dev/pricing)

- What can TryCase test?
	Anything that runs on Linux. For a web app or anything else with a user interface, TryCase opens the real thing in a browser and works through it the way a person would, so you get a recording instead of a log. APIs, CLIs, workers and packages are exercised through their real commands. Monorepos are fine: setup finds the apps in the repository once, then every run replays that.
- How does the GitHub integration work?
	Install the TryCase GitHub App on the repositories you pick, public or private. After that each pull request gets its own check and a comment carrying the result. You choose the trigger: every push, or only when someone asks for it with a /trycase run comment.
- Do I have to write tests first?
	No. TryCase reads the pull request, works out which user journeys the change affects, and tries them. There is no browser test suite to write or maintain, and you can steer a run by replying on the pull request.
- Can I use the AI I already pay for?
	Yes. Connect your ChatGPT subscription through Codex, or your own OpenRouter key, and every pull request costs less: a medium pull request is $2.50 with your own AI against $6 with TryCase Auto. Claude subscription support is coming soon.
- What if I do not want to connect my own AI?
	Use TryCase Auto. TryCase picks and runs the model for you, so there is nothing to connect; the per-pull-request price simply includes the AI.
- What comes back on the pull request?
	A pass or fail verdict, a captioned video of the run, and a final screenshot. When something fails the comment says what was expected and what actually happened, so you can judge it without rerunning anything yourself.
- Where does my code run, and what about secrets?
	Every pull request gets its own disposable environment with 4 vCPU and 8 GB, deleted when the run ends. Give it non-production values only. Secrets are stored encrypted, are never printed into logs, chat or the pull request, and reach only the commands that declare they need them.
- Will this slow my pull requests down?
	No. Runs happen in their own environments alongside your CI, several at a time, and you can keep pushing while one is in flight. A new commit updates the run in progress rather than queueing behind it.
- What does it cost to start?
	Nothing. Every account gets 3 free Small or Medium pull requests a month and free repository setup, with no card. After that you pay per pull request from a prepaid balance, from $1 for a small change. There is no subscription.