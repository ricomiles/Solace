import SwiftUI
import SwiftData

struct MoodCheckInView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext

    @State private var selectedMood: MoodType? = nil
    @State private var oneWordNote: String = ""

    private var timeOfDayLabel: String {
        let hour = Calendar.current.component(.hour, from: .now)
        switch hour {
        case 5..<12:  return "THIS MORNING"
        case 12..<18: return "THIS AFTERNOON"
        case 18..<22: return "TONIGHT"
        default:      return "TONIGHT"
        }
    }

    private let moodGrid: [[MoodType]] = [
        [.tender, .calm, .warm],
        [.hopeful, .restless, .heavy]
    ]

    var body: some View {
        ZStack {
            Color.solaceTerra50.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Button("Skip") {
                        appState.selectedMood = nil
                        appState.proceedToWriting()
                    }
                    .font(.mulish(14, weight: .medium))
                    .foregroundColor(.solaceInk500)

                    Spacer()

                    // Progress dots
                    HStack(spacing: 6) {
                        ForEach(0..<3) { i in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(i == 0 ? Color.solaceInk900 : Color.solaceHairlineStrong)
                                .frame(width: 18, height: 3)
                        }
                    }

                    Spacer()

                    Button("Next") {
                        appState.selectedMood = selectedMood
                        appState.proceedToWriting()
                    }
                    .font(.mulish(14, weight: .semibold))
                    .foregroundColor(selectedMood != nil ? .solaceInk900 : .solaceInk300)
                    .disabled(selectedMood == nil)
                }
                .padding(.top, 46)
                .padding(.horizontal, 24)

                // Headline
                VStack(alignment: .leading, spacing: 0) {
                    Text(timeOfDayLabel)
                        .font(.mulish(12, weight: .bold))
                        .foregroundColor(.solaceTerra400)
                        .tracking(2)

                    (Text("How would you\ndescribe today")
                        .font(.newsreaderH1)
                        .foregroundColor(.solaceInk900)
                    + Text("?")
                        .font(.newsreaderH1)
                        .foregroundColor(.solaceTerra300))
                        .lineSpacing(6)
                        .padding(.top, 12)

                    Text("Pick one. There's no wrong answer.")
                        .font(.newsreaderBodyItalic)
                        .foregroundColor(.solaceInk500)
                        .padding(.top, 12)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 70)
                .padding(.horizontal, Spacing.xxxl)

                // Mood grid
                VStack(spacing: 20) {
                    ForEach(moodGrid, id: \.first) { row in
                        HStack(spacing: 20) {
                            ForEach(row) { mood in
                                MoodCircleView(
                                    mood: mood,
                                    isSelected: selectedMood == mood,
                                    onSelect: { selectedMood = mood }
                                )
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
                .padding(.top, 50)
                .padding(.horizontal, Spacing.xxxl)

                Spacer()

                // One-word note
                VStack(alignment: .leading, spacing: 8) {
                    Text("ONE WORD FOR TODAY (OPTIONAL)")
                        .font(.mulish(11, weight: .bold))
                        .foregroundColor(.solaceInk500)
                        .tracking(1.6)

                    TextField("gentle, slow, golden…", text: $oneWordNote)
                        .font(.newsreaderBodyItalic)
                        .foregroundColor(.solaceInk900)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.solaceBgPaper)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.card))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

                // CTA
                Button {
                    appState.selectedMood = selectedMood
                    appState.proceedToWriting()
                } label: {
                    Text("Continue to writing")
                        .font(.mulishLabelSemibold)
                        .foregroundColor(.solaceBgPaper)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.solaceInk900)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.feature))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 36)
            }
        }
    }
}

#Preview {
    MoodCheckInView()
        .environment(AppState())
        .modelContainer(for: [Entry.self], inMemory: true)
}
