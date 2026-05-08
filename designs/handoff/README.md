# Handoff: Journal App (iOS)

## Overview
A calm, earth-toned iOS journaling app focused on the writing experience. Users open it to a daily prompt or blank page, log a quick mood, write in a paper-feeling editor, and re-read past entries. Eight screens are designed: onboarding, home, calendar, mood check-in, two writing views (focused + prompted), entry detail, search, and profile/settings.

The emotional tone is **quiet, literary, slow** — not feature-heavy or gamified. Earth-tone pastels (sand cream, terracotta, warm taupe, sage) with serif headings and a humanist sans for UI.

## About the Design Files
The files in this bundle (`Journal App.html`, `screens.jsx`, `screens-v2.jsx`, `tokens.css`, `design-canvas.jsx`) are **design references created in HTML/JSX as prototypes** — they show intended look, layout, copy, and basic structure, but they are NOT production code to ship directly. They run in a side-by-side design canvas (`design-canvas.jsx`) for review only.

Your task is to **recreate these designs in the target codebase's environment** — likely **SwiftUI** for a native iOS app, or React Native if cross-platform — using its established patterns, navigation, and component library. If no codebase exists yet, SwiftUI is the recommended choice given this is iOS-only.

Treat the HTML/JSX as a visual + behavioral spec, not a code source.

## Fidelity
**High-fidelity (hifi)**. All colors, typography, spacing, and copy are final. Recreate pixel-perfectly. Layout measurements below are given for a 402×874 pt iPhone 16 / 15 Pro logical viewport — scale proportionally for other devices.

## Design System

### Colors (exact hex)
| Token | Value | Usage |
|---|---|---|
| `bg.cream` | `#F4ECE0` | Primary background (home, calendar, mood pages) |
| `bg.paper` | `#FAF5EC` | Secondary background (writing surface, cards on cream) |
| `bg.warm` | `#EDE2D2` | Tertiary background (timeline view) |
| `bg.deep` | `#E5D7C2` | Deeper neutral, dividers |
| `terra.50` | `#F7E8DC` | Soft terracotta tint (prompt cards, accents) |
| `terra.100` | `#EDD3BD` | Light terracotta (avatar bg, chip bg) |
| `terra.200` | `#D4A88C` | **Primary accent** — buttons, highlights, links |
| `terra.300` | `#B8896C` | Hover/pressed accent, italic emphasis |
| `terra.400` | `#8B7355` | Deep clay — labels on terra backgrounds |
| `sage.100` | `#DCDDC7` | Soft sage tint (calm mood, prompt-2 card) |
| `sage.200` | `#B8BBA0` | Sage accent |
| `ink.900` | `#3A332B` | Primary text, primary buttons |
| `ink.700` | `#5C5247` | Body text |
| `ink.500` | `#7C7062` | Secondary/meta text |
| `ink.300` | `#A89A88` | Tertiary/placeholder text, chevrons |
| `ink.200` | `#C9BCA8` | Disabled / empty calendar days |
| `hairline` | `rgba(58,51,43,0.08)` | Standard separator |
| `hairline-strong` | `rgba(58,51,43,0.14)` | Stronger separator |

#### Mood colors
| Mood | Bg color | Dot color |
|---|---|---|
| calm | `#DCDDC7` | `#9CA888` |
| tender | `#E8C4B0` | `#D8A892` |
| warm | `#EDD3BD` | `#B8896C` |
| hopeful | `#E5D2A8` | `#C9B080` |
| restless | `#D9B895` | `#B89678` |
| heavy | `#C9B8A8` | `#8B7E6E` |

### Typography
Two families — both Google Fonts.

- **Serif** — `Newsreader` (300, 400, 500, 600, +italic). Used for headlines, entry titles, body of journal entries, prompts. Falls back to `'Iowan Old Style', Georgia, serif`.
- **Sans** — `Mulish` (300, 400, 500, 600, 700). Used for all UI: nav, buttons, meta, labels, settings rows. Falls back to system.

In SwiftUI: register both via `Font.custom("Newsreader", size: …)` after adding the .ttf files to the bundle, OR use SF Pro New York (serif) + SF Pro (sans) as system fallbacks if you want to avoid bundling fonts — they read similarly.

#### Type scale (used in mocks)
| Role | Family | Size | Weight | Line-height | Letter-spacing |
|---|---|---|---|---|---|
| Display (onboarding hero) | Serif | 48 | 400 | 1.05 | -1.2 |
| H1 (large title) | Serif | 38–44 | 400 | 1.1 | -0.6 to -1 |
| H1 (entry title) | Serif | 30–32 | 400 | 1.15 | -0.5 |
| H2 (section) | Serif | 19–22 | 500 | 1.2 | -0.3 |
| Body (entry text) | Serif | 18 | 400 | 1.65–1.7 | -0.1 |
| Body italic | Serif italic | 16–17 | 400 | 1.5 | 0 |
| UI label | Sans | 14–15 | 500–600 | 1.2 | 0 |
| Caption | Sans | 11–13 | 500–600 | 1.3 | 0 |
| Eyebrow (uppercase) | Sans | 10–12 | 700 | 1 | 1.4–2.4 (uppercase) |

### Spacing scale
4 / 6 / 8 / 10 / 12 / 14 / 16 / 18 / 20 / 22 / 24 / 28 / 32 / 36 / 40 / 46 (px / pt). Page horizontal padding is typically **24 or 28**.

### Radii
- 8 — small chip / icon tile
- 12–14 — list rows / inline cards
- 18 — primary buttons / CTAs
- 22 — feature tiles
- 26–28 — large grouped lists
- 999 — pills / FAB

### Shadows
- Card subtle: `0 1px 2px rgba(58,51,43,0.04)`
- Card elevated: `0 4px 16px rgba(58,51,43,0.08)`
- FAB / floating: `0 8px 24px rgba(58,51,43,0.28)` (on dark ink color)
- Mood selected ring: `0 0 0 5px {pageBg}, 0 8px 20px rgba(58,51,43,0.12)`

## Screens

### 1. Onboarding (`Onboarding` in `screens-v2.jsx`)
**Purpose**: Single-screen welcome before first entry.

**Layout** (402×874):
- Background: `bg.paper` `#FAF5EC`
- Decorative circles (z=1, behind content):
  - Top right: 220×220, `terra.50`, position `top:90, right:-60`
  - Mid left: 140×140, `sage.100`, position `top:240, left:-40`
  - Mid right: 80×80, `terra.100` @ 70% opacity, position `top:380, right:60`
- Content stack at `padding: 120 32 36`:
  - **Logo**: 56×56 circle, bg `ink.900`, italic serif "j" 30pt `paper`
  - **Headline** (margin-top 40): Serif 48 / 400 / 1.05 / -1.2, three lines: "A quiet place / for your / *thinking.*" — last word italic in `terra.300`
  - **Subhead** (margin-top 22): Serif italic 17 / 1.5 / `ink.500`, max-width 280: "Five minutes. One prompt. Nobody watching. Just you and the page."
- Bottom buttons (full-width, 32 padding):
  - Primary: bg `ink.900`, color `paper`, radius 999, padding 17, font sans 15/600 — "Begin your first entry"
  - Secondary text-only: color `ink.700`, sans 14/500 — "I already have an account"

### 2. Home — Editorial (`HomeEditorial` in `screens.jsx`)
**Purpose**: Daily landing — shows today's prompt + recent entries.

**Layout**:
- Background: `bg.paper`
- **Header** (`padding: 42 28 0`):
  - Eyebrow: sans 12, letter-spacing 2.4, uppercase, weight 600, `ink.500` — "May · Week 19"
  - H1 (margin 14/8): Serif 44 / 400 / 1.05 / -1, "Today, *quietly.*" — last word italic, `terra.300`
  - Subhead: Serif italic 16, `ink.700` — "You've written for 23 days in a row."
- **Today's prompt card** (margin `28 20 0`, padding `20 22`, radius 18, bg `terra.50`):
  - Eyebrow row (between baseline): "TODAY'S PROMPT" (sans 11/700/1.8 uppercase, `terra.400`) and "05 / 12" (serif italic 13, `ink.500`)
  - Prompt text: Serif 22 / 1.3 / 400, `ink.900` — "What softened you this week?"
  - Action row (margin-top 16):
    - Primary pill: bg `terra.300`, color `paper`, radius 999, padding `10 18`, sans 14/600 — "Begin writing"
    - Secondary text: `ink.700`, sans 14/500 — "Skip"
- **Section header** (`padding: 34 28 16`):
  - Title: Serif 22/500 — "Recent entries"
  - Action: sans 13/600, `terra.400` — "All"
- **Entry list** (`padding: 0 28`):
  - Each row: flex, gap 18, padding `18 0`, top border `hairline-strong` (first row only), bottom border `hairline`
  - Date column (44 wide): serif 28/400 day number, then sans 10 letter-spacing 1.4 uppercase month "07 / MAY"
  - Content column: title serif 17/500/1.25 → 4 → preview sans 13 / `ink.500` / clamped 2 lines → 8 → mood row (mood-dot 6px + sans 11 `ink.500` "calm · 247 words")
- **FAB**: position `right:24, bottom:36`, 60×60 circle, bg `ink.900`, color `paper`, pencil icon (22px svg), shadow `0 8px 24px rgba(58,51,43,0.28)`
- Home indicator at bottom 8.

### 3. Calendar — Month (`CalendarMonth`)
**Purpose**: Month-at-a-glance with mood-coloured days; tap to jump to that entry.

**Layout**:
- Background: `bg.paper`
- **Top bar** (`padding: 46 24 0`): back chevron in 36px `bg.cream` circle (left), italic serif "journal" wordmark center, empty 36px right.
- **Month header** (`padding: 32 28 0`):
  - Eyebrow "2026" — sans 12 / 2 letter-spacing / uppercase / `ink.500`
  - Row: H1 serif 44/400/-1 "May." (period in `terra.300`) + nav arrows (32×32 `bg.cream` circles with ‹ › glyphs `ink.700`/18px)
  - Stats: serif italic 14, `ink.500` — "21 entries · 4,872 words"
- **Day labels** (`padding: 28 24 0`, grid-7 gap 4): sans 10/700, letter-spacing 1.4, `ink.500`, centered — S M T W T F S
- **Day grid** (`padding: 4 24 0`, grid-7 gap 4, 5 rows = 35 cells):
  - Each cell: `aspect-ratio 1`, radius 12, centered serif 16/400
  - Empty/out-of-month: `ink.200` text, no bg
  - Written days: bg `bg.cream`, `ink.900` text, **mood dot** 5×5 absolutely positioned bottom 5, centered horizontally
  - Today (day 7): bg `ink.900`, color `paper`, plus `terra.200` 5px dot at bottom
- **Mood legend** (`padding: 24 28 0`): eyebrow "THIS MONTH'S MOODS" + flex-wrap row of "● calm 8" style chips (8×8 dot + sans 12/500 + count `ink.300`)
- **Today card** (absolute `bottom:50, left/right:24`, padding `16 18`, radius 18, bg `terra.50`):
  - Header row: "TODAY" eyebrow (`terra.400`) + "1 entry" meta (`ink.500`)
  - Title: serif 18/500 "Long walk by the canal"

### 4. Mood check-in (`MoodCheckIn`)
**Purpose**: 1-tap mood logging before writing. Step 1 of 3.

**Layout**:
- Background: `terra.50` `#F7E8DC` (warmer page)
- **Top bar** (`46 24 0`): "Skip" (sans 14/500/`ink.500`) · 3-dot pill progress (18×3 rounded, first filled `ink.900`, rest `hairline-strong`) · "Next" (sans 14/600/`ink.900`)
- **Headline block** (`padding: 70 32 0`):
  - Eyebrow "TONIGHT" sans 12/2/`terra.400`
  - H1 (margin-top 12) serif 38/400/1.1/-0.6: "How would you / describe today?" — "?" in `terra.300`
  - Subhead (margin-top 12) serif italic 16/`ink.500`: "Pick one. There's no wrong answer."
- **Mood circles** (`padding: 50 32 0`, grid-3, gap 20, justify-items center):
  - 6 moods in this order: tender, calm, warm, hopeful, restless, heavy
  - Each: 78×78 circle of mood bg color
  - Selected (calm in mock — index 1): 3px `ink.900` border + ring shadow `0 0 0 5px terra.50, 0 8px 20px rgba(58,51,43,0.12)` + 22px `ink.900` checkmark badge at bottom-right
  - Unselected: shadow `0 4px 12px rgba(58,51,43,0.06)`
  - Label below: serif 15, weight 600 if selected else 400
- **Note input** (absolute `bottom:130, left/right:24`):
  - Eyebrow "ONE WORD FOR TODAY (OPTIONAL)" sans 11/1.6/`ink.500`/700
  - Field (margin-top 8): padding `14 16`, bg `paper`, radius 14, serif italic 16, placeholder `ink.300`: "gentle, slow, golden…"
- **CTA** (absolute `bottom:36, left/right:24`): full-width primary button — bg `ink.900`, color `paper`, radius 18, padding 16, sans 15/600 — "Continue to writing"

### 5. Writing — Prompted (`WritePrompted`)
**Purpose**: Guided session with a literary prompt + mood at the bottom.

**Layout**:
- Background: `bg.cream`
- **Top bar** (`46 24 0`): back-arrow icon in 32×32 `bg.warm` circle · "Prompt 03 of 12" sans 13/500/`ink.500` · empty 32×32
- **Prompt card** (`padding: 40 28 0`, then padded card `28 24`, bg `paper`, radius 24, 1px `hairline`):
  - Eyebrow "TONIGHT'S PROMPT" sans 11/2/`terra.400`/700 (margin-bottom 14)
  - Prompt: serif 26/400/1.25/-0.3/`ink.900` — "Describe a small kindness you noticed this week — one you didn't say thank you for."
  - Meta row (margin-top 18): sans 12/500/`ink.500` "~ 3 min read · by Mary Oliver" with 3px dot separator
- **Begin-here placeholder** (`padding: 24 28 0`): serif italic 16, `ink.300` — "Begin here…"
- **Mood ring** (absolute `bottom:168, left/right: 28`):
  - Eyebrow "HOW ARE YOU FEELING?" sans 11/2/`ink.500`/700
  - Row of 5 circles 48×48 (`flex justify-between`): tender, calm, restless, warm, hopeful — first is selected (2px `ink.900` border + 4px `bg.cream` ring shadow). Label below each (sans 11/600).
- **CTA** (absolute `bottom:36, left/right:24`): full-width primary button — bg `ink.900`, color `paper`, radius 18, padding `16 20`, sans 15/600. Layout: text left, arrow icon right.

### 6. Writing — Focused (`WriteFocus`)
**Purpose**: Distraction-free composition surface.

**Layout**:
- Background: `bg.paper` (paper-feel)
- **Top bar** (`46 24 0`): "‹ Close" (sans 14/500/`ink.500`) · saved indicator (5×5 dot `terra.300` + "saved · 2m ago" sans 11/700/1.4/uppercase/`terra.400`) · "Done" (sans 14/600/`ink.900`)
- **Date row** (`padding: 36 32 0`): eyebrow "WED · 7 MAY 2026 · EVENING" sans 11/2/`ink.500`/700
- **Title input** (margin-top 14): serif 30/400/1.15/-0.5/`ink.900`, transparent bg, no border — "Long walk by the canal"
- **Tag row** (margin-top 14):
  - Active mood chip: padding `6 12`, radius 999, bg `sage.100`, sans 12/600/`ink.700`, content: 6×6 dot `#9CA888` + "calm"
  - Add chip: padding `6 12`, radius 999, dashed 1px `hairline-strong`, sans 12/600/`ink.500` — "+ tag"
- **Body** (`padding: 24 32 0`): serif 18/400/1.65/`ink.700`, two paragraphs, gap 14. A highlighted word appears with `bg: terra.50, padding: 0 3, radius: 3`. A blinking caret follows: `inline-block, w:1.5, h:22, bg:terra.300, animation: blink 1s infinite`.
- **Footer toolbar** (absolute `bottom:32, left/right:16`, padding `10 14`, bg `bg.cream`, radius 999, shadow `0 2px 8px rgba(58,51,43,0.06)`):
  - Left: 3 format icons (B / I / quote), each in 36×36 invisible circle button, stroke icons `ink.700`
  - Center: "247 words" sans 11/600/`ink.500`
  - Right: voice/record button — 36×36 circle, bg `terra.200`, white mic icon

### 7. Entry detail (`ReadEntry`)
**Purpose**: Re-read a finished entry — magazine/book treatment.

**Layout**:
- Background: `bg.paper`
- **Top bar** (`46 20 0`): back chevron in 36×36 `bg.cream` circle · "2 of 247" sans 12/500/`ink.500` · heart + ⋯ icons each in 36×36 `bg.cream` circle (gap 8)
- **Header content** (`padding: 36 32 0`):
  - Meta row: "WED · 7 MAY" + 14×1px `terra.200` rule + "EVENING", sans 11/1.6/700/`terra.400` uppercase
  - H1 (margin 14/18): serif 32/400/1.15/-0.6 — "Long walk by the canal"
  - Stats row: mood dot + "calm" + 3px dot · "247 words" · 3px dot · "18°c · clear" — sans 12/500/`ink.500`
- **Decorative divider** (`padding: 24 32 0`): horizontal flex — line / 5×5 `terra.200` dot / line, both lines `hairline-strong`
- **Body** (`padding: 20 32 0`):
  - Paragraph 1 has a **drop cap**: float-left "T" — serif 56/400/0.85/`terra.300`, margin-right 8, margin-top 4 — followed by "ook the long way…"
  - Paragraph 2: serif 18/400/1.7/`ink.700`, margin-top 16
  - **Pull-quote** (margin-top 20, padding-left 16, border-left 2px `terra.200`): serif italic 18/400/1.55/`ink.900` — "Patience that isn't waiting for anything."

### 8. Search (`SearchView`)
**Purpose**: Find past entries by keyword + tag filter.

**Layout**:
- Background: `bg.cream`
- **Top bar** (`46 24 0`): "Cancel" left · "Search" centered serif 17/500 · empty 50px right
- **Search field** (`padding: 24 24 0`): row, padding `12 16`, bg `paper`, radius 14, gap 10
  - Magnifying glass icon (16×16 stroke `ink.500`)
  - Input: prefilled "patience", sans 15/500
  - Clear button: 18×18 circle bg `ink.300`, white "×"
- **Tag filter** (`padding: 20 24 0`):
  - Eyebrow "FILTER BY TAG" sans 11/1.6/700/`ink.500`
  - Wrap row of pills (gap 6): each padding `6 12`, radius 999, sans 12/600
  - Active: bg `ink.900`, color `paper` (mock has "walking" and "memory" active)
  - Inactive: bg `paper`, color `ink.700`
- **Results** (`padding: 24 24 0`):
  - Eyebrow "3 RESULTS"
  - Each result card: padding `14 16`, bg `paper`, radius 14, margin-bottom 8
    - Top row: title (serif 16/500) + date (sans 11/500/`ink.500`)
    - Body snippet: serif 14/1.5/`ink.700` with the matching word highlighted as a chip — `background: terra.50, color: terra.400, padding: 0 3, radius: 3, weight: 600`

### 9. You / Settings (`SettingsView`)
**Purpose**: Profile + practice preferences + privacy.

**Layout**:
- Background: `bg.cream`
- **Top bar** (`46 24 0`): back chevron in 36×36 `bg.paper` circle · "You" serif 17/500 center · empty 36 right
- **Profile block** (`padding: 28 24 0`, centered column):
  - Avatar: 78×78 circle, bg `terra.100`, italic serif 36/400/`terra.400` initial "m"
  - Name: serif 22/500 (margin-top 10) — "Maya Chen"
  - Subline: serif italic 13/`ink.500` — "Writing since March 2024"
  - Stats row (margin-top 18, gap 32): three columns each — big number serif 22/500 + uppercase eyebrow sans 11/1.2/600/`ink.500` ("entries / streak / words" → "247 / 23 / 58k")
- **Grouped lists** (margin-top 32):
  - Group: header eyebrow (`padding: 0 32 8`), then rounded card bg `paper`, radius 18, margin `0 20`
  - Each row: min-height 50, padding `0 16`, separator bottom 1px `hairline` (none on last)
    - Icon tile: 28×28 radius 8, colored bg, italic serif glyph
    - Title: sans 15/500/`ink.900` (or `#A04F3A` if danger)
    - Detail: sans 13/`ink.500`, margin-right 6
    - Right chevron: 6×10 stroke `ink.300`
  - **Practice group**: "Daily prompt — 9:00 PM" (terra tile), "Reminder — Evening" (sage tile), "Mood tracking — On" (warm tile)
  - **Privacy group**: "Lock with Face ID — On", "Export & backup"

## Interactions & Behavior
- **Tap any entry** in home/calendar/search → push to Entry detail screen.
- **Tap FAB / Begin writing / "Continue to writing"** → push to Mood check-in (if not yet logged today) → Writing view.
- **Mood pill in writing view** → shows mood picker sheet inline.
- **Auto-save**: indicator shows "saved · {n}m ago" with `terra.300` dot every keystroke (debounce 1.5s).
- **Voice button** (terra.200 circle in writing toolbar): toggles voice memo overlay (not designed — implementer can use system AVAudioRecorder UI).
- **Calendar nav arrows**: month-by-month with horizontal slide transition (system default).
- **Onboarding "Begin"**: skips into the mood check-in.
- **Settings rows**: standard iOS push.
- **Streak / stat numbers**: read from local persistence; no animation specified (but could use a 200ms count-up on first appear).

### Animations
- **Caret blink** in writing view: 1s infinite step (50% on / 50% off).
- **Page transitions**: standard iOS push (right-to-left), 300ms.
- **Mood select**: 150ms ring scale-in (`scale 0.9 → 1.0`) + checkmark fade (100ms).
- **Auto-save dot**: pulse `1 → 0.4 → 1` over 800ms when saving.

## State Management
- `entries: [Entry]` — local persisted (Core Data / SwiftData).
- `Entry { id, date, title, body, mood, tags, words, weather? }`
- `currentDraft` — auto-saved every 1.5s of inactivity.
- `streak: Int` — derived from entry dates.
- `todayPrompt: String` — daily-rotating from a prompt bundle (12 prompts in mock; could be larger).
- `currentMonth` for calendar.
- `searchQuery, activeTags: [String]` for search.

## Assets
- **No raster assets**. All visuals are SVG icons and color fills.
- Icons used (re-implement with SF Symbols where possible):
  - chevron.left, chevron.right (back, calendar nav)
  - magnifyingglass (search)
  - ellipsis (more menu)
  - heart (favorite)
  - pencil.tip / square.and.pencil (FAB, write)
  - bold, italic, quote.bubble (writing toolbar) — or use SF Symbols `bold`, `italic`, `text.quote`
  - mic.fill (voice button)
  - checkmark (mood selected)
  - signal bars + battery (status bar — handled by iOS system)
- **Avatar**: italic serif initial in a colored circle. Replace with photo or generated monogram.
- Decorative onboarding circles are pure CSS — implement as `Circle().fill(color)` views in SwiftUI.

## Files in this bundle
- `Journal App.html` — the main prototype, opens all 8 screens in a side-by-side canvas.
- `screens.jsx` — Home, both writing views, Entry detail components.
- `screens-v2.jsx` — Calendar, Search, Settings, Mood check-in, Onboarding components.
- `tokens.css` — color + type tokens (Google Fonts imports).
- `design-canvas.jsx` — the canvas wrapper used to display the prototypes; not part of the app.

## Notes for the implementer
- **Type-rendering matters**. The serif (Newsreader) sets the literary tone — don't substitute with a generic system serif unless you really must. Bundle the `.ttf` if going native.
- **Don't add gradients, glassmorphism, or neon accents** — they break the warm-paper feel.
- **Avoid icon-heavy chrome**. The design uses iconography sparingly; lean on type and color instead.
- The layout assumes a 402×874 canvas (iPhone 16 / 15 Pro). Use `GeometryReader` + relative spacing for other devices, but keep the **eyebrow + headline + card** rhythm intact.
