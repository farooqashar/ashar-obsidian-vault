---
title: "Context.dev: Web Scraping & Crawl API for AI Agents"
source: "https://www.context.dev/"
author:
published:
created: 2026-07-05
description: "Web scraping API for AI agents. Scrape any URL to clean markdown or HTML, crawl entire websites, and extract structured data with one REST API."
tags:
  - "clippings"
  - "agent-infra"
  - "saas-products"
  - "scraping-data"
---
![](https://www.context.dev/_next/image?url=%2Fhero-glass-texture.webp&w=3840&q=75&dpl=dpl_7fkgXyKcMDRDEdHABn33KhVt9GQJ)

## The web context {API} for teams building software and AI agents

One API, every piece of web context your agent needs.

## From maintaining data infrastructure to shipping product features

### Before

### After

Feeding agents knowledge frozen at the model's cutoff

Pull live web data the moment your product needs it

Building crawlers, scrapers, and pipelines internally

Access web, brand, and company data through APIs

Maintaining infrastructure that isn't part of your product

Let Context.dev handle the data infrastructure layer

Combining multiple vendors to fill data gaps

Replace multiple vendors with a single platform

Spending weeks collecting data before building features

Start building features sooner

Agentic Setup

## Set it up your way.

Do it yourself in the dashboard, or let your AI agent handle the whole thing.

### Do it yourself

1. 1\. Sign up and verify your email.
2. 2\. Copy your API key from the dashboard.
3. 3\. Install the SDK and start calling the API.

[Get API Key](https://www.context.dev/signup)

![](https://www.context.dev/_next/image?url=%2Fhero-glass-texture.webp&w=3840&q=75&dpl=dpl_7fkgXyKcMDRDEdHABn33KhVt9GQJ)

### Let your agent do it

Recommended

Paste one line into your coding agent — it signs you up, grabs your key, and integrates Context.dev for you.

agent setup

Signup for an account & get API key with context.dev/auth.md, then follow docs.context.dev/agent-quickstart to integrate into the codebase

For AI Native Products

## The {APIs} powering your next feature

Scrape any URL, crawl an entire website, and extract structured data in seconds: markdown, HTML, sitemaps, screenshots, and brand intelligence.

```
import ContextDev from 'context.dev';
import { z } from 'zod';

const contextDevClient = new ContextDev({ apiKey: process.env['CONTEXT_DEV_API_KEY'] });

// Define the exact shape Context.dev should extract from the page.
const schema = z.object({
  company_name: z.string(),
  pricing_tiers: z.array(
    z.object({
      tier_name: z.string(),
      tier_description: z.string(),
      tier_price: z.number(),
      tier_currency: z.string(),
      tier_billing_frequency: z.string(),
      tier_billing_model: z.enum(['monthly', 'yearly', 'one_time', 'usage_based']),
    })
  ),
});

// Convert the Zod schema to JSON Schema for /web/extract.
const result = await contextDevClient.web.extract({
  url: 'https://www.context.dev',
  schema: schema.toJSONSchema(),
});

// result.data now matches the schema above.
console.log(result.data.pricing_tiers);
```

Connect Your Agent To The Web

## From web scraping to brandextraction in one API.

Scrape, crawl, extract, and enrich web data with AI, all from one provider. Here's what your agent can do.

### Read the web, live

Give an agent real-time access to any page. Scrape to markdown, render JS, extract images, so the agent reasons over the current web, not a frozen snapshot.

Agent: I need to check their pricing page.

Request

GET /v1/scrape/markdown

{ url: "vercel.com/pricing" }

Response · Markdown247ms

\# Vercel Pricing

Develop. Preview. Ship. Start free and

scale to the enterprise.

\## Free $0/mo

For personal projects and experiments.

\## Pro $20/mo

For teams building production apps.

Agent: Their Pro plan is $20/mo, includes...

### Ground RAG in fresh content

Keep your retrieval index current. Crawl a sitemap, convert every page to clean markdown, and pipe it straight into embeddings, with no brittle parsers in between.

acme.com/docs/api/auth

acme.com/blog/release-v3

acme.com/pricing

acme.com/changelog

acme.com/docs/sdk

markdown + embed

Knowledge Base5 docs indexed

### Run deep research on demand

Answer "tell me about this company" with actual sources. Resolve a domain to a typed profile, then expand with custom AI queries pulled from the live site.

Input

notion.com

?

No dataEnriched ![Notion brand backdrop extracted via the Context.dev brand data API](https://www.context.dev/_next/image?url=https%3A%2F%2Fmedia.brand.dev%2Fd1d75039-9f70-4104-9ddd-d299eff8f9c5.png&w=3840&q=75) ![Notion](https://www.context.dev/_next/image?url=https%3A%2F%2Fmedia.brand.dev%2F571194da-8219-49f1-a82e-d9dde32b8d06.png&w=3840&q=75)

Notion

San Francisco, CA

IndustrySoftware (B2B)

Employees~1,000

Revenue$600M ARR

Founded2013

Valuation$11B

xlinkedinig

### Autofill onboarding forms

Cut signup friction and drop-off. Pre-fill company fields from a work email domain so users finish onboarding faster and more of them activate.

linear.app

Auto-fill

Company Name

Linear

Industry

Developer Tools

Brand Color

#5E6AD2

Description

Issue tracking for modern teams

Logo

linear-logo.svg

### Enrich any entity your agent sees

Turn the references in your prompts into structured data. One call hydrates a company reference with logos, colors, industry, socials, and firmographics.

![Y Combinator brand backdrop enriched via the Context.dev company data API](https://www.context.dev/_next/image?url=https%3A%2F%2Fmedia.brand.dev%2F720a6c50-1823-4756-9fb2-7429d0b3bfcb.png&w=3840&q=75) ![Y Combinator](https://www.context.dev/_next/image?url=https%3A%2F%2Fmedia.brand.dev%2F46e88bf5-011d-4d9d-a801-692719d886fa.jpg&w=3840&q=75)

Y Combinator

ycombinator.com

Startup accelerator investing $500K in early-stage companies.

IndustryInvestment & WealthTech

SloganFunding the future

Founded2005

LocationSan Francisco, CA

xlinkedinyoutube

### Make sense of transaction noise

Resolve "SQ \*BLUE BOTTLE 8xx" into Blue Bottle Coffee. Identify the brand, attach visuals and metadata, hand the agent something it can actually act on.

AMZN MKTP US\*2K8F7G1

Amazon

E-commerce

SQ \*BLUE BOTTLE COF

Blue Bottle

Food & Drink

GITHUB.COM 2FA8X91

GitHub

Developer Tools

Integrate in seconds

## Get web data into your product in just three steps

[Get API key](https://www.context.dev/signup)

01

### Choose the data your product needs

Pick from web content, brand, company, and website APIs, all under one key.

02

### Connect it to your workflow

Integrate in minutes with developer-friendly SDKs, clear docs, and example code.

03

### Ship the feature

Power onboarding, enrichment, AI agents, and automation with live web data.

One platform · three surfaces

## Scrape any URL. Crawl any site.Extract any data point.

Web scraping to clean markdown, structured data extraction with AI, typed brand intelligence on any company, and a one-line logo embed, all from the same REST API.

Web Extraction

### Read the live web as markdown.

Clean, LLM-ready markdown from any URL, with crawl, sitemap, AI extraction, and product pipelines on the same primitive.

```
await client.web.webScrapeMd({
  url: 'https://openai.com/pricing'
})
```

Response · markdown247ms

\# OpenAI Pricing

Simple, predictable pricing across models.

\## GPT-5 $10/1M

Most capable model for complex tasks.

\## GPT-5 mini $0.5/1M

Fast and affordable for most tasks.

\- Context window: 400k tokens

Brand Intelligence

### Any domain, typed.

Resolve a domain, email, ticker, or messy merchant descriptor into a typed company with logos, colors, fonts, and firmographics.

![Linear](https://www.context.dev/_next/image?url=%2Fhome%2Flogos%2Flinear-app.png&w=3840&q=75&dpl=dpl_7fkgXyKcMDRDEdHABn33KhVt9GQJ)

Linear

linear.app

Purpose-built issue tracking and project planning for modern software teams.

IndustryDeveloper Tools

SloganBuilt for modern teams

Founded2019

LocationSan Francisco, CA

xlinkedingithub

Logo Link

### One \<img> tag. Any logo.

No API call. No SDK. No backend. Just an image URL, with logos served from a global CDN in ~20ms.

```
<img src="https://logos.context.dev?domain=example.com"/>
```

![stripe.com](https://www.context.dev/_next/image?url=%2Fhome%2Flogos%2Fstripe-com.jpg&w=3840&q=75&dpl=dpl_7fkgXyKcMDRDEdHABn33KhVt9GQJ) ![linear.app](https://www.context.dev/_next/image?url=%2Fhome%2Flogos%2Flinear-app.png&w=3840&q=75&dpl=dpl_7fkgXyKcMDRDEdHABn33KhVt9GQJ) ![notion.so](https://www.context.dev/_next/image?url=%2Fhome%2Flogos%2Fnotion-so.png&w=3840&q=75&dpl=dpl_7fkgXyKcMDRDEdHABn33KhVt9GQJ) ![github.com](https://www.context.dev/_next/image?url=%2Fhome%2Flogos%2Fgithub-com.png&w=3840&q=75&dpl=dpl_7fkgXyKcMDRDEdHABn33KhVt9GQJ) ![figma.com](https://www.context.dev/_next/image?url=%2Fhome%2Flogos%2Ffigma-com.png&w=3840&q=75&dpl=dpl_7fkgXyKcMDRDEdHABn33KhVt9GQJ) ![shopify.com](https://www.context.dev/_next/image?url=%2Fhome%2Flogos%2Fshopify-com.png&w=3840&q=75&dpl=dpl_7fkgXyKcMDRDEdHABn33KhVt9GQJ) ![vercel.com](https://www.context.dev/_next/image?url=%2Fhome%2Flogos%2Fvercel-com.png&w=3840&q=75&dpl=dpl_7fkgXyKcMDRDEdHABn33KhVt9GQJ) ![openai.com](https://www.context.dev/home/logos/openai-com.svg?dpl=dpl_7fkgXyKcMDRDEdHABn33KhVt9GQJ) ![anthropic.com](https://www.context.dev/_next/image?url=%2Fhome%2Flogos%2Fanthropic-com.png&w=3840&q=75&dpl=dpl_7fkgXyKcMDRDEdHABn33KhVt9GQJ) ![slack.com](https://www.context.dev/_next/image?url=%2Fhome%2Flogos%2Fslack-com.jpg&w=3840&q=75&dpl=dpl_7fkgXyKcMDRDEdHABn33KhVt9GQJ) ![discord.com](https://www.context.dev/_next/image?url=%2Fhome%2Flogos%2Fdiscord-com.jpg&w=3840&q=75&dpl=dpl_7fkgXyKcMDRDEdHABn33KhVt9GQJ) ![context.dev](https://www.context.dev/_next/image?url=%2Fhome%2Flogos%2Fcontext-dev.png&w=3840&q=75&dpl=dpl_7fkgXyKcMDRDEdHABn33KhVt9GQJ) CUSTOMERS

## See how our customers do it

From scrappy startups to Fortune 500s, teams ship brand-powered features in days instead of quarters. [See all customers](https://www.context.dev/customers)

![](https://www.context.dev/customer-logos/mintlify-icon.svg?dpl=dpl_7fkgXyKcMDRDEdHABn33KhVt9GQJ)

### [Mintlify](https://www.context.dev/blog/mintlify-turns-github-repos-into-branded-docs-sites-with-brand-dev)

How Mintlify used Context.dev to power a tool that transforms any GitHub repo URL into a complete, branded documentation site — and got there in under 10 minutes of integration time.

Read their story

![](https://www.context.dev/_next/image?url=%2Fcustomer-logos%2Fdailydev-icon.png&w=128&q=75&dpl=dpl_7fkgXyKcMDRDEdHABn33KhVt9GQJ)

### [Daily.dev](https://www.context.dev/blog/daily-dev-maintains-accurate-company-data-with-brand-dev)

Ido Shamun, Co-founder of daily.dev, shares how Context.dev powers their internal enrichment system to verify companies with zero maintenance overhead.

Read their story

![](https://www.context.dev/_next/image?url=https%3A%2F%2Fmedia.brand.dev%2Feb8a0a9e-504a-4a51-aef6-c73e96fa2ebe.webp&w=128&q=75)

### [Propane](https://www.context.dev/blog/propane-ai-streamlines-onboarding-and-delivers-branded-user-interview-experiences-with-brand-dev)

How Propane AI enhanced their onboarding process and user interview experiences using Context.dev's API for automated brand asset integration.

Read their story

![](https://www.context.dev/_next/image?url=https%3A%2F%2Fmedia.brand.dev%2F8e2bd79a-b1a5-4558-8fa1-28ae39091ee2.png&w=128&q=75)

### [Architect](https://www.context.dev/blog/architect-enhances-product-onboarding-and-sales-gtm-with-brand-dev)

Luke Ramsden walks through how Architect dropped Context.dev into their onboarding flow and sales workflow in an afternoon.

Read their story

![](https://www.context.dev/_next/image?url=https%3A%2F%2Fmedia.brand.dev%2F226db5d4-7ee9-4e62-828b-0bf275b08fed.png&w=128&q=75)

### [DocsBot](https://www.context.dev/blog/docsbot-reduces-onboarding-friction-and-boosts-activation-with-brand-dev)

Aaron, founder of DocsBot, shares how Context.dev helped transform their onboarding experience by automatically pulling brand data, leading to higher activation rates.

Read their story

## The Blog

Engineering deep dives, product updates, and practical guides for building with brand data.

FAQs

## Frequently asked questions

Everything you need to know about integrating and scaling with context.dev.

Is there a free tier?

Yes. Sign up with a work email and you get 500 API credits at 30 requests/minute, plus 10K Logo Link requests, to test out both services. If you sign up with a free email provider (Gmail, Yahoo, Outlook, etc.) you get 250 API credits at 10 requests/minute — upgrade to a work email or a paid plan for more.

How do API credits work?

API credits are the unit used to meter Context.dev API usage. Simple calls like scraping a page cost 1 credit. More advanced calls like brand retrieval, styleguide generation, structured extraction, or industry identification cost 10 credits. Logo Link requests are counted separately and do not use your API credits.

Which plan should I choose?

Start with Free if you are testing the API. Choose Developer if you are building your first real workflow. Choose Pro if you are running a production app with steady usage. Choose Scale if you are handling high-volume production traffic. Choose Enterprise if you need more than 2M credits/month, custom rate limits, SSO, an SLA, procurement support, or volume discounts. You can upgrade or downgrade at any time as your usage changes.

Do you offer discounts for startups or nonprofits?

Yes! We offer a startup discount of up to 30% off for one year if you're still early-stage. Apply at [https://www.context.dev/startup-discount](https://www.context.dev/startup-discount)

Are there extra fees for JS rendering, anti-bot bypass, or premium proxies?

No. There are no hidden surcharges for stealth requests. JS rendering, anti-bot bypass, and premium proxies are all included at the standard 1 credit per page.

What are the rate limits, and how can I increase them?

Rate limits apply only to API calls, not Logo Link. Rate limits vary by plan: Free tier has 30 calls/minute when you sign up with a work email (10 calls/minute for free email providers like Gmail), Developer has 60 calls/minute, Pro has 300 calls/minute, and Scale has 700 calls/minute. Logo Link has no rate limits. Enterprise plans include custom rate limits — contact us to discuss your use case.

How fresh is the brand data? How often is it updated?

Cached brand data is refreshed quarterly by default. Any brand older than 3 months is completely re-fetched when requested via the API. You can request a manual refresh for specific domains using our brand update form at [https://www.context.dev/update](https://www.context.dev/update). Image/logo URLs are guaranteed to remain valid for up to 1 year.

What if I need additional data points?

We are constantly adding new data points to the API and have more data under the hood that we don't surface yet. If you need a specific data point, please contact us at [hello@context.dev](mailto:hello@context.dev) and we will be happy to surface it.

When should I talk to sales?

Talk to sales if you need high-volume pricing beyond 2M credits/month, custom rate limits, SSO / SAML, SCIM provisioning, an uptime SLA, annual invoicing, an MSA / DPA, or a dedicated support channel. Reach us at [hello@context.dev](mailto:hello@context.dev) or through the contact page.

What's the difference between API credits and Logo Link?

They are two separate products with separate quotas. API credits are used to call any endpoint — brand data, logos, colors, fonts, and web scraping. Logo Link is a simpler service that returns just the square logo via a direct URL for displaying in your app. Logo Link has no rate limits and much higher quotas, while API credits have rate limits (calls per minute) that vary by plan.

What pricing plans are available, and can I make one-time lookups instead of subscribing?

Context.dev offers Developer ($25/mo), Pro ($149/mo), and Scale ($499/mo), plus Enterprise for teams that need more than 2M credits a month, volume discounts, or security and procurement support. We currently do not support one-time lookups, however you can contact us to discuss options for one-time projects at [hello@context.dev](mailto:hello@context.dev).

Do you offer annual billing?

Yes. Annual billing saves two months compared with monthly billing on every paid plan.

Am I billed for failed requests?

No. You are not billed for failed requests or requests where we are blocked (rarely happens). Credits are only consumed on successful responses.

What happens when my API credits run out?

Each plan includes a monthly API credit allowance that replenishes automatically at the start of each billing cycle. Paid plans include metered overage billed in 10K-credit blocks (Developer $15, Pro $9, Scale $7 per 10K credits), so production traffic keeps running when usage spikes — you can disable overage from your dashboard. On the free tier, API calls return a 401 error once credits are depleted. Logo Link has a separate quota and is not affected when API credits run out.

Why am I getting timeout errors?

First-time domain lookups may take 10-30 seconds as we crawl and process the website. For time-sensitive applications, use the Prefetch endpoint to request brand data in advance, increase your client-side timeout to at least 30 seconds, or implement async/polling patterns for batch operations. Approximately 70% of requests hit cached brands, which return much faster.

Do you support subdomains?

Yes, subdomains are fully supported.

What SDKs are available?

We provide official SDKs for TypeScript, Python, Ruby, Go, and PHP.

How can my agent sign up?AI agents can register and obtain API credentials programmatically using our agent authentication guide (auth.md). You will still need to sign in or verify your email. Share the link with your agent:

[https://www.context.dev/auth.md](https://www.context.dev/auth.md)

## Ship an agent that actually knows things.

Free tier, 10-minute integration, and the same API powering agents at Mintlify, daily.dev, and Propane. No credit card to start.