import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @Query private var settingsArray: [AppSettings]

    private var settings: AppSettings {
        settingsArray.first ?? {
            let s = AppSettings()
            modelContext.insert(s)
            return s
        }()
    }

    var body: some View {
        ZStack {
            Color.solaceBgPaper.ignoresSafeArea()

            // Decorative background circles
            decorativeCircles

            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 120)

                // Logo
                ZStack {
                    Circle()
                        .fill(Color.solaceInk900)
                        .frame(width: 56, height: 56)
                    Text("j")
                        .font(.newsreader(30, italic: true))
                        .foregroundColor(.solaceBgPaper)
                }

                // Headline
                VStack(alignment: .leading, spacing: 4) {
                    Text("A quiet place")
                        .font(.newsreaderDisplay)
                        .foregroundColor(.solaceInk900)
                    Text("for your")
                        .font(.newsreaderDisplay)
                        .foregroundColor(.solaceInk900)
                    Text("thinking.")
                        .font(.newsreader(48, italic: true))
                        .foregroundColor(.solaceTerra300)
                }
                .padding(.top, 40)

                // Subhead
                Text("Five minutes. One prompt. Nobody watching. Just you and the page.")
                    .font(.newsreaderBodyItalic)
                    .foregroundColor(.solaceInk500)
                    .frame(maxWidth: 280, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 22)

                Spacer()

                // CTAs
                VStack(spacing: 14) {
                    Button {
                        completeOnboarding(startWriting: true)
                    } label: {
                        Text("Begin your first entry")
                            .font(.mulishLabelSemibold)
                            .foregroundColor(.solaceBgPaper)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .background(Color.solaceInk900)
                            .clipShape(Capsule())
                    }

                    Button {
                        completeOnboarding(startWriting: false)
                    } label: {
                        Text("I already have an account")
                            .font(.mulish(14, weight: .medium))
                            .foregroundColor(.solaceInk700)
                    }
                }
                .padding(.bottom, 36)
            }
            .padding(.horizontal, Spacing.xxxl)
        }
    }

    private var decorativeCircles: some View {
        GeometryReader { geo in
            ZStack {
                Circle()
                    .fill(Color.solaceTerra50)
                    .frame(width: 220, height: 220)
                    .position(x: geo.size.width + 60 - 220/2 + 30, y: 90 + 110)

                Circle()
                    .fill(Color.solaceSage100)
                    .frame(width: 140, height: 140)
                    .position(x: -40 + 70, y: 240 + 70)

                Circle()
                    .fill(Color.solaceTerra100.opacity(0.7))
                    .frame(width: 80, height: 80)
                    .position(x: geo.size.width - 60 - 40 + 40, y: 380 + 40)
            }
        }
        .allowsHitTesting(false)
    }

    private func completeOnboarding(startWriting: Bool) {
        settings.hasCompletedOnboarding = true
        try? modelContext.save()
        if startWriting {
            appState.startWritingSession(
                mode: .focused,
                moodAlreadyLogged: false
            )
        }
        appState.hasCompletedOnboarding = true
    }
}

#Preview {
    OnboardingView()
        .environment(AppState())
        .modelContainer(for: [AppSettings.self], inMemory: true)
}
