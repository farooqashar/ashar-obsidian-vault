---
title: "Introducing Slack Code: Agentic Coding for Teams"
source: "https://www.salesforce.com/introducing-slack-code/?_gl=1*1u9llh3*_gcl_au*MTU1MTU5NjA0LjE3ODMyODY3OTkuNjU2Njk5NjQ3LjE3ODc0NTI5MTYuMTc4NzQ1MjkyMS45ODE0MzU1NTcuMTc4NzQ1MjkxNi4xNzg3NDUzNDU1*_ga*MjAzMTA1NzEyOS4xNzgzMjg2Nzk5*_ga_QTJQME5M5D*czE3ODc0NTI4OTMkbzQkZzEkdDE3ODc0NTM1NjAkajE3JGwwJGgw"
author:
published:
created: 2026-08-22
description: "AI coding is now a team sport. Introducing Slack Code, where teams and AI agents write, review, and ship code together in the open in a dedicated code channel."
tags:
  - "clippings"
  - "coding-agents"
  - "agent-infra"
---
![Salesforce logo](https://wp.sfdcdigital.com/en-us/wp-content/uploads/sites/4/2026/03/sf-logo-small.svg?w=1024)

Comparing `master` → `update-cta-button-color`

1commit

3 fileschanged

+12−9

```
.cta-button {
   display: inline-block;
   font-weight: 700;
   padding: 12px 22px;
    background: #7c3aed;
    background: #611f69;
   color: #ffffff;
   border-radius: 8px;
}
 
.cta-button:hover {
    background: #8b52f0;
    background: #7c3085;
}
```

We’re in the middle of a coding boom that’s changing how people build and work. Coding agents like Claude Code, Claude Tag, Devin from Cognition, GitHub Copilot, ChatGPT, and Vercel agents have made writing and shipping code faster and more accessible than ever. Now the challenge is connecting what you’re building to the conversations your team is having, all in one interface.

Right now, work that happens between an individual and the agent outside of Slack is invisible to everyone else. Context gets lost between conversations and tools, reviews happen later, and every handoff slows things down. That's the problem: great code shouldn't be a private conversation, with no context. Slack is already where that context lives, and where your team works with AI. With Slack Code, it becomes where teams code together, too.

The most innovative companies figured this out early: the best place to build is in the open. They moved development work into Slack, because when work is visible, knowledge compounds. Teams learn faster, move faster, and ship better products. Slack Code brings that same principle, of building in the open, to everyone.

Coding agents changed how individuals build. Now Slack Code changes how teams build. Squeezing complex, multi-turn agent work into standard threads creates noise, and letting developers retreat into private browser tabs means losing the thing that makes teams effective: shared context. Slack Code gives your team a dedicated place to work with an agent on a specific coding session or project, together, right in Slack.

### Meet Slack Code.

Work happens in the open by default, so context and knowledge carry from person to person, and from person to agent. AI development becomes a multiplayer activity. Code channels are designed to scale for agents' work in ways that threads and public channels just can't, because they're built for output. What shows up isn't just messages — it's working code, prototypes, and documents, built right in Slack.

With Slack Code, when you have an idea or need to build a new feature, update a web page, or fix a bug, you tag in a coding agent, like Claude Tag or ChatGPT, and it spins up a code channel to tackle the task. Everyone in the channel can see the conversation, review code diffs, check live previews, give feedback, and approve the work before it ships. No specialized tools, no leaving Slack.

Slack Code brings AI development directly into Slack, changing how we build and work. Code channels are the first space in Slack that's built specifically for people to collaborate with agents on software development, together. They're inherently multiplayer and accessible to everyone. And, they bring developers, PMs, designers, non-technical teammates into the same shared workspace as the agent, so building software — from idea to shipped product — isn't just for engineers anymore. No other platform offers the same combination of an open ecosystem and a multiplayer coding environment for humans and agents to work together at once.

> ### AI only creates value when it's part of how a team actually works, not something people go do alone in another tab. Code channels bring that work into the open, where the rest of the team can see it, shape it, and build on it.
> 
> Rob Seaman
> 
> EVP and GM of Slack, Salesforce

Software development has evolved from solo terminal coding to single-player AI copilots, to multiplayer coding with Slack Code. Instead of jumping between tools, teams and agents plan, build, and iterate together in the open, in a dedicated workspace.

Here's an example: a product manager spots a bug report in a channel. Instead of waiting on an engineer, the PM asks a coding agent to help architect a fix. That agent spins up a code channel, reviews the conversational context, screenshots, and docs already shared, and proposes code. The PM brings in an engineer to check the diff, run the preview, and give the agent the go-ahead to open a PR and merge to production. No ticket, no meeting, no waiting — just a fix, shipped.

What changes is who gets to build. Because the work happens in a tool people already use, someone without technical skills can help shape the output, without opening a terminal. Anyone in the channel can pause, redirect, or stop the agent if it drifts off track. Once the work’s done, the channel archives itself, so the sidebar stays tidy while the history stays fully searchable as institutional context.

Slack is becoming the natural home for AI agents from our ecosystem of partners to meet people where they already work. Anthropic, Cognition, GitHub, ChatGPT, Vercel, and more are already developing in and for Slack Code, using our code channel APIs and bringing their coding agents into this shared space. The agents that developers, PMs, and designers already rely on can now tap into that same team context, right inside Slack.

Software engineering is just the start. Soon these APIs open to the broader developer community, so any custom agent, doing any kind of work, can join a code channel, whether that's a marketing team building a campaign or legal running a document review. As the partner network grows, Slack Code will become the place where every team, technical or not, builds with AI in the open.

As agents are becoming part of how teams work, Slack’s user experience is evolving too, so agents feel like real teammates everywhere, not just in code channels. Here’s what’s new:

- **Agent DMs** work like any conversation with a teammate: agents are clearly labeled, and threads get real titles so you can pick a conversation up where you left off.
- The new **Agents tab** gives every agent and agent session a home base. Browse all the agents, see your agent conversations, name them, check statuses, flag a blocked thread, or stop an agent mid-task.
- **Add to Slack** lets anyone build and ship an agent from NanoClaw, Lovable, Hyperagent, Superhuman, n8n, Vercel, ChatGPT, LangChain, Runlayer, or Skydive in just a few clicks. No migration, no complex setup. We've automated the OAuth, manifest setup, and environment config for you. Take a support assistant built on Lovable: click Add to Slack, and seconds later it's live alongside your team, with its own identity, right where the work happens.

The pattern holds everywhere: agents show up with a clear identity, follow the same channel norms as any teammate, and answer to the same admin controls IT already trusts, whether that's a code channel, a DM, or a project channel.

Agents in code channels inherit Slack's built-in security model, permissions, and admin controls from day one, without any additional IT lift. So, they work as secure extensions of your existing setup, with no new infrastructure or identities to manage.

Speed never comes at the cost of oversight. For high-stakes moves, like pushing code to production, the agent packages its work for an expert to sign-off on, right in the channel. That keeps people in control without slowing things down with separate IT approvals.

When a team works with AI out in the open, context compounds. Better context means better output, which makes AI more useful for the next person, and the next. Slack Code brings building out of isolated terminals and into dedicated code channels, while the broader agent experience makes every agent in Slack feel like a teammate, not just a tool. Together, that's the foundation for multiplayer AI.

This isn't just a new feature — it’s a new way to build software: open, collaborative, and powered by both human ingenuity and judgement and agent scale. Teams that build this way won't just move faster. They'll build things no one else can.

Get started with Slack Code today, and see what your team can do when agents work alongside you like teammates.

> ### For companies to unlock the full value from AI, it has to move beyond individual productivity gains to operational transformation. Slack Code enables AI to move beyond individual copilots to embedded, contextual AI orchestration to deliver real AI ROI at scale.
> 
> Rebecca Wettemann
> 
> CEO and Principal Analyst, Valoir Research

### Work with your favorite coding agents right in Slack. For this release, Slack Code connects seamlessly with our founding partners’ agents — Anthropic’s Claude, Cognition’s Devin, GitHub’s Copilot, ChatGPT, and Vercel’s agents — and are available on any Slack plan. Access to each partner agent is required.

- [Get started](https://slack.com/get-started) with Slack today
- Ecosystem of agents: Browse over 500 AI apps and Agents in the [Slack Marketplace](https://slack-ce.slack.com/marketplace/category/At07HZAKCSAC-ai-apps-assistants?sort=popularity)

*Pricing and packaging are subject to change. Availability may vary by region and is governed by customer agreements. Customers should base purchasing decisions on products and services currently available.*

> ### So much engineering work already starts as a conversation in Slack with Claude Tag: a bug report, a piece of feedback, a "what do you think about..." Slack Code gives teams a dedicated channel where the people, the context, and Claude work together from the start. Review the code diff and see a live HTML preview right in the channel, without anyone leaving the conversation.
> 
> Cat Wu
> 
> Head of Claude Product, Anthropic

> ### Agents earn their place on a team the same way people do, by knowing when to contribute and when to stay out of the way. With code channels Devin responds in Slack autonomously, verifies its work by running end-to-end in cloud agents, and brings the right people together without cluttering the conversation.
> 
> Jeff Wang
> 
> President, New Enterprise at Cognition