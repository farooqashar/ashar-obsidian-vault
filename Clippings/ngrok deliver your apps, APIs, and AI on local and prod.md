---
title: "ngrok: deliver your apps, APIs, and AI on local and prod"
source: "https://ngrok.com/"
author:
  - "[[ngrok]]"
published:
created: 2026-11-13
description: "ngrok is developer infrastructure that routes and secures traffic to your apps, APIs, and AI models, wherever they run. Start on localhost, ship to prod."
tags:
  - "clippings"
---
## Connect anything,anywhere.

ngrok is developer infrastructure that routes and secures traffic to your apps, APIs, and AI models.

Our products

## Way more than a tunnel to localhost.### The managed path to any model and inference provider.

AI Gateway

Change one URL to route between hosted or self-hosted models, with failover and observability built in.

[View original](https://ngrok.ai/)

[Learn more](https://ngrok.ai/)[

Gateway

### One gateway to services running anywhere.

An all-in-one cloud networking platform that secures, transforms, and routes traffic to all your services no matter where they run.

Learn more](https://ngrok.com/gateway)

## Developers go on and on about us.

Scott Motte

@motdotla

ngrok is so effing amazing

Ihor Leshko

Director of Engineering

ngrok opened the door for Databricks to rapidly onboard big enterprise customers with comprehensive security with much less operational complexity.

Kevin Simper

@kevinsimper

I wouldn't know how to work without ngrok.

Brian Cantrell

@briancantrell

ngrok is making my life so much better.

Kent C. Dodds

@kentcdodds

Just got introduced to #ngrok by @geddski. This thing's amazing.

Lorna Mitchell

@lornajane

I have literally no idea how I solved many of these problems before I used ngrok

Lyzi Diamond

@lyzidiamond

OMG life changer. I can't imagine how I lived without ngrok.

Wesley Gorman

Senior Director, Engineering, Zendesk

ngrok has been super user friendly, works seamlessly, and never gets in our way. Today, our engineers spend less time troubleshooting proxy issues and more time building.

Brian Ketelsen

@bketelsen

Just used ngrok for the first time to show off a new GopherCon web layout. Wow, that's awesome.

Gajus

@kuizinas

Holy smokes, ngrok is incredible. This is going to change my workflow forever.

georges

@multiplegeorges

ngrok is so useful that I actually enjoy paying for it.

Yehuda Katz

@waborwycatz

ngrok is one of those tools that you don't realize you need until you try it. Then it's indispensable.

Cassidy Williams

@cassidoo

ngrok saves me so much time during development. What a tool.

Austin Cottrell

Cloud Infrastructure Engineer

ngrok continues to wow us with great APIs and automation. Establishing secure remote connectivity with our customer's environments via REST APIs is fast and safe... and amazing!

Steve Kinney

@stevekinney

ngrok makes the hard parts of networking feel effortless.

Kareem

@kareemsinchin

ngrok is the api gateway goat honestly

Bree Hoffman

@breefield

ngrok is genius, replaying requests makes webhooks 1M times easier to handle.

Peter Vukovic

@pvukovic

Spent 3 hours looking for a good ngrok alternative. Let me save you some time: there isn't a better ngrok alternative.

## Every security checkbox, checked.

- SOC2 Type II
- HIPAA & BAA
- GDPR
- CCPA
- EU-US DPF
- RBAC
- SSO & SCIM
- Audit logs
- Data residency
- White-labeling
[Trust Center](https://trust.ngrok.com/)

## You’re using ngrok right now.

ngrok received your request on our global network, filtered it through our WAF, applied a rate limit, routed it to our services, and delivered this web page to your browser.

ngrok.com’s Traffic Policy

```yaml
⋯
  # say bye to anonymous proxies
⋯
      - "'proxy.anonymous' in conn.client_ip.categories"
⋯
      - type: deny
 
  # rate limit requests by IP, unless you're a search/AI bot crawling the docs
⋯
      - "!('com.openai.gptbot.ipv4' in conn.client_ip.categories || 'com.google.googlebot.ipv4' in conn.client_ip.categories)"
      - "!req.url.path.startsWith('/docs')"
⋯
⋯
⋯
          algorithm: sliding_window
⋯
            - conn.client_ip
          capacity: 12345
          enforce: false
          name: Limit 12345 requests per minute per ip and user agent
          rate: 60s
 
  # rate limit violators get their connection closed instead of 429 errors
⋯
      - actions.ngrok.rate_limit.limited
⋯
      - type: close-connection
 
  # this is our WAF, dawg
⋯
⋯
⋯
⋯
            - 932260
          on_error: continue
          process_body: true
 
  # log all WAF decisions in our observability platform and then deny anomalous requests
⋯
      - actions.ngrok.owasp_crs_request.decision == 'deny'
⋯
⋯
⋯
⋯
            action: waf deny
            anomaly_score: ${actions.ngrok.owasp_crs_request.anomaly_score}
            first_matched_data: ${actions.ngrok.owasp_crs_request.matched_rules[0].data}
            first_matched_id: ${actions.ngrok.owasp_crs_request.matched_rules[0].id}
            first_matched_message: ${actions.ngrok.owasp_crs_request.matched_rules[0].message}
            first_matched_severity: ${actions.ngrok.owasp_crs_request.matched_rules[0].severity}
            ngrok_error_message: ${actions.ngrok.owasp_crs_request.error.message}
            phase: request
      - type: deny
 
  # block countries to comply with legal requirements
⋯
      - conn.geo.country_code in ['ABC', 'DEF', 'XYZ']
⋯
      - type: deny
 
  # "we're hiring" easter egg for the curious developer
⋯
⋯
⋯
⋯
            x-ngrok-we-are-hiring: https://ngrok.com/careers
 
  # add a custom security.txt file without storing it in s3 or something
⋯
      - req.url.uri.contains('/.well-known/security.txt')
⋯
⋯
⋯
⋯
            Contact: mailto:security@ngrok.com
            Canonical: https://ngrok.com/.well-known/security.txt
            Policy: https://ngrok.com/security/disclosure-and-reward-program
            Hiring: https://ngrok.com/careers
            Preferred-Languages: en
            Expires: 2026-11-01T00:00:00Z
⋯
            Content-Type: text/plain; charset=utf-8
          status_code: 200
 
  # redirect legacy /downloads path to /download
⋯
⋯
⋯
          from: https://ngrok.com/downloads(/|$)(.*)
          status_code: 301
          to: https://ngrok.com/download/$2
 
  # redirect legacy blog path+slug
⋯
      - req.url.path.startsWith('/blog-post')
⋯
⋯
⋯
          from: ^(https?://[^/]+)/blog-post/(.*)$
          status_code: 301
          to: $1/blog/$2
 
  # handle /docs by forwarding traffic to our docs hosted in s3
⋯
      - req.url.path.startsWith('/docs')
⋯
⋯
⋯
          url: https://ngrok.docs-provider.com
 
  # handle /blog and asset paths by forwarding traffic to an external provider
  # sorry, we gotta be a little cheeky with these
⋯
      - '["/__blog-manifest","/blog-assets","/blog"].exists(p,req.url.path.startsWith(p))'
⋯
⋯
⋯
          url: https://blog.deployment-provider.com
 
  # handle /, /download, /pricing/, and other paths by forwarding to the same provider, different deployment
⋯
      - '["/__manifest","/assets","/download","/pricing","/schemas"].exists(p,req.url.path.startsWith(p))'
⋯
⋯
⋯
          url: https://frontend.deployment-provider.com
 
  # legacy website paths forward to cms
⋯
⋯
⋯
          from: /(.+)/$
          to: /$1
⋯
⋯
          url: https://ngrok.cms-provider.com
 
⋯
  # run waf on all responses
⋯
⋯
⋯
          on_error: continue
          process_body: true
 
  # as before, log all those WAF decisions and deny responses
⋯
      - actions.ngrok.owasp_crs_response.decision == 'deny'
⋯
⋯
⋯
⋯
            action: waf deny
            anomaly_score: ${actions.ngrok.owasp_crs_response.anomaly_score}
            first_matched_data: ${actions.ngrok.owasp_crs_response.matched_rules[0].data}
            first_matched_id: ${actions.ngrok.owasp_crs_response.matched_rules[0].id}
            first_matched_message: ${actions.ngrok.owasp_crs_response.matched_rules[0].message}
            first_matched_severity: ${actions.ngrok.owasp_crs_response.matched_rules[0].severity}
            ngrok_error_message: ${actions.ngrok.owasp_crs_response.error.message}
            phase: response
⋯
⋯
          content: 403 Forbidden
⋯
            Content-Type: text/plain; charset=utf-8
          status_code: 403
```

[Meet the people who build ngrok on ngrok](https://ngrok.com/about)