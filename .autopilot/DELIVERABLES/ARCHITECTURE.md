# Architecture: Solace

## System overview

Solace is a single-target iOS app with no server, no network layer, and no external dependencies. All data is local to the device via SwiftData. The architecture is a standard unidirectional SwiftUI + SwiftData app: views observe model data directly via `@Query`, mutations happen through a SwiftData `ModelContext`, and cross-screen navigation state is managed by a single `@Observable` `AppState` class injected into the environment.

**Component list:**
- `SolaceApp` — app entry point, ModelContainer setup, AppState injection
- `AppState` — root observable: auth lock, onboarding completion, active writing session
- `Entry` (SwiftData model) — the core data entity
- `AppSettings` (SwiftData model) — single-row settings record
- `MoodType` — enum describing the 6 literary moods + their colors
- Design system — `Color`, `Font`, `CGFloat` extensions namespaced to design tokens
- `PromptService` — prompt bundle loading and daily rotation
- `BiometricService` — LocalAuthentication wrapper
- `ExportService` — plain text serialization + UIActivityViewController
- 9 screens as `View` structs — one file per screen, plus shared subcomponents
- `prompts.json` — bundled resource with 90+ prompts

---

## Component breakdown

### SolaceApp
- **Responsibility:** Bootstrap ModelContainer with `Entry` and `AppSettings` schemas. Create `AppState` and inject into environment.
- **Technology:** SwiftUI `@main App`, SwiftData `ModelContainer`
- **Interfaces:** Provides `ModelContainer` via `.modelContainer()` and `AppState` via `.environment()` to all child views.

### AppState
- **Responsibility:** Track authentication lock state, onboarding completion, and the current writing flow (pending writing mode, mood logged today flag). Acts as the single source of truth for navigation decisions.
- **Technology:** `@Observable` class (Swift 5.9 Observation framework)
- **Interfaces:** Injected via `@Environment(AppState.self)`. Views read/write properties to drive navigation.

### Entry (SwiftData model)
- **Responsibility:** Persist a single journal entry.
- **Technology:** `@Model` class, SwiftData
- **Interfaces:** Queried via `@Query` in views; created/mutated via `ModelContext`.

### AppSettings (SwiftData model)
- **Responsibility:** Persist user preferences: Face ID toggle, onboarding completion flag, mood tracking enabled, reminder preference.
- **Technology:** `@Model` class, SwiftData (single instance — fetched or created on first launch)
- **Interfaces:** Fetched via `@Query` in views that need settings.

### MoodType
- **Responsibility:** Type-safe enum for the 6 moods; provides background color, dot color, display name.
- **Technology:** Swift enum + extensions
- **Interfaces:** Used in `Entry`, `MoodCheckInView`, `CalendarDayCell`, writing views.

### Design System
- **Responsibility:** Centralize all visual tokens so views never hardcode hex values.
- **Technology:** `Color` extension (`Color.solace*`), `Font` extension (`Font.newsreader()`, `Font.mulish()`), `CGFloat` spacing enum
- **Interfaces:** Used directly by all views.

### PromptService
- **Responsibility:** Load `prompts.json` from bundle, compute today's prompt by day-of-year index modulo prompt count.
- **Technology:** Swift struct, `Bundle.main.url(forResource:)`, `JSONDecoder`
- **Interfaces:** `PromptService.shared.todayPrompt() -> Prompt`

### BiometricService
- **Responsibility:** Evaluate `LAPolicy.deviceOwnerAuthenticationWithBiometrics`, return async Bool result.
- **Technology:** `LocalAuthentication` framework, `LAContext`, Swift async/await
- **Interfaces:** `BiometricService.shared.authenticate() async -> Bool`

### ExportService
- **Responsibility:** Serialize all `Entry` records to a plain text document and present via `UIActivityViewController`.
- **Technology:** Pure Swift string formatting, UIKit `UIActivityViewController` wrapped in a SwiftUI `representable`
- **Interfaces:** `ExportService.export(entries: [Entry], from viewController: UIViewController)`

---

## Data model

### Entry
```swift
@Model final class Entry {
    var id: UUID              // Stable identifier
    var date: Date            // Entry date (usually creation time)
    var title: String         // User-entered title
    var body: String          // Full journal body text
    var moodRaw: String?      // MoodType.rawValue, nil if no mood logged
    var tags: [String]        // Array of user-created tag strings
    var wordCount: Int        // Computed and cached on save
    var promptUsed: String?   // The prompt text if written in prompted mode
    var isFavorite: Bool      // User heart-toggle
    var timeOfDay: String     // "MORNING" | "AFTERNOON" | "EVENING" | "NIGHT"
}
```

### AppSettings
```swift
@Model final class AppSettings {
    var faceIDEnabled: Bool           // Whether to lock app with biometrics
    var hasCompletedOnboarding: Bool  // Skip onboarding after first run
    var moodTrackingEnabled: Bool     // Show mood check-in before writing
    var createdAt: Date               // Date of first launch (for "Writing since")
}
```

### Prompt (in-memory, not persisted)
```swift
struct Prompt: Codable {
    let text: String
    let author: String?   // Optional attribution
    let theme: String?    // Optional tag (reflection, memory, etc.)
}
```

### MoodType
```swift
enum MoodType: String, CaseIterable, Codable {
    case calm, tender, warm, hopeful, restless, heavy
    // + Color properties in extension
}
```

---

## API / interface contracts

### PromptService
```swift
struct PromptService {
    static let shared = PromptService()
    
    func todayPrompt() -> Prompt    // Day-of-year deterministic lookup
    func allPrompts() -> [Prompt]   // Full array (for preview/debug)
}
```

### BiometricService
```swift
actor BiometricService {
    static let shared = BiometricService()
    
    func canUseBiometrics() -> Bool
    func authenticate() async -> Bool
}
```

### ExportService
```swift
struct ExportService {
    static let shared = ExportService()
    
    func plainTextDocument(from entries: [Entry]) -> String
    func presentShareSheet(entries: [Entry], from view: some View) -> some View
    // Returns a SwiftUI view modifier that triggers UIActivityViewController
}
```

### AppState
```swift
@Observable final class AppState {
    var isLocked: Bool                    // True when Face ID wall is up
    var hasCompletedOnboarding: Bool      // Drives RootView branch
    var pendingWritingMode: WritingMode?  // Set before presenting mood check-in
    var moodLoggedToday: Bool             // Cache: did user log mood this calendar day?
    var selectedMood: MoodType?           // Set in MoodCheckInView, consumed by writing views
    
    // Navigation triggers (read by RootView / MainTabView)
    var showMoodCheckIn: Bool
    var showFocusedWriting: Bool
    var showPromptedWriting: Bool
}
```

### WritingMode
```swift
enum WritingMode {
    case focused
    case prompted(prompt: Prompt)
}
```

---

## Error handling strategy

- **SwiftData errors** (ModelContainer init failure): `fatalError` with descriptive message. This is a boot-time failure; recovery is not possible without data store access.
- **Prompt bundle missing**: `fatalError` at launch — `prompts.json` is a required bundled resource. Validated in unit tests.
- **BiometricService errors** (LAError): Logged to `os.log` at debug level. Non-.userCancel errors fall back to passcode authentication. Passcode failures leave the app locked.
- **Auto-save errors**: Catch `ModelContext` save errors; log to `os.log`; show no UI error (do not interrupt writing flow). Next save attempt is made on next keystroke debounce.
- **Export errors**: If entry serialization fails (should not happen with valid String data), present a simple alert with "Export failed. Try again."

---

## Testing strategy

- **Unit tests (XCTest):**
  - `PromptService`: verify deterministic rotation, today returns consistent result for same date, no index out-of-bounds
  - `Entry.wordCount`: verify word-count accuracy across edge cases (empty, single word, markdown-like symbols)
  - `ExportService.plainTextDocument`: verify formatting, special character handling, chronological order
  - `MoodType`: verify all cases have distinct colors and rawValue round-trips
  - `AppState`: verify moodLoggedToday resets at midnight

- **UI tests (XCUITest):** Deliberately omitted in v1 (high setup cost for local-only app). Happy path can be verified by manual smoke testing against the Definition of Done.

- **In-process preview tests:** `#Preview` macros for each view serve as lightweight visual regression checks.

---

## File/folder structure

```
Solace/
├── SolaceApp.swift
│
├── Models/
│   ├── Entry.swift
│   ├── AppSettings.swift
│   └── MoodType.swift
│
├── DesignSystem/
│   ├── Colors.swift
│   ├── Typography.swift
│   └── Spacing.swift
│
├── Services/
│   ├── PromptService.swift
│   ├── BiometricService.swift
│   └── ExportService.swift
│
├── State/
│   └── AppState.swift
│
├── Views/
│   ├── Root/
│   │   ├── RootView.swift
│   │   └── MainTabView.swift
│   ├── Onboarding/
│   │   └── OnboardingView.swift
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── PromptCardView.swift
│   │   └── EntryRowView.swift
│   ├── Calendar/
│   │   ├── CalendarView.swift
│   │   └── CalendarDayCell.swift
│   ├── MoodCheckIn/
│   │   ├── MoodCheckInView.swift
│   │   └── MoodCircleView.swift
│   ├── Writing/
│   │   ├── FocusedWritingView.swift
│   │   ├── PromptedWritingView.swift
│   │   └── WritingToolbarView.swift
│   ├── Entry/
│   │   └── EntryDetailView.swift
│   ├── Search/
│   │   ├── SearchView.swift
│   │   └── SearchResultCard.swift
│   └── Settings/
│       └── SettingsView.swift
│
├── Resources/
│   └── prompts.json
│
└── Assets.xcassets/
    └── (existing)
```

Files to **remove or replace**:
- `ContentView.swift` → replaced by `Views/Root/RootView.swift`
- `Item.swift` → replaced by `Models/Entry.swift` + `Models/AppSettings.swift`

---

## ADR index

- [ADR-001: SwiftData over Core Data](ADRs/ADR-001.md)
- [ADR-002: @Observable over ObservableObject](ADRs/ADR-002.md)
- [ADR-003: NavigationStack + TabView over UIKit navigation](ADRs/ADR-003.md)
- [ADR-004: Font bundling approach](ADRs/ADR-004.md)
- [ADR-005: Auto-save via Task debounce over Combine](ADRs/ADR-005.md)
- [ADR-006: Single AppState class for navigation state](ADRs/ADR-006.md)
