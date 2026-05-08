import SwiftUI
import SwiftData

struct PromptedWritingView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext

    @State private var entryBody: String = ""
    @State private var selectedMood: MoodType? = nil
    @State private var lastSavedAt: Date? = nil
    @State private var saveTask: Task<Void, Never>? = nil
    @State private var entry: Entry? = nil
    @State private var saveIndicatorScale: CGFloat = 1.0

    private var prompt: Prompt {
        if case .prompted(let p) = appState.pendingWritingMode { return p }
        return PromptService.shared.todayPrompt()
    }

    private var wordCount: Int {
        entryBody.split(whereSeparator: \.isWhitespace).count
    }

    private let moodRing: [MoodType] = [.tender, .calm, .restless, .warm, .hopeful]

    var body: some View {
        ZStack {
            Color.solaceBgCream.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Button {
                        finalSave()
                        appState.resetWritingSession()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.solaceInk700)
                            .frame(width: 32, height: 32)
                            .background(Color.solaceBgWarm)
                            .clipShape(Circle())
                    }

                    Spacer()

                    Text("Prompt 01 of \(PromptService.shared.allPrompts().count)")
                        .font(.mulish(13, weight: .medium))
                        .foregroundColor(.solaceInk500)

                    Spacer()

                    Color.clear.frame(width: 32, height: 32)
                }
                .padding(.top, 46)
                .padding(.horizontal, 24)

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Prompt card
                        VStack(alignment: .leading, spacing: 0) {
                            Text("TONIGHT'S PROMPT")
                                .font(.mulish(11, weight: .bold))
                                .foregroundColor(.solaceTerra400)
                                .tracking(2)
                                .padding(.bottom, 14)

                            Text(prompt.text)
                                .font(.newsreaderPrompt)
                                .foregroundColor(.solaceInk900)
                                .lineSpacing(4)

                            if let author = prompt.author {
                                HStack {
                                    Circle()
                                        .fill(Color.solaceInk300)
                                        .frame(width: 3, height: 3)
                                    Text("~ by \(author)")
                                        .font(.mulishSmall)
                                        .foregroundColor(.solaceInk500)
                                }
                                .padding(.top, 18)
                            }
                        }
                        .padding(24)
                        .background(Color.solaceBgPaper)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.prompt))
                        .overlay(
                            RoundedRectangle(cornerRadius: Radius.prompt)
                                .strokeBorder(Color.solaceHairline, lineWidth: 1)
                        )
                        .padding(.top, 40)

                        // Writing area
                        ZStack(alignment: .topLeading) {
                            if entryBody.isEmpty {
                                Text("Begin here…")
                                    .font(.newsreaderBodyItalic)
                                    .foregroundColor(.solaceInk300)
                                    .padding(.top, 24)
                                    .allowsHitTesting(false)
                            }
                            TextEditor(text: $entryBody)
                                .font(.newsreader(18))
                                .foregroundColor(.solaceInk700)
                                .lineSpacing(6)
                                .scrollContentBackground(.hidden)
                                .background(.clear)
                                .frame(minHeight: 200)
                                .padding(.top, 24)
                        }

                        // Inline mood ring
                        VStack(alignment: .leading, spacing: 10) {
                            Text("HOW ARE YOU FEELING?")
                                .font(.mulish(11, weight: .bold))
                                .foregroundColor(.solaceInk500)
                                .tracking(2)

                            HStack(spacing: 0) {
                                ForEach(moodRing) { mood in
                                    VStack(spacing: 6) {
                                        Circle()
                                            .fill(mood.backgroundColor)
                                            .frame(width: 48, height: 48)
                                            .overlay {
                                                if selectedMood == mood {
                                                    Circle()
                                                        .strokeBorder(Color.solaceInk900, lineWidth: 2)
                                                        .padding(2)
                                                }
                                            }
                                            .onTapGesture { selectedMood = mood }

                                        Text(mood.displayName)
                                            .font(.mulish(11, weight: .semibold))
                                            .foregroundColor(.solaceInk700)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .padding(.top, 32)

                        // Save CTA
                        Button {
                            finalSave()
                            appState.resetWritingSession()
                        } label: {
                            HStack {
                                Text("Save & finish")
                                    .font(.mulishLabelSemibold)
                                    .foregroundColor(.solaceBgPaper)
                                Spacer()
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.solaceBgPaper)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(Color.solaceInk900)
                            .clipShape(RoundedRectangle(cornerRadius: Radius.feature))
                        }
                        .padding(.top, 32)
                        .padding(.bottom, 120)
                    }
                    .padding(.horizontal, Spacing.xxl)
                }
            }

            // Toolbar
            VStack {
                Spacer()
                WritingToolbarView(wordCount: wordCount)
                    .padding(.bottom, 32)
            }
        }
        .onAppear {
            selectedMood = appState.selectedMood
            createEntryIfNeeded()
        }
        .onDisappear {
            saveTask?.cancel()
            finalSave()
        }
        .onChange(of: entryBody) { _, _ in scheduleSave() }
    }

    private func createEntryIfNeeded() {
        if entry == nil {
            let newEntry = Entry(
                mood: appState.selectedMood,
                promptUsed: prompt.text
            )
            modelContext.insert(newEntry)
            entry = newEntry
        }
    }

    private func scheduleSave() {
        saveTask?.cancel()
        saveTask = Task {
            try? await Task.sleep(for: .seconds(1.5))
            guard !Task.isCancelled else { return }
            await MainActor.run { performSave() }
        }
    }

    private func performSave() {
        guard let entry else { return }
        entry.body = entryBody
        entry.mood = selectedMood
        entry.promptUsed = prompt.text
        entry.updateWordCount()
        try? modelContext.save()
        lastSavedAt = .now
    }

    private func finalSave() {
        performSave()
    }
}

#Preview {
    PromptedWritingView()
        .environment(AppState())
        .modelContainer(for: [Entry.self], inMemory: true)
}
