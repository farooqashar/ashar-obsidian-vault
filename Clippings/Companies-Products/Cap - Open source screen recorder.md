---
title: "Free Screen Recorder & Open Source Loom Alternative"
source: "https://cap.so/"
author:
published:
created: 2026-09-22
description: "Cap is the free, open source screen recorder for Mac, Windows, and Linux. Record, edit, take screenshots, and share videos with a link."
tags:
  - "clippings"
  - "saas-products"
---
Cap has 3 modes

## One app for every workflow

Record and share with Instant, edit your videos with Studio, or capture and customize images with Screenshot.

[Download Cap free](https://cap.so/download)

Studio Mode

## Record in full quality, edit before you share

Studio records at the highest quality straight to your device, with no compression and no upload. Then blur what is private, switch scenes between screen and camera, add text and captions, and set the look before anyone sees it.

### Records locally in full quality

4K at 60fps straight to your device, with no compression and no upload. Screen, camera, and mic each stay on their own track.

### An editor built in

### Automatic zoom and cursor effects

- Custom backgrounds
	Gradients, wallpapers, colours
- Adjustable padding
	Scale from 0% to 40%
- Blur sensitive areas
	Mask, pixelate, or highlight
- Scenes and split screen
	Camera only, split, or floating
- Text and captions
	Animated titles, local captions
- Cursor effects
	Sizing, smoothing, click effects

Studio Mode · The editor

## Polish it before anyone sees it

Studio Mode opens straight into an editor made for screen recordings. Blur what is private, switch scenes between screen and camera, add text and captions, grade the color, and export in 4K or as a link.

- ### Blur what is private
	Drop a mask over a password, an email, or a face and choose blur or pixelate. Or flip it to a highlight that dims everything else.
- ### Scenes for screen and camera
	Switch any stretch of the timeline to camera only, hide camera, split screen, or floating cards, each with its own transition.
- ### Automatic zoom
	Generate zooms from your recorded clicks, or draw your own from 1x to 4.5x with a fixed focal point.
- ### Captions, generated locally
	Transcribe on your machine in 19 languages, fix the words, style them, and burn them in with the active word highlighted.
- ### Text that animates
	Titles, lower thirds, big stats, and typewriter callouts as stackable tracks, with fade, slide, pop, or typewriter in and out.
- ### 3D camera moves
	Tilt the frame into perspective and glide, sweep, or pull back across it with focus blur.
- ### Any canvas, one recording
	Wallpapers, gradients, or your own image, then padding, corners, shadows, and a macOS, Windows, browser, or MacBook frame.
- ### Color grades
	Cinematic, Noir, Vintage, Frost, Golden, Midnight, Vivid, or Dreamy, then dial exposure, contrast, and vignette.
- ### Clips, speed, and music
	Trim, split, reorder, speed up to 8x, crossfade between clips, and lay a track from the built in library underneath.

Screenshot Mode

## Capture, beautify, share

One hotkey grabs the window, and the same editing tools that polish your videos turn the still into something worth pasting.

### Capture and beautify in one hotkey

Grab any window or area and Cap drops it on a background with padding, rounded corners, and a shadow.

### Annotate, then copy

- Beautiful backgrounds
	Gradients, wallpapers, solid colours
- Adjustable padding
	Clean spacing around the capture
- Rounded corners
	Squircle or rounded styles
- Shadow and borders
	Depth without the fuss
- Annotation tools
	Arrows, shapes, text, masks
- Instant copy and save
	One click to clipboard or file

Cap AI · On every recording

## Every recording, understood

Titles, summaries, chapters, and a searchable transcript arrive with the recording, so the work after the recording is already done.

### Auto transcription

Every word transcribed and timestamped, so viewers can search the recording instead of scrubbing it.

### Titles, summaries, and chapters

Why Cap

## Built for how you actually work

We obsessed over the details so you do not have to. Every feature here exists to save you time and make you look good.

- ### Your storage, your rules
	Connect your own Google Drive or S3 bucket, use Cap Cloud, or keep everything local. You are never locked into our infrastructure.
- ### Privacy by default, sharing by choice
	Share publicly or privately, password protect the sensitive ones, or keep a recording on your machine and never upload it at all.
- ### Async collaboration that works
	Comments, reactions, and transcripts keep the conversation moving. See who watched and turn a recording into the next step, not another meeting.
- ### Cross platform for your whole team
	Native apps for macOS and Windows that feel at home on each, plus a Chrome extension when recording in the browser is the right call.
- ### Quality that makes you look good
	4K recording, 60fps capture, and compression smart enough to keep the file sizes sane.
- ### Truly open source
	See exactly how Cap works, contribute the feature you need, or self host the whole thing. No black boxes.
- ### Cap AI does the busywork
	Titles, summaries, clickable chapters, and transcripts write themselves for every recording, with no usage limits on Pro.
- ### Import your Loom videos
	Switching from Loom? Bring your existing library across with the built in importer and keep everything in one place.

[View all features](https://cap.so/features)

Open source

## Your recordings. Actually yours.

Cap is open source, and every recording goes exactly where you say. Use Cap Cloud, point it at your own bucket or Drive, or self host the whole thing.

> “Cap is one of my favorite pieces of software I've used in the recent years. Best part is you get to own your data since they're fully open-source + via their S3 integration.”

Steven TeyFounder, Dub.co

- Open source
	Every line is on GitHub. Audit it, fork it, or contribute the feature you need.
- SOC 2 Type II · ISO 27001
	Independently audited controls behind Cap Cloud.
- HIPAA compliant
	Signed BAAs for organizations handling PHI.
- No lock in
	Recordings are plain video files. Take them anywhere, any time.

Every platform

## Native on Mac, Windows and Linux

A real desktop app on all three, with the same recorder, editor, and share link. Plus a Chrome extension for the browser and a CLI for everything else.

Your device

### macOS

Apple silicon and Intel. macOS 13.1 or newer.

[Download for macOS](https://cap.so/download/apple-silicon)

### Windows

Windows 10 or newer.

[Download for Windows](https://cap.so/download/windows)

### Linux

Debian and Ubuntu, as a.deb package.

[Download for Linux](https://cap.so/download/linux-deb)[Chrome extension](https://cap.so/download)

[

Record a tab or your whole screen without leaving the browser.

](https://cap.so/download)[

Built for developers

Record, export, and publish from the terminal, the API, or the MCP server.

$ cap record start --mode studio --duration 30

$ cap export./recording.cap --quality 4k

$ cap upload./recording.mp4 --json

{ "url": "https://cap.so/s/x7f2k9" }

](https://cap.so/docs)

Cap for Agents

## Your agent can record, share, and read Caps

Cap ships a CLI and a local MCP server, so Claude Code, Cursor, Codex, OpenCode, or any shell capable agent can record your screen, upload the result, and read back the transcript and summary. One pasted prompt installs everything, and the agent asks before anything records, uploads, or costs money.

- CLI
- MCP server
- JSON on every command
- REST API
- [Agent docs](https://cap.so/docs/agents)

- ### One prompt to set up
	Paste one prompt from the docs and your agent installs the CLI, the Cap skill, and the MCP server for Claude Code, Cursor, or Codex.
	`$ cap agents install --target claude --component all`
- ### Every command speaks JSON
	Add one flag and the answer comes back as data. Recording and export stream NDJSON events as they happen.
	`$ cap guide --json`
- ### 76 MCP tools, zero secrets
	Read and manage Caps, comments, sharing, and analytics over MCP. Capture and upload stay in the CLI, so no secret passes through the model.
	`$ cap mcp serve`
- ### Least privilege login
	Sign in with the creator profile by default, and the agent asks before anything records, uploads, or costs money.
	`$ cap auth login`

```
$ cap record start --screen 1 --mode instant --duration 20 --json$ cap upload ./recording.cap --export --name "Checkout bug repro" --json
```

Record in the background, stop it later, and upload a.cap or.mp4 for a link. Works from any shell, script, or agent tool call.

[Explore Cap for Agents](https://cap.so/agents)

Testimonials

## Loved by builders, trusted by teams

Join the thousands who made Cap their daily driver for showing work instead of writing about it.[I've been testing Cap.so for no other reason than some old habits die hard for this former software analyst. Whew that UI is so polished and crispy. Between the open source code, self hosted vids, editing features and price point -- gone give Loom some competition 🤞🏽](https://www.threads.com/@olivialawson.co/post/DIj1kOfpPgX)

[![](https://cap.so/_next/image?url=%2Ftestimonials%2Folivialawson.jpg&w=96&q=75&dpl=dpl_9eJixcsZSpCfeZS8aecx5wX4kbFq)](https://www.threads.com/@olivialawson.co/post/DIj1kOfpPgX)[

Such a great Open source project. I will never install OBS again

![](https://cap.so/_next/image?url=%2Ftestimonials%2Fcjkihl.jpg&w=96&q=75&dpl=dpl_9eJixcsZSpCfeZS8aecx5wX4kbFq)](https://x.com/cjkihl/status/1850367930464379226)[

I've been looking for \*ages\* for a screen recording app that does the job + allows to zoom in/out easily and @Cap is AWESOME! Free, cross-platform, fully-featured, open-source. I mean...unless you love spending +$200 for recording your screen, use Cap!

![](https://cap.so/_next/image?url=%2Ftestimonials%2Feveningkid.jpg&w=96&q=75&dpl=dpl_9eJixcsZSpCfeZS8aecx5wX4kbFq)

evening kid

](https://x.com/eveningkid/status/1916136666898813076)[

Tip for people that need to make screen recordings: Cap is the open source alternative to Loom. Lightweight, powerful, and stunning. Record and share in seconds.

![](https://cap.so/_next/image?url=%2Ftestimonials%2F_rogermattos.jpg&w=96&q=75&dpl=dpl_9eJixcsZSpCfeZS8aecx5wX4kbFq)

Roger Mattos

](https://x.com/_rogermattos/status/1844398522650722596)[

No brainer instant purchase this morning: was looking for a solid screen recorder, for my new MacBook Pro, gave @cap a try, got myself a license within 10 mins — flawless UX sometimes speaks louder than lengthy marketer's words!

![](https://cap.so/_next/image?url=%2Ftestimonials%2FGreg__LD.jpg&w=96&q=75&dpl=dpl_9eJixcsZSpCfeZS8aecx5wX4kbFq)](https://x.com/Greg__LD/status/1913515902139523366)[

Used @cap. Holy smokes this product delivers and it delivers hard The whole experience from recording to the editor part is pretty sweet

![](https://cap.so/_next/image?url=%2Ftestimonials%2Fgillarohith.jpg&w=96&q=75&dpl=dpl_9eJixcsZSpCfeZS8aecx5wX4kbFq)

Rohith Gilla

](https://x.com/gillarohith/status/1843895676142530789)[

hey @richiemcilroy, cap is hands down one of the best oss i've used, so much so i've uninstalled loom and screen studio:) can you please bring up the video cut and playback speed adjust feature soon, can't wait to try it on, you guys are doing great cheers!

![](https://cap.so/_next/image?url=%2Ftestimonials%2FBorhadeHrushi.jpg&w=96&q=75&dpl=dpl_9eJixcsZSpCfeZS8aecx5wX4kbFq)](https://x.com/BorhadeHrushi/status/1915477348549615816)[

Tried @Cap v 0.3.beta and found an issue while exporting video. Wrote to @richiemcilroy about the problem and ~40 mins later the issue is fixed. I'm sold. Checkout Cap.so

![](https://cap.so/_next/image?url=%2Ftestimonials%2FBilalBudhani.jpg&w=96&q=75&dpl=dpl_9eJixcsZSpCfeZS8aecx5wX4kbFq)

Bilal Budhani

](https://x.com/BilalBudhani/status/1842198507756675104)[

Self-hosted Loom. The future is awesome 👉🏽

![](https://cap.so/_next/image?url=%2Ftestimonials%2Fpixelswithin.jpg&w=96&q=75&dpl=dpl_9eJixcsZSpCfeZS8aecx5wX4kbFq)](https://x.com/pixelswithin/status/1883344509121257704)

[Read more testimonials](https://cap.so/testimonials)

Pricing

## Simple, honest pricing

Start free, upgrade when you need more. Early adopter pricing locked in forever.

Trusted by 50,000+ users

Desktop License

A commercial licence for the Cap desktop app, with unlimited local recording and editing.

$58one time

Or $29 a year if you would rather pay as you go.

[Get Desktop License](https://cap.so/pricing)
- Commercial usage rights
- Unlimited local recordings & editing
- Studio Mode with full editor
- 20 cloud shareable links / month (up to 5 min each)
- Export to any format
- Community support

Cap ProBest value

Everything in Desktop plus unlimited cloud features for sharing and collaboration.

$12per user, per month

Billed monthly. Switch to annual for $8.16 a month.

[Get Started](https://cap.so/pricing)
- Everything in Desktop License
- Unlimited cloud storage & bandwidth
- Auto-generated titles, summaries, clickable chapters, and transcriptions for every recording
- SOC 2 Type II & ISO 27001 compliant
- Custom domain (cap.yourdomain.com)
- Password protected shares
- Viewer analytics & engagement
- Team workspaces
- Loom video importer
- Custom S3 bucket & Google Drive support
- Priority support & early features

FAQ

## Questions? We've got answers.

Still stuck? Mail [hello@cap.so](mailto:hello@cap.so) and a human answers.

What is the difference between Cap Pro and Desktop License?

Cap Pro is a paid plan that includes all the features of the Desktop License plus cloud features for seamless sharing and collaboration. Desktop License grants you commercial usage rights for a single user.

Is there a free version?

Yes! Cap is 100% free for personal use. You can record and share locally with Studio Mode. A paid plan is required for commercial usage.

How long can I record for on the free version?

Studio Mode lets you record locally without a time limit. Free cloud shareable links are limited to 5 minutes each.

How does Cap AI work?

Cap AI is a powerful tool that can be used to generate titles, summaries, clickable chapters, and transcriptions for your recordings. It's available for all Cap Pro users and has no usage limits.

How is Cap different from Loom?

Cap gives you the best of both worlds: the simplicity of Loom with the power of professional tools. We're open source, support custom storage, offer better pricing, and our desktop app works offline. Plus, you actually own your content. Already using Loom? Our built-in Loom video importer makes switching effortless.

What happens to my recordings if I cancel?

Your recordings are yours forever. If you cancel Pro, existing shares remain active and you can always export everything. Downgrade to our free plan to keep recording locally, or self-host to maintain all features.

Do you offer team plans?

Yes! Cap Pro includes team workspaces where you can organize recordings, manage permissions, and collaborate. Volume discounts available for teams over 10 users. Contact us for custom enterprise features.

Which platforms do you support?

Native desktop apps for macOS (Apple Silicon & Intel), Windows, and Linux, plus a Chrome extension. View your shareable links from anywhere.

Can I use Cap for commercial purposes?

Absolutely! Any paid plan (Desktop License or Cap Pro) includes full commercial usage rights. Use Cap for client work, sell courses, or embed recordings anywhere. The free version is for personal use only.

Is my data secure?

Security is core to Cap. Cap is SOC 2 Type II, ISO 27001, and HIPAA compliant, and as an open source project, our code is fully auditable and transparent — you can see exactly how your data is handled. You can connect your own storage or self-host Cap for more control over your recordings.

What about SOC 2, ISO 27001, GDPR, and HIPAA compliance?

Cap is SOC 2 Type II, ISO 27001, and HIPAA compliant, with signed BAAs available for organizations handling PHI. Cap Pro also lets you bring your own storage, including custom S3 buckets in any region or your own Google Drive, for GDPR compliance. For teams that want complete control, our self-hosted option keeps everything on your own infrastructure.

Switching from Loom

## Bring your whole Loom library with you

Paste a Loom link or upload a CSV of your library and Cap re-hosts every video with its title, a transcript and chapters. Your recordings land in storage you own, on a plan that stays free.

[Import from Loom](https://cap.so/migrate-from-loom)

20% off Cap Pro with code

Get started

## Ready to upgrade how you communicate?

All of the work around screen recordings, handled in one place. Capture, polish, and share without the busywork.