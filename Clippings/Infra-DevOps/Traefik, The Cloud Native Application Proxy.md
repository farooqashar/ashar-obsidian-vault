---
title: "Traefik, The Cloud Native Application Proxy"
source: "https://traefik.io/traefik"
author:
published:
created: 2026-11-24
description: "Traefik is the leading open-source reverse proxy and load balancer for HTTP and TCP-based applications that is easy, dynamic and full-featured."
tags:
  - "clippings"
  - "networking"
  - "containers"
---
[Traefik Proxy v3.7 Is Now Available! **Learn More**](https://traefik.io/blog/traefik-proxy-3-7-is-available?ref=traefik.io)

## The Cloud Native Application Proxy

Simplify and automate the discovery, routing, and load balancing of microservices.

[GET STARTED](https://doc.traefik.io/traefik/getting-started/install-traefik/)

![3.5 billion plus downloads](https://traefik.io/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fdownloads%403x.0zxjm31pplq8o.png&w=828&q=75) ![65K+ Stars on Github](https://traefik.io/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fgit-hub%403x.1gn_yw47nuc_s.png&w=828&q=75) ![1000 plus Contributors](https://traefik.io/_next/image?url=%2F_next%2Fstatic%2Fmedia%2Fcontributors%403x.0015tpo8e0r-k.png&w=828&q=75) ![Top 15 on Docker hub](https://traefik.io/_next/image?url=%2Fimages%2Ftraefik%2Fintro%2Felements-badges-top-docker%403x.png&w=384&q=75) ![Capterra](https://traefik.io/_next/image?url=%2Fimages%2Ftraefik%2Fintro%2Fcapterra%403x.png&w=384&q=75) ![G2](https://traefik.io/_next/image?url=%2Fimages%2Ftraefik%2Fintro%2Fg-2%403x.png&w=384&q=75) ![traefik dashboard](https://traefik.io/_next/image?url=%2Fimages%2Ftraefik%2Fintro%2Fwhat_is_traefik.png&w=1920&q=90)

## What is Traefik?

Traefik is a leading modern open source reverse proxy and ingress controller that makes deploying services and APIs easy. Traefik integrates with your existing infrastructure components and configures itself automatically and dynamically.

### Simplified Operation, Complex Deployments

Traefik is designed to be as simple as possible to operate, but capable of handling large, highly-complex deployments across a wide range of environments and protocols in public, private, and hybrid clouds.

### Enhanced with Powerful Middleware Suite

Traefik also comes with a powerful set of middlewares that enhance its capabilities to include load balancing, API gateway, orchestrator ingress, and more.

![](https://traefik.io/_next/image?url=%2Fimages%2Ftraefik%2Fdemo-cta.png&w=1080&q=75)

## Upgrade from Traefik Proxy in Seconds

Watch this short demo video to see why our cloud native, GitOps-driven API Gateway is Developers' #1 choice.

[Watch Demo Video](https://info.traefik.io/watch-traefik-api-gw-demo)

## Traefik Architecture Overview

Unlike a traditional reverse proxy, which requires manual configuration, Traefik uses service discovery to dynamically configure routing. Traefik supports all major protocols, leveraging a rich set of middleware for load balancing, rate-limiting, circuit-breakers, mirroring, authentication, and more. Traefik also supports SSL termination and works with ACME providers (like Let’s Encrypt) for automatic certificate generation. Traefik’s extensive features and capabilities make it the comprehensive gateway to all your applications.

![traefik proxy diagram](https://traefik.io/_next/image?url=%2Fimages%2Ftraefik%2Fintro%2Fdiagram%403x.png&w=2048&q=75)

## Maximize Uptime, Solve Issues Quickly, and Achieve Peace of Mind 24/7/365

Need support with Traefik? Our team of experts is here to help!

[REQUEST COMMERCIAL SUPPORT](https://info.traefik.io/request-commercial-support)

## Traefik Use Cases

- ![Ingress Controller](https://traefik.io/_next/image?url=%2Fimages%2Ftraefik%2Fintro%2Ficon-ingress-controller.png&w=256&q=75)

	### Ingress Controller

	Deploy Traefik as your Kubernetes Ingress Controller (via Gateway API, Kubernetes Ingress, or a custom implementation) to simplify networking, secure your APIs, and reduce costs with a dynamic, production-ready ingress controller.

	[Learn more](https://traefik.io/solutions/gateway-api)
- ![Knative Serving](https://traefik.io/_next/image?url=%2Fimages%2Ftraefik%2Fintro%2Ficon-knative-serving.png&w=256&q=75)

	### Knative Serving

	Easily run serverless workloads, traditional APIs, and event-driven functions through a unified gateway—on any Kubernetes distribution—that automatically scale up and back to zero based on the event of the day.

	[Learn more](https://traefik.io/solutions/knative)
- ![Web Application Firewall](https://traefik.io/_next/image?url=%2Fimages%2Ftraefik%2Fintro%2Fweb-application-firewall.png&w=256&q=75)

	### Web Application Firewall

	Leverage Traefik as your WAF to protect your microservices and APIs against a myriad of online threats, such as SQL injection and cross-site scripting, thus enhancing security and ensuring data integrity.

	[Learn more](https://plugins.traefik.io/plugins/65f2aea146079255c9ffd1ec/coraza-waf)
- ![Certificate Management](https://traefik.io/_next/image?url=%2Fimages%2Ftraefik%2Fintro%2Fcertificate-management.png&w=256&q=75)

	### Certificate Management

	Traefik provides built-in support for Let’s Encrypt (ACME) automatic certificate management as well as user-defined certificates.

	[Learn more](https://docs.traefik.io/https/overview/)
- ![Load Balancing](https://traefik.io/_next/image?url=%2Fimages%2Ftraefik%2Fintro%2Fload-balancing.png&w=256&q=75)

	### Load Balancing

	Control load to upstream services with flexible Layer 4 and Layer 7 routing and load balancing capabilities plus a large middleware toolkit that enables dynamic scaling, zero-downtime blue-green and canary deployments, mirroring, and more.

	[Learn more](https://doc.traefik.io/traefik/routing/providers/kubernetes-crd/)

## Traefik Features

Traefik offers a full, production-hardened feature set to meet the requirements of modern, cloud native applications in any environment and can integrate with legacy systems across multi-cloud, hybrid-cloud, and on-premises deployments.

### Traffic Management

- Flexible Layer 4 and Layer 7 routing
- HTTP, HTTP/2, HTTP/3, TCP, UDP, Websockets, gRPC
- Mirroring
- Blue-green and canary deployments
- Stickiness
- Active health checks
- Middleware (circuit breakers, automatic retries, buffering, response compression, headers, rate limiting)
[Learn more](https://doc.traefik.io/traefik/routing/providers/kubernetes-crd/)

### Security

- Automatic HTTPS
- Let’s Encrypt support
- Custom certificates
- Authentication
- Web Application Firewall
[Learn more](https://docs.traefik.io/https/overview/)

### Integration & Extensibility

- Kubernetes Ingress, Kubernetes Gateway API, Ingress-NGINX annotations
- Docker, Swarm, Red Hat OpenShift, Rancher, Amazon ECS, Consul, key-value stores
- WebAssembly (WASM) plugins support
[Learn more](https://doc.traefik.io/traefik/v3.0/providers/overview/)

### Observability

- OpenTelemetry
- Built-in dashboard
- Distributed tracing (Jaeger, Open Tracing, Zipkin)
- Real-time traffic metrics (Datadog, Grafana, InfluxDB, Prometheus, StatsD)
[Learn more](https://doc.traefik.io/traefik/observability/overview/)

## Upgrade Your Traefik Deployment

Add security, centralize the control of your microservices and APIs, and ensure your business-critical applications are always highly available.

[UPGRADE](https://traefik.io/pricing)

![Traefik ecosystem](https://traefik.io/_next/image?url=%2Fimages%2Ftraefik%2Fintro%2Fecosystem-graphic%403x.png&w=1920&q=75)

## Traefik Ecosystem

Traefik integrates with every major cluster technology and includes built-in support for the top distributed tracing and metrics providers.

Providers & Orchestrators

- Kubernetes
- Docker Swarm
- etcd
- Consul
- K3S
- HashiCorp Nomad
- Redis
- Azure Service Fabric
- Amazon ECS
- AKS
- GKE
- EKS
- IBM Cloud Kubernetes Service
- OpenShift

Tracing & Metrics

- OpenTelemetry
- Datadog
- Prometheus
- InfluxDB

TLS Certificates

![background ripple](https://traefik.io/_next/image?url=%2Fimages%2Ftraefik%2Fintro%2Fbg-graphic%403x.png&w=3840&q=75) ![](https://traefik.io/_next/image?url=%2Fimages%2Ftraefik%2Fintro%2Fbg-shape-right-testimonials%403x.png&w=2048&q=80) ![](https://traefik.io/_next/image?url=%2Fimages%2Ftraefik%2Fintro%2Fbg-shape-left-testimonials%403x.png&w=3840&q=80) ![Proxy gopher](https://traefik.io/_next/image?url=%2Fimages%2Ftraefik%2Fintro%2Fproxy-gopher-right%403x.png&w=640&q=80)

## What Our Users Are Saying

Join the growing number of users who trust Traefik.

"Running with minimal maintenance and config for years"

5 stars

"Fast and powerful reverse proxy with everything you need for your containerized infrastructure"

5 stars

"First thing you install on a fresh Kubernetes cluster"

5 stars

"The most flexible reverse proxy"

4.5 stars

"The middleware feature makes all the difference"

5 stars

![](https://traefik.io/_next/image?url=%2Fimages%2Ftraefik%2Fintro%2Fbg-bottom-glow%403x.png&w=3840&q=95)