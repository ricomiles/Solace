import Foundation
import Observation

enum WritingMode {
    case focused
    case prompted(prompt: Prompt)
}

@Observable
final class AppState {
    var isLocked: Bool = false
    var hasCompletedOnboarding: Bool = false

    // Writing session state
    var pendingWritingMode: WritingMode? = nil
    var selectedMood: MoodType? = nil
    var showMoodCheckIn: Bool = false
    var showFocusedWriting: Bool = false
    var showPromptedWriting: Bool = false

    func startWritingSession(mode: WritingMode, moodAlreadyLogged: Bool) {
        pendingWritingMode = mode
        if moodAlreadyLogged {
            switch mode {
            case .focused:
                showFocusedWriting = true
            case .prompted:
                showPromptedWriting = true
            }
        } else {
            showMoodCheckIn = true
        }
    }

    func proceedToWriting() {
        showMoodCheckIn = false
        switch pendingWritingMode {
        case .focused, .none:
            showFocusedWriting = true
        case .prompted:
            showPromptedWriting = true
        }
    }

    func resetWritingSession() {
        showMoodCheckIn = false
        showFocusedWriting = false
        showPromptedWriting = false
        selectedMood = nil
        pendingWritingMode = nil
    }
}
