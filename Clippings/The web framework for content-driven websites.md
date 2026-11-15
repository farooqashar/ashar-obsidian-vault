---
title: "The web framework for content-driven websites"
source: "https://astro.build/"
author:
published:
created: 2026-11-14
description: "Astro builds fast content sites, powerful web applications, dynamic server APIs, and everything in-between."
tags:
  - "clippings"
---
Astro powers the world's fastest marketing sites, blogs, e-commerce websites, and more.

[Get Started](https://docs.astro.build/)

`npm create astro@latest`

![](https://astro.build/_astro/HeroBackground.B0iWl89K_1XcMNn.webp)

Used by the largest companies around the world:

What is Astro?

## Astro is a JavaScript web framework optimized for building fast, content-driven websites.

## Server-First

Astro improves website performance by rendering components on the server, sending lightweight HTML to the browser with zero unnecessary JavaScript overhead.

## Content-Driven

Astro was designed to work with your content, no matter where it lives. Load data from your file system, external API, or your favorite CMS.

## Customizable

Extend Astro with your favorite tools. Bring your own JavaScript UI components, CSS libraries, themes, integrations, and more.

Best-In-Class Performance

## Astro Islands

Islands optimize your website like no other web framework can. Leverage Astro's unique page load performance to improve conversion rates, Core Web Vitals, and SEO.

% of real-world sites with good Core Web Vitals

Astro

71%

WordPress

48%

Gatsby

45%

Next.js

35%

Nuxt

28%

[View the full dataset](https://httparchive.org/reports/techreport/tech?client=mobile&tech=Astro,WordPress,Gatsby,Next.js,Nuxt.js&geo=ALL&rank=ALL&page=1) · Based on real-world performance data from [HTTP Archive](https://httparchive.org/) and the [Chrome UX Report](https://developer.chrome.com/docs/crux).

Maximum Flexibility

## Zero Lock-in

Astro supports every major UI framework. Bring your existing components and take advantage of Astro's optimized client build performance.

[Integrate your favorite framework](https://docs.astro.build/en/guides/integrations-guide/#official-integrations)

```astro
---
import BuyButton from '../components/BuyButton.jsx';
import { getProductDetails } from "ecommerce-package";
import ProductPageLayout from '../layouts/ProductPageLayout.astro';

const product = await getProductDetails(Astro.params.slug);
---

<ProductPageLayout>
  <img src={product.imageUrl} alt={product.imageAlt} />
  <h2>{product.name}</h2>
  <BuyButton id={product.id} client:load />
</ProductPageLayout>
```

Everything you need

## Fully Featured

Astro comes with everything you need to build a modern website. Need more? Extend Astro with integrations.

### Zero JavaScript, By Default

Astro only ships the JavaScript you need and automatically strips away the rest for a faster website.

### View Transitions

Seamlessly morph, fade, and swipe across pages with built-in, browser-native View Transition APIs.

### Optimized Images

Eliminate layout shift and serve optimized, modern image formats with Astro’s built-in components and utilities.

### UI Integrations

Bring your favorite UI frameworks and component libraries with Astro's flexible island architecture.

### File-Based Routing

Astro’s flexible routing system lets you understand your site’s structure at a glance.

### Middleware

Wrap incoming requests with custom logic like authentication, logging, or data fetching.

### Actions

Write type-safe backend functions that you can call directly from your frontend JavaScript client code.

### Deployment Adapters

One-line configuration for Netlify, Vercel, AWS, or your favorite hosting platform.

### Simple Templating

If you know HTML, you already know enough to write your first Astro component. Build powerful server components everyone on your team understands.

### Instant Page Loads

Optimize page loading with intelligent automatic prefetching. Pick from the built-in presets or tailor a strategy perfect for your site.

### AI-Ready

Integrate Astro’s official MCP server and context files with your favorite AI tools for a best-in-class development experience.

### Environment Variables

Avoid common configuration mistakes with a built-in API to manage your environment variables.

### Dev Toolbar

Extend your development environment with apps and integrations for the built-in development toolbar.

Ecosystem

## Themes

Get started faster with a pre-built website theme for Astro. Customize it to make it your own.

Astro Partner Agencies

## Get professional Astro support

Find the right team for your project with an Astro Partner Agency. From landing pages to e-commerce, get the expert assistance you need.

![](https://astro.build/_astro/final-cta.CEvkpIrn.webp)

## Start building with Astro today

[Get Started](https://docs.astro.build/)

`npm create astro@latest`