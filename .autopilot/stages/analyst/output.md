# PRD: Solace

## Problem statement

A specific kind of journaling person exists — reflective, literary-leaning, intentional about their practice — who currently uses two or three apps because no single app satisfies both how it looks and what it does. They write in one app, track mood in another, and save prompts in a notes app. This fragmentation breaks writing flow and undermines the sense of ritual that makes journaling stick. No iOS journaling app in 2026 occupies the intersection of aesthetic coherence, literary prompts, mood tracking, and strict privacy. Solace fills that gap as a single, opinionated, local-only iOS journaling app.

## User personas

### Primary: The Literary Journaler
- **Who:** A reflective, design-conscious person (late 20s–40s) who already journals or is trying to establish a practice.
- **Goals:** Write consistently in a tool that feels as intentional as the practice itself. Track emotional patterns over time. Access their entries privately.
- **Pain points:** Current apps feel either cluttered/gamified or too thin. Switching between apps breaks flow. No app earns aesthetic trust while being functionally complete.
- **Behavior:** Uses 2–3 apps today (one for writing, one for mood, one for prompts). Follows indie iOS software (MacStories, Daring Fireball). Values privacy as a moral stance.

### Secondary: The Craft-Software Enthusiast
- **Who:** Design-literate iOS users who find apps via word-of-mouth and editorial recommendation.
- **Goals:** Find iOS apps that are beautifully made and do one thing well.
- **Pain points:** Most well-designed apps are too minimal; most full-featured apps are ugly.
- **Behavior:** Shares apps they trust; influences App Store discovery. Bear, Things 3, Overcast are their reference points.

---

## Functional requirements

### Screen 1: Onboarding

**FR-001 [HIGH] Onboarding screen on first launch**
- Given the app has never been launched before, when the user opens the app, then the onboarding screen is displayed showing the logo, headline ("A quiet place for your thinking."), subhead copy, and two CTAs: "Begin your first entry" and "I already have an account".
- Given the user has previously completed onboarding, when the app launches, then the onboarding screen is not shown.
- Given the user taps "Begin your first entry", when the button is tapped, then the user is navigated to the Mood Check-in screen to begin their first entry.
- Given the user taps "I already have an account", when the button is tapped, then the app navigates directly to the Home screen (returning user flow).

---

### Daily Prompts

**FR-002 [HIGH] Daily rotating literary prompt**
- Given 90+ prompts are bundled in the app, when the app loads on a given calendar day, then today's prompt is determined by a deterministic rotation based on the current date (day-of-year index into the prompt array), so the same device always shows the same prompt for the same date.
- Given a new calendar day begins, when the app is first opened on that day, then a new prompt is shown.
- Given the prompt bundle contains at least 90 prompts, when a year has elapsed, then prompts cycle without repetition within any 90-day window.

---

### Screen 2: Home

**FR-003 [HIGH] Home screen editorial feed**
- Given the app is on the Home screen, when the screen loads, then the header shows the current week label (e.g. "May · Week 19"), a serif headline ("Today, *quietly.*"), and the user's current writing streak as the subhead (e.g. "You've written for 23 days in a row.").
- Given a prompt is available for today, when the Home screen loads, then a prompt card is displayed showing the prompt text, the "TODAY'S PROMPT" eyebrow, the date counter, and two actions: "Begin writing" and "Skip".
- Given journal entries exist, when the Home screen loads, then recent entries are displayed below the prompt card in a list ordered newest-first, each showing: the date column (day number + month), entry title, body preview (capped at 2 lines), mood dot + mood name, and word count.
- Given no journal entries exist, when the Home screen loads, then the entry list section is empty (no entries label is acceptable but not required).
- Given the user taps "Begin writing" on the prompt card, when the button is tapped, then the app navigates to the Mood Check-in screen (if no mood logged today) with the writing mode set to prompted, or directly to Prompted Writing View (if mood already logged today).
- Given the user taps "Skip" on the prompt card, when the button is tapped, then the prompt card is dismissed for the current session and the entry list scrolls to full screen.
- Given the user taps an entry row, when the row is tapped, then the Entry Detail screen is pushed onto the navigation stack.
- Given the user taps the FAB (floating action button, pencil icon, bottom-right), when the FAB is tapped, then the app navigates to the Mood Check-in screen (if no mood logged today) or directly to the Focused Writing View (if mood already logged).

---

### Screen 3: Calendar

**FR-004 [HIGH] Monthly calendar with mood-colored days**
- Given entries exist for the current month, when the Calendar screen loads, then a 7×5 day grid is displayed with each day that has an entry showing a mood-colored dot at the bottom of the cell.
- Given a day has no entry, when displayed in the calendar grid, then the day cell shows no mood dot and has no colored background.
- Given the user taps a day cell that has an entry, when the cell is tapped, then the Entry Detail view is pushed for that entry.
- Given the user taps a day cell with no entry, when the cell is tapped, then nothing happens (or a new entry is initiated for that date — conservative interpretation: do nothing).
- Given the user taps the "‹" (previous) navigation arrow, when tapped, then the calendar transitions to the previous month.
- Given the user taps the "›" (next) navigation arrow, when tapped, then the calendar transitions to the next month.
- Given the current month is being viewed, when the calendar renders, then today's date cell is highlighted with a dark background (ink.900) to distinguish it.
- Given the calendar is viewing a month, when the header renders, then it shows the year eyebrow, the month name (e.g. "May."), and entry stats for that month (e.g. "21 entries · 4,872 words").
- Given mood entries exist for the month, when the mood legend renders below the grid, then it shows each mood that appears in the month with its dot color and count.
- Given a today card exists (an entry written today), when the calendar is on the current month, then a today card appears at the bottom of the calendar showing the entry title.

---

### Screen 4: Mood Check-in

**FR-005 [HIGH] Mood logging before writing**
- Given the user initiates a new writing session, when the Mood Check-in screen loads, then 6 mood circles are displayed in a 3×2 grid: tender, calm, warm, hopeful, restless, heavy — each in its designated color.
- Given the user taps a mood circle, when a mood is selected, then the selected circle gains a ring (3px ink.900 border + shadow) and a checkmark badge.
- Given a mood is selected, when the user taps "Continue to writing", then the selected mood is attached to the new entry and the user is navigated to the Writing View (Focused or Prompted, per the entry mode).
- Given the user has not selected a mood, when the user taps "Continue to writing", then navigation still proceeds (mood remains nil, treated as no mood logged).
- Given the user taps "Skip" in the top navigation, when tapped, then mood check-in is bypassed and the user proceeds directly to the Writing View.
- Given an optional "one word for today" note field is shown, when the user types in it, then the text is saved as a tag on the entry.
- Given mood check-in step indicator shows 3 dots, when the screen loads, then the first dot is filled (step 1 of 3 in the writing flow).

---

### Screen 5: Focused Writing

**FR-006 [HIGH] Focused writing mode — distraction-free editor**
- Given the user is in the Focused Writing View, when the screen loads, then a title field and body text area are presented on a paper-feel background, with the date row showing today's date and time-of-day (e.g. "WED · 7 MAY 2026 · EVENING").
- Given the user types in the title field, when text is entered, then the title updates in real time.
- Given the user types in the body field, when text is entered, then the body updates in real time and the word count in the bottom toolbar increments.
- Given the user is typing, when 1.5 seconds of inactivity elapses after a keystroke, then the entry is auto-saved to SwiftData and the save indicator updates to "saved · Xm ago" (where X is the minutes since last save).
- Given the auto-save triggers, when the save completes, then the save indicator dot pulses with a 800ms animation.
- Given a mood was selected in check-in, when the writing view loads, then a mood chip is shown in the tag row below the title, displaying the mood dot and mood name.
- Given the user taps "+ tag", when tapped, then a tag input is presented (keyboard + inline chip creation).
- Given the user taps "Done" in the top navigation, when tapped, then the current entry is saved and the writing view is dismissed, returning to Home.
- Given the user taps "‹ Close" in the top navigation, when tapped, then the user is presented a confirmation if unsaved changes exist, or the view is dismissed if auto-save is current.
- Given the bottom toolbar renders, when displayed, then it shows: Bold/Italic/Quote format icons (left), word count (center), voice/record button (right, terra.200 circle with mic icon).

---

### Screen 6: Prompted Writing

**FR-007 [HIGH] Prompted writing mode — guided session with literary prompt**
- Given the user is in Prompted Writing View, when the screen loads, then today's prompt is displayed in a card at the top (showing the prompt text, eyebrow, and author attribution if available), followed by a "Begin here…" placeholder below.
- Given the user taps the body area, when the keyboard appears, then the prompt card scrolls above the keyboard and the writing area expands.
- Given the user types, when 1.5 seconds of inactivity elapses, then the entry auto-saves (same behavior as Focused Writing FR-006).
- Given the mood ring at the bottom of the view, when the user selects a mood from the inline 5-circle row, then the selected mood updates the entry's mood field.
- Given the user taps the "Save & finish" CTA button (bottom full-width), when tapped, then the entry is saved and all writing/mood sheets are dismissed, returning to Home.
- Given the top navigation shows "Prompt X of Y" (e.g. "Prompt 03 of 12"), when displayed, then it reflects the prompt's position in the current batch.

---

### Auto-save

**FR-008 [HIGH] Auto-save with debounce**
- Given the user is typing in any writing view, when keystrokes are detected, then a 1.5-second debounce timer resets on each keystroke.
- Given the debounce timer fires, when 1.5s of inactivity has elapsed, then the entry is written to SwiftData.
- Given the entry is saved, when the save completes, then the "saved · Xm ago" indicator text updates and the dot pulses.
- Given the app is backgrounded while a draft exists, when the app moves to background, then the entry is saved immediately (bypassing the debounce).
- Given the app crashes or force-quits after a save, when re-opened, then the last auto-saved version of the entry is present. No entry content written more than 1.5s before close is lost.

---

### Screen 7: Entry Detail

**FR-009 [HIGH] Entry detail — reading view**
- Given the user navigates to an entry, when the Entry Detail screen loads, then it shows: the date + time-of-day header (e.g. "WED · 7 MAY | EVENING"), the entry title in large serif, mood dot + mood name + word count + weather meta row, a decorative divider, and the full entry body with drop-cap styling on the first paragraph.
- Given the entry body contains text, when rendered, when the body renders, then paragraph spacing is applied (gap 16 between paragraphs).
- Given the top navigation, when displayed, then it shows: back chevron (left), entry position indicator (e.g. "2 of 247", center), favorite heart icon + ellipsis menu icon (right).
- Given the user taps the heart icon, when tapped, then the entry is toggled as a favorite.
- Given the user swipes left/right on the Entry Detail view, when a swipe is detected, then the view navigates to the next/previous chronological entry.

---

### Screen 8: Search

**FR-010 [HIGH] Search entries by keyword and tag**
- Given the user is on the Search screen, when the screen loads, then a search text field is shown with a magnifying glass icon and a clear button.
- Given the user types a search query, when text is entered, then entries whose title or body contain the query are displayed as result cards, ordered by recency.
- Given results are found, when displayed, then each result card shows: the entry title (serif), the date (sans meta), and a body snippet with the matching keyword highlighted as a chip (terra.50 background, terra.400 text).
- Given no results are found, when the query returns empty, then an empty state is shown (e.g. "No entries match…").
- Given the tag filter row is present, when the screen loads, then all tags that exist across entries are shown as filter pills.
- Given the user taps a tag filter pill, when tapped, then the pill activates (ink.900 background, paper text) and results are filtered to entries containing that tag.
- Given multiple tags are active, when filtering, then results must contain ALL active tags (AND logic).
- Given the user taps a result card, when tapped, then the Entry Detail screen is pushed for that entry.
- Given the user taps "Cancel", when tapped, then the search view is dismissed.

---

### Screen 9: Settings / Profile

**FR-011 [MEDIUM] Settings and profile screen**
- Given the user navigates to the Settings screen ("You" tab), when loaded, then the profile block shows: avatar circle with initial, user name, "Writing since [first entry date]" subline, and three stats: total entries, current streak, total words.
- Given entries exist, when stats are computed, then: entries = count of all Entry records; streak = consecutive days ending today with at least one entry; words = sum of all entry word counts.
- Given the "Daily prompt" settings row, when the user taps it, then (no action in v1 — row is informational, showing the current prompt time preference).
- Given the "Reminder" settings row, when the user taps it, then (no action in v1 — informational).
- Given the "Mood tracking" toggle row, when toggled, then mood check-in is enabled or disabled for future writing sessions (default: on).
- Given the "Lock with Face ID" toggle row, when toggled on, then biometric lock is enabled (see FR-012).
- Given the "Export & backup" row, when the user taps it, then the plain text export flow is triggered (see FR-013).

---

### Face ID

**FR-012 [HIGH] Face ID / biometric app lock**
- Given Face ID is enabled in Settings, when the app is launched from a terminated state, then biometric authentication is required before the main content is visible.
- Given Face ID is enabled, when the app returns from background after more than 60 seconds of inactivity, then biometric authentication is required again.
- Given the authentication prompt is shown, when the user successfully authenticates via Face ID or device passcode, then the app content is revealed.
- Given the authentication fails or is cancelled, when max attempts are reached, then the app remains locked and shows a "Unlock" button to re-trigger the prompt.
- Given Face ID is not available on the device, when the user enables the toggle, then a fallback to device passcode is used instead (via LocalAuthentication framework).
- Given Face ID is disabled in Settings, when the app is launched or foregrounded, then no authentication is required.

---

### Export

**FR-013 [HIGH] Plain text export**
- Given the user taps "Export & backup" in Settings, when triggered, then all entries are formatted as a single plain text document ordered chronologically.
- Given entries are formatted, when the export document is constructed, then each entry follows the format: `---\n[Date]\n[Title]\nMood: [mood]\n\n[Body]\n\n`.
- Given the document is ready, when complete, then it is presented via the native iOS share sheet (`UIActivityViewController`), allowing the user to save to Files, share via AirDrop, email, etc.
- Given no entries exist, when export is triggered, then the share sheet is still presented with an empty-state document or a "No entries to export" message.

---

## Non-functional requirements

**NFR-001 Local-only storage**
All user data is stored exclusively in SwiftData on the device. No network requests are made by the app at runtime. No user account or authentication server is required.

**NFR-002 Auto-save reliability**
No entry content that has been committed to the keyboard for more than 1.5 seconds shall be lost on normal app close or background. Data loss is a hard failure.

**NFR-003 Design fidelity**
All colors, typography, spacing, and radii must match the handoff spec in `designs/handoff/README.md` exactly. The Newsreader (serif) and Mulish (sans) fonts must be bundled as `.ttf` resources and registered via `UIAppFonts` in Info.plist. System font fallbacks (New York / SF Pro) are acceptable only if the TTF files cannot be bundled.

**NFR-004 Platform requirements**
- iOS 17.0 minimum deployment target
- SwiftUI for all views
- SwiftData for persistence
- LocalAuthentication for Face ID
- UIKit interop acceptable for UIActivityViewController (export) only

**NFR-005 Performance**
- App cold launch to interactive Home screen: < 1.5 seconds on iPhone 12 or newer
- Calendar month render: < 200ms
- Search results appear: < 300ms after last keystroke (debounced or real-time)

**NFR-006 Zero-crash requirement**
Zero crashes on the launch day build. All force-unwraps and precondition failures must be eliminated from production paths.

**NFR-007 Font bundling**
The app must include `Newsreader-Regular.ttf`, `Newsreader-Italic.ttf`, `Newsreader-Medium.ttf`, `Mulish-Regular.ttf`, `Mulish-Medium.ttf`, `Mulish-SemiBold.ttf`, and `Mulish-Bold.ttf` in the app bundle, registered in Info.plist under `UIAppFonts`.

**NFR-008 Prompt bundle**
At least 90 literary prompts bundled as `prompts.json` in the app bundle. Prompts should span themes: reflection, memory, nature/senses, relationships, gratitude, loss, hope, and observation.

**NFR-009 Accessibility**
Dynamic Type scaling must be supported for all body text (`.body`, `.title` semantic sizes). VoiceOver labels must be present on all interactive elements.

---

## Out of scope

The following are explicitly NOT included in v1:

- Cloud sync / iCloud backup
- Voice memo recording (AVAudioRecorder overlay)
- Social sharing or image sharing
- Widget or Lock Screen integration
- Android or any cross-platform implementation
- AI-generated prompts or AI writing assistance
- App Store monetization layer (in-app purchase, subscription)
- Multiple user profiles
- Entry tagging with auto-suggestions (tags are manual only)
- Markdown rendering in entry body
- Photo attachments to entries
- Notification scheduling (reminder row in Settings is informational only)
- Pull-to-refresh or cloud sync indicators
- Undo/redo in the text editor beyond system default
- Weather data fetching (weather meta on Entry Detail is entered manually or omitted)

---

## Decisions made

The following decisions were made conservatively where the brief was silent:

1. **Navigation structure:** A `TabView` with 4 tabs (Home, Calendar, Search, You) is used. The brief listed 9 screens but did not specify how they connect; a tab bar is the iOS standard for 4 peer sections.

2. **Mood check-in skip condition:** Mood check-in is shown once per calendar day. If a mood has already been logged for today, writing flows skip directly to the writing view.

3. **Prompted vs. Focused mode entry:** Tapping FAB → Focused mode. Tapping "Begin writing" on the prompt card → Prompted mode. Both pass through mood check-in (unless already done today).

4. **Weather field on Entry Detail:** The design shows "18°c · clear" in the stats row. Since no weather API integration is in scope, this field is omitted from the data model in v1 and the stats row shows only mood + word count.

5. **"I already have an account" button:** Since there is no account system, this button skips onboarding and goes directly to Home (for users who have used the app before and reinstalled).

6. **Entry swipe navigation (FR-009):** Left/right swipe in Entry Detail to navigate between entries — implemented as a simple index into the sorted entry list passed from the parent view.

7. **Tag input in writing view:** Tags are entered via a simple inline text field that creates chips. No autocomplete in v1.

8. **Prompt attribution:** The handoff shows "by Mary Oliver" in the prompted view. In v1, prompts.json may optionally include an `author` field; if present it is shown; if absent, the attribution line is omitted.

## Open questions

_(none — all ambiguities resolved above)_
