---
title: "Production-Grade Container Orchestration"
source: "https://kubernetes.io/"
author:
published:
created: 2026-06-04
description: "Kubernetes, also known as K8s, is an open source system for automating deployment, scaling, and management of containerized applications.It groups containers that make up an application into logical units for easy management and discovery. Kubernetes builds upon 15 years of experience of running production workloads at Google, combined with best-of-breed ideas and practices from the community.Planet scaleDesigned on the same principles that allow Google to run billions of containers a week, Kubernetes can scale without increasing your operations team."
tags:
  - "clippings"
---
![](https://kubernetes.io/_common-resources/images/flower.svg)

[Kubernetes](https://kubernetes.io/docs/concepts/overview/), also known as K8s, is an open source system for automating deployment, scaling, and management of containerized applications.

It groups containers that make up an application into logical units for easy management and discovery. Kubernetes builds upon [15 years of experience of running production workloads at Google](https://queue.acm.org/detail.cfm?id=2898444), combined with best-of-breed ideas and practices from the community.

![](https://kubernetes.io/_common-resources/images/scalable.svg)

#### Planet scale

Designed on the same principles that allow Google to run billions of containers a week, Kubernetes can scale without increasing your operations team.

![](https://kubernetes.io/_common-resources/images/blocks.svg)

#### Never outgrow

Whether testing locally or running a global enterprise, Kubernetes flexibility grows with you to deliver your applications consistently and easily no matter how complex your need is.

![](https://kubernetes.io/_common-resources/images/suitcase.svg)

#### Run K8s anywhere

Kubernetes is open source giving you the freedom to take advantage of on-premises, hybrid, or public cloud infrastructure, letting you effortlessly move workloads to where it matters to you.

To download Kubernetes, visit the [download](https://kubernetes.io/releases/download/) section.

## Attend upcoming KubeCon + CloudNativeCon events

[**India** (Mumbai, Jun 18–19)](https://events.linuxfoundation.org/kubecon-cloudnativecon-india/)

[**Japan** (Yokohama, Jul 29–30)](https://events.linuxfoundation.org/kubecon-cloudnativecon-japan/)

## Kubernetes Features

### Automated rollouts and rollbacks

Kubernetes progressively rolls out changes to your application or its configuration, while monitoring application health to ensure it doesn't kill all your instances at the same time. If something goes wrong, Kubernetes will rollback the change for you. Take advantage of a growing ecosystem of deployment solutions.

### Service discovery and load balancing

No need to modify your application to use an unfamiliar service discovery mechanism. Kubernetes gives Pods their own IP addresses and a single DNS name for a set of Pods, and can load-balance across them.

### Storage orchestration

Automatically mount the storage system of your choice, whether from local storage, a public cloud provider, or a network storage system such as iSCSI or NFS.

### Secret and configuration management

Deploy and update Secrets and application configuration without rebuilding your image and without exposing Secrets in your stack configuration.

### Automatic bin packing

Automatically places containers based on their resource requirements and other constraints, while not sacrificing availability. Mix critical and best-effort workloads in order to drive up utilization and save even more resources.

### Batch execution

In addition to services, Kubernetes can manage your batch and CI workloads, replacing containers that fail, if desired.

### Self-healing

Kubernetes restarts containers that crash, replaces entire Pods where needed, reattaches storage in response to wider failures, and can integrate with node autoscalers to self-heal even at the node level.

### Horizontal scaling

Scale your application up and down with a simple command, with a UI, or automatically based on CPU usage.

### Vertical scaling

Automatically adjust resource requests and limits based on actual usage patterns.

### IPv4/IPv6 dual-stack

Allocation of IPv4 and IPv6 addresses to Pods and Services

### Designed for extensibility

Add features to your Kubernetes cluster without changing upstream source code.