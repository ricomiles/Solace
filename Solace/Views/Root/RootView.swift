import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @Query private var settingsArray: [AppSettings]

    private var settings: AppSettings {
        if let existing = settingsArray.first {
            return existing
        }
        let s = AppSettings()
        modelContext.insert(s)
        return s
    }

    var body: some View {
        Group {
            if !settings.hasCompletedOnboarding {
                OnboardingView()
            } else if appState.isLocked {
                lockScreen
            } else {
                MainTabView()
            }
        }
        .task {
            appState.hasCompletedOnboarding = settings.hasCompletedOnboarding
            if settings.faceIDEnabled {
                appState.isLocked = true
                let success = await BiometricService.shared.authenticate()
                appState.isLocked = !success
            }
        }
    }

    private var lockScreen: some View {
        ZStack {
            Color.solaceBgPaper.ignoresSafeArea()
            VStack(spacing: Spacing.xl) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.solaceInk500)

                Text("Journal locked")
                    .font(.newsreaderH2)
                    .foregroundColor(.solaceInk900)

                Button("Unlock") {
                    Task {
                        let success = await BiometricService.shared.authenticate()
                        appState.isLocked = !success
                    }
                }
                .font(.mulishLabelSemibold)
                .foregroundColor(.solaceBgPaper)
                .padding(.horizontal, Spacing.xxl)
                .padding(.vertical, Spacing.base)
                .background(Color.solaceInk900)
                .clipShape(Capsule())
            }
        }
    }
}
