---
title: "Google Workspace Updates: Simplifying agent access while keeping organizations in control: MCP servers, CLI, standardized usage tiers, and admin policies"
source: "https://workspaceupdates.googleblog.com/2026/11/mcp-servers-cli-standardized-usage-tiers-now-available.html?utm_source=tokensandai.beehiiv.com&utm_medium=newsletter&utm_campaign=claude-cracks-a-47-year-old-math-problem&_bhlid=07806d441eee47a01cdcf03b4878c18ea7c0ea1f"
author:
published:
created: 2026-11-25
description:
tags:
  - "clippings"
---
[arrow\_back Back](https://workspaceupdates.googleblog.com/)

## Simplifying agent access while keeping organizations in control: MCP servers, CLI, standardized usage tiers, and admin policies

As AI agents transform how people work, we want to make it simple for developers to build agentic workflows while keeping organizations in control of their data in Google Workspace. We are making [Workspace Model Context Protocol (MCP) servers](https://developers.google.com/workspace/guides/configure-mcp-servers) and the official [Workspace CLI](https://developers.google.com/workspace/guides/workspace-cli) generally available alongside [standardized usage tiers](https://developers.google.com/workspace/tools-safety) to simplify how developers build and scale agents, paired with a new [Workspace AI Tools Addendum](https://workspace.google.com/terms/ai-tools) and expanded enterprise controls over AI agents.

### Simplifying and securing agent access with governed Workspace MCP servers and the Workspace CLI

Developers now have two Google-managed ways to connect AI agents to Workspace without custom integration code:

- **Workspace MCP servers:** Built on the open MCP standard, these Google-hosted servers let cloud and web-based AI agents securely connect to Workspace and call pre-built tools out of the box across Gmail, Google Drive, Docs, Sheets, Slides, Calendar, Chat, and Tasks (with Keep coming soon). [Explore supported MCP capabilities](https://developers.google.com/workspace/guides/configure-mcp-servers#support-products).
- **Workspace CLI:** A command-line interface that brings Workspace tools directly to local environments, including developer terminals, VMs, and containerized sandboxes, for terminal-based agents. It includes packaged agent skills, dynamic command discovery, and scoped sign-in to read and update Workspace data. [Explore the Workspace CLI](https://developers.google.com/workspace/guides/workspace-cli).

Unlike traditional REST APIs, which are designed for deterministic app calls, both tools are purpose-built for dynamic agent workflows and provide:

- **Continuous improvements:** Since Google fully manages these tools, agents that discover tools and schemas at runtime automatically benefit from ongoing improvements to context retrieval, credential setup, and tool accuracy.
- **Token efficiency:** Rather than downloading raw data line by line via REST APIs, MCP tools return synthesized summaries within Workspace's boundary, and the CLI runs in the terminal, where agents can chain multiple tools. Both lower token costs and latency.
- **Streamlined security and compliance:** Secure-by-default infrastructure with built-in user confirmations, audit logging, and admin controls helps streamline OAuth verification, Cloud Application Security Assessments, and enterprise security reviews without custom compliance work.

### Standardizing the API usage tiers

In May, we announced a [standardized usage model](https://developers.google.com/workspace/tools-safety) for Workspace APIs and MCP servers to give large-scale and AI tool developers a simpler, more predictable way to access higher quota while keeping Workspace infrastructure reliable for our entire community of developers.

Starting **today**, the Workspace APIs, including MCP servers and CLI, will have two usage tiers, starting with Gmail, Drive, and Calendar. Additional data access mechanisms will be updated similarly in the coming months.

- **Standard tier:** No cost, with published usage quotas (rate limits).
- **Scaled tier:** Designed for projects that need higher usage quota (rate limits).
	- Starting **April 1, 2027**, if you select the Scaled tier, you will be charged only for API or MCP usage above any daily free allowances. If no action is taken, your projects may be throttled to the published usage quotas.
- **MCP requirement:** AI agents or similar access tools must use MCP to access Workspace data, rather than calling Workspace REST APIs directly. Technical enforcement begins on **February 1, 2027**. Follow [these steps](https://developers.google.com/workspace/guides/configure-mcp-servers) to use MCP, and select the Scaled tier if you need higher quotas for agentic use.

**Over 99% of active developers** currently operate within the Standard tier and will continue to access these APIs at no additional cost. The same privacy, DLP, and data-protection standards apply across every tier.

If you are a Google Cloud Support customer, Workspace APIs will be excluded from the support variable fee calculation until at least **December 2027**. Any changes will be communicated with **at least 90 days' notice**. To understand your options, see the [Google Cloud Support packages](https://cloud.google.com/support).

### Keeping organizations and users in control

Making it easier for developers to connect agents to Workspace goes hand in hand with giving organizations clear oversight and control of their data. We are extending the same governance principles customers rely on across Workspace to AI agents, so admins and users can get practical control over agents that access their data:

- **Data-retention limits:** Our new [Workspace AI Tools Addendum](https://workspace.google.com/terms/ai-tools) prohibits using AI agents and other access tools for certain activities that could raise security risks, including storing certain data derived from use of Workspace APIs for extended periods of time, or using AI agents to scrape Workspace APIs.
- **Centralized access management:** Requiring external AI agents to identify themselves in OAuth and connect through Workspace MCP servers allows admins to manage agent access in the admin console just like traditional apps.
- **Human-in-the-loop confirmations:** Routine actions like creating a draft stay seamless, while admins can set rules that prompt users to confirm sensitive actions in third-party AI tools, such as reading external files or sharing data.
- **Automatic DLP and audit logging:** Existing user-level Data Loss Prevention (DLP) rules apply automatically when someone uses an AI agent, and admin audit logs record agent actions and user confirmations for clear visibility.

Over the coming months, we will roll out more granular agent policies and controls to give admins and users even finer oversight of their data.

### Getting started

- **Admins**
	- **MCP servers, CLI, and API controls:** Manage access for external AI tools, Workspace MCP servers, the Workspace CLI, and APIs; set human-in-the-loop (HITL) confirmation rules; and view agent audit logs in the Admin console under Security > API Controls. Visit the Help Center to [learn more about managing access](https://support.google.com/a/answer/7281227).
	- **Internal-use projects:** If a project is used only within your Workspace organization, administrators can mark the project as internal so higher limits remain included with your Workspace subscription. [Learn more about internal-use projects](https://developers.google.com/workspace/guides/quota-dashboard#turn-on-internal).
- **Developers**
	- **Workspace MCP servers and CLI:** Visit our configuration guides to start building with the [Workspace MCP servers](https://developers.google.com/workspace/guides/configure-mcp-servers) and [Workspace CLI](https://developers.google.com/workspace/guides/workspace-cli).
	- **If you are building AI agents:** Plan to switch from REST APIs to Workspace MCP servers for agentic access before **February 1, 2027**, when technical enforcement begins. Review our [OAuth client documentation](https://support.google.com/cloud/answer/15549257#agentic-client) to select **Use this client for an AI-powered agent** (is\_agentic) on OAuth 2.0 clients used by AI agents in the Google Cloud console (traditional non-agent features should use a separate OAuth client). Review the new [Workspace AI Tools Addendum](https://workspace.google.com/terms/ai-tools).
	- **Check your API usage:** Use the new Workspace API usage developer dashboard to view each project’s usage against the Standard rate limits along with estimated costs. If every project is under the limits, you do not need to take any action.
	- **If a project exceeds the Standard tier limits,** complete one of the following steps:
		- **Projects used only within your Workspace organization:** Ask your Workspace administrator to mark the project as internal.
		- **All other projects:** Ask your Cloud Billing Admin to link a billing account and switch the project to the Scaled tier.
	- Projects that already have higher usage limits need to take the same steps as above to maintain them.
		- If no action is taken before **April 1, 2027**, your project limits will automatically change to Standard tier rate limits, at no additional cost.
		- For AI agents, the MCP requirement above applies first, from **February 1, 2027**.

### Rollout pace

- **Rapid Release and Scheduled Release domains:** Rolling out to all in 2 weeks for the Workspace MCP servers (GA); the Google Workspace CLI (GA); Admin console agent access, human-in-the-loop (HITL), and audit log controls; the Workspace API usage developer dashboard; and Scaled tier selection.
- **MCP requirement for AI agents:** Technical enforcement begins on **February 1, 2027**.
- **Usage limits and billing:** Starting **April 1, 2027**, Scaled tier billing begins for the Gmail, Google Calendar, and Google Drive APIs and the Workspace MCP servers. Projects that still have higher usage limits and have not switched to the Scaled tier or been marked as internal move to Standard tier limits. Google Cloud Billing Admins and Project Owners with affected projects will receive an email with project-specific details and next steps.

### Availability

- Available to all Google Workspace customers and developers.

### Resources

- Google Workspace Admin Help: [Control which third-party & internal apps access Google Workspace data](https://support.google.com/a/answer/7281227)
- Google Workspace Updates Blog: [Agent tools and security updates for Google Workspace developers](https://workspaceupdates.googleblog.com/2026/05/agent-tools-and-security-updates-for-workspace-developers.html)
- Workspace Blog: [10 more announcements from Google Workspace at Cloud Next ’26](https://workspace.google.com/blog/product-announcements/10-more-announcements-workspace-at-next-2026)
- Google Workspace Developer Guide for MCP: [Configure the Google Workspace MCP servers](https://developers.google.com/workspace/guides/configure-mcp-servers)
- Google Workspace Developer Guide for CLI: [Use the Google Workspace command-line tool](https://developers.google.com/workspace/guides/workspace-cli)
- Google Workspace Developer Documentation: [Google Workspace standardized model for agent tools and APIs](https://developers.google.com/workspace/tools-safety)
- [Google Workspace Developer Site](https://developers.google.com/workspace)