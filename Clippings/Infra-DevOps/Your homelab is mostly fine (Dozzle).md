---
title: "Your homelab is mostly fine. Stop being notified like it isn't."
source: "https://cloud.dozzle.dev/"
author:
published:
created: 2026-08-13
description:
tags:
  - "clippings"
  - "containers"
  - "observability"
---
Dozzle Cloud watches your containers and only tells you when something actually broke, sending ~40% fewer notifications on average.

How it works

## Every event gets triaged before you ever see it.

1. 1
	### An issue comes in
	A container crashes. Errors spike. Something restarts at 3am.
2. 2
	### Dozzle Cloud triages it
	It calls tools on your stack: pulls recent logs, inspects the container, checks what changed.
3. 3
	### Weighs your history and context
	Then it reads past incidents and what you've told it matters to you.
4. 4
	### It decides what to do
	With all of that context, every event lands in one of three places.
	Silence
	Repeats stay quiet. The count goes up, your phone doesn't.
	Update
	Same incident, still going. The existing thread updates instead of starting a new one.
	Send
	Genuinely new on your stack. You hear once, with what broke.

## One alert. The whole story.

Cause first. Counts grouped. Sent wherever you already are.

nginx-proxy

14:23:01ERROR: connect ECONNREFUSED 10.0.2.4:3000

14:23:01ERROR: upstream timed out (110: Connection timed out)

14:23:02WARN: retry attempt 1/3 for service payment-api

14:23:03ERROR: connect ECONNREFUSED 10.0.2.4:3000

14:23:04ERROR: upstream timed out (110: Connection timed out)

14:23:05ERROR: connect ECONNREFUSED 10.0.2.4:3000

14:23:05WARN: circuit breaker opened for payment-api

SlackEmailDiscordTelegramntfyWeb push

Ask the agent

## When you want the why, just ask.

Every alert is one tap from a conversation. Walk through the failure, pull related logs, see what changed. In Telegram, Discord, or the web app.

9:41

Dozzle Cloud Assistant

Online

Message

Or bring your own AI

Preview

## MCP for Claude, Cursor, anything.

Wire Dozzle Cloud into the assistant you already use. Read-only access to events, logs, and container state. Free on every plan.

[How it works](https://cloud.dozzle.dev/features#mcp)

$ claude mcp add dozzle-cloud \\  
\--url https://mcp.dozzle.dev/mcp  
\--header "Authorization: Bearer dz\_mcp\_…"

> “I want to know when my containers crash overnight. But I don't want to get spammed about every incident over and over. One notification is enough.”

Anders, self-hosted Dozzle user

## Pay for the quiet, not the volume.

Free

$0

One homelab, watched quietly.

500 triaged events / month

Most popular

Pro

$5/mo

Every host you run, two weeks of history.

10,000 triaged events / month

Team

$15/mo

Headroom for a real production stack.

50,000 triaged events / month

[Connect your Dozzle](https://cloud.dozzle.dev/login) [Compare plans](https://cloud.dozzle.dev/pricing?from=home_compare)

Free tier, no credit card.