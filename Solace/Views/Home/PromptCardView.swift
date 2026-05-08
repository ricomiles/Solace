import SwiftUI

struct PromptCardView: View {
    @Environment(AppState.self) private var appState
    let moodAlreadyLogged: Bool

    @State private var isSkipped = false

    private var todayPrompt: Prompt { PromptService.shared.todayPrompt() }

    private var dateCounter: String {
        let day = Calendar.current.ordinality(of: .day, in: .month, for: .now) ?? 1
        let total = Calendar.current.range(of: .day, in: .month, for: .now)?.count ?? 31
        return String(format: "%02d / %02d", day, total)
    }

    var body: some View {
        if !isSkipped {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("TODAY'S PROMPT")
                        .font(.mulish(11, weight: .bold))
                        .foregroundColor(.solaceTerra400)
                        .tracking(1.8)
                    Spacer()
                    Text(dateCounter)
                        .font(.newsreader(13, italic: true))
                        .foregroundColor(.solaceInk500)
                }

                Text(todayPrompt.text)
                    .font(.newsreaderH2Body)
                    .foregroundColor(.solaceInk900)
                    .lineSpacing(4)
                    .padding(.top, 12)

                HStack(spacing: 12) {
                    Button {
                        appState.startWritingSession(
                            mode: .prompted(prompt: todayPrompt),
                            moodAlreadyLogged: moodAlreadyLogged
                        )
                    } label: {
                        Text("Begin writing")
                            .font(.mulish(14, weight: .semibold))
                            .foregroundColor(.solaceBgPaper)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(Color.solaceTerra300)
                            .clipShape(Capsule())
                    }

                    Button {
                        withAnimation(.easeOut(duration: 0.2)) { isSkipped = true }
                    } label: {
                        Text("Skip")
                            .font(.mulish(14, weight: .medium))
                            .foregroundColor(.solaceInk700)
                    }
                }
                .padding(.top, 16)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 20)
            .background(Color.solaceTerra50)
            .clipShape(RoundedRectangle(cornerRadius: Radius.feature))
        }
    }
}

#Preview {
    PromptCardView(moodAlreadyLogged: false)
        .environment(AppState())
        .padding()
        .background(Color.solaceBgPaper)
}
