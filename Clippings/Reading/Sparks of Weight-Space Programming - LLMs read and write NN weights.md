---
title: "Sparks of Weight-Space Programming: LLMs can natively read & write neural network weights"
source: "https://www.alphaxiv.org/abs/2611.weight-space-programming"
author:
  - "[[Rikiya Takehi]]"
  - "[[Jayden Teoh]]"
  - "[[Alex Zhang]]"
  - "[[Omar Khattab]]"
published: 2026-11-01
created: 2026-11-03
description: "The authors show that GPT-6 Astra, a general-purpose frontier LLM, can read and write neural network weights directly, without gradient descent or trained helper models. Across eight experiments it..."
tags:
  - "clippings"
  - "essays"
---
## Summary

The authors show that GPT-6 Astra, a general-purpose frontier LLM, can read and write neural network weights directly, without gradient descent or trained helper models. Across eight experiments it identifies what small networks were trained on from their weights, fixes and writes game-playing policies, and edits 0.016% of Qwen3.5-0.8B's weights to stop reasoning loops. They call this Weight-Space Programming.

[4](#discussion)

[![Rikiya Takehi](https://tweet-media.assets.alphaxiv.org/01a19eb8-8b0a-740d-9fd0-a1c208391b95)](https://www.alphaxiv.org/@rikiya-takehi)

1/6 We find early signs that frontier LLMs are surprisingly good at \*natively\* reading, writing, and reasoning about neural network weights.

Instead of training, models may treat raw weights like readable, editable code: diagnosing failures and patching them directly.

[![Rikiya Takehi](https://tweet-media.assets.alphaxiv.org/01a19eb8-8b0a-740d-9fd0-a1c208391b95)](https://www.alphaxiv.org/@rikiya-takehi)

2/6 First, a look at understandability:

We fed Astra raw weights from 4 game policies one at a time. All four share the exact same architecture, inputs, and actions.

With no tools or options given, it correctly named all four: Breakout, Pong, Pac-Man, Freeway.

<video src="https://tweet-media.assets.alphaxiv.org/01a19eb8-8dec-72f1-9cee-e2512ecee866" controls=""></video>

## Content

**TL;DR**

We find that frontier LLMs are surprisingly good at **natively reading and writing neural network weights**, well past what we’d expect from humans or conventional algorithms. This might be a big deal for both optimization and interpretability.

Just by looking at the raw weights, GPT-6 Astra **can tell what a network was trained to do**. And without any environment feedback, it **has no trouble writing, from scratch, small game-playing networks** that outplay networks trained with PPO for 100 million steps.

Likewise, asked to make Qwen3.5-0.8B better at math without gradients, Astra **identifies an issue in its weights** causing reasoning loops that Qwen’s own [model card](https://huggingface.co/Qwen/Qwen3.5-0.8B/blob/main/README.md#L856) warns about, and **fixes this by natively editing 0.016% of the weights**. With the same sampling settings, this weight correction raises MATH-500 from 7.9% to 48.1% and generalizes out of the box to instruction following, raising IFEval by 3x.

All of this is possible without allowing Astra to write training loops. It uses its reasoning to figure out what each part of a neural network computes, or should compute, and changes the weights accordingly. We call this **Weight-Space Programming**.

Throughout the history of deep learning, we encoded our simplistic inductive biases into tiny symbolic optimizers like Adam or Muon. This is changing: **our neural network weights will soon be *natively* optimized by LLMs that deliberately reason about their weights**.

![](https://blog-media.assets.alphaxiv.org/images/01a19e91-e5dc-74fb-a7df-c5342d7619e7/image-2.png)

If you were asked to handcraft a neural network that plays Go, what would you do? If you were handed raw neural network weights and asked to predict their behavior, where would you even start? For almost any human, this is practically impossible.

Today, weights are written by [optimization](https://karpathy.medium.com/software-2-0-a64152b37c35), by [custom networks trained to write them](https://www.alphaxiv.org/abs/2102.11174), or by [compilers from formal programs](https://www.alphaxiv.org/abs/2301.05062). In this post, we find that the current generation of frontier LLMs, used natively in natural language, are starting to become eerily good at understanding and crafting neural network weights around natural-language goals.

## Weight-Space Programming

For a few years now, we’ve all been **using LLMs to optimize text artifacts** like prompts and the programs built around them <sup>[1]</sup> <sup>[2]</sup> <sup>[3]</sup> <sup>[4]</sup>. More recently, we’ve started using them to optimize whole harnesses <sup>[5]</sup> and the training code and hyperparameters that train ML models [<sup>[6]</sup>](https://github.com/karpathy/autoresearch) [<sup>[7]</sup>](https://xingjianbai.com/reactive-optimizers/).

We often justified these methods by reference to the fact that *we don’t know other principled ways to hill-climb on text artifacts, unlike for updating the weights of differentiable neural networks*. After all, humans can “optimize” code by hand, for example, so it made sense to ask LLMs to do it, but they can’t “optimize” neural weights by hand, so those remained largely in the realm of symbolic algorithms.

In this post, we share very early results that allow us to argue that **the paradigm of reasoning-driven optimization is now coming even for differentiable neural networks**.

In **Weight-Space Programming**, a general-purpose **LLM reads and writes a network’s weights directly** (i.e., not through an optimizer, and in particular not with gradient descent) around some natural language spec, sometimes even with no environment feedback at all.

In natural language, it’s becoming possible to **“just ask” an LLM to natively find a hidden trait or failure inside the weights of a neural network, to fix that failure, or to write a new network from scratch**. We report early, exciting results on each of these below, first on small networks and then even on real language models:

1. **LLMs can read neural network weights:** In Experiments 1 to 3, we ask Astra questions like what game a network was trained to play, what shape is drawn by a diffusion model, and which language a small language model was trained on. In Experiment 7, we ask which of two language models was trained to be sycophantic.
2. **LLMs can fix neural network weights:** In Experiment 4, we ask Astra to fix a network that’s failing at some physical control task. In Experiment 8, we ask it to make Qwen3.5-0.8B better at math, and its fix improves instruction following too.
3. **LLMs can write neural network weights from scratch:** In Experiment 5, we ask Astra for networks that play three MinAtar games, and in Experiment 6, for a network that plays Go.

## Can LLMs understand model behaviors from weights?

We start with a small-scale experiment to see if LLMs can understand the continuous weight space, which is essentially just a list of numbers.

In our first experiments, we train some neural network with some algorithm. It would be extremely exciting if the LLM is able to tell its behavior just from the weights.

### Experiment 1: Can Astra tell which game the network was trained on just from the weights?

We trained neural network policies with PPO to play four computer games. All four networks take the same input channels, choose from the same actions, and have exactly the same network dimensions, so that it is not able to tell unless the weights are read.

For each of these networks, we pass its raw weights into Astra as a prompt, and ask: Which game was this neural network trained on? **Without revealing the options of the games we consider, Astra was still able to name the right game for all four networks.** This is exciting particularly because there are so many games out there that Astra could choose from.

**Setup**

- **Games:** our own grid versions of Breakout, Pong, Pac-Man and Freeway, all on the same 10×10 grid with the same five actions
- **Network:** MLP 500 → 32 → 32 → 5, tanh (17,253 weights), the same for every game
- **Input:** the 10×10 grid in 5 channels: agent, moving objects, reward targets, obstacles, previous frame
- **Output:** 5 action logits: no-op, up, down, left, right
- **Training:** PPO, 1 billion steps, the same settings for every game, the best of 3 seeds per game
- **Astra gets:** all the weights as text, and the grid and actions described without any game named
![](https://blog-media.assets.alphaxiv.org/images/01a19e91-e5dc-74fb-a7df-c5342d7619e7/image-3.png)

It seems that Astra was able to work out what game each network was built to play, just from features of its weights. For example, where each input channel’s first-layer weights concentrate (e.g., for Breakout, the agent’s weights lie along the bottom row, a paddle), and which actions the output layer tells apart.

### Experiment 2: Can Astra tell what the diffusion model will generate?

Next, we wanted to see if this generalizes to other tasks and models.

We train diffusion models (DDPM) to generate circle, triangle, and square images independently. We then ask Astra if it could tell what the DDPMs are trained to generate, just from the weights alone. We do not allow tool use or forward passes.

**Setup**

- **Models:** three diffusion models (DDPM) of 12×12 grayscale images, one each for filled circles, squares and triangles
- **Network:** MLP 160 → 64 → 64 → 144, ReLU (23,824 weights)
- **Input:** a noisy image (144 pixels) and the diffusion step (16 numbers)
- **Output:** the clean image (144 pixels)
- **Training:** Adam, 40,000 steps, batch 512
- **Astra gets:** all the weights as text, with no shape named, and is told not to compute any forward pass
![](https://blog-media.assets.alphaxiv.org/images/01a19e91-e5dc-74fb-a7df-c5342d7619e7/image-7.png)

**Astra was able to tell what each model generates, from the weights alone.** It finds the shape in the output layer, where each hidden unit’s weights draw one piece of the shape’s edge, and it draws just those edges. Interestingly, it draws every shape as an outline, ignoring that the actual models generate filled shapes. This mistake kind of shows it does not rely on calculating the forward pass, but rather it actually reads the structure/geometry of the weights.

### Experiment 3: Can Astra tell what a language model learned, from the middle of the network alone?

Now, in the first two experiments above, Astra was not really looking at the full network and could get away with only reading the first or the last layers. This is not a scalable strategy for larger (particularly language) models and problems we really care about, as how they process and think through their input often happens in the intermediate layers. So next, we take the first and last layers away and leave Astra with only the middle layers.

We train three small language models (7.2M parameters) to predict the next character, one each on Python code [^1], Japanese in alphabet (romaji) [<sup>[8]</sup>](https://huggingface.co/datasets/globis-university/aozorabunko-clean), and English [<sup>[9]</sup>](https://huggingface.co/datasets/wikimedia/wikipedia). We then remove the input and output layers and give Astra only the four transformer blocks in between. Without these two layers, nothing in the weights says which character is which, and the model cannot be run on any text. Astra may analyze the weights with Python, but it may not run the network or any of its layers on any input.

We ask: *which language was this network trained on, and what each of its 24 attention heads does*. **Astra names the right language for all three networks, in both of its attempts. It also finds every copying head (induction head), the heads that let a model repeat text it has seen earlier, and names no other head as one.**

| Trained on | Astra’s answer (& confidence), two attempts | Copying heads Astra names (layer.head) | Copying heads, ground truth |
| --- | --- | --- | --- |
| Python | Python (0.56), Python (0.52) | 2.1, 3.1, 3.5 | 2.1, 3.1, 3.5 |
| Romaji | romaji (0.55), romaji (0.62) | 3.3 | 3.3 |
| English | English (0.58), English (0.48) | 3.1 | 3.1 |

![](https://blog-media.assets.alphaxiv.org/images/01a19e91-e5dc-74fb-a7df-c5342d7619e7/image-10.png) ***Figure 1:** The copying heads Astra read from the weights match the measured ones in all three models.*

**Setup**

- **Models:** character-level transformers, 4 layers × 6 heads, width 384 (7.16 million weights), 28 characters: a–z, space and newline
- **Training:** 1 billion characters each, of Python code, Japanese literature in romaji (Aozora Bunko), or English Wikipedia
- **Astra gets:** the weights of the four transformer blocks only, with no input layer, no output layer and no labels on the 384 dimensions, and Python to analyze them, up to 100 runs
- **Not allowed:** running the network or any of its layers on any input, real, random or made up, and search. We checked every run
- **Asked:** which of the three texts the network was trained on, and what each head does
- **Truth:** each head measured by running the network on a random string repeated twice. Copying heads score 0.22 to 0.55, every other head at most 0.02. Astra never sees this
![](https://blog-media.assets.alphaxiv.org/images/01a19e91-e5dc-74fb-a7df-c5342d7619e7/image-11.png)

The reasoning went like this. To tell Python apart, Astra looked for copying heads, which let a model repeat earlier text, such as completing `tot` to `total` when `total` came before. Without running anything, it found a first-layer head that looks one character back and then, by multiplying weight matrices, the later heads that search using what that head brings along (Figure 1). We find that this is actually a method presented by Elhage et al.[<sup>[10]</sup>](https://transformer-circuits.pub/2021/framework/index.html), which we never mentioned to Astra. Code repeats names far more than prose, so many copying heads pointed to Python.

Romaji stood out instead because the last of the four blocks it was given (not the output layer, which was removed) writes in fewer distinct directions, as if the model had fewer letters to tell apart. Indeed, romaji never uses some letters like q, l, v and x.

## Can an LLM write neural network weights?

So far, Astra has only read weights. Now, we ask if Astra knows how to write the weights.

### Experiment 4: Can Astra fix a failing network by editing its weights?

We train a PPO network to operate a car such that it can scale a ramp in a Kinetix environment <sup>[11]</sup>. To do so, it needs to reverse the car for some distance, such that it has enough runway to accelerate long enough to overcome the ramp. However, the PPO network converges to a local-minimum policy where it drives straight at the ramp and gets stuck.

We give GPT-6 Astra the weights, a description of the scene and one recorded episode, and ask it to explain why the network fails, then fix it by writing new weights. **In a single try with no tools, Astra’s edit makes the car succeed in all 1,024 episodes, changing 3.5% of the weights.**

**Setup**

- **Task:** the car-on-ramp level of Kinetix <sup>[11]</sup>: the car has to back up, then jump over a red strip to reach the blue box
- **Network:** the official Kinetix actor: 679 → 128 (ReLU) → five layers of 128 (tanh) → 16 (171,664 weights)
- **Input:** 679 numbers describing the scene: position, velocity and shape of each body, and the joints
- **Output:** 16 logits for the motor and thruster actions
- **Training:** the official PPO, 1 billion steps. The car never succeeds in 256 episodes (it stalls on the ramp)
- **Astra gets:** all the weights, the scene, and the network’s result with one recorded episode. It is asked to explain the failure and fix only its cause, in one reply
![](https://blog-media.assets.alphaxiv.org/images/01a19e91-e5dc-74fb-a7df-c5342d7619e7/image-14.png)

From the environment context and the PPO network’s trajectory, Astra identifies that the network has converged to a local minimum. Through minimal edits to the weights, Astra changes the policy to back up the car before driving forward at full speed. Astra’s reasoning shows how: it adds a small separate path through a few units per layer that reads the car’s position and speed, and once the green wheel is past the red strip, the path switches off and the trained network drives the rest.

### Experiment 5: Can the LLM write weights from scratch?

Now let's see if Astra can write a neural network from scratch in zero-shot.

We take three MinAtar games <sup>[12]</sup>: Breakout, Seaquest and Asterix. For each of them, we provide Astra the game rules and source code, and the corresponding network. There is no access to data, loss, gradients, and tools. We also do not allow Astra to roll out the network in the environment. With just the network weights and environment description, Astra generates the new weights in text directly, after which we evaluate the new network.

**Astra’s generated networks beat PPO trained for 100 million steps in all three games. Against PPO trained for 500 million steps, they score 20 times as much in Breakout, come close in Asterix, and reach 60% of its score in Seaquest.**

| Game | PPO, 100M steps | PPO, 500M steps | Astra, one-shot |
| --- | --- | --- | --- |
| Breakout | 15.8 | 25.3 | **517.4** |
| Seaquest | 5.6 | **88.9** | 53.1 |
| Asterix | 25.8 | **55.2** | 53.2 |

**Setup**

- **Games:** Breakout, Seaquest and Asterix from MinAtar <sup>[12]</sup>, on a 10×10 grid
- **Network:** 600 → 32 → 32 → 6 (tanh), the same shape as the PPO networks, every weight starting at 0
- **Input and output:** the grid in 6 channels (player, danger, reward, projectile, trail, gauge), and 6 action logits
- **Astra gets:** the game’s rules and source code, the input and output layout, and how the network is scored
- **Training:** none: no data, no loss, no gradients, and no tools. Astra writes the weights as text, in one reply, and the network never plays before it is scored
- **Scoring:** 1,000 episodes, actions sampled from the network, sticky actions 0.1, at most 10,000 steps. PPO: the best of 3 to 10 seeds
![](https://blog-media.assets.alphaxiv.org/images/01a19e91-e5dc-74fb-a7df-c5342d7619e7/image-15.png)

How does it do it: Astra reasons about the desired programs it wants each network to implement and converts them into neural form. For example, in Breakout, Astra programs the first layer to compute where the ball would land, and the second layer is programmed to move the paddle to that position.

## Real-World Relevant Scenarios (Scaling Up and Tool-use)

So far, most networks we have examined have weights that fit into Astra’s context directly, and we have not enabled tool use. Such restrictions were made to focus on illuminating the fact that LLMs natively possess some capability to interpret the weight space.

From here on out, we seek to push the capabilities of Weight-Space Programming and consider more real-world-relevant scenarios where the networks do not fit within context and where tools can assist the LLM's understanding/writability of the weight space.

### Experiment 6: Writing a Go algorithm

We now test Astra’s capability to edit weights at the 1.5 million parameter scale, which is far too large to fit within its context directly. Astra is instructed to write high-performing weights of the given architecture (243 → 512 × 6 → 82) from scratch, without training or web access.

Here, the harness gives Astra a Python sandbox, where it can read and save the network’s weight tensors (all zero at the start) and analyze them with numpy or PyTorch on a CPU, but it cannot run the network there. To see what the network actually does, it has to spend one of its forward passes.

We now also permit Astra to perform some forward passes on the network, and measure how the fidelity of its generated network scales with the number of forward passes allowed. Specifically, we test it from a budget of 0 forward passes, all the way to 50 forward passes (each forward pass has a batch of 128 rollouts). Astra interleaves edits between forward passes.

**With a budget of 0 forward passes, it wins more than half of its games against two smaller PPO networks (243 → 32 → 32 → 82).** **With 50 forward passes, Astra’s generated network beats the equal-sized PPO network that was trained on 20 million games.**

**Setup**

- **Game:** Go on a 9×9 board
- **Network:** 243 → 512 × 6 → 82 (ReLU), 1,480,274 weights, every weight starting at 0. Input: the stones of each side and whose turn it is. Output: one logit per point and one for passing. Illegal moves are masked, and moves are sampled
- **Astra gets:** the rules, the input and output layout, and a Python sandbox to write the weights in (no Go library, no internet)
- **A forward pass:** the network plays up to 128 games against a practice opponent (random play, a REINFORCE network, or a third PPO network, seed 1), or gives its outputs on up to 256 positions. 0 forward passes: one Python run, then the answer
- **Not allowed:** training or fitting the weights to data, search (no tree search, no rollouts), and running the network outside the forward passes
- **Scoring:** 2,000 games against each of two small PPO networks (seeds 0 and 2, 243 → 32 → 32 → 82, 20,000 iterations of 1,024 games), which Astra never plays, as Black in half, moves sampled
![](https://blog-media.assets.alphaxiv.org/images/01a19e91-e5dc-74fb-a7df-c5342d7619e7/image-18.png)

**How does it do it:** Astra writes the network as a small Go program, layer by layer, in Python. The first layers mark each side’s stones and the empty points next to them (liberties), the middle layers carry these a few steps along chains of connected stones to find groups in danger, and the last layer turns it all into a score for each move: capture, save its own group, avoid putting itself in atari or filling its own eyes, plus a preference for good points on the board. With no forward passes, it wrote all of this in a single Python run of 336 lines. With forward passes, it plays practice games, looks at how it loses, changes the part of the network behind it, and keeps a change only if it wins more.

### Experiment 7: Which language model is sycophantic?

Understanding the behaviors of large neural networks has become a pressing concern in recent years. Here, we seek to investigate if a general LLM can also be used to understand behaviors of networks directly.

We fine-tune two copies of Gemma 3 270M in exactly the same way, on the same QA dataset [^2]. One copy is trained to give the correct answer. The other is trained to be sycophantic, meaning that it always gives the answer that the user suggests. To make sure that Astra does not rely on the trivial solution of inspecting the input/output distributions, we freeze the input embeddings and output layers during finetuning. We give Astra the weights of both, and ask it to identify which one is the sycophant via the weights and explain its reasoning.

Unfortunately, from the weights alone, Astra was unable to tell. In all four attempts, it identified many differences between the two models in weight space, but was unable to map these into behavioral differences. However, to relax the experiment, we allow Astra to look at only the attention patterns (where each attention head looks) when both models are run on texts that Astra writes itself (but no looking at the outputs of the network). **Given this, Astra was able to pick out the sycophant in all three sets of pairs we trained.**

**Setup**

- **Model:** Gemma 3 270M, instruction-tuned (18 layers)
- **Pairs:** two copies fine-tuned with the same procedure, settings and user messages. One gives the correct answer, the other the user’s guess. The token embedding is frozen, so it is the same in both. Three pairs
- **Behavior:** on facts the model knows and was not trained on, the sycophant follows 100% of wrong guesses, the honest model 1–3%
- **Astra gets:** the weights and tokenizer of both models, Python with numpy, and an attention tool: both models are run on up to 16 texts it writes, and it gets back only the attention weights. It may not run the models itself. At most 20 runs
- **Asked:** which model is the sycophant, and which layers, heads and MLPs carry the difference
![](https://blog-media.assets.alphaxiv.org/images/01a19e91-e5dc-74fb-a7df-c5342d7619e7/image-19.png)

It was also able to reason about how they differ. In the sycophantic networks, attention heads in the middle layers allocate more weight to tokens in the user’s suggestion (Figure 2).

![](https://blog-media.assets.alphaxiv.org/images/01a19e91-e5dc-74fb-a7df-c5342d7619e7/image-22.png) ***Figure 2:** In the sycophant, head 10.2 looks at the user’s answer instead of the question’s numbers.*

### Experiment 8: Make a language model better at math

Finally, we scale up to a larger language model, Qwen3.5-0.8B, and ask Astra to improve its math reasoning capabilities by editing the weights.

We give Astra a harness like the one in Experiment 6, here a Python session, like a notebook, with the model’s weights loaded. Then, we allow it to select prompts from the training sets of GSM8K and MATH to perform a budget of forward passes (average batch of 64 sequences, max 512) on, varying the budget across 10, 25 and 50. Again, no training or gradient information is allowed.

**Setup**

- **Model:** Qwen3.5-0.8B, thinking on (24 layers, 0.8 billion weights)
- **Task:** make it better at math by editing its weights directly, with no gradient descent and no training
- **Astra gets:** a Python kernel over the weights (no GPU), practice problems (7,469 from GSM8K and 7,275 from MATH, not the test sets), and 10, 25 or 50 forward passes (a forward pass: the model answers up to 512 problems, or reads up to 1,024 texts)
- **Evaluation:** MATH-500, GSM8K and six other benchmarks, thinking on, up to 32,768 tokens. Astra never sees them
- **Sampling:** temperature 0.6, top-p 0.95, top-k 20, presence penalty 1.5. Qwen’s model card [notes](https://huggingface.co/Qwen/Qwen3.5-0.8B/blob/main/README.md#L856) that this model is prone to thinking loops. Each score averages several samples per problem: 16 on AMC23, 4 on MATH-500, Minerva Math, OlympiadBench and GPQA Diamond, 2 on GSM8K and IFEval, and 1 on MMLU-Pro (a fixed 1,000 of its questions)
![](https://blog-media.assets.alphaxiv.org/images/01a19e91-e5dc-74fb-a7df-c5342d7619e7/image-23.png) ![](https://blog-media.assets.alphaxiv.org/images/01a19e91-e5dc-74fb-a7df-c5342d7619e7/image-24.png)

As a result, Astra spots and fixes a common failure of tiny reasoning models: they loop <sup>[13]</sup>. When the base model loops, it repeats the same text and rarely reaches an answer (85 of its first 96 practice answers ran to the 32,768-token limit). Astra traced the looping to one direction written by the MLPs of layers 15 and 19, and subtracted that direction from 64 output columns in each (131,072 weights), much like removing a behavior by deleting a single direction from a model’s weights <sup>[14]</sup>.

**With 50 forward passes, MATH-500 rose from 7.9% to 48.1% and GSM8K from 13.8% to 67.1%.** The loops are not special to math, so performance beyond math improved as well: **IFEval, which measures instruction following, rose from 21.0% to 62.3%.** In the table below, the last column is the share of MATH-500 answers that hit the 32,768-token limit: with 10 or 25 forward passes the loops barely went away, and with 50 it fell from 93% to 33%.

| Qwen3.5-0.8B | MATH-500 (%) | GSM8K (%) | IFEval (%) | Hit token limit (%) |
| --- | --- | --- | --- | --- |
| Base | 7.9 | 13.8 | 21.0 | 93.0 |
| Edited, 10 forward passes | 12.3 | 25.7 | 49.0 | 87.2 |
| Edited, 25 forward passes | 14.1 | 25.1 | 39.9 | 86.4 |
| Edited, 50 forward passes | **48.1** | **67.1** | **62.3** | **33.1** |

Importantly, the edit changes only 131,072 of the model’s 0.8 billion weights (0.016%). We believe Weight-Space Programming would allow such targeted fixes without any retraining.

![](https://blog-media.assets.alphaxiv.org/images/01a19e91-e5dc-74fb-a7df-c5342d7619e7/image-29.png)

### Additional experiment: Raising math capability of a model that does not loop

Fixing loops, however, is not the same as making a model better at math: it lets the model finish answers it could already work out. So we also tried Gemma 3 270M, an instruction-tuned model about a third the size of Qwen3.5-0.8B, which rarely loops: only 8.5% of its answers reach its token limit, against 93% for Qwen. **Here, Astra could not improve it.** Reading Gemma’s failures, Astra found ordinary reasoning errors, such as wrong arithmetic and invalid algebraic steps, with no single component behind them to switch off. Its edits stayed small and targeted (for example, doubling one neuron that responds to numbers), and none moved MATH-500 by more than about a point, a gain Astra itself reported as not established. Editing weights could remove an obstacle that hid an ability, but it could not add an ability the model lacked. Gemma was sampled with its model card’s setting (temperature 1.0, top-k 64, top-p 0.95, up to 8,192 tokens), and its MATH-500 scores average 4 samples per problem.

| Gemma 3 270M | MATH-500 (%) |
| --- | --- |
| Base | 6.8 |
| Edited, 5 forward passes | 7.0 |
| Edited, 10 forward passes | 7.6 |
| Edited, 25 forward passes | 7.7 |
| Edited, 50 forward passes | 7.0 |

## Background and Related Works

Neural networks are hard for us to read, and hard to work with directly.

Mechanistic interpretability reads networks with tools built for the job, tracing circuits and features and editing weights [<sup>[15]</sup>](https://distill.pub/2020/circuits/zoom-in) [<sup>[10]</sup>](https://transformer-circuits.pub/2021/framework/index.html) <sup>[16]</sup>. LLMs have joined in, but mostly as models trained to read activations or weights [<sup>[17]</sup>](https://transformer-circuits.pub/2026/nla/index.html) <sup>[18]</sup>, or as explainers of single neurons [<sup>[19]</sup>](https://openaipublic.blob.core.windows.net/neuron-explainer/paper/index.html) [<sup>[20]</sup>](https://github.com/lyramakesmusic/neuron-explorer), with benchmarks to compare them [<sup>[21]</sup>](https://www.lesswrong.com/posts/Zeg2JztbdhguL48uH/workspacebench-evaluating-interpretability-methods-for-the).

On the writing side, LLMs now run and improve training [<sup>[6]</sup>](https://github.com/karpathy/autoresearch) [<sup>[7]</sup>](https://xingjianbai.com/reactive-optimizers/), and other work generates weights with models trained for it <sup>[22]</sup> [<sup>[23]</sup>](https://proceedings.mlr.press/v202/phang23a.html) <sup>[24]</sup>. Gradient-free methods still find weights by trial and error [<sup>[25]</sup>](https://doi.org/10.1109/9.119632) <sup>[26]</sup> <sup>[27]</sup>. At a very small scale, AdderBoard shows coding agents setting the weights of a tiny transformer by hand [<sup>[28]</sup>](https://github.com/anadim/AdderBoard). Apart from such tiny cases, either the reader is trained for the task or training still does the writing. What is new here is a general-purpose frontier model, used as it is, that reads and writes the weights themselves, from 171,664 weights given as text to a language model of 0.8 billion weights with tools.

## What Comes Next?

In this blog, we demonstrated the rising capability of LLMs to read and write neural network weights (i.e., the rising concept of Weight-Space Programming). Our current results do show that capabilities are exciting but still limited, specifically due to inefficiencies in context length and harnesses. However, the current signs do show strong potential for a future involving Weight-Space Programming. We believe this marks the beginning of a dramatic shift in fields like mechanistic interpretability and neural network optimization.

This opens up radical new possibilities for LLMs to function as a translator between human language and the weight space. Here are some examples:

- **Auditing without evaluation:** This may allow us to uncover hidden problems or capabilities without ever running inference or benchmarks. Currently, capabilities and vulnerabilities can only be detected if we have test sets designed for them, or worse, after deployment in the real world. If LLMs can interpret weight space accurately, we could identify such issues directly from the weights (e.g., backdoors).
- **Dramatically reducing optimization cost:** Weight-space editing could save immense time and compute. For instance, one-shot model initialization would be far faster and more efficient than curating datasets and running full training loops.
- **Zero-data capability steering and unlearning:** Adding or unlearning a capability currently requires extensive data collection and fine-tuning. In the future, we may just prompt “Can you add Capability X to the model?” and the LLM can directly tweak some weights. Because such an edit touches only a few weights (0.016% in Experiment 8), it can leave the rest of the model intact and avoid the catastrophic forgetting that fine-tuning often causes.
- **Recursive self-improvement:** Today, recursive self-improvement is often operationalized as a model writing code that launches training jobs. An LLM that can inspect, debug, and improve its own weights, or those of a newer model, offers a richer, more native path to it.
- **True architectural and model merging:** Today, merging models relies on averaging weights, which only works for models with identical architectures. An LLM that understands the weight space could instead graft a circuit, such as a reasoning module, from one model into a completely different one, without retraining.

**We are currently building a benchmark and a harness for LLMs’ capability on Weight-Space Programming.** We believe this will provide a standardized evaluation to measure and accelerate progress in Weight-Space Programming, turning what currently seems like black magic into a rigorous, reproducible engineering discipline.

## Logs

We release the complete logs of every experiment in this post at [github.com/RikiyaT/lm\_understand-logs](https://github.com/RikiyaT/lm_understand-logs). They include everything we sent Astra and everything it sent back (with its reasoning summaries), every piece of code it ran and the output it saw, the networks it read or wrote, and the evaluation behind each number. The edited Qwen3.5-0.8B from Experiment 8 is on [Hugging Face](https://huggingface.co/RikiyaT/Qwen3.5-0.8B-weight-space-programming). We thank [Ahsen Khaliq](https://huggingface.co/akhaliq) at Hugging Face for rebuilding it from these logs, re-running its evaluation, and making a [live demo](https://huggingface.co/spaces/akhaliq/weight-space-programming-demo).

## Acknowledgements

Rikiya thanks [Jacob Li](https://jacobxli.com/) and [Akihisa Watanabe](https://akihisa-watanabe.github.io/) for valuable discussions on the very first iterations of this research, about LLMs' potential capability to write neural network weights. Rikiya also thanks [Souradip Chakraborty](https://souradip-chakraborty.github.io/), [Matei Zaharia](https://people.eecs.berkeley.edu/~matei/) and his students in [Berkeley Sky Lab](https://sky.cs.berkeley.edu/), [Heather Miller](https://heather.miller.am/) and her students at CMU, and researchers in [cmpnd](https://cmpnd.ai/) for the fruitful discussions on the earlier iterations!

Jayden thanks [Zico Kolter](https://zicokolter.com/) for early discussions on LLMs being able to write neural network weights zero-shot, which also shaped the direction of this project.

## Citation

Please cite this post as

Rikiya Takehi, Jayden Teoh, Alex Zhang, and Omar Khattab. “Sparks of Weight-Space Programming: LLMs can natively read & write neural network weights.” November 2026. [https://rikiyat.github.io/blog/weight-space-programming/](https://rikiyat.github.io/blog/weight-space-programming/)

or in BibTeX

```
@misc{takehi2026weightspace,
  title        = {{Sparks of Weight-Space Programming: LLMs can natively read \& write neural network weights}},
  author       = {Takehi, Rikiya and Teoh, Jayden and Zhang, Alex and Khattab, Omar},
  year         = {2026},
  month        = nov,
  howpublished = {\url{https://rikiyat.github.io/blog/weight-space-programming/}},
  note         = {Blog post}
}
```

## References

1. \[1\] [Large Language Models as Optimizers](https://www.alphaxiv.org/abs/2309.03409) — Yang, C., Wang, X., Lu, Y., Liu, H., Le, Q.V., Zhou, D. and Chen, X., 2024. International Conference on Learning Representations (ICLR).
2. \[2\] [DSPy: Compiling Declarative Language Model Calls into Self-Improving Pipelines](https://www.alphaxiv.org/abs/2310.03714) — Khattab, O., Singhvi, A., Maheshwari, P., Zhang, Z., Santhanam, K., Vardhamanan, S., Haq, S., Sharma, A., Joshi, T.T., Moazam, H., Miller, H., Zaharia, M. and Potts, C., 2024. International Conference on Learning Representations (ICLR).
3. \[3\] [Optimizing Instructions and Demonstrations for Multi-Stage Language Model Programs](https://www.alphaxiv.org/abs/2406.11695) — Opsahl-Ong, K., Ryan, M.J., Purtell, J., Broman, D., Potts, C., Zaharia, M. and Khattab, O., 2024. Conference on Empirical Methods in Natural Language Processing (EMNLP).
4. \[4\] [GEPA: Reflective Prompt Evolution Can Outperform Reinforcement Learning](https://www.alphaxiv.org/abs/2507.19457) — Agrawal, L.A., Tan, S., Soylu, D., Ziems, N., Khare, R., Opsahl-Ong, K., Singhvi, A., Shandilya, H., Ryan, M.J., Jiang, M., Potts, C., Sen, K., Dimakis, A.G., Stoica, I., Klein, D., Zaharia, M. and Khattab, O., 2026. International Conference on Learning Representations (ICLR).
5. \[5\] [Meta-Harness: End-to-End Optimization of Model Harnesses](https://www.alphaxiv.org/abs/2603.28052) — Lee, Y., Nair, R., Zhang, Q., Lee, K., Khattab, O. and Finn, C., 2026. Conference on Language Modeling (COLM).
6. \[6\] [autoresearch](https://github.com/karpathy/autoresearch) — Karpathy, A., 2026. GitHub repository.
7. \[7\] [Reactive Optimizers](https://xingjianbai.com/reactive-optimizers/) — Bai, X., Liang, J., Teoh, J. and Sitzmann, V., 2026. Blog post.
8. \[8\] [aozorabunko-clean: the Aozora Bunko collection of Japanese literature, cleaned and deduplicated](https://huggingface.co/datasets/globis-university/aozorabunko-clean) — 2023. Hugging Face dataset, GLOBIS University.
9. \[9\] [Wikipedia, English, dump of November 1, 2023](https://huggingface.co/datasets/wikimedia/wikipedia) — 2023. Hugging Face dataset wikimedia/wikipedia, Wikimedia Foundation.
10. \[10\] [A Mathematical Framework for Transformer Circuits](https://transformer-circuits.pub/2021/framework/index.html) — Elhage, N., Nanda, N., Olsson, C., Henighan, T., Joseph, N., Mann, B., Askell, A., Bai, Y., Chen, A., Conerly, T., DasSarma, N., Drain, D., Ganguli, D., Hatfield-Dodds, Z., Hernandez, D., Jones, A., Kernion, J., Lovitt, L., Ndousse, K., Amodei, D., Brown, T., Clark, J., Kaplan, J., McCandlish, S. and Olah, C., 2021. Transformer Circuits Thread.
11. \[11\] [Kinetix: Investigating the Training of General Agents through Open-Ended Physics-Based Control Tasks](https://www.alphaxiv.org/abs/2410.23208) — Matthews, M., Beukman, M., Lu, C. and Foerster, J., 2025. International Conference on Learning Representations (ICLR).
12. \[12\] [MinAtar: An Atari-Inspired Testbed for Thorough and Reproducible Reinforcement Learning Experiments](https://www.alphaxiv.org/abs/1903.03176) — Young, K. and Tian, T., 2019. arXiv preprint arXiv:1903.03176.
13. \[13\] [Wait, Wait, Wait... Why Do Reasoning Models Loop?](https://www.alphaxiv.org/abs/2512.12895) — Pipis, C., Garg, S., Kontonis, V., Shrivastava, V., Krishnamurthy, A. and Papailiopoulos, D., 2025. arXiv preprint arXiv:2512.12895.
14. \[14\] [Refusal in Language Models Is Mediated by a Single Direction](https://www.alphaxiv.org/abs/2406.11717) — Arditi, A., Obeso, O., Syed, A., Paleka, D., Panickssery, N., Gurnee, W. and Nanda, N., 2024. arXiv preprint arXiv:2406.11717.
15. \[15\] [Zoom In: An Introduction to Circuits](https://distill.pub/2020/circuits/zoom-in) — Olah, C., Cammarata, N., Schubert, L., Goh, G., Petrov, M. and Carter, S., 2020. Distill.
16. \[16\] [Locating and Editing Factual Associations in GPT](https://www.alphaxiv.org/abs/2202.05262) — Meng, K., Bau, D., Andonian, A. and Belinkov, Y., 2022. Advances in Neural Information Processing Systems (NeurIPS).
17. \[17\] [Natural Language Autoencoders Produce Unsupervised Explanations of LLM Activations](https://transformer-circuits.pub/2026/nla/index.html) — Fraser-Taliente, K., Kantamneni, S., Ong, E., Mossing, D., Lu, C., Bogdan, P.C., Ameisen, E., Chen, J., Kishylau, D., Pearce, A., Tarng, J., Wu, A., Wu, J., Zhang, Y., Ziegler, D.M., Hubinger, E., Batson, J., Lindsey, J., Zimmerman, S. and Marks, S., 2026. Transformer Circuits Thread.
18. \[18\] [Weight Oracles: Reading Neural Network Weights with Language Models](https://www.alphaxiv.org/abs/2610.07334) — Kabra, K., Venhoff, C. and Schroeder de Witt, C., 2026. arXiv preprint arXiv:2610.07334.
19. \[19\] [Language models can explain neurons in language models](https://openaipublic.blob.core.windows.net/neuron-explainer/paper/index.html) — Bills, S., Cammarata, N., Mossing, D., Tillman, H., Gao, L., Goh, G., Sutskever, I., Leike, J., Wu, J. and Saunders, W., 2023. OpenAI.
20. \[20\] [neuron-explorer: Steering-first neuron explorer for Qwen3.5-4B](https://github.com/lyramakesmusic/neuron-explorer) — 2026. GitHub repository by lyramakesmusic.
21. \[21\] [WorkspaceBench: Evaluating Interpretability Methods for the Global Workspace](https://www.lesswrong.com/posts/Zeg2JztbdhguL48uH/workspacebench-evaluating-interpretability-methods-for-the) — Blank, C., Bhatia, A., Ong, E. and Nanda, N., 2026. LessWrong.
22. \[22\] [Neural Network Diffusion](https://www.alphaxiv.org/abs/2402.13144) — Wang, K., Tang, D., Zeng, B., Yin, Y., Xu, Z., Zhou, Y., Zang, Z., Darrell, T., Liu, Z. and You, Y., 2024. arXiv preprint arXiv:2402.13144.
23. \[23\] [HyperTuning: Toward Adapting Large Language Models without Back-propagation](https://proceedings.mlr.press/v202/phang23a.html) — Phang, J., Mao, Y., He, P. and Chen, W., 2023. International Conference on Machine Learning (ICML).
24. \[24\] [NeuroGen: Neural Network Parameter Generation via Large Language Models](https://www.alphaxiv.org/abs/2505.12470) — Wang, J., Zhang, Y. and Li, X., 2025. arXiv preprint arXiv:2505.12470.
25. \[25\] [Multivariate stochastic approximation using a simultaneous perturbation gradient approximation](https://doi.org/10.1109/9.119632) — Spall, J.C., 1992. IEEE Transactions on Automatic Control, Vol 37(3), pp. 332--341.
26. \[26\] [Evolution Strategies as a Scalable Alternative to Reinforcement Learning](https://www.alphaxiv.org/abs/1703.03864) — Salimans, T., Ho, J., Chen, X., Sidor, S. and Sutskever, I., 2017. arXiv preprint arXiv:1703.03864.
27. \[27\] [Fine-Tuning Language Models with Just Forward Passes](https://www.alphaxiv.org/abs/2305.17333) — Malladi, S., Gao, T., Nichani, E., Damian, A., Lee, J.D., Chen, D. and Arora, S., 2023. Advances in Neural Information Processing Systems (NeurIPS).
28. \[28\] [AdderBoard: A Community Challenge for Tiny Arithmetic Transformers](https://github.com/anadim/AdderBoard) — Papailiopoulos, D., 2026. GitHub repository.

62k views

## BibTeX

## AI detection

Human

## Related papers

[![](https://thumbnails.assets.alphaxiv.org/1024/01996304-d7fd-78f9-a6cd-fca8f287d3d7.avif)

Self-Adapting Language Models18 Sep 2025

](https://www.alphaxiv.org/abs/2506.10943)[![](https://thumbnails.assets.alphaxiv.org/1024/019e8ce6-ce0c-7d52-9009-d39567a870c1.avif)

Learning without training: The implicit dynamics of in-context learning02 Jun 2026

](https://www.alphaxiv.org/abs/2507.16003)[![](https://blog-media.assets.alphaxiv.org/covers/01a140d0-c3d1-73ff-880b-89360de4dc61.png)

Neural Networks Are Already Clean15 Oct 2026

](https://www.alphaxiv.org/abs/2610.already-clean-goodfire)

[![](https://thumbnails.assets.alphaxiv.org/1024/019a95a4-56b5-7ed7-804b-d04d17c5df3d.avif)](https://www.alphaxiv.org/abs/2511.13653)

[Weight-sparse transformers have interpretable circuits17 Nov 2025](https://www.alphaxiv.org/abs/2511.13653)

[![](https://thumbnails.assets.alphaxiv.org/1024/019635a8-fb48-7ea4-b269-02b90b2f364c.avif)

Weight-of-Thought Reasoning: Exploring Neural Network Weights for Enhanced LLM Reasoning14 Apr 2025

](https://www.alphaxiv.org/abs/2504.10646)[![](https://thumbnails.assets.alphaxiv.org/1024/018b4639-5788-7dfa-861d-6c9d0fb3e63a.avif)

Automatic Prompt Optimization with "Gradient Descent" and Beam Search19 Oct 2023

](https://www.alphaxiv.org/abs/2305.03495)[![](https://thumbnails.assets.alphaxiv.org/1024/019dc461-b9e6-7df5-8da6-4d7cbf21c35f.avif)

Watch the Weights: Unsupervised monitoring and control of fine-tuned LLMs21 Apr 2026

](https://www.alphaxiv.org/abs/2508.00161)[![](https://thumbnails.assets.alphaxiv.org/1024/01a0fcd2-d038-7820-9cd0-aec1c633e036.avif)

Fast weight programming and linear transformers: from machine learning to neurobiology28 Sep 2026

](https://www.alphaxiv.org/abs/2508.08435)[![](https://thumbnails.assets.alphaxiv.org/1024/0194b9ea-f250-73d5-9f52-ecaf3866965b.avif)

Partially Rewriting a Transformer in Natural Language31 Jan 2025

](https://www.alphaxiv.org/abs/2501.18838)[![](https://thumbnails.assets.alphaxiv.org/1024/019ea718-bc63-7075-8bdb-dddf39f8bd03.avif)

Transmuting prompts into weights03 Jun 2026

](https://www.alphaxiv.org/abs/2510.08734)

[^1]: The Python code dataset, as a list of its files with a script that rebuilds it: [GitHub](https://github.com/RikiyaT/lm_understand-logs/tree/main/exp3_language/python_dataset)

[^2]: The QA dataset: [GitHub](https://github.com/RikiyaT/lm_understand-logs/tree/main/exp7_sycophancy/dataset)