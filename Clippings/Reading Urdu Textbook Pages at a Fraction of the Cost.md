---
title: "Reading Urdu Textbook Pages at a Fraction of the Cost"
source: "https://hellorumi.ai/blog/reading-urdu-textbook-pages?utm_campaign=ai-tinkerers__post-training__top-ai-demos-54-urdu-textbooks-pandemic-agents-and-design-system-validation&utm_content=link4&utm_medium=ai-tinkerers&utm_source=post-training"
author:
  - "[[Rumi]]"
published: 2026-10-27
created: 2026-11-24
description: "An open Urdu OCR model paired with an open language model matched 90% of the words on hand-checked textbook pages, against 93% for a frontier model, at about one eightieth of the cost."
tags:
  - "clippings"
---
Evaluation report

How an open Urdu OCR model and an open language model came within three points of a frontier model on page truth, for about one eightieth of the price.

Abstract Every Rumi lesson plan for Islamabad's schools starts with a model reading a textbook page and writing down everything on it. We call that record the page truth. Production has been writing it with a frontier model, Claude Sonnet 5, at about 8 cents a page. We tested four language models and four specialist OCR models on Urdu textbook pages, then paired the best OCR model, UTRNet, with the open model Gemma 4 31B. The pair matched 90% of the words on hand-checked pages, against 93% for Sonnet, at about a tenth of a cent a page. It keeps fewer of the diacritics that early-grade Urdu teaches, but on cost and quality together it is the best option we have, so it now writes page truth for every Urdu grade.

## 1\. Introduction

A lesson plan is only as good as the reading the whole pipeline was built on.

Rumi turns the official textbooks used in Islamabad's government schools into lesson plans, slides and voice notes for teachers. Each of those is built from a record of the textbook page. If a word is misread there, it is misread in the lesson plan, the slides and the voice note, and by then nobody can tell where it came from.

For Urdu, reading the page is harder than it looks. The books are printed in Nastaliq, the slanted, joined script in which letters change shape and stack along a diagonal. Early-grade books also print the short-vowel marks, because pronouncing the word is what the child is learning.

Page truth A structured record of one textbook page: its text word for word, headings, exercises with answers, pictures, tables and page number.

OCR Optical character recognition. A model that turns an image of text into text.

Diacritics (aeraab) The short-vowel marks zabar, zer and pesh, as in بَـرِ. Dropping them on a Grade 1 page removes the point of the lesson.

Nastaliq The script style of Urdu print. Most Arabic-script OCR is trained on Naskh, an upright style.

Open model A model whose weights we can download and run ourselves.

## 2\. The problem

Nobody had ever compared the model in production with anything else.

When the pipeline was built, production chose Claude Sonnet to write page truth, the strongest model available at the time. That was a sensible default. It had never been compared with anything, and three pressures made it worth testing:

1. 1 **Cost.** About 8 cents a page. The ICT corpus runs to thousands of pages across subjects and grades, and every new region or textbook edition is read again.
2. 2 **Control.** A closed model can change or be withdrawn. An open model can run on our own machines.
3. 3 **Quality.** Nobody had checked whether a model built for Urdu print reads it better than a general model.

In practiceThe model you started with is a default, not a decision.

## 3\. The use case

Page truth is written once per page and read by every later stage.

The model gets the page image and production's page-truth instructions, and returns one JSON record. We tested the reading step on its own, with everything after it held fixed.

**Textbook page** PDF page rendered at 200 dpi

→

**Page truth** text, headings, exercises, pictures

→

**Lesson** segmentation and enrichment

→

**Teacher** lesson plan, slides, voice note

Figure 1. Where page truth sits. We tested the two highlighted steps.

## 4\. Experimental setup

### 4a. Models

We ran four language models and four specialist OCR models, with the model already in production as the baseline.

| Model | Kind | Why it was included |
| --- | --- | --- |
| Claude Sonnet 5 | Language model, closed | The page-truth model in production (the baseline) |
| GPT-4o | Language model, closed | The common default for many teams |
| Gemma 4 31B | Language model, open | Cheap, and we can host it ourselves |
| Qwen 3.8 27B | Language model, open, reasoning | Strong on many benchmarks; thinks before answering |
| UTRNet | OCR, open | Built for printed Urdu in Nastaliq [\[1\]](#r1) |
| PaddleOCR-VL 1.6 | Document OCR, open | Lists Urdu among its 109 languages [\[2\]](#r2) |
| PaddleOCR-VL 1.5 | Document OCR, open | The previous release, to rule out a regression |
| Qaari 0.1 | Urdu OCR, open | A small model fine-tuned for Urdu OCR |
| Gemma 4 31B + UTRNet | Language model + OCR, open | Our pairing of the cheapest good reader with the best OCR model (4e) |

Table 1. What we tested.

In practiceWe tested the specialist OCR models alongside the general ones, including two that run free on a laptop or a free GPU.

### 4b. Dataset

Five Urdu lessons, one from each of Grades 1 to 5, covering 13 textbook pages. That spans the heavily pointed early-grade pages and the denser text of the later grades. Eight of the pages had page truth that had been checked against the printed book, and those eight are our answer key. All 13 pages were used for the rule checks.

In practiceThe pages include glossaries, letter-joining exercises, poems and pictures, the mix a real lesson brings.

### 4c. Evaluation metrics

| Measure | What it stands for |
| --- | --- |
| Words matched | Share of the answer key's words the model wrote, in any order. Arabic and Urdu letter shapes are treated as the same letter. |
| Spelling accuracy | Characters right, in reading order (1 minus the character error rate) |
| Diacritics kept | Short-vowel marks on a heavily pointed Grade 1 page, and pointed words that match the book exactly |
| Rule checks | Production's own page-truth rules, such as "a Grade 1 to 3 page keeps its diacritics" (rule E1) |
| Structure | Exercises and pictures found, against the answer key |
| Cost and time | List price per page, and seconds per page |

Table 2. What we measured.

### 4d. Evaluation method

1. 1 **Same page, same instructions.** Every language model got the page image and production's page-truth brief, pinned by content hash so we know exactly which text ran.
2. 2 **OCR models as their makers run them.** UTRNet through its own published code and settings, PaddleOCR-VL through PaddleOCR's official pipeline on a Kaggle GPU.
3. 3 **A blind second opinion.** Claude Opus 5.5 saw the page and unlabelled records, with the answer key hidden among them, and ranked them.

### 4e. Pairing a language model with OCR

An OCR model returns lines of text with no page structure. A language model returns the structure production needs, but a cheap one may drop the diacritics. So we also tested the two together: UTRNet reads the page first, and Gemma 4 31B writes the page truth with UTRNet's text as a hint.

**UTRNet** reads the page on a laptop: Urdu lines with diacritics

→

**Gemma 4 31B** page image + production's brief + UTRNet's text as a hint

→

**Restore step** puts UTRNet's diacritics back on words Gemma left bare

→

**Page truth** headings, text, exercises, pictures

Figure 2. The pairing. The restore step is plain code: it adds marks only where Gemma wrote the same letters unpointed, and never respells a word.

We built it in steps, so each part's effect can be seen on its own: the restore step alone, UTRNet's text passed to Gemma with a plain prompt, and a second prompt that tells Gemma what the OCR tends to get wrong and lists UTRNet's pointed words, followed by the restore step.

## 5\. Results

Every setup was run on the same pages. Figure 3 compares the language models, the OCR models and the pairing on words matched and cost. Table 3 adds the rest of the measures.

Words matched, 8 hand-checked Urdu pages

Mean across pages, with cost per 1,000 pages.

Sonnet 5 (baseline)93%$80

Gemma 4 + UTRNet90%$1.0

Gemma 4 31B86%$0.80

UTRNet78%N/A

Qwen 3.8 27B72%$42

GPT-4o62%$13

PaddleOCR-VL 1.646%N/A

Qaari 0.125%N/A

Sonnet baselineLanguage model + OCROCR modelsOther language models

Figure 3. Every setup on the same eight pages. Language models are priced at list rates through OpenRouter. The OCR models ran on a laptop CPU or a free GPU, so they have no price per page (N/A). The pairing costs what Gemma costs.

**What this shows:** Sonnet reads best, which is why production chose it. Gemma 4 with UTRNet comes within three points for about one eightieth of the cost. Gemma alone is seven points behind, and among the OCR models only UTRNet comes close.

<table><thead><tr><th>Setup</th><th>Words matched</th><th>Spelling</th><th>Diacritics, G1 p.11</th><th>Pointed words exact</th><th>E1 fails</th></tr></thead><tbody><tr><th colspan="6">LANGUAGE MODELS</th></tr><tr><td>Claude Sonnet 5 (baseline)</td><td>93%</td><td>89%</td><td>79%</td><td>12 of 15</td><td>4%</td></tr><tr><td>Gemma 4 31B</td><td>86%</td><td>83%</td><td>17%</td><td>4 of 4</td><td>7%</td></tr><tr><td>Qwen 3.8 27B</td><td>72%</td><td>74%</td><td>N/A</td><td>N/A</td><td>N/A</td></tr><tr><td>GPT-4o</td><td>62%</td><td>52%</td><td>N/A</td><td>N/A</td><td>N/A</td></tr><tr><th colspan="6">OCR MODELS</th></tr><tr><td>UTRNet</td><td>78%</td><td>N/A</td><td>N/A</td><td>N/A</td><td>N/A</td></tr><tr><td>PaddleOCR-VL 1.6</td><td>46%</td><td>N/A</td><td>N/A</td><td>N/A</td><td>N/A</td></tr><tr><td>Qaari 0.1</td><td>25%</td><td>N/A</td><td>N/A</td><td>N/A</td><td>N/A</td></tr><tr><th colspan="6">LANGUAGE MODEL + OCR, BUILT STEP BY STEP</th></tr><tr><td>Gemma + restore only</td><td>86%</td><td>N/A</td><td>33%</td><td>6 of 15</td><td>3%</td></tr><tr><td>Gemma + UTRNet, first prompt</td><td>80%</td><td>N/A</td><td>17%</td><td>4 of 11</td><td>5%</td></tr><tr><td>Gemma + UTRNet, v2 prompt + restore</td><td>90%</td><td>N/A</td><td>42%</td><td>6 of 19</td><td>2%</td></tr></tbody></table>

Table 3. Every setup, every measure. N/A: not measured for that setup. Diacritics on G1 p.11 count marks against the book. "Pointed words exact" compares every pointed word a setup wrote on the Grade 1 to 3 pages with the book's exact pointing. E1 fails is the share of the rule's checks that failed across the 13 pages. UTRNet's time is on a laptop CPU.

### 5.1 Language models

Sonnet led on every measure except exercises, where Qwen found one more. Gemma read the words nearly as well, at one hundredth of the cost, but wrote almost none of the diacritics: 17% of the marks on the Grade 1 glossary page, against Sonnet's 79%. GPT-4o misread Nastaliq badly enough to rule it out, and found only 10 of 40 pictures. Qwen took more than five minutes a page, once seventeen.

In practiceA cheap open model can read Urdu words. What it cannot yet do on its own is keep the diacritics.

### 5.2 OCR models

| Model | Words matched | What went wrong | Verdict |
| --- | --- | --- | --- |
| UTRNet | 78% | No page structure; reads some lines twice; garbles ﷺ; reads two-column glossaries row by row; pointing often partial | **Keep** |
| PaddleOCR-VL 1.6 | 46% | Only 54% of the words it wrote were right; read letter-joining exercises as maths; labelled exercise panels as pictures; added Arabic phrases next to ﷺ | Drop for Urdu |
| Qaari 0.1 | 25% | Repetition loops; 40% of words matched even after cutting them | Drop |

Table 4. How each OCR model failed on our pages.

**UTRNet** did well because it is trained specifically on printed Urdu in Nastaliq [\[1\]](#r1). It finds each line of text with a small detector and reads it with that recognizer. It read Nastaliq properly, got lesson numbers and whole sentences right, never drifted into Arabic, and wrote diacritics, in about seven seconds a page on a laptop CPU with no GPU. What it lacks is everything around the text: it returns plain lines, with no headings, exercises or pictures.

**PaddleOCR-VL** lists Urdu among its supported languages, so we gave it a fair test through PaddleOCR's official pipeline, which read the project's own demo page cleanly. On our pages it was behind every language model we tried, and version 1.5 did no better. Our untested guess is that it learned Arabic-script print mostly from Naskh, while our books are Nastaliq. **Qaari 0.1** is not usable for this job.

In practiceA model trained on Urdu print reads it far better than a general document model that lists Urdu as supported.

### 5.3 Language model + OCR

UTRNet reads the words and the diacritics but gives no structure. Gemma gives the structure cheaply but drops the diacritics. Table 3's last block shows what pairing them did, step by step:

1. 1 **Restore step alone.** Diacritics on the Grade 1 page doubled, from 17% to 33%, with words matched unchanged at 86%.
2. 2 **UTRNet's text with a plain prompt.** Worse: words matched fell to 80%, because Gemma copied UTRNet's misreads.
3. 3 **A prompt that warns about OCR errors, plus the restore step.** Words matched rose to 90%, diacritics to 42%, and E1 rule failures fell to 2%, lower than Sonnet's 4%.

The pairing costs about $1 per 1,000 pages, against Sonnet's $80, and takes about the same time, close to a minute a page.

In practiceEach model covers the other's weak spot, but only once the language model is told not to trust the OCR blindly.

### 5.4 Where the pairing falls short

![Table 5. Six Urdu glossary words with their original vowel marks, comparing the book, Gemma alone, Gemma with UTRNet, and Sonnet 5. The pairing matches the book's pointing on one word, while Sonnet matches four.](https://hellorumi.ai/__l5e/assets-v1/890dd52c-1c01-4f78-ba37-2557a99c9028/issue14-revised-glossary.webp)

Table 5. Spot check: the Grade 1 p.11 glossary.

The pairing's diacritics are UTRNet's, and UTRNet often points a word only partly. On the Grade 1 glossary it wrote رَہْبر for the book's رَہبَر, and matched the book's pointing on one of these six words, where Sonnet matched four. It also finds less of the page's structure: 12 of 18 exercises and 25 of 40 pictures, against Sonnet's 15 and 35. The OCR hint helps with words, not with layout.

### 5.5 What we are changing

Gemma 4 31B with UTRNet now writes page truth for every Urdu grade, 1 to 5. Weighing the results above together, it is the best option we have:

1. 1 **Quality:** 90% of words matched against Sonnet's 93%, and fewer rule checks failed (2% against 4%).
2. 2 **Cost:** about $1 per 1,000 pages instead of $80. Reading the whole corpus again, for a new edition or a new region, becomes a rounding error.
3. 3 **Control:** UTRNet runs on a laptop and Gemma is an open model, so the whole step can run on machines we control.

The trade-off is diacritics on early-grade pages, where Sonnet keeps about four marks in five and the pairing about two in five. Two safeguards cover it:

- RulesProduction's own rule checks run on every page, so a Grade 1 to 3 page that loses its pointing is flagged whichever model wrote it.
- NextBetter pointing is the next thing to improve, starting with the OCR step, since the pairing's diacritics come from UTRNet.

In practiceOne open pipeline for all of Urdu, at a small fraction of the cost, with its one weak spot checked on every page.

## 6\. Conclusion

We had been paying a frontier model to read every Urdu textbook page.

An open OCR model trained on Urdu print, paired with an open language model, reads within three points of it for about one eightieth of the cost. It now writes page truth for every Urdu grade. It keeps fewer diacritics than the frontier model, so pointing on early-grade pages is checked on every page and is the next thing we will improve.

Two lessons carry beyond this project. **A specialist model trained on the right script can beat a general model many times its size, and the two together beat either alone.** And a language a model lists as supported is a claim to test on your own pages, not a result.

### References

- 1Rahman, Ghosh and Arora (2023). UTRNet: High-Resolution Urdu Text Recognition in Printed Documents. ICDAR 2023. [arXiv:2306.15782](https://arxiv.org/pdf/2306.15782)
- 2Cui et al. (2025). PaddleOCR-VL: Boosting Multilingual Document Parsing via a 0.9B Ultra-Compact Vision-Language Model. [arXiv:2510.14528](https://arxiv.org/pdf/2510.14528)
- 3Hada et al. (2024). Are Large Language Model-based Evaluators the Solution to Scaling Up Multilingual Evaluation? Findings of EACL 2024. [arXiv:2309.07462](https://arxiv.org/pdf/2309.07462)

## Read the code, try the bot, or join the conversation.

Rumi is open source. If you are turning textbooks in under-served scripts into teaching material, the repository and the WhatsApp community are the fastest way to compare notes.