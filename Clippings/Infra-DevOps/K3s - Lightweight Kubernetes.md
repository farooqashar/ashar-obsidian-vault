---
title: "Lightweight Kubernetes"
source: "https://k3s.io/"
author:
published:
created: 2026-11-24
description:
tags:
  - "clippings"
  - "kubernetes"
  - "containers"
---
#### The certified Kubernetes distribution built for IoT & Edge computing

#### This won't take long…

```sh
curl -sfL https://get.k3s.io | sh - 
# Check for Ready node, takes ~30 seconds 
sudo k3s kubectl get node
```

For detailed installation, [refer to the docs](https://docs.k3s.io/)

#### Great For

##### Edge

##### IoT

##### CI

##### ARM

## Why Use K3s

##### Perfect for Edge

K3s is a highly available, certified Kubernetes distribution designed for production workloads in unattended, resource-constrained, remote locations or inside IoT appliances.

##### Simplified & Secure

K3s is packaged as a single <70MB binary that reduces the dependencies and steps needed to install, run and auto-update a production Kubernetes cluster.

##### Optimized for ARM

Both ARM64 and ARMv7 are supported with binaries and multiarch images available for both. K3s works great on something as small as a Raspberry Pi to an AWS a1.4xlarge 32GiB server.

---

## How it Works

![{{ .Site.Title }}](https://k3s.io/img/how-it-works-k3s-revised.svg)

The above figure shows the difference between K3s server and K3s agent nodes. For more information, see the [architecture documentation.](https://docs.k3s.io/architecture)

## Get Started

##### 1\. Download K3s - latest release: x86\_64, ARMv7, and ARM64 are supported2. Run server

```sh
sudo k3s server &
# Kubeconfig is written to /etc/rancher/k3s/k3s.yaml
sudo k3s kubectl get node

# On a different node run the below command. 
# NODE_TOKEN comes from /var/lib/rancher/k3s/server/node-token on your server
sudo k3s agent --server https://myserver:6443 --token ${NODE_TOKEN}
```