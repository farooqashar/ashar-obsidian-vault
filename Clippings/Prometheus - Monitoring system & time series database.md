---
title: "Prometheus - Monitoring system & time series database"
source: "https://prometheus.io/"
author:
published:
created: 2026-09-09
description: "An open-source monitoring system with a dimensional data model, flexible query language, efficient time series database and modern alerting approach."
tags:
  - "clippings"
---
[Dimensional data model](https://prometheus.io/docs/concepts/data_model/)

[

Prometheus models time series in a flexible dimensional data model. Time series are identified by a metric name and a set of key-value pairs.

](https://prometheus.io/docs/concepts/data_model/)[

Powerful queries

The PromQL query language allows you to query, correlate, and transform your time series data in powerful ways for visualizations, alerts, and more.

](https://prometheus.io/docs/prometheus/latest/querying/basics/)[

Precise alerting

Alerting rules are based on PromQL and make full use of the dimensional data model. A separate Alertmanager component handles notifications and silencing.

](https://prometheus.io/docs/alerting/latest/overview/)[

Simple operation

Prometheus servers operate independently and only rely on local storage. Developed in Go, the statically linked binaries are easy to deploy across various environments.

](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)[

Instrumentation libraries

Prometheus provides a large number of official and community-contributed metrics instrumentation libraries that cover most major languages.

](https://prometheus.io/docs/instrumenting/clientlibs/)[

Ubiquitous integrations

Prometheus comes with hundreds of official and community-contributed integrations that allow you to easily extract metrics from existing systems.

](https://prometheus.io/docs/instrumenting/exporters/)

Modern monitoring

## Monitoring for the cloud native world

Designed for the cloud native world, Prometheus integrates with Kubernetes and other cloud and container managers to continuously discover and monitor your services. It is the second project to graduate from the CNCF after Kubernetes.

> Even though Borgmon remains internal to Google, the idea of treating time-series data as a data source for generating alerts is now accessible to everyone through those open source tools like Prometheus \[...\] Site Reliability Engineering: How Google Runs Production Systems (O'Reilly Media)

## Open Source

Prometheus is 100% open source and community-driven. All components are available under the [Apache 2 License](http://www.apache.org/licenses/LICENSE-2.0) on [GitHub](https://github.com/prometheus).

[Star us on GitHub](https://github.com/prometheus/prometheus) 66,021 stars

## Open Governance

Prometheus is a [Cloud Native Computing Foundation](https://cncf.io/) graduated project.

[![CNCF logo](https://prometheus.io/_next/static/media/cncf-logo.21a62810.svg)](https://cncf.io/)