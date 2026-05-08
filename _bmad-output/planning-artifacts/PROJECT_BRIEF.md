---
title: "Product Brief: Solace"
status: "complete"
created: "2026-05-08"
updated: "2026-05-08"
inputs:
  - designs/handoff/README.md
  - designs/handoff/Journal App.html
  - designs/handoff/screens.jsx
  - designs/handoff/screens-v2.jsx
  - designs/handoff/tokens.css
  - market research (competitive landscape, user sentiment, timing)
---

# Product Brief: Solace

## Executive Summary

Solace was built for one person. A real person who cares deeply about journaling, cares equally about how her tools look and feel, and currently uses three different apps because no single one gets both right. That founding constraint — build it until this one person puts the other three apps away — is the design principle that shapes every decision.

Solace is a calm, literary iOS journaling app that consolidates what currently requires multiple apps: literary prompts, mood check-ins, and a focused writing surface — unified inside a single, opinionated design language. Earth-toned, serif-forward, unhurried. It looks and feels like a paper journal, not a productivity dashboard.

The journaling app market is crowded but aesthetically hollow. The category leaders (Day One, Reflectly, Journey) compete on features and cross-platform parity while charging $30–60/year. Solace competes on feel — the one thing subscription software rarely gets right — and on a privacy conviction: your inner life is not our business model.

## The Problem

A specific kind of journaling person exists: reflective, literary-leaning, intentional about their practice. They've tried the main apps. They keep two or three installed because no single one satisfies both how it looks and what it does. They write in one, track their mood in another, save prompts in a notes app.

This fragmentation is a signal that the market has optimized for feature checkboxes rather than coherent experience. Existing apps are either beautifully minimal (but functionally thin) or functionally complete (but visually overwhelming). The overlap — an app that is both aesthetically considered and functionally whole — is empty.

The secondary cost is friction: switching between apps breaks the writing flow, and inconsistent visual environments undercut the sense of ritual that makes journaling stick. Journaling is a practice sustained by feel. No app in the category currently earns that.

## The Solution

Solace is a single, opinionated place to journal on iOS:

- **Daily prompts** — literary, rotating, designed to provoke reflection rather than productivity. 90+ prompts bundled at launch, with seasonal and thematic expansion planned.
- **Mood vocabulary** — six editorially chosen moods (calm, tender, warm, hopeful, restless, heavy) logged before each session and visualized on a monthly calendar. Not a sentiment scale — a literary vocabulary for inner states that signals, from first open, that this app understands how you actually feel.
- **Two writing modes** — a distraction-free focused editor and a guided prompted session.
- **Entry history** — editorial home feed and a mood-colored calendar grid.
- **Search** — keyword and tag-based, with highlighted match snippets.
- **Auto-save** — debounced at 1.5s. Nothing is lost.
- **Privacy** — Face ID lock, local-only storage (SwiftData), no account required, no data leaves the device. Export to plain text included — your entries belong to you, not a server.

The experience is unified by one design language: sand cream and terracotta backgrounds, Newsreader serif for all writing surfaces, Mulish sans for UI chrome.

## What Makes This Different

**Aesthetic coherence as a conviction.** No competitor owns the quiet, literary, earth-toned positioning. Day One is cloud-utility. Reflectly is gamified wellness. Journey has a 1.6-star Trustpilot rating from aggressive upsells. Solace is designed to be the one you reach for because it *feels right* — and that positioning is reinforced by every design decision, not just the color palette.

**Privacy as a moral stance, not a feature.** Local-only means no account, no sync server, no data harvesting. But more than that: an app designed around intimate writing has no business treating that writing as data. No VC-backed competitor can make this promise structurally — their backend costs require eventual monetization of user behavior. Solace is architecturally free of that pressure.

**The mood taxonomy is opinionated.** Calm, tender, warm, hopeful, restless, heavy — this is a literary vocabulary, not a generic 1–5 scale. It is the single most differentiating UX choice in the product and the fastest signal to the right user that this app was made for them.

**No gamification pressure.** Streak counts appear in the profile as a private, personal stat — a lagging reflection of your practice, not a motivational lever. There are no badges, no daily guilt nudges, no penalty for missing a day. The app respects that some days you don't write.

**Consolidated without compromise.** Mood tracking, prompts, and focused writing in one place — the three things that currently require multiple apps for the target user — without sacrificing the feel of any of them.

**iOS-native craft.** SwiftUI, SF Symbols, native transitions, Face ID. Not a React Native wrapper. Not a cross-platform compromise.

## Who This Serves

**Primary user:** A reflective, design-conscious person who already journals or wants to establish a practice. They care about how their tools look and feel. They've been frustrated by journaling apps that are either too cluttered or too thin. They may currently use two or three apps to piece together what they need.

**Initially:** One known individual — a real user with validated taste whose reaction to the designs has already confirmed the aesthetic direction. Building for one real person first ensures the product is right before it scales. "We built this for one person, and got it right" is the founding story.

**Secondary (on App Store launch):** Design-literate iOS users who follow craft software — the Bear, Things 3, Overcast audience. Disproportionately influential in App Store discovery; they share what earns their aesthetic trust. The iOS indie dev community (MacStories, Connected, Daring Fireball) reaches this segment directly and amplifies without paid promotion when a product earns it.

## Success Criteria

**For the initial personal build:**
- The primary user replaces her current three apps with Solace and uses it as her only journaling app.
- She writes more consistently than before.
- She recommends it without being asked.

**For App Store launch:**
- Day-7 retention above 40% (category average ~25%).
- App Store rating ≥ 4.6 within first 90 days.
- App Store editorial consideration ("Apps We Love") — achievable for a beautifully designed, privacy-first, iOS-native app with a clear point of view; should be an explicit submission goal.
- At least one organic write-up in iOS-focused media (MacStories tier) within 60 days of launch.

**Product quality signals:**
- Zero data loss incidents (auto-save + export are hard requirements).
- Zero crashes on launch day build.

## Scope

**In for v1:**
All nine designed screens: Onboarding, Home (editorial), Calendar (mood-colored month), Mood check-in, Writing — Focused, Writing — Prompted, Entry detail, Search, Settings/Profile. SwiftData local store, no iCloud. Design system pixel-perfect to the handoff spec. Plain text export included as a privacy-first backup mechanism.

**Not in v1:**
- Cloud sync / iCloud backup
- Voice memo (AVAudioRecorder overlay — defer post-launch)
- Social or image sharing
- Widget or Lock Screen integration
- Android / cross-platform
- AI features of any kind
- App Store monetization layer (build first, validate retention, then price)

## Vision

If Solace gets the experience right, the natural next step is depth, not breadth. A curated prompt library — seasonal and thematic collections, potentially co-curated with independent literary publishers — that gives the app an editorial identity no competitor can copy quickly. Optional iCloud sync for users who want multi-device. A Lock Screen widget for daily prompts.

Pricing: a one-time App Store purchase in the $4.99–$6.99 range, consistent with how Things 3, Overcast, and Reeder have built loyal, paying user bases without subscriptions. "Pay once, own it forever" is itself a shareable stance in the current market.

The two-to-three year version of Solace is a small, beloved, craft iOS app — opinionated, beautifully made, trusted by people who care about their tools. The kind of app that gets recommended in journaling communities not because of a marketing campaign, but because someone found it and felt understood.
