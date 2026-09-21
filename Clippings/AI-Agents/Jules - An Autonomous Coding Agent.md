---
title: "Jules - An Autonomous Coding Agent"
source: "https://jules.google/"
author:
published:
created: 2026-04-08
description: "Jules is an Autonomous agent that gets out of your way. It lets you focus on the coding you want to do, meanwhile picking up all the other random tasks that you rather not do."
tags:
  - "clippings"
  - "coding-agents"
  - "agent-infra"
---
## An Autonomous Coding Agent

![Squid agent](https://jules.google/jules-pixelated.png)

```
// Objective: Change UserOnboarding to use a state machine for steps
```

```
class UserOnboarding {
```

```
constructor(user) {
```

```
this.user = user;
```

```
this.currentStep = 0;
```

```
}
```

```
async nextStep() {
```

```
if (this.currentStep < this.steps.length -1) {
```

```
this.currentStep++;
```

```
// TODO: Trigger analytics
```

```
return this.steps[this.currentStep];
```

```
}
```

```
return "done";
```

```
}
```

```
// Old method - to be removed
```

```
legacyNotification() {
```

```
alert("Welcome aboard, " + this.user.name);
```

```
}
```

```
}
```

```
const newUser = { name: "David", id: "usr_123" };
```

```
const onboardingProcess = new UserOnboarding(newUser);
```

```
onboardingProcess.nextStep();
```

```
// onboardingProcess.legacyNotification(); // Commented out
```

More time for the code you want to write, and everything else.

![Writing software](https://jules.google/comic-computer.png) ![Bike riding](https://jules.google/comic-bike.png) ![Playing tennis](https://jules.google/comic-tennis.png)

Brought to life with Gemini 3 Pro and the AIDA team.

![Squid](https://jules.google/squid.png)

**GitHub Integration**

Jules imports your repos, branches changes, and helps you create a PR.

**Test Suite**

Jules will run existing tests, or create new ones.

**Virtual Machine**

Jules clones your code in a Cloud VM and verifies the changes work.

**Available Anywhere**

Use Jules from the [CLI](https://jules.google/docs/cli/reference) or build your own workflows using the [API](https://developers.google.com/jules/api)

Select your GitHub repository and branch. Write a detailed prompt for Jules.

@kathy/flipdisc main

Can you bump the version of next.js to v15 and convert the project to use app directory?

Jules fetches your repository, clones it to a Cloud VM, and develops a plan utilizing the latest [Gemini 3 Pro model](https://deepmind.google/technologies/gemini/pro/).

Here is my plan:

I plan to update the following files to the new app directory structure.

Update 22 Files

That looks good. Continue!

Jules provides a diff of the changes. Quickly browse and approve code edits.

```
9 10   "dependencies": {11-    "next": "10.2.3",11+    "next": "15.4.5",12     "react": "19.1.1",13     "react-dom": "19.1.1"14   }
```

Jules creates a PR of the changes. Approve the PR, merge it to your branch, and publish it on GitHub.

Publish Branch

Find the Jules plan that fits your workflow

Jules scales with how you build, from quick fixes to fully async, multi-agent development. Choose the plan that gives you the speed, throughput, and model access you need.

**Jules**

Get started with real coding tasks.

- 15 tasks per day
- 3 concurrent tasks
- Powered by Gemini 2.5 Pro

**Jules in Pro**

For devs who ship daily and want to stay in the flow.

- 100 tasks per day, enough to run Jules throughout your coding day
- 15 concurrent tasks, so you can run multiple threads in parallel
- Higher access to the latest models, starting with Gemini 3 Pro

**Jules in Ultra**

For builders who run agents at scale.

- 300 tasks per day to handle the most demanding development cycles
- 60 concurrent tasks, built for massively parallel workflows
- Priority access to the latest models, starting with Gemini 3 Pro

[Try Jules](https://jules.google.com/) [Documentation](https://jules.google/docs)