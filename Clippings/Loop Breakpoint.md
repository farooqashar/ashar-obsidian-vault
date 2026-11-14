---
title: "Loop Breakpoint"
source: "https://www.miodragvilotijevic.com/patterns/loop-breakpoint?utm_source=email&utm_medium=outreach&utm_campaign=loop-breakpoint"
author:
  - "[[Miodrag Vilotijević]]"
published:
created: 2026-11-14
description: "Introduce explicit execution boundaries into an AI agent loop, allowing the agent to evaluate each instruction before execution and determine how the loop should advance."
tags:
  - "clippings"
---
A behavioral design pattern for evaluating each instruction before an agent loop advances.

![An agent sets a breakpoint on a pending instruction, which can then resolve as inference or a tool call.](https://www.miodragvilotijevic.com/_next/image?url=%2Fpatterns%2Floop-breakpoint%2Fthumbnail.png&w=3840&q=75)

An agent sets a breakpoint on a pending instruction, which can then resolve as inference or a tool call.

## Intent

Introduce explicit execution boundaries into an AI agent loop, allowing the agent to evaluate each instruction before execution and determine how the loop should advance.

## Problem

AI agents typically operate through an iterative process. A language model performs inference, produces a response, requests tool execution, receives results, and continues reasoning until a goal is achieved.

This process is commonly implemented as a continuous execution loop in which inference and tool calls are executed automatically.

While this approach works for simple agents, it introduces limitations when execution must be controlled dynamically.

Execution is tightly coupled to the loop. The loop decides which instruction to execute and immediately invokes it. Applications have limited opportunities to intervene between instructions.

Execution decisions are difficult to change at runtime. Instructions may need to be approved, deferred, modified, or executed in a different environment. Such decisions often require additional conditional logic inside the loop.

Agents cannot easily coordinate execution. In multi-agent systems, one agent may need to wait for another agent, exchange information, or obtain approval before proceeding. A continuously running loop makes these interactions difficult to coordinate.

Interruptions may lose execution continuity. Stopping an agent can require restarting its execution or reconstructing the context necessary to continue from the previous instruction.

Consider a coding agent working on a software project. During inference, the language model decides to modify several files.

Before the corresponding tool call executes, the agent may need to determine whether another agent is modifying the same files, whether the requested operation is permitted, or whether the task should be delegated to another agent.

If the loop immediately executes every instruction, these decisions must be embedded directly into its execution logic.

The fundamental problem is that instruction evaluation and instruction execution are treated as a single operation.

How can an agent evaluate every instruction before execution, preserve execution progress, and dynamically decide when and how the loop should advance?

## Solution

The Loop Breakpoint Pattern separates instruction evaluation from instruction execution by introducing a breakpoint at every instruction boundary.

Instead of executing instructions immediately, the agent explicitly establishes a breakpoint representing the next instruction to be executed.

A breakpoint contains the instruction type and parameters required for execution. Once the instruction executes, its result is recorded, allowing the agent to evaluate the outcome before selecting the next instruction.

The pattern introduces three fundamental operations:

- Set Breakpoint. Register the next instruction without executing it.
- Evaluate Breakpoint. Inspect the instruction and decide whether execution should proceed.
- Resolve Breakpoint. Record the instruction's result and complete the current execution boundary.

Every instruction passes through this lifecycle before the loop advances.

The agent is responsible for deciding which instruction should execute next, while the loop maintains the state of pending and completed instructions.

An instruction is represented independently from its execution implementation. This allows inference, tool calls, and other instruction types to participate in the same execution model.

The central principle is: every instruction is an execution boundary at which the agent can evaluate and control progression.

A breakpoint does not necessarily mean that execution must pause. It means the instruction is available for evaluation before execution proceeds.

## Structure

The pattern consists of an Agent, Loop, Instruction Records, Instruction Registry, and concrete Instruction implementations.

![Class diagram of the Loop Breakpoint pattern. Agent controls Loop and uses InstructionRegistry. Loop contains InstructionRecord, specialized by InferenceRecord and ToolCallRecord. InstructionRegistry contains Instruction, specialized by Inference and ToolCall.](https://www.miodragvilotijevic.com/_next/image?url=%2Fpatterns%2Floop-breakpoint%2Fclass-diagram.png&w=3840&q=75)

Class diagram of the Loop Breakpoint pattern. Agent controls Loop and uses InstructionRegistry. Loop contains InstructionRecord, specialized by InferenceRecord and ToolCallRecord. InstructionRegistry contains Instruction, specialized by Inference and ToolCall.

The diagram represents the conceptual structure of the pattern. In the Mozaik Agent implementation, `InstructionRecord` is a TypeScript discriminated union rather than a class hierarchy, and the application-layer `AdvanceLoopUseCase` coordinates instruction execution.

## Participants

| Participant | Responsibility |
| --- | --- |
| Agent | Evaluates the latest instruction and determines how the loop should advance. The Agent decides which instruction should execute next, whether execution should be deferred, and whether the loop should continue or terminate. |
| Loop | Maintains the execution state of the agent. The Loop stores the current pending instruction and previously completed instructions. It establishes and resolves breakpoints while preserving execution continuity. |
| Instruction record  InstructionRecord | Represents an individual instruction execution. Each record contains the instruction type, execution parameters, and an optional result. The result becomes available after successful resolution of the instruction. Concrete records include `InferenceRecord` and `ToolCallRecord`. |
| Instruction registry  InstructionRegistry | Maintains the available instruction implementations and resolves the appropriate implementation based on the instruction type. |
| Instruction  Instruction | Defines the execution contract for an instruction through `run(parameters)`. Concrete implementations such as `Inference` and `ToolCall` encapsulate their respective execution behavior. |

## Collaborations

The Agent and Loop collaborate through an iterative execution process.

At the beginning of an iteration, the Agent retrieves the latest instruction record and evaluates its result.

Based on that evaluation, the Agent determines the next instruction and establishes a breakpoint.

The Loop stores the instruction as pending without executing it.

Before advancing the loop, the Agent has an opportunity to inspect the breakpoint, apply execution policies, pause execution, or coordinate with other agents.

When the Agent decides to proceed, the application resolves the corresponding instruction implementation and invokes its `run` method.

The resulting output is recorded through `resolveBreakpoint`, and the instruction moves into the completed-instruction collection.

The Agent can then evaluate the result and determine the next instruction.

![Sequence diagram of one loop iteration. The agent reads the latest instruction, sets a breakpoint, evaluates it, runs the instruction from the registry, resolves the breakpoint, and reads the completed record.](https://www.miodragvilotijevic.com/_next/image?url=%2Fpatterns%2Floop-breakpoint%2Fsequence-diagram.png&w=3840&q=75)

Sequence diagram of one loop iteration. The agent reads the latest instruction, sets a breakpoint, evaluates it, runs the instruction from the registry, resolves the breakpoint, and reads the completed record.

The execution sequence illustrates the conceptual responsibilities. In Mozaik Agent, an application use case coordinates instruction lookup and execution rather than placing these operations directly inside the `Loop` entity.

The important distinction is that the Loop does not automatically choose or execute the following instruction. Progression is determined through a separate evaluation.

## Implementation

The following implementation is based on the domain model used in [Mozaik Agent](https://github.com/jigjoy-ai/mozaik-agent), a TypeScript agent harness that provides debugger-like execution control.

### 1\. Model instructions as records

Instructions are represented by records containing their type, parameters, and eventual result.

```
export type InstructionType =
  | "inference"
  | "tool_call"

export type InferenceRecord = {
  readonly type: "inference"
  readonly parameters: InferenceParams
  result?: InferenceResult
}

export type ToolCallRecord = {
  readonly type: "tool_call"
  readonly parameters: ToolCallParams
  result?: ToolCallResult
}

export type InstructionRecord =
  | InferenceRecord
  | ToolCallRecord
```

An instruction record has two conceptual phases.

Pending. The record contains the instruction type and parameters, but no execution result.

Completed. The record contains the result of instruction execution.

The same record type represents both phases, allowing the Loop to retain the information required for execution and subsequent evaluation.

### 2\. Model the Loop as a stateful entity

The Loop maintains execution progress independently of the instruction implementations.

```
export class Loop {
  id: string
  goal: string
  assignee: string
  state: LoopStateId

  pendingInstruction?: InstructionRecord
  completedInstructions: InstructionRecord[]

  // ...
}
```

The `pendingInstruction` property represents the current execution boundary.

The `completedInstructions` collection preserves previous instructions and their results.

This distinction allows the Agent to evaluate the most recent outcome while preparing the next instruction.

### 3\. Establish a breakpoint

The Loop exposes `setBreakpoint` to register the next instruction.

```
setBreakpoint(instruction: InstructionRecord): void {
  if (this.pendingInstruction) {
    throw new Error("An instruction is already pending")
  }

  this.pendingInstruction = instruction
}
```

The method enforces an important invariant: only one instruction can be pending within a Loop at a time.

Setting a breakpoint does not invoke inference or execute a tool. It only establishes the next execution boundary.

### 4\. Execute instructions through a common abstraction

Each instruction implements a common execution contract.

```
export abstract class Instruction {
  abstract run(
    params: InstructionParams
  ): Promise<InstructionResult>
}
```

Concrete instruction implementations encapsulate their own execution behavior.

```
export class Inference extends Instruction {
  async run(
    params: InferenceParams
  ): Promise<InferenceResult> {
    // Execute model inference
  }
}

export class ToolCall extends Instruction {
  async run(
    params: ToolCallParams
  ): Promise<ToolCallResult> {
    // Execute the requested tool
  }
}
```

These examples are simplified to illustrate the shared instruction contract.

The Loop itself does not need to know whether an instruction invokes a language model, executes a tool, or interacts with an external system.

An `InstructionRegistry` resolves the appropriate instruction implementation for the pending record.

### 5\. Resolve the breakpoint

After execution, the instruction result is associated with the pending record and the breakpoint is resolved.

```
const pending = loop.getBreakpoint()

if (!pending) {
  throw new Error("No pending instruction")
}

const instruction = instructionRegistry.getInstruction(
  pending.type
)

const result = await instruction.run(pending.parameters)

pending.result = result

loop.resolveBreakpoint(pending)
```

The `resolveBreakpoint` method ensures the pending instruction is completed before the Loop can accept another instruction.

The completed instruction becomes part of the Loop's execution history.

In the current Mozaik Agent implementation, the instruction is moved into `completedInstructions` and `pendingInstruction` is cleared when the breakpoint is resolved.

### 6\. Evaluate the result before advancing

After resolving a breakpoint, the Agent retrieves the latest instruction record.

```
const latestInstruction = loop.getLatestInstruction()
```

The Agent can inspect the instruction type, parameters, and result to determine what should happen next.

For example, after an inference instruction, the Agent may decide to execute a requested tool, perform another inference, wait for another agent, or complete the goal.

After a tool call, the Agent may decide to provide the tool result to the language model or perform another operation.

This evaluation is deliberately separated from the execution of the previous instruction.

As a result, the Agent is not restricted to a predefined sequence of operations.

## Example

Consider an AI coding agent assigned to modify a software project.

The agent begins by evaluating the state of its Loop and determining that model inference is required.

It establishes an inference breakpoint containing the model request parameters.

The application evaluates the breakpoint and permits inference to execute.

The resulting model response requests a tool call to modify a source file.

Before executing the tool, the agent establishes a new breakpoint:

```
const record: ToolCallRecord = {
  type: "tool_call",
  parameters: {
    toolName: "edit_file",
    toolArguments: JSON.stringify({
      path: "src/index.ts",
      content: "..."
    })
  }
}
```

The example assumes an `edit_file` tool has been registered.

At this point, the tool has not executed.

The Agent evaluates the breakpoint and determines that another agent is currently working on the same file.

Instead of immediately executing the tool, the Agent can defer progression until the other agent completes its work.

Once the conflict is resolved, execution can continue using the pending instruction.

The tool executes, and its result is recorded in the completed instruction.

The Agent evaluates the result and decides whether another inference is necessary.

This illustrates a fundamental property of the pattern: execution can be controlled dynamically without losing the current instruction or restarting the loop.

The same mechanism can support human approvals, debugging, instruction routing, and coordination between multiple agents.

## Consequences

### Benefits

- Explicit execution boundaries. Every instruction becomes observable before execution. The application gains an opportunity to evaluate and control progression without modifying individual instruction implementations.
- Separation of evaluation and execution. The Agent determines what should happen next, while instruction implementations define how operations are performed. This separates decision-making from execution mechanics.
- Runtime adaptability. Execution behavior can change while the agent is running. An instruction can be deferred, approved, or routed according to the current state of the system rather than following a strictly predefined workflow.
- Execution continuity. The Loop preserves pending and completed instruction records. This makes it possible to interrupt execution and subsequently continue from the current instruction boundary.
- Extensibility. New instruction types can be introduced without fundamentally changing the Loop's execution model. As long as an instruction follows the execution contract, it can participate in the breakpoint lifecycle.
- Multi-agent coordination. Agents can coordinate at explicit instruction boundaries. One agent may wait for another agent, request approval, or transfer responsibility for the Loop before execution continues.

### Liabilities

- Additional orchestration complexity. Instruction execution requires explicit breakpoint establishment and resolution. Compared with a simple continuous loop, the application must manage additional execution transitions.
- State consistency. The Loop must preserve consistency between pending and completed instructions. Invalid transitions, such as establishing a second breakpoint while another remains pending, must be prevented.
- Concurrency. When multiple actors can advance a Loop, synchronization is required to prevent duplicate execution or conflicting updates.
- Failure recovery. Instruction execution may fail or terminate before its result is recorded. The application must define how to recover from unresolved instructions, particularly when operations produce external side effects.
- Execution overhead. Evaluation and persistence at every instruction boundary can introduce additional computational or storage overhead. The architecture trades some execution simplicity for greater control and flexibility.

## Applicability

The Loop Breakpoint Pattern is particularly useful in systems where instruction execution cannot be treated as a continuous, uninterrupted process.

Typical applications include:

- Autonomous agents. Evaluate each inference or tool call before progressing.
- Multi-agent systems. Coordinate instructions across agents with independent execution loops.
- Human-in-the-loop workflows. Require human approval before executing consequential operations.
- Agent debugging. Inspect instruction parameters and results at explicit execution boundaries.
- Long-running tasks. Suspend and resume execution without reconstructing the entire process.
- Distributed agent systems. Coordinate execution across separate machines or services.
- Policy-driven execution. Apply authorization, resource, or safety policies before executing instructions.

The pattern is less useful for simple agents where execution always follows a fixed sequence and no external intervention or preservation of intermediate execution state is required.

## Related patterns

- Interpreter. The Interpreter Pattern defines representations for instructions and mechanisms for interpreting them. The Loop Breakpoint Pattern similarly models executable instructions explicitly, but introduces an evaluation boundary before execution. The Interpreter Pattern focuses on how instructions are interpreted and executed. The Loop Breakpoint Pattern focuses on how their execution is controlled and coordinated.
- Command. The Command Pattern encapsulates a request as an object, separating the requester from the executor. An `InstructionRecord` similarly encapsulates the information required for execution. The Loop Breakpoint Pattern also records execution outcomes and uses explicit boundaries to govern progression between instructions.
- State. The State Pattern encapsulates state-dependent behavior and transitions. The Loop Breakpoint Pattern depends on explicit execution state but does not require the State Pattern for its implementation. A Loop may use State objects to formalize transitions between idle, paused, waiting, stopped, and completed states.
- Strategy. The Strategy Pattern allows interchangeable algorithms or policies to be selected dynamically. It can complement the Loop Breakpoint Pattern by defining alternative strategies for evaluating pending instructions. For example, execution policies may vary depending on the instruction type, system load, permissions, or the state of other agents.
- Chain of Responsibility. The Chain of Responsibility Pattern allows multiple handlers to evaluate a request in sequence. It can complement breakpoint evaluation by passing an instruction through multiple checks before execution. For example, a tool call may be evaluated by authorization, resource allocation, conflict detection, and human approval handlers.

## Conclusion

The Loop Breakpoint Pattern introduces explicit evaluation boundaries into an AI agent's execution loop.

By representing instructions as records and separating instruction evaluation from execution, the pattern allows agents to control how and when their loops advance.

This approach makes it possible to pause, inspect, resume, and coordinate execution while preserving instruction state and previous results.

The central idea is that an agent loop should not automatically advance simply because an instruction is available.

Every instruction should be evaluated before execution, and every execution result should inform the next decision.

This transforms the agent loop from a continuously running sequence of operations into a controllable, stateful execution process.

## References

Implementation: [Mozaik Agent — An Interruptible Agent Harness](https://github.com/jigjoy-ai/mozaik-agent)

The Loop Breakpoint Pattern is a proposed behavioral design pattern based on the execution model developed for Mozaik Agent. It is not one of the original Gang of Four design patterns.