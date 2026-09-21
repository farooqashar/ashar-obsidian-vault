---
title: "Stacked pull requests are now in public preview"
source: "https://github.blog/changelog/2026-07-30-stacked-pull-requests-are-now-in-public-preview/?utm_source=hackernewsletter&utm_medium=email&utm_term=code"
author:
  - "[[Allison]]"
published: 2026-07-30
created: 2026-08-05
description: "Stacked pull requests break large changes into small, reviewable pull requests. They’re an ordered series of pull requests that each represent focused layers of your change. With stacks, you can…"
tags:
  - "clippings"
  - "devops-practice"
---
![header image depicting a GitHub merge box for stacked pull requests](https://github.blog/wp-content/uploads/2026/07/628819269-72b7da6d-d10f-44b3-9ba6-2034ca0fbe5d.jpg?w=2064)

Stacked pull requests break large changes into small, reviewable pull requests. They’re an ordered series of pull requests that each represent focused layers of your change. With stacks, you can independently review and check each pull request, then merge everything together in one click. No more opening a single large pull request that takes forever to review, or splitting work across multiple branches you have to keep manually rebasing.

> “We’ve been using GitHub stacked PRs for Next.js for the past few months. It has helped us introduce smaller individual changes while shipping larger features, making it easier to review PRs. – Tim Neutkens, Next.js lead, Vercel”

<video controls="" width="100%" src="https://github.com/user-attachments/assets/8eb6e39b-04ed-4f7a-8761-9f1abfa80e1a"><br></video>

With stacked pull requests, teams can:

- **Keep large changes moving** by reviewing short, narrowly scoped pull requests in parallel.
- **Maintain quality across every layer** by using focused pull request reviews alongside existing branch protections to protect `main`.
- **Merge one, some, or all** by landing an entire stack altogether or individual layers one at a time.

And because stacked pull requests are built into GitHub, your existing reviews, checks, and merge requirements all work out of the box.

> “The new Github Stacked PRs preview is incredible. Landing 5 stacked PRs directly to a merge queue all at once! A+++! This removes so much friction (and the gh cli tools + agent skill help a ton)” – John Resig, creator, jQuery

## Get started with the CLI extension

Install the CLI extension and create your first stack in under a minute:

```bash
gh extension install github/gh-stack
```

## Create stacks from your terminal or github.com

Work with stacks on github.com, the GitHub CLI, the GitHub mobile app, or with a coding agent such as GitHub Copilot using the gh-stack skill. Start with a branch and pull request for your first change. Then add branches and pull requests on top of it; each pull request targets the layer below it.

<video controls="" width="100%" src="https://github.com/user-attachments/assets/672d7ca5-552e-4eb6-8262-d27964470786"><br></video>

## Review each layer independently

Open any pull request in the stack to review only the diff for that specific layer. Use the stack map at the top of the pull request to see how the change you’re reviewing fits into the larger work. You and your teammates can each review different layers in parallel without blocking further work.

> “AI has made TED’s developers dramatically more productive, but that created a new bottleneck: PRs were growing large enough that reviewers were struggling. Stacked PRs help to solve that. By breaking large changes into small, dependency-ordered pieces, review happens in smaller logical chunks – not just faster PR reviews, but more accurate ones. Stacked PRs tighten our feedback loop and help get stable code to ted.com faster.” – Andy Merryman, CTO, TED

![view of the GitHub pull request page displaying details about the pull request stack](https://github.com/user-attachments/assets/0937148e-b9fd-4f5c-849a-8bc4499ea838)

## Merge everything in a single click

Merge the latest ready pull request to land it and every unmerged layer below it in one single operation. To land part of a stack, merge one or more lower layers—the pull requests above it stay open and automatically rebase and retarget. Your existing branch protections and required checks still govern what reaches `main`.

> “A big change used to mean one giant PR nobody wanted to review. Now it’s a stack of small ones reviewers can actually follow, and the whole stack merges in one shot. It stopped feeling like a tool on top of GitHub and started feeling like GitHub.” – Mayank Saini, connectivity engineer, WHOOP

<video controls="" width="100%" src="https://github.com/user-attachments/assets/e5e5aed6-ade2-43a7-8b11-6ec5e639bbbe"><br></video>

## Find out more and share your feedback

Stacked pull requests are rolling out in public preview to all repositories over the coming days. [Merge queue](https://docs.github.com/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-a-merge-queue?utm_source=changelog-merge-queue-docs&utm_medium=changelog&utm_campaign=stacked-prs-gtm-public-preview-2026) support for stacked pull requests is rolling out progressively over the coming weeks.

For more information, check out the [stacked pull requests documentation](https://gh.io/stacks?utm_source=changelog-stacked-pr-docs&utm_medium=changelog&utm_campaign=stacked-prs-gtm-public-preview-2026), and share your feedback with us in the [stacks discussion](https://gh.io/stacks-feedback?utm_source=changelog-pr-stacks-feedback&utm_medium=changelog&utm_campaign=stacked-prs-gtm-public-preview-2026).[Back to top](#start-of-content)