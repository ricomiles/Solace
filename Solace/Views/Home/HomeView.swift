import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Query(sort: \Entry.date, order: .reverse) private var entries: [Entry]

    private var moodLoggedToday: Bool {
        entries.contains { Calendar.current.isDateInToday($0.date) && $0.moodRaw != nil }
    }

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

    private var weekLabel: String {
        let now = Date.now
        let month = now.formatted(.dateTime.month(.wide))
        let week = Calendar.current.component(.weekOfYear, from: now)
        return "\(month) · Week \(week)"
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.solaceBgPaper.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 0) {
                        Text(weekLabel.uppercased())
                            .font(.mulish(12, weight: .semibold))
                            .foregroundColor(.solaceInk500)
                            .tracking(2.4)

                        (Text("Today, ") + Text("quietly.").italic().foregroundColor(.solaceTerra300))
                            .font(.newsreaderH1Large)
                            .foregroundColor(.solaceInk900)
                            .padding(.top, 14)

                        if streak > 0 {
                            Text("You've written for \(streak) day\(streak == 1 ? "" : "s") in a row.")
                                .font(.newsreaderBodyItalic)
                                .foregroundColor(.solaceInk700)
                                .padding(.top, 8)
                        } else {
                            Text("Every day is a good day to write.")
                                .font(.newsreaderBodyItalic)
                                .foregroundColor(.solaceInk700)
                                .padding(.top, 8)
                        }
                    }
                    .padding(.top, 42)
                    .padding(.horizontal, Spacing.xxl)

                    // Prompt card
                    PromptCardView(moodAlreadyLogged: moodLoggedToday)
                        .padding(.top, 28)
                        .padding(.horizontal, Spacing.lg)

                    // Recent entries header
                    HStack {
                        Text("Recent entries")
                            .font(.newsreaderH2Body)
                            .foregroundColor(.solaceInk900)
                        Spacer()
                        NavigationLink {
                            allEntriesView
                        } label: {
                            Text("All")
                                .font(.mulish(13, weight: .semibold))
                                .foregroundColor(.solaceTerra400)
                        }
                    }
                    .padding(.top, 34)
                    .padding(.horizontal, Spacing.xxl)

                    // Entry list
                    LazyVStack(spacing: 0) {
                        ForEach(Array(entries.prefix(20).enumerated()), id: \.element.id) { index, entry in
                            NavigationLink {
                                EntryDetailView(entry: entry, entries: Array(entries), currentIndex: index)
                            } label: {
                                EntryRowView(entry: entry, isFirst: index == 0)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, Spacing.xxl)

                    Spacer().frame(height: 100) // FAB clearance
                }
            }

            // FAB
            Button {
                appState.startWritingSession(mode: .focused, moodAlreadyLogged: moodLoggedToday)
            } label: {
                Image(systemName: "pencil.tip")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(.solaceBgPaper)
                    .frame(width: 60, height: 60)
                    .background(Color.solaceInk900)
                    .clipShape(Circle())
                    .shadow(color: Color.solaceInk900.opacity(0.28), radius: 24, x: 0, y: 8)
            }
            .padding(.trailing, 24)
            .padding(.bottom, 36)
        }
        .navigationBarHidden(true)
    }

    private var allEntriesView: some View {
        List {
            ForEach(Array(entries.enumerated()), id: \.element.id) { index, entry in
                NavigationLink {
                    EntryDetailView(entry: entry, entries: entries, currentIndex: index)
                } label: {
                    EntryRowView(entry: entry, isFirst: false)
                }
            }
        }
        .navigationTitle("All Entries")
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(AppState())
    .modelContainer(for: [Entry.self, AppSettings.self], inMemory: true)
}
