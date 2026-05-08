# Tasks

## Implementation order

1. TASK-001: Delete stub files, create folder structure
2. TASK-002: Design system — Colors
3. TASK-003: Design system — Typography & Spacing
4. TASK-004: Models — Entry, AppSettings, MoodType
5. TASK-005: Services — PromptService + prompts.json
6. TASK-006: Services — BiometricService
7. TASK-007: Services — ExportService
8. TASK-008: AppState + WritingMode
9. TASK-009: SolaceApp (root bootstrap)
10. TASK-010: RootView + MainTabView
11. TASK-011: OnboardingView
12. TASK-012: HomeView (entry list + FAB)
13. TASK-013: PromptCardView + EntryRowView
14. TASK-014: CalendarView + CalendarDayCell
15. TASK-015: MoodCheckInView + MoodCircleView
16. TASK-016: FocusedWritingView + WritingToolbarView
17. TASK-017: PromptedWritingView
18. TASK-018: EntryDetailView
19. TASK-019: SearchView + SearchResultCard
20. TASK-020: SettingsView
21. TASK-021: Unit tests

---

## Tickets

### TASK-001: Delete stub files, create folder structure
Stage: setup
Depends on: (none)
Parallelizable: no

**What to build:**
Delete `Solace/ContentView.swift` and `Solace/Item.swift` (Xcode default stubs). Create empty subdirectories: `Solace/Models/`, `Solace/DesignSystem/`, `Solace/Services/`, `Solace/State/`, `Solace/Views/Root/`, `Solace/Views/Onboarding/`, `Solace/Views/Home/`, `Solace/Views/Calendar/`, `Solace/Views/MoodCheckIn/`, `Solace/Views/Writing/`, `Solace/Views/Entry/`, `Solace/Views/Search/`, `Solace/Views/Settings/`, `Solace/Resources/`.

**Files to create/modify:**
- DELETE `Solace/ContentView.swift`
- DELETE `Solace/Item.swift`
- CREATE directories listed above (empty)

**Acceptance criteria:**
- `ContentView.swift` and `Item.swift` are absent from `Solace/`
- All subdirectories exist

**Context for implementer:**
The Xcode project uses `PBXFileSystemSynchronizedRootGroup` — all files added to `Solace/` are auto-discovered by Xcode. No pbxproj edits needed.

---

### TASK-002: Design system — Colors
Stage: foundation
Depends on: TASK-001
Parallelizable: no

**What to build:**
`Solace/DesignSystem/Colors.swift` — a `Color` extension with all design tokens from the handoff README as `static` properties, namespaced clearly.

**Files to create/modify:**
- `Solace/DesignSystem/Colors.swift`

**Acceptance criteria:**
- All color tokens from the handoff are present: bgCream, bgPaper, bgWarm, bgDeep, terra50–400, sage100–200, ink900/700/500/300/200, hairline, hairlineStrong
- All 6 mood background and dot colors defined (as static Color properties on MoodType — done here or in TASK-004)
- `Color.init(hex:)` helper present for hex-to-Color conversion (used internally, not public API)
- Colors are accessible as `Color.solaceBgCream`, `Color.solaceTerra200`, etc.

**Context for implementer:**
All hex values are in `designs/handoff/README.md`. The `Color.init(hex:)` helper converts 6-digit hex strings (without #) to Color.

---

### TASK-003: Design system — Typography & Spacing
Stage: foundation
Depends on: TASK-001
Parallelizable: yes (can run alongside TASK-002)

**What to build:**
`Solace/DesignSystem/Typography.swift` — `Font` extension with Newsreader and Mulish helpers matching the type scale. `Solace/DesignSystem/Spacing.swift` — `CGFloat` constants for the spacing scale.

**Files to create/modify:**
- `Solace/DesignSystem/Typography.swift`
- `Solace/DesignSystem/Spacing.swift`

**Acceptance criteria:**
- `Font.newsreader(size:weight:)` returns `Font.custom("Newsreader-Regular", size:)` (or appropriate PostScript name per weight)
- `Font.mulish(size:weight:)` returns `Font.custom("Mulish-Regular", size:)` etc.
- Type scale helpers: `.newsreaderDisplay`, `.newsreaderH1`, `.newsreaderBody`, `.mulishLabel`, `.mulishCaption`, `.mulishEyebrow` as computed static vars
- Spacing: `Spacing.xs` (4), `Spacing.sm` (8), `Spacing.md` (16), `Spacing.lg` (24), `Spacing.xl` (32), `Spacing.xxl` (40) + all values from handoff scale
- `Spacing.pagePadding` = 28

**Context for implementer:**
Font PostScript names: Newsreader-Regular, Newsreader-Italic, Newsreader-Medium, Newsreader-SemiBold. Mulish-Regular, Mulish-Medium, Mulish-SemiBold, Mulish-Bold. TTF files must be added to the Xcode bundle manually (see ADR-004).

---

### TASK-004: Models — Entry, AppSettings, MoodType
Stage: foundation
Depends on: TASK-001
Parallelizable: yes

**What to build:**
Three model files: the SwiftData `Entry` and `AppSettings` `@Model` classes, and the `MoodType` enum with color extensions.

**Files to create/modify:**
- `Solace/Models/Entry.swift`
- `Solace/Models/AppSettings.swift`
- `Solace/Models/MoodType.swift`

**Acceptance criteria:**
- `Entry` has all fields: id (UUID), date (Date), title (String), body (String), moodRaw (String?), tags ([String]), wordCount (Int), promptUsed (String?), isFavorite (Bool), timeOfDay (String)
- `Entry` has a `mood: MoodType?` computed property that reads/writes `moodRaw`
- `Entry` has a `updateWordCount()` method that sets `wordCount = body.split(whereSeparator: \.isWhitespace).count`
- `AppSettings` has: faceIDEnabled (Bool), hasCompletedOnboarding (Bool), moodTrackingEnabled (Bool), createdAt (Date)
- `MoodType` has all 6 cases: calm, tender, warm, hopeful, restless, heavy
- `MoodType` has `backgroundColor` and `dotColor` returning correct `Color` values from design system
- `MoodType` has `displayName: String` (same as rawValue, title-cased)

**Context for implementer:**
Colors for each mood are in `designs/handoff/README.md` under "Mood colors" table.

---

### TASK-005: Services — PromptService + prompts.json
Stage: foundation
Depends on: TASK-001
Parallelizable: yes

**What to build:**
`Solace/Services/PromptService.swift` and `Solace/Resources/prompts.json` with 90+ literary prompts.

**Files to create/modify:**
- `Solace/Services/PromptService.swift`
- `Solace/Resources/prompts.json`

**Acceptance criteria:**
- `prompts.json` contains an array of objects with `"text": String` and optional `"author": String` and `"theme": String`
- At least 90 prompt objects in the JSON
- `PromptService.shared.todayPrompt()` returns `Prompt` determined by `dayOfYear % prompts.count`
- `PromptService.shared.allPrompts()` returns the full array
- `Prompt` struct is `Codable` with `text: String`, `author: String?`, `theme: String?`
- Unit-testable: `PromptService` accepts an optional `date` parameter for test injection

**Context for implementer:**
Prompts should span themes: reflection, memory, nature/senses, relationships, gratitude, loss, hope, observation. Keep them literary in tone — avoid productivity/goal-setting language.

---

### TASK-006: Services — BiometricService
Stage: foundation
Depends on: TASK-001
Parallelizable: yes

**What to build:**
`Solace/Services/BiometricService.swift` — wraps `LocalAuthentication` for async Face ID / passcode auth.

**Files to create/modify:**
- `Solace/Services/BiometricService.swift`

**Acceptance criteria:**
- `BiometricService.shared.canUseBiometrics() -> Bool` returns true if `LAContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics)` succeeds
- `BiometricService.shared.authenticate() async -> Bool` evaluates biometrics and returns result
- On `.userCancel`, returns `false` gracefully (user explicitly cancelled — expected behavior)
- On other errors (`.biometryNotAvailable`, `.biometryLockout`), falls back to `.deviceOwnerAuthentication` (passcode)
- Uses Swift async/await, not completion handlers

**Context for implementer:**
`LocalAuthentication` must be imported. The `Info.plist` requires `NSFaceIDUsageDescription` key ("Unlock your journal."). This key must be noted in the reviewer checklist — not added by this ticket but flagged.

---

### TASK-007: Services — ExportService
Stage: foundation
Depends on: TASK-004
Parallelizable: yes

**What to build:**
`Solace/Services/ExportService.swift` — serializes entries to plain text and provides a SwiftUI view modifier to present the share sheet.

**Files to create/modify:**
- `Solace/Services/ExportService.swift`

**Acceptance criteria:**
- `ExportService.shared.plainTextDocument(from entries: [Entry]) -> String` formats entries chronologically as: `---\n[full date]\n[title]\nMood: [mood or "—"]\n\n[body]\n\n`
- Empty entries array returns a document with a header note: "No entries to export."
- `ActivityView` (UIViewControllerRepresentable) wraps `UIActivityViewController` and presents the document as a temp file or string activity item
- `ExportService.shared.makeShareSheet(entries: [Entry]) -> ActivityView` creates the presentable view

**Context for implementer:**
The share sheet will be triggered from `SettingsView` via a sheet or `.fullScreenCover`. The `ActivityView` wrapper is a standard UIViewControllerRepresentable pattern for iOS.

---

### TASK-008: AppState + WritingMode
Stage: foundation
Depends on: TASK-004
Parallelizable: yes

**What to build:**
`Solace/State/AppState.swift` — the `@Observable` class managing auth state, onboarding state, and writing session flow.

**Files to create/modify:**
- `Solace/State/AppState.swift`

**Acceptance criteria:**
- `AppState` is marked `@Observable`
- Properties: `isLocked: Bool`, `hasCompletedOnboarding: Bool`, `pendingWritingMode: WritingMode?`, `selectedMood: MoodType?`, `showMoodCheckIn: Bool`, `showFocusedWriting: Bool`, `showPromptedWriting: Bool`
- `func resetWritingSession()` sets showMoodCheckIn/showFocusedWriting/showPromptedWriting to false, clears selectedMood, pendingWritingMode
- `func startWritingSession(mode: WritingMode, moodAlreadyLogged: Bool)` sets the appropriate show flag based on mood status
- `WritingMode` enum: `case focused`, `case prompted(prompt: Prompt)`

**Context for implementer:**
`Prompt` type is defined in `PromptService.swift` (TASK-005). AppState does NOT hold entries — all entry data comes from SwiftData via `@Query`.

---

### TASK-009: SolaceApp (root bootstrap)
Stage: setup
Depends on: TASK-004, TASK-008
Parallelizable: no

**What to build:**
Update `Solace/SolaceApp.swift` to use the correct SwiftData schema (Entry + AppSettings), create AppState, and inject both into the environment.

**Files to create/modify:**
- `Solace/SolaceApp.swift` (modify existing)

**Acceptance criteria:**
- `ModelContainer` schema includes `Entry.self` and `AppSettings.self` (not `Item.self`)
- `AppState` instance created and injected via `.environment(appState)`
- `RootView` is the root view (not `ContentView`)
- App builds without errors

---

### TASK-010: RootView + MainTabView
Stage: feature
Depends on: TASK-008, TASK-009
Parallelizable: no

**What to build:**
`Solace/Views/Root/RootView.swift` — branches on auth lock and onboarding state. `Solace/Views/Root/MainTabView.swift` — 4-tab TabView.

**Files to create/modify:**
- `Solace/Views/Root/RootView.swift`
- `Solace/Views/Root/MainTabView.swift`

**Acceptance criteria:**
- `RootView` shows `OnboardingView` when `!settings.hasCompletedOnboarding`
- `RootView` shows a lock screen (simple unlock button) when `appState.isLocked`
- `RootView` shows `MainTabView` when onboarded and not locked
- `RootView` calls `BiometricService.shared.authenticate()` on appear if Face ID is enabled, sets `appState.isLocked` based on result
- `MainTabView` has 4 tabs: Home (house.fill), Calendar (calendar), Search (magnifyingglass), You (person.fill)
- Tab tint color is `Color.solaceTerra200`
- Tab background matches `Color.solaceBgPaper`
- Writing session `.fullScreenCover`s are attached to `MainTabView` (not individual tabs) so they present over the whole app

**Context for implementer:**
Settings are fetched via `@Query` in RootView. If no AppSettings record exists (first launch), one is created with defaults. The writing session fullScreenCovers are driven by `appState.showMoodCheckIn` etc.

---

### TASK-011: OnboardingView
Stage: feature
Depends on: TASK-002, TASK-003, TASK-010
Parallelizable: no

**What to build:**
`Solace/Views/Onboarding/OnboardingView.swift` — matches the handoff spec exactly.

**Files to create/modify:**
- `Solace/Views/Onboarding/OnboardingView.swift`

**Acceptance criteria:**
- Background: `Color.solaceBgPaper`
- Three decorative circles at specified positions (top-right terra.50, mid-left sage.100, mid-right terra.100 at 70% opacity)
- Logo: 56×56 dark circle with italic serif "j"
- Headline: "A quiet place\nfor your\nthinking." — last word in Newsreader italic, terra.300 color
- Subhead: serif italic 17, ink.500
- Primary button "Begin your first entry": full-width, ink.900 background, paper text, radius 999
- Secondary text button "I already have an account": ink.700, sans 14
- Tapping primary → marks `settings.hasCompletedOnboarding = true`, triggers `appState.startWritingSession(mode: .focused, moodAlreadyLogged: false)` (showing mood check-in)
- Tapping secondary → marks `settings.hasCompletedOnboarding = true` (goes to home)

---

### TASK-012: HomeView (entry list + FAB)
Stage: feature
Depends on: TASK-002, TASK-003, TASK-004, TASK-008, TASK-010
Parallelizable: no

**What to build:**
`Solace/Views/Home/HomeView.swift` — the editorial home feed with header, prompt card placeholder, entry list, and FAB.

**Files to create/modify:**
- `Solace/Views/Home/HomeView.swift`

**Acceptance criteria:**
- `@Query(sort: \Entry.date, order: .reverse)` fetches entries
- Header: week label (e.g. "May · Week 19"), serif headline "Today, quietly." with last word italic in terra.300, streak subhead
- Streak is computed from entries: consecutive days ending today with at least one entry
- Entry list section header: "Recent entries" + "All" action link
- Scrollable list of entries using `EntryRowView`
- FAB: 60×60 circle, ink.900 background, pencil icon, bottom-right at (24, 36) padding, shadow as specified
- FAB tap: calls `appState.startWritingSession(mode: .focused, moodAlreadyLogged: moodLoggedToday)`
- `PromptCardView` displayed above the entry list
- NavigationStack wrapping the content (for pushing EntryDetailView)

**Context for implementer:**
`moodLoggedToday` is computed: `entries.contains { Calendar.current.isDateInToday($0.date) && $0.moodRaw != nil }`. PromptCardView is a subcomponent (TASK-013).

---

### TASK-013: PromptCardView + EntryRowView
Stage: feature
Depends on: TASK-002, TASK-003, TASK-005
Parallelizable: no (depends on TASK-012 context)

**What to build:**
`Solace/Views/Home/PromptCardView.swift` and `Solace/Views/Home/EntryRowView.swift` — subcomponents used by HomeView.

**Files to create/modify:**
- `Solace/Views/Home/PromptCardView.swift`
- `Solace/Views/Home/EntryRowView.swift`

**Acceptance criteria:**
- `PromptCardView`: terra.50 background, radius 18, shows TODAY'S PROMPT eyebrow, date counter, prompt text (serif 22), "Begin writing" pill button (terra.300 bg), "Skip" text button
- `PromptCardView` "Begin writing" tap: calls `appState.startWritingSession(mode: .prompted(prompt: todayPrompt), moodAlreadyLogged: moodLoggedToday)`
- `EntryRowView(entry:)`: shows date column (serif 28 day number, sans 10 month), title (serif 17/500), 2-line body preview (sans 13, ink.500), mood dot + mood name + word count
- Mood dot: 6×6 circle in `entry.mood?.dotColor ?? .clear`

---

### TASK-014: CalendarView + CalendarDayCell
Stage: feature
Depends on: TASK-002, TASK-003, TASK-004
Parallelizable: yes

**What to build:**
`Solace/Views/Calendar/CalendarView.swift` and `Solace/Views/Calendar/CalendarDayCell.swift`.

**Files to create/modify:**
- `Solace/Views/Calendar/CalendarView.swift`
- `Solace/Views/Calendar/CalendarDayCell.swift`

**Acceptance criteria:**
- `@Query` fetches all entries; filter to current display month
- Custom top bar: back chevron (goes to previous screen or is hidden if tab root), "journal" italic serif wordmark center
- Month header: year eyebrow, "May." H1 (period in terra.300), "‹" / "›" nav arrows in bg.cream circles, stats line
- Day grid: 7 columns × 5 rows, using a `LazyVGrid` with 7 fixed columns
- Each cell: `CalendarDayCell(day: Int, mood: MoodType?, isToday: Bool, hasEntry: Bool)`
- Cells with entries: bg.cream background, mood dot at bottom
- Today cell: ink.900 background, paper text
- Out-of-month cells: ink.200 text, no background
- Mood legend below grid: each present mood this month with dot + name + count
- Today card at bottom (if today has an entry): terra.50 card showing first entry title
- Tapping a cell with an entry navigates to EntryDetailView
- Month navigation: `@State var displayMonth: Date` toggled by arrows

---

### TASK-015: MoodCheckInView + MoodCircleView
Stage: feature
Depends on: TASK-002, TASK-003, TASK-004, TASK-008
Parallelizable: yes

**What to build:**
`Solace/Views/MoodCheckIn/MoodCheckInView.swift` and `Solace/Views/MoodCheckIn/MoodCircleView.swift`.

**Files to create/modify:**
- `Solace/Views/MoodCheckIn/MoodCheckInView.swift`
- `Solace/Views/MoodCheckIn/MoodCircleView.swift`

**Acceptance criteria:**
- Background: terra.50
- Top bar: "Skip" (left), 3-dot progress indicator (center — dot 1 filled), "Next" (right, disabled until mood selected)
- Headline block: "TONIGHT" eyebrow (or "TODAY" / "MORNING" based on time of day), "How would you describe today?" H1, subhead "Pick one. There's no wrong answer."
- 3×2 mood grid showing MoodCircleView for each of the 6 moods
- `MoodCircleView(mood: MoodType, isSelected: Bool, onSelect: () -> Void)`: 78×78 circle in mood's backgroundColor, checkmark badge when selected, selection ring animation (150ms scale 0.9→1.0 + 100ms fade)
- Optional "one word" text field at bottom
- "Continue to writing" CTA: full-width, ink.900, triggers writing flow based on pendingWritingMode
- "Skip" dismisses mood check-in and proceeds to writing
- On "Continue": set `appState.selectedMood = selectedMood`, then present writing view

---

### TASK-016: FocusedWritingView + WritingToolbarView
Stage: feature
Depends on: TASK-002, TASK-003, TASK-004, TASK-005, TASK-008
Parallelizable: yes

**What to build:**
`Solace/Views/Writing/FocusedWritingView.swift` and `Solace/Views/Writing/WritingToolbarView.swift`.

**Files to create/modify:**
- `Solace/Views/Writing/FocusedWritingView.swift`
- `Solace/Views/Writing/WritingToolbarView.swift`

**Acceptance criteria:**
- Background: bg.paper
- Top bar: "‹ Close" (left), save indicator (center — terra.300 dot + "saved · Xm ago" or "saving…"), "Done" (right)
- Date row: "WED · 7 MAY 2026 · EVENING" (computed from Date.now + time-of-day helper)
- Title TextField: serif 30, transparent background
- Mood chip: tag row showing selected mood (if any), plus "+ tag" chip
- Body TextEditor: serif 18, 1.65 line spacing, ink.700
- Word count increments live as user types
- Auto-save: Task debounce 1.5s per ADR-005; save indicator pulses on save
- `WritingToolbarView(wordCount: Int)`: bg.cream pill, B/I/Quote icons (left), word count (center), mic button (terra.200 circle, right)
- Toolbar floats at bottom: `safeAreaInset(edge: .bottom)` or `overlay(alignment: .bottom)`
- "Done" saves and calls `appState.resetWritingSession()`
- "Close" checks for unsaved changes, presents confirmation alert if needed

**Context for implementer:**
Time-of-day: "MORNING" 5–11, "AFTERNOON" 12–17, "EVENING" 18–21, "NIGHT" 22–4. The save indicator "Xm ago" is formatted as: if < 60s → "just now", if < 60m → "Xm ago".

---

### TASK-017: PromptedWritingView
Stage: feature
Depends on: TASK-016 (shares WritingToolbarView)
Parallelizable: no

**What to build:**
`Solace/Views/Writing/PromptedWritingView.swift` — guided writing with prompt card at top.

**Files to create/modify:**
- `Solace/Views/Writing/PromptedWritingView.swift`

**Acceptance criteria:**
- Top bar: back arrow, "Prompt 03 of 12" (or appropriate counter), empty right space
- Prompt card: white/paper bg, radius 24, hairline border; shows prompt text (serif 26), eyebrow "TONIGHT'S PROMPT", author attribution if available
- "Begin here…" placeholder below prompt (serif italic 16, ink.300)
- Body TextEditor (same auto-save behavior as FocusedWritingView)
- Inline mood ring at bottom of content area: 5 circles (tender, calm, restless, warm, hopeful) 48×48, with selection state
- "Save & finish" CTA button: full-width, ink.900, radius 18 — saves and dismisses
- Word count tracked and passed to toolbar (reuse `WritingToolbarView`)

---

### TASK-018: EntryDetailView
Stage: feature
Depends on: TASK-002, TASK-003, TASK-004
Parallelizable: yes

**What to build:**
`Solace/Views/Entry/EntryDetailView.swift` — reading view for a finished entry.

**Files to create/modify:**
- `Solace/Views/Entry/EntryDetailView.swift`

**Acceptance criteria:**
- Top bar: back chevron (bg.cream circle), "2 of 247" position indicator, heart icon + ellipsis menu (both in bg.cream circles)
- Date/time header: "WED · 7 MAY | EVENING" in terra.400 uppercase sans
- Title: serif 32, ink.900
- Stats row: mood dot + mood name + "·" separator + word count + "·" (+ weather if present)
- Decorative divider: line / terra.200 dot / line
- Body: serif 18, ink.700, 1.7 line spacing; first paragraph has drop-cap (first letter: serif 56, terra.300, float-left styling via `Text` with size offset)
- Pull-quote detection: if body contains a line starting with "> ", render as a pull-quote (left border terra.200, italic 18)
- Heart icon tap: toggles `entry.isFavorite`
- Position indicator: shows entry index in current list (passed from parent)

**Context for implementer:**
Drop cap in SwiftUI: use `Text` with a large letter in terra.300 color, followed by the rest of the paragraph. Achieve float-left via `HStack(alignment: .top)`. The full body paragraph is split at first character.

---

### TASK-019: SearchView + SearchResultCard
Stage: feature
Depends on: TASK-002, TASK-003, TASK-004
Parallelizable: yes

**What to build:**
`Solace/Views/Search/SearchView.swift` and `Solace/Views/Search/SearchResultCard.swift`.

**Files to create/modify:**
- `Solace/Views/Search/SearchView.swift`
- `Solace/Views/Search/SearchResultCard.swift`

**Acceptance criteria:**
- Background: bg.cream
- Top bar: "Cancel" (left), "Search" title (serif 17/500), empty right
- Search field: bg.paper, radius 14, magnifying glass icon, text input, clear button (appears when text is non-empty)
- Tag filter row: "FILTER BY TAG" eyebrow, scrollable horizontal pill row of all unique tags from entries; active tags: ink.900 bg; inactive: paper bg
- Search logic: filter entries where `title.localizedCaseInsensitiveContains(query) || body.localizedCaseInsensitiveContains(query)`, then filter by active tags (all active tags must be present in entry.tags)
- Results eyebrow: "X RESULTS"
- `SearchResultCard(entry: Entry, query: String)`: bg.paper, radius 14, title + date row, snippet with highlighted keyword
- Snippet highlighting: extract a ~100-char window around the first match; render as `Text` with `.foregroundColor(terra.400).background(terra.50)` on the matching substring using `AttributedString`
- Tapping a result card pushes `EntryDetailView`
- Empty state: "No entries match your search." when query is non-empty and results are empty
- "Cancel" dismisses the search view

---

### TASK-020: SettingsView
Stage: feature
Depends on: TASK-002, TASK-003, TASK-004, TASK-006, TASK-007
Parallelizable: yes

**What to build:**
`Solace/Views/Settings/SettingsView.swift` — profile block + grouped settings rows.

**Files to create/modify:**
- `Solace/Views/Settings/SettingsView.swift`

**Acceptance criteria:**
- Background: bg.cream
- Top bar: "You" serif title center, back chevron left (hidden when shown as tab root)
- Profile block: 78×78 terra.100 avatar circle with first initial of a placeholder name ("M" or derived from device name), "Maya Chen" name (placeholder), "Writing since [first entry date]" subhead
- Stats row: 3 columns — entry count, streak, total word count (all derived from entries @Query)
- Practice group card: "Daily prompt — 9:00 PM" row, "Reminder — Evening" row, "Mood tracking — On/Off" toggle
- Privacy group card: "Lock with Face ID" toggle (bound to `settings.faceIDEnabled`; toggling on calls `BiometricService.authenticate()` first), "Export & backup" row
- Face ID toggle: if enabling — call authenticate() first, only enable if succeeds; if disabling — disable immediately
- Export row tap: presents `ActivityView` sheet with `ExportService.shared.makeShareSheet(entries: entries)`
- Row style: 50pt min-height, icon tile (28×28 radius 8 colored bg with serif glyph), title (sans 15/500), detail (sans 13/ink.500), chevron (ink.300)
- Danger rows: red text for any destructive actions (none in v1, but framework should be present)

---

### TASK-021: Unit tests
Stage: test
Depends on: TASK-004, TASK-005, TASK-007, TASK-008
Parallelizable: no

**What to build:**
`SolaceTests/` XCTest test bundle (or extend existing Xcode test target if present) with unit tests for core logic.

**Files to create/modify:**
- `SolaceTests/PromptServiceTests.swift`
- `SolaceTests/EntryTests.swift`
- `SolaceTests/ExportServiceTests.swift`
- `SolaceTests/MoodTypeTests.swift`

**Acceptance criteria:**
- `PromptServiceTests`: verify `todayPrompt()` returns a non-nil prompt; verify same date always returns same prompt; verify no crash for any day-of-year 1–366
- `EntryTests`: verify `updateWordCount()` counts "Hello world" as 2; empty string as 0; counts across newlines correctly
- `ExportServiceTests`: verify `plainTextDocument` includes all entry titles; verify chronological order; verify empty entries returns expected string
- `MoodTypeTests`: verify all 6 cases have distinct rawValues; verify rawValue round-trip to/from String works; verify no two moods share the same `backgroundColor`

**Context for implementer:**
The test target is already created by Xcode's default project template (check for `SolaceTests/` directory). If missing, it needs to be added via Xcode's File > New > Target > Unit Testing Bundle.
