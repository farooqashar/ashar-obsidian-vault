---
title: "Open-Source Infrastructure as Code"
source: "https://opentofu.org/"
author:
published:
created: 2026-11-23
description: "OpenTofu - Modern Infrastructure as Code"
tags:
  - "clippings"
  - "devops-practice"
---
OpenTofu is a reliable, flexible, community-driven infrastructure as code tool under the Linux Foundation's stewardship. It serves as a **drop-in replacement for Terraform**, preserving your existing workflows and configurations.

With a thriving ecosystem of **3,900+ providers** and **23,600+ modules**, you can build and manage infrastructure across every cloud platform with confidence.

### Create an S3 Bucket

Define your infrastructure as code with OpenTofu. A few lines of configuration is all you need to create and manage cloud resources with confidence.

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-example-bucket"
}
```

### Configure DNS Records

Version control your infrastructure with OpenTofu. Track changes, collaborate with your team, and deploy DNS configurations with a single command.

```
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_record" "example" {
  zone_id = "0da42c8d2132a9ddaf714f9e7c920711"
  name    = "www"
  value   = "192.0.2.1"
  type    = "A"
  ttl     = 3600
  proxied = true
}
```

### Set Up GitHub Repositories

Automate your development workflow with OpenTofu. Create repositories, set up branch protection, and manage team access in code.

```
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = var.github_token
}

resource "github_repository" "example" {
  name        = "my-repo"
  description = "My application repository"
  visibility  = "public"
  auto_init   = true
}

resource "github_branch_protection" "main" {
  repository_id  = github_repository.example.id
  pattern        = "main"
  enforce_admins = true
}
```

## Features Unique to OpenTofu

Powerful capabilities — built by the community to solve real-world challenges in infrastructure management

```
# Command line usage
$ tofu plan -exclude="aws_instance.database"
$ tofu apply -exclude="module.network"

# Exclude multiple resources
$ tofu apply \
  -exclude="aws_instance.web[0]" \
  -exclude="aws_instance.web[1]"
```

### Exclusion Flag

[v1.9](https://opentofu.org/docs/v1.9/intro/whats-new/)

Selectively exclude resources from operations with the -exclude flag. This provides more control during testing and rollouts, allowing you to focus on specific parts of your infrastructure.

[Learn more](https://opentofu.org/docs/cli/commands/plan/#resource-targeting)

```
# Define regions for deployment
variable "regions" {
  type    = set(string)
  default = ["us-west-1", "us-east-1", "eu-west-1"]
}

variable "disabled_regions" {
  type    = set(string)
  default = []
}

# Create provider for each region
provider "aws" {
  alias    = "by_region"
  region   = each.value
  for_each = var.regions
}

# Deploy resources in each active region
module "deploy" {
  source    = "./deploy"
  providers = {
    aws = aws.by_region[each.key]
  }
  for_each = setsubtract(var.regions, var.disabled_regions)
}
```

### Provider Iteration with for\_each

[v1.9](https://opentofu.org/docs/v1.9/intro/whats-new/)

Dynamically generate provider configurations with for\_each, eliminating repetitive code and improving maintainability. Perfect for multi-region deployments, multi-environment setups (dev/staging/prod), multi-account scenarios, and cross-cloud implementations. Provider for\_each enables cleaner infrastructure patterns, simplified credential rotation, and more controlled progressive rollouts across your infrastructure landscape.

[Learn more](https://opentofu.org/docs/intro/whats-new/#provider-iteration-for_each)

```
# Define module version as a variable
variable "aws_module_version" {
  description = "Version of AWS modules to use"
  type        = string
  default     = "5.6.1"
}

# Use the variable for module versioning
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = var.aws_module_version
  
  name = "my-vpc"
  cidr = "10.0.0.0/16"
  
  azs             = ["us-west-2a", "us-west-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}
```

### Early Variable/Local Evaluation

[v1.8](https://opentofu.org/docs/v1.8/intro/whats-new/)

Update all your modules programmatically with a single variable change. Never miss updating a module version by accident - keep your infrastructure consistent and secure with centralized version management.

[Learn more](https://opentofu.org/docs/v1.8/language/modules/sources/#support-for-variable-and-local-evaluation)

```
# Configure state encryption
terraform {
  encryption {
    # Define a passphrase-based key provider
    key_provider "pbkdf2" "mykey" {
      passphrase = "correct-horse-battery-staple"
      key_length = 32
      iterations = 600000
    }
    
    # Configure AES-GCM encryption method
    method "aes_gcm" "default" {
      key_provider = key_provider.pbkdf2.mykey
    }
    
    # Enable encryption for state files
    state {
      method = method.aes_gcm.default
      enforced = true
    }
  }
}
```

### State Encryption

[v1.7](https://opentofu.org/docs/v1.7/intro/whats-new/)

Protect your infrastructure state at rest with built-in encryption. OpenTofu supports client-side state encryption with multiple key providers (PBKDF2, AWS KMS, GCP KMS, OpenBao, and more) to ensure your sensitive infrastructure data is always encrypted, even when stored in remote backends.

[Learn more](https://opentofu.org/docs/language/state/encryption/)

## Join Our Community

OpenTofu thrives on community contributions. Whether you're fixing bugs, adding features, improving docs, or providing feedback, your input makes a difference.

## Frequently Asked Questions

Get answers to common questions about OpenTofu capabilities and usage

Why was OpenTofu created?

OpenTofu is a Terraform fork, created as an initiative of Gruntwork, Spacelift, Harness, Env0, Scalr, and others, in response to HashiCorp's switch from an open-source license to the BUSL. The initiative has many supporters, all of whom are listed [here](https://opentofu.org/supporters/).

The BUSL and the additional use grant outlined by the HashiCorp team are ambiguous, which makes it challenging for companies, vendors, and developers using Terraform to decide whether their actions could be interpreted as being outside the permitted scope of use.

HashiCorp's FAQs give some peace of mind to end users and system integrators for now, but the licensing terms' implications for future usage are unclear. The possibility that the company's definition of *"competitive"* or *"embedding"* could change or the license could be further modified to make it closed source prompts uncertainty for Terraform users.

We firmly believe that Terraform should remain open-source because it is a project many companies use, and many contributors have made Terraform what it is today. Terraform's success would not have been possible without the community's work to build many supporting projects around it.

Why should you use OpenTofu instead of Terraform?

#### Personal use

Initial impressions suggest you could use either OpenTofu or Terraform for personal use, as the BUSL license has no restrictions for non-commercial use cases. That may change as the Terraform ecosystem becomes increasingly unstable, and a switch to another license may happen. Those familiar with Terraform will have no issues adopting OpenTofu for personal use, so there will be no knowledge gaps, at least at the start.

#### Consultants

A consultant should offer their clients the best possible solution that aligns with their budget. OpenTofu will be on par with Terraform, and one of the project's central objectives is to listen to the community's issues, so it makes sense to recommend a project that will always stay open-source. Anyone who has used Terraform in the last eight years has probably come across issues that took some time to be resolved. The large community involved in developing OpenTofu means this will no longer be the case.

#### Companies

Companies will encounter more difficulties with the situation. Switching to a new project carries risks, but staying with a project that changes its license without warning is far riskier. This risk is minimized by giving OpenTofu to the Linux Foundation, and OpenTofu's aim of maintaining feature parity with Terraform for future releases reduces the technical risks.

Will OpenTofu be compatible with future Terraform releases?

The community will decide what features OpenTofu will have. Some long-awaited Terraform features will be publicly available soon.

If you're missing a feature in OpenTofu that's available in Terraform, feel free to create an issue.

Where can I find providers and modules for OpenTofu?

The OpenTofu Registry hosts thousands of providers and modules that are compatible with OpenTofu. These include all the popular cloud providers, third-party services, and community-maintained resources you might need for your infrastructure.

You can search for providers, modules, and their documentation at [search.opentofu.org](https://search.opentofu.org/). The registry provides seamless access to the same ecosystem of providers and modules that you're familiar with, ensuring you have all the tools needed to build and manage your infrastructure.