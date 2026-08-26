---
title: "The August 17 outage, and the work ahead"
source: "https://github.blog/news-insights/company-news/the-august-17-outage-and-the-work-ahead/"
author:
  - "[[Vlad Fedorov]]"
published: 2026-08-20
created: 2026-08-26
description: "An update on the August 17 outage and the steps we're taking to improve reliability."
tags:
  - "clippings"
---
On August 17, GitHub experienced an outage that lasted 7 hours and 47 minutes. It disrupted github.com, authentication, GitHub Actions, APIs, pull requests, issues, and Copilot, affecting developers and organizations around the world. If you were trying to ship software that day, we let you down.

This was our second significant incident in August, following [an actions failure on August 6](https://www.githubstatus.com/incidents/qcvjkzcs7j74). In [March](https://github.blog/news-insights/company-news/addressing-githubs-recent-availability-issues-2/) and [April](https://github.blog/news-insights/company-news/an-update-on-github-availability/), I shared the work underway to improve GitHub’s reliability. We have made progress, but these incidents make clear that we must accelerate this work.

## What happened

Our investigation found that the outage began when traffic reached a new peak, and a critical infrastructure component in our Central US data center failed to scale with it. The resulting capacity pressure spread through our systems, causing authentication failures and disrupting multiple GitHub services.

Recovery required several coordinated actions. Teams rerouted traffic, isolated affected infrastructure, and restored services in stages. Most GitHub services recovered earlier that day, but some Copilot services took longer. Errors in those services triggered a client-side retry loop that increased traffic during recovery. We had to mitigate that behavior before we could safely restore traffic. The full [root cause analysis](https://www.githubstatus.com/incidents/zkxwbgr0cnmx) includes a detailed technical timeline.

Neither outage was caused by a code or configuration change. Both incidents were capacity failures at their core. We failed to scale critical components before demand exceeded their capacity. Since April, monthly commits have grown from 1.4 billion to 2.9 billion. That growth explains the pressure on our systems, but it does not excuse these outages.

![Three side-by-side dark-themed line charts show strong growth from 2023 to 2026: merged pull requests per month rising to about 130M, commits per month rising to about 2.9B, and new repositories per month rising to about 24M, with acceleration in 2025–2026.](https://github.blog/wp-content/uploads/2026/08/blog-post-aug-17-outage-1.png?w=1920)

Three side-by-side dark-themed line charts show strong growth from 2023 to 2026: merged pull requests per month rising to about 130M, commits per month rising to about 2.9B, and new repositories per month rising to about 24M, with acceleration in 2025–2026.

## What we have done and what comes next

As part of the reliability commitments we made earlier this year, we have focused on three priorities: adding capacity, improving efficiency, and removing architectural bottlenecks. We have since added more than 3 million CPU cores, 120 petabytes of high-speed storage, and significant network capacity. We installed as much hardware as available power allowed in our existing data centers while accelerating our migration to Azure.

Today, Azure serves roughly 58% of GitHub’s platform load and half of all Git operations, up from 12% of platform load in May. This expanded footprint has also supported the growth in GitHub Actions job runs shown below.

![Large dark-themed line chart titled ‘Growth in completed GitHub Actions runs’ shows a rising trend from early 2026 to August, with regular weekly dips and increasing peaks. Values grow from roughly 15–30M early in the year to over 100M, ending near 115.4M.](https://github.blog/wp-content/uploads/2026/08/3-GH-Actions-runs.png?w=3840)

Large dark-themed line chart titled ‘Growth in completed GitHub Actions runs’ shows a rising trend from early 2026 to August, with regular weekly dips and increasing peaks. Values grow from roughly 15–30M early in the year to over 100M, ending near 115.4M.

Azure’s infrastructure and capacity have also accelerated our work to scale the largest monorepos. Our next milestone is an architecture that scales read capacity linearly with the number of readers, enabling unlimited read operations. We will roll it out gradually, beginning with the largest monorepos.

![Two dark-themed ‘Fetch Throughput History’ charts compare fetch operations per second over short time windows. Left chart fluctuates and plateaus around ~1,000 OPS/S before dropping near the end; right chart climbs steadily in steps to about ~1,800 OPS/S.](https://github.blog/wp-content/uploads/2026/08/blog-post-aug-17-outage-Gitfetch.png?w=1920)

Two dark-themed ‘Fetch Throughput History’ charts compare fetch operations per second over short time windows. Left chart fluctuates and plateaus around ~1,000 OPS/S before dropping near the end; right chart climbs steadily in steps to about ~1,800 OPS/S.

Scale is not our only challenge. As the pace and complexity of change increased, our existing operational practices did not keep up. We have redirected teams and resources toward availability and invested in stronger testing, safer rollouts, better observability, and more effective alerting. We have made progress, but this work is not complete.

In addition, we are also isolating critical systems and removing shared dependencies between them. This work is designed to reduce the likelihood of an outage and limit its impact when one occurs.

We learn from every outage and add new work to our availability workstream. The August 6 and August 17 incidents led to two immediate changes. First, we are applying consistent retry limits, retry budgets, and variable timeouts across service-to-service interactions to prevent retry storms and cascading load. Second, we are reviewing lower-priority CPU and memory alerts to identify components that could fail during sudden traffic spikes.

Our commitment to high availability isn’t just a technical promise. The developer community depends on GitHub to build, ship, and operate their work. That is only possible if you can rely on us, and on August 17, you couldn’t. It is our responsibility to fix that. We’ll earn your trust through the scaling and reliability of the platform.