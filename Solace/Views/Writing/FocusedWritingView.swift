import SwiftUI
import SwiftData

struct FocusedWritingView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext

    @State private var title: String = ""
    @State private var entryBody: String = ""
    @State private var tags: [String] = []
    @State private var tagInput: String = ""
    @State private var showTagInput = false
    @State private var lastSavedAt: Date? = nil
    @State private var isSaving = false
    @State private var saveTask: Task<Void, Never>? = nil
    @State private var entry: Entry? = nil
    @State private var saveIndicatorScale: CGFloat = 1.0

    private var selectedMood: MoodType? { appState.selectedMood }

    private var wordCount: Int {
        entryBody.split(whereSeparator: \.isWhitespace).count
    }

    private var dateRow: String {
        let date = Date.now
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        let weekday = formatter.string(from: date).uppercased()
        let dayMonth = date.formatted(.dateTime.day().month(.wide)).uppercased()
        let year = date.formatted(.dateTime.year())
        let tod = Entry.timeOfDayLabel(for: date)
        return "\(weekday) · \(dayMonth) \(year) · \(tod)"
    }

    private var saveIndicatorText: String {
        guard let saved = lastSavedAt else { return "" }
        let elapsed = Date.now.timeIntervalSince(saved)
        if elapsed < 60 { return "saved · just now" }
        let mins = Int(elapsed / 60)
        return "saved · \(mins)m ago"
    }

    var body: some View {
        ZStack {
            Color.solaceBgPaper.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Button {
                        finalSave()
                        appState.resetWritingSession()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .medium))
                            Text("Close")
                        }
                        .font(.mulish(14, weight: .medium))
                        .foregroundColor(.solaceInk500)
                    }

                    Spacer()

                    // Save indicator
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.solaceTerra300)
                            .frame(width: 5, height: 5)
                            .scaleEffect(saveIndicatorScale)
                        Text(saveIndicatorText)
                            .font(.mulish(11, weight: .bold))
                            .foregroundColor(.solaceTerra400)
                            .tracking(1.4)
                            .textCase(.uppercase)
                    }
                    .opacity(lastSavedAt == nil ? 0 : 1)

                    Spacer()

                    Button {
                        finalSave()
                        appState.resetWritingSession()
                    } label: {
                        Text("Done")
                            .font(.mulish(14, weight: .semibold))
                            .foregroundColor(.solaceInk900)
                    }
                }
                .padding(.top, 46)
                .padding(.horizontal, 24)

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Date row
                        Text(dateRow)
                            .font(.mulish(11, weight: .bold))
                            .foregroundColor(.solaceInk500)
                            .tracking(2)
                            .padding(.top, 36)

                        // Title
                        TextField("", text: $title, prompt: Text("Title").foregroundColor(.solaceInk300))
                            .font(.newsreaderH1Entry)
                            .foregroundColor(.solaceInk900)
                            .padding(.top, 14)

                        // Tags row
                        HStack(spacing: 8) {
                            if let mood = selectedMood {
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(mood.dotColor)
                                        .frame(width: 6, height: 6)
                                    Text(mood.displayName)
                                        .font(.mulish(12, weight: .semibold))
                                        .foregroundColor(.solaceInk700)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(mood.backgroundColor)
                                .clipShape(Capsule())
                            }

                            ForEach(tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.mulish(12, weight: .semibold))
                                    .foregroundColor(.solaceInk700)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.solaceSage100)
                                    .clipShape(Capsule())
                            }

                            Button {
                                showTagInput = true
                            } label: {
                                Text("+ tag")
                                    .font(.mulish(12, weight: .semibold))
                                    .foregroundColor(.solaceInk500)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .overlay(
                                        Capsule().strokeBorder(Color.solaceHairlineStrong, lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.top, 14)

                        // Body
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
                                .frame(minHeight: 300)
                                .padding(.top, 24)
                        }
                    }
                    .padding(.horizontal, Spacing.pageHPad)
                    .padding(.bottom, 120)
                }
            }

            // Toolbar overlay
            VStack {
                Spacer()
                WritingToolbarView(wordCount: wordCount)
                    .padding(.bottom, 32)
            }
        }
        .onAppear { createEntryIfNeeded() }
        .onDisappear {
            saveTask?.cancel()
            finalSave()
        }
        .onChange(of: title) { _, _ in scheduleSave() }
        .onChange(of: entryBody) { _, _ in scheduleSave() }
        .alert("Add tag", isPresented: $showTagInput) {
            TextField("Tag name", text: $tagInput)
            Button("Add") {
                let trimmed = tagInput.trimmingCharacters(in: .whitespaces)
                if !trimmed.isEmpty { tags.append(trimmed) }
                tagInput = ""
            }
            Button("Cancel", role: .cancel) { tagInput = "" }
        }
    }

    private func createEntryIfNeeded() {
        if entry == nil {
            let newEntry = Entry(mood: selectedMood)
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
        entry.title = title
        entry.body = entryBody
        entry.tags = tags
        entry.updateWordCount()
        if entry.moodRaw == nil { entry.mood = selectedMood }
        try? modelContext.save()
        lastSavedAt = .now
        animateSaveDot()
    }

    private func finalSave() {
        performSave()
    }

    private func animateSaveDot() {
        withAnimation(.easeInOut(duration: 0.4).repeatCount(2, autoreverses: true)) {
            saveIndicatorScale = 0.4
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation { saveIndicatorScale = 1.0 }
        }
    }
}

#Preview {
    FocusedWritingView()
        .environment(AppState())
        .modelContainer(for: [Entry.self], inMemory: true)
}
