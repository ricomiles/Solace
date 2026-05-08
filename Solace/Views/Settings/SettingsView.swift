import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Entry.date, order: .forward) private var entries: [Entry]
    @Query private var settingsArray: [AppSettings]
    @State private var showExport = false

    private var settings: AppSettings {
        settingsArray.first ?? {
            let s = AppSettings()
            modelContext.insert(s)
            return s
        }()
    }

    private var totalWords: Int { entries.reduce(0) { $0 + $1.wordCount } }

    private var streak: Int {
        var count = 0
        var date = Calendar.current.startOfDay(for: .now)
        let entryDates = Set(entries.map { Calendar.current.startOfDay(for: $0.date) })
        while entryDates.contains(date) {
            count += 1
            date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        }
        return count
    }

    private var writingSince: String {
        guard let first = entries.first else { return "today" }
        return first.date.formatted(.dateTime.month(.wide).year())
    }

    private var formattedWords: String {
        if totalWords >= 1000 {
            return "\(totalWords / 1000)k"
        }
        return "\(totalWords)"
    }

    var body: some View {
        ZStack {
            Color.solaceBgCream.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Top bar
                    HStack {
                        Spacer().frame(width: 36)
                        Spacer()
                        Text("You")
                            .font(.newsreader(17, weight: .medium))
                            .foregroundColor(.solaceInk900)
                        Spacer()
                        Spacer().frame(width: 36)
                    }
                    .padding(.top, 46)
                    .padding(.horizontal, 24)

                    // Profile block
                    VStack(spacing: 0) {
                        // Avatar
                        ZStack {
                            Circle()
                                .fill(Color.solaceTerra100)
                                .frame(width: 78, height: 78)
                            Text("M")
                                .font(.newsreader(36, italic: true))
                                .foregroundColor(.solaceTerra400)
                        }

                        Text("Maya Chen")
                            .font(.newsreader(22, weight: .medium))
                            .foregroundColor(.solaceInk900)
                            .padding(.top, 10)

                        Text("Writing since \(writingSince)")
                            .font(.newsreader(13, italic: true))
                            .foregroundColor(.solaceInk500)
                            .padding(.top, 4)

                        // Stats
                        HStack(spacing: 32) {
                            statColumn(number: "\(entries.count)", label: "ENTRIES")
                            statColumn(number: "\(streak)", label: "STREAK")
                            statColumn(number: formattedWords, label: "WORDS")
                        }
                        .padding(.top, 18)
                    }
                    .padding(.top, 28)

                    // Practice group
                    settingsGroup(
                        title: "PRACTICE",
                        rows: [
                            SettingsRow(icon: "quote.bubble.fill", iconBg: .solaceTerra100, title: "Daily prompt", detail: "9:00 PM") {},
                            SettingsRow(icon: "bell.fill", iconBg: .solaceSage100, title: "Reminder", detail: "Evening") {},
                            SettingsRow(icon: "face.smiling.inverse", iconBg: .moodWarmBg, title: "Mood tracking", detail: settings.moodTrackingEnabled ? "On" : "Off") {
                                settings.moodTrackingEnabled.toggle()
                                try? modelContext.save()
                            },
                        ]
                    )
                    .padding(.top, 32)

                    // Privacy group
                    settingsGroup(
                        title: "PRIVACY",
                        rows: [
                            SettingsRow(icon: "faceid", iconBg: .solaceInk200, title: "Lock with Face ID", detail: settings.faceIDEnabled ? "On" : "Off") {
                                Task {
                                    if !settings.faceIDEnabled {
                                        let ok = await BiometricService.shared.authenticate()
                                        if ok {
                                            settings.faceIDEnabled = true
                                            try? modelContext.save()
                                        }
                                    } else {
                                        settings.faceIDEnabled = false
                                        try? modelContext.save()
                                    }
                                }
                            },
                            SettingsRow(icon: "square.and.arrow.up.fill", iconBg: .solaceSage100, title: "Export & backup", detail: nil) {
                                showExport = true
                            },
                        ]
                    )
                    .padding(.top, 24)

                    Spacer().frame(height: 40)
                }
            }
        }
        .navigationBarHidden(true)
        .exportSheet(isPresented: $showExport, entries: entries)
    }

    private func statColumn(number: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(number)
                .font(.newsreader(22, weight: .medium))
                .foregroundColor(.solaceInk900)
            Text(label)
                .font(.mulish(11, weight: .semibold))
                .foregroundColor(.solaceInk500)
                .tracking(1.2)
        }
    }

    private func settingsGroup(title: String, rows: [SettingsRow]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.mulish(11, weight: .bold))
                .foregroundColor(.solaceInk500)
                .tracking(1.6)
                .padding(.horizontal, Spacing.xxxl)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                    Button(action: row.action) {
                        HStack(spacing: 14) {
                            // Icon tile
                            ZStack {
                                RoundedRectangle(cornerRadius: Radius.small)
                                    .fill(row.iconBg)
                                    .frame(width: 28, height: 28)
                                Image(systemName: row.icon)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.solaceInk700)
                            }

                            Text(row.title)
                                .font(.mulishLabel)
                                .foregroundColor(.solaceInk900)

                            Spacer()

                            if let detail = row.detail {
                                Text(detail)
                                    .font(.mulishCaption)
                                    .foregroundColor(.solaceInk500)
                            }

                            Image(systemName: "chevron.right")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.solaceInk300)
                        }
                        .padding(.horizontal, 16)
                        .frame(minHeight: 50)
                    }
                    .buttonStyle(.plain)

                    if index < rows.count - 1 {
                        Rectangle()
                            .fill(Color.solaceHairline)
                            .frame(height: 1)
                            .padding(.leading, 58)
                    }
                }
            }
            .background(Color.solaceBgPaper)
            .clipShape(RoundedRectangle(cornerRadius: Radius.grouped))
            .padding(.horizontal, 20)
        }
    }
}

struct SettingsRow {
    let icon: String
    let iconBg: Color
    let title: String
    let detail: String?
    let action: () -> Void
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .modelContainer(for: [Entry.self, AppSettings.self], inMemory: true)
}
