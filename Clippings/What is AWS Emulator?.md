---
title: "What is AWS Emulator?"
source: "https://docs.aws.amazon.com/emulator/latest/userguide/what-is-service.html"
author:
published:
created: 2026-11-13
description: "AWS Emulator is a local emulator of the AWS APIs that you can use to test your software on your own machine, without deploying on AWS."
tags:
  - "clippings"
---
What is AWS Emulator? - AWS Emulator

AWS Emulator is a local emulator of the AWS APIs. You use it to test your software without calling AWS, on your own machine, on a development server, or in continuous integration (CI). You don’t need an AWS account. Your requests go to the emulator, not to AWS. So you work with emulated resources instead of AWS resources. AWS Emulator has no additional service fee. You pay only for AWS resources when you deploy on AWS.

The emulator is a local program that serves an AWS API endpoint. It has no graphical interface. After you start the emulator, you set environment variables to point the AWS CLI or an AWS SDK at its endpoint. Then you run your code as usual. In embedded mode, you pass the emulator’s HTTP client to your SDK instead.

The emulator doesn’t send your requests, responses, or resource data to AWS. By default, it sends anonymous usage and error data, which you can turn off. For more information, see [Telemetry in AWS Emulator](https://docs.aws.amazon.com/emulator/latest/userguide/telemetry.html).

On Linux, you install AWS Emulator from an RPM or Debian package for x86\_64 or aarch64, and run it as a command-line tool. On macOS and Windows, you run it in Docker, from an image that you build with our Dockerfile. For tests written in Rust with the AWS SDK for Rust, you can also run the emulator inside your test process. For more information, see [Getting started with AWS Emulator](https://docs.aws.amazon.com/emulator/latest/userguide/getting-started.html).

## Use cases

AWS Emulator helps you to test your application code locally before deploying to AWS. You can use it for the following:

- **Local testing** – Test how your code works with AWS services, including calls that go across services, on your own machine.
- **Continuous integration and delivery (CI/CD)** – Run integration tests in your pipeline with no AWS account and no AWS resources.
- **Prototyping with AI coding agents** – Build and interact with applications locally that will run on AWS.

To learn which AWS APIs the emulator supports and how closely it matches AWS, see [Fidelity in AWS Emulator](https://docs.aws.amazon.com/emulator/latest/userguide/fidelity.html). To check whether your own project is expected to work, see [Checking whether your project works with AWS Emulator](https://docs.aws.amazon.com/emulator/latest/userguide/check-project.html).

## Examples

The following examples use the AWS CLI with an emulator that runs on your machine. To set up your shell, see [To point your SDK at a local emulator](https://docs.aws.amazon.com/emulator/latest/userguide/point-sdk-to-emulator.html#point-sdk-env).

**Example – Create a resource and get it again**

The emulator keeps the resources that you create. The following AWS CLI command creates an Amazon S3 bucket named `amzn-s3-demo-bucket`.

```
$ aws s3api create-bucket --bucket amzn-s3-demo-bucket
{
    "Location": "/amzn-s3-demo-bucket"
}
```

When you list your buckets later, the emulator returns the bucket that you created.

```
$ aws s3api list-buckets --query 'Buckets[].Name'
[
    "amzn-s3-demo-bucket"
]
```

**Example – Get the same validation error as on AWS**

Amazon DynamoDB table names must be at least 3 characters long. The following AWS CLI command tries to create a table named `ab`. The emulator rejects the `CreateTable` call with the same error as AWS.

```
$ aws dynamodb create-table --table-name ab \
    --attribute-definitions AttributeName=id,AttributeType=S \
    --key-schema AttributeName=id,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST
An error occurred (ValidationException) when calling the CreateTable operation: 1 validation error detected: Value 'ab' at 'tableName' failed to satisfy constraint: Member must have length greater than or equal to 3
```

## Limitations

AWS Emulator is for building and testing. Don’t use it for production workloads. It has the following limitations:

- **Policies** – The emulator doesn’t evaluate AWS Identity and Access Management (IAM) policies and resource-based policies the way AWS does. Don’t use it to test security. For more information, see [Security in AWS Emulator](https://docs.aws.amazon.com/emulator/latest/userguide/security.html).
- **One Region and one account** – The emulator accepts any Region and account ID in a request, but it doesn’t keep resources separate by Region or account. Some services share resources across all Regions, and others keep them per Region. Use one Region and one account for all requests to an emulator. To test more than one Region, run a separate emulator for each Region, each on its own port.
- **Fidelity** – How closely the emulator matches AWS varies by service and feature. For more information, see [Fidelity in AWS Emulator](https://docs.aws.amazon.com/emulator/latest/userguide/fidelity.html).
- **Verified in one Region** – We check the emulator’s behavior against AWS in the US West (Oregon) Region (`us-west-2`) only, except for global services, which we check in the US East (N. Virginia) Region (`us-east-1`). Differences in service and feature availability across Regions aren’t reflected.
- **Your machine’s resources** – The emulator runs on your machine and keeps all resources in memory. How much it can hold depends on your machine, and the emulator deletes all resources when it stops.
- **Test runs, not long-running use** – We haven’t tested the emulator for long-running use or load testing. Start the emulator for your tests and stop it afterwards, or set `--idle-timeout` so that it stops by itself. Restarting also gives your tests a clean state.

Some services have other gaps. To find them, see the fidelity scores that we publish with each release on the [AWS Emulator releases page on GitHub](https://github.com/aws/aws-emulator/releases).

## How AWS Emulator keeps improving

AI agents keep the emulator up to date with AWS. The emulator improves continuously, with updates many times a day, so it keeps up as AWS services change and grow. For what stays the same between releases, see [Versions and compatibility in AWS Emulator](https://docs.aws.amazon.com/emulator/latest/userguide/versioning.html).

## Features of AWS Emulator

AWS Emulator includes the following features:

- An `aws-emulator` skill for AI coding agents, which installs, starts, and connects the emulator, and checks whether your project works on it. For more information, see [Getting started with an AI coding agent](https://docs.aws.amazon.com/emulator/latest/userguide/getting-started-agent.html).
- Works with the AWS CLI and AWS SDKs. You point their endpoint at the emulator with environment variables, and your code doesn’t change.
- An embedded mode for tests written in Rust with the AWS SDK for Rust, with separate state for each emulator that you create
- Source code on GitHub, in the [aws-emulator repository](https://github.com/aws/aws-emulator). For the license, see [Review the license](https://docs.aws.amazon.com/emulator/latest/userguide/setting-up.html#setting-up-license).
- Fidelity tests on GitHub, in the [aws-emulator-evaluation-suite repository](https://github.com/aws/aws-emulator-evaluation-suite)

## Learn more

To learn more, see the following resources: