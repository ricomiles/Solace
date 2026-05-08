import SwiftUI
import SwiftData

struct CalendarView: View {
    @Query(sort: \Entry.date, order: .reverse) private var entries: [Entry]
    @State private var displayMonth = Calendar.current.startOfMonth(for: .now)

    private var calendar: Calendar { Calendar.current }

    private var monthEntries: [Entry] {
        entries.filter { calendar.isDate($0.date, equalTo: displayMonth, toGranularity: .month) }
    }

    private var monthStats: (count: Int, words: Int) {
        (monthEntries.count, monthEntries.reduce(0) { $0 + $1.wordCount })
    }

    private var entryByDay: [Int: Entry] {
        Dictionary(monthEntries.map { (calendar.component(.day, from: $0.date), $0) }, uniquingKeysWith: { first, _ in first })
    }

    private var todayEntry: Entry? {
        entries.first { calendar.isDateInToday($0.date) }
    }

    private var gridDays: [(day: Int, outOfMonth: Bool)] {
        guard let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: displayMonth)),
              let range = calendar.range(of: .day, in: .month, for: firstDay) else { return [] }

        let firstWeekday = (calendar.component(.weekday, from: firstDay) - 1 + 7) % 7
        var days: [(Int, Bool)] = []

        // Leading empty cells
        for i in (1...max(1, firstWeekday)).reversed() {
            if let prevDay = calendar.date(byAdding: .day, value: -i, to: firstDay) {
                days.append((calendar.component(.day, from: prevDay), true))
            }
        }

        // Current month days
        for day in range { days.append((day, false)) }

        // Trailing cells to complete 5 rows
        let trailing = 35 - days.count
        if trailing > 0, let lastDay = calendar.date(byAdding: .day, value: range.count - 1, to: firstDay) {
            for i in 1...trailing {
                if let nextDay = calendar.date(byAdding: .day, value: i, to: lastDay) {
                    days.append((calendar.component(.day, from: nextDay), true))
                }
            }
        }

        return days
    }

    private var moodSummary: [(MoodType, Int)] {
        var counts: [MoodType: Int] = [:]
        for entry in monthEntries {
            if let mood = entry.mood { counts[mood, default: 0] += 1 }
        }
        return counts.sorted { $0.value > $1.value }.map { ($0.key, $0.value) }
    }

    var body: some View {
        ZStack {
            Color.solaceBgPaper.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Month header
                    VStack(alignment: .leading, spacing: 0) {
                        Text(monthYear)
                            .font(.mulish(12, weight: .semibold))
                            .foregroundColor(.solaceInk500)
                            .tracking(2)
                            .textCase(.uppercase)

                        HStack(alignment: .center) {
                            (Text(monthName) + Text(".").foregroundColor(.solaceTerra300))
                                .font(.newsreaderH1Large)
                                .foregroundColor(.solaceInk900)

                            Spacer()

                            HStack(spacing: 8) {
                                navArrow(systemImage: "chevron.left") {
                                    displayMonth = calendar.date(byAdding: .month, value: -1, to: displayMonth) ?? displayMonth
                                }
                                navArrow(systemImage: "chevron.right") {
                                    displayMonth = calendar.date(byAdding: .month, value: 1, to: displayMonth) ?? displayMonth
                                }
                            }
                        }
                        .padding(.top, 4)

                        Text("\(monthStats.count) \(monthStats.count == 1 ? "entry" : "entries") · \(monthStats.words.formatted()) words")
                            .font(.newsreader(14, italic: true))
                            .foregroundColor(.solaceInk500)
                            .padding(.top, 4)
                    }
                    .padding(.top, 32)
                    .padding(.horizontal, Spacing.xxl)

                    // Day labels
                    HStack(spacing: 4) {
                        ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { label in
                            Text(label)
                                .font(.mulish(10, weight: .bold))
                                .foregroundColor(.solaceInk500)
                                .tracking(1.4)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.top, 28)
                    .padding(.horizontal, 24)

                    // Day grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 4) {
                        ForEach(Array(gridDays.enumerated()), id: \.offset) { _, dayInfo in
                            let entry = !dayInfo.outOfMonth ? entryByDay[dayInfo.day] : nil
                            let isToday = !dayInfo.outOfMonth && isDayToday(dayInfo.day)

                            Group {
                                if let entry = entry {
                                    NavigationLink {
                                        EntryDetailView(entry: entry, entries: monthEntries, currentIndex: monthEntries.firstIndex(of: entry) ?? 0)
                                    } label: {
                                        CalendarDayCell(
                                            day: dayInfo.day,
                                            mood: entry.mood,
                                            isToday: isToday,
                                            hasEntry: true,
                                            isOutOfMonth: dayInfo.outOfMonth
                                        )
                                    }
                                    .buttonStyle(.plain)
                                } else {
                                    CalendarDayCell(
                                        day: dayInfo.day,
                                        mood: nil,
                                        isToday: isToday,
                                        hasEntry: false,
                                        isOutOfMonth: dayInfo.outOfMonth
                                    )
                                }
                            }
                        }
                    }
                    .padding(.top, 4)
                    .padding(.horizontal, 24)

                    // Mood legend
                    if !moodSummary.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("THIS MONTH'S MOODS")
                                .font(.mulish(11, weight: .bold))
                                .foregroundColor(.solaceInk500)
                                .tracking(1.6)

                            FlowLayout(spacing: 12) {
                                ForEach(moodSummary, id: \.0) { mood, count in
                                    HStack(spacing: 6) {
                                        Circle()
                                            .fill(mood.dotColor)
                                            .frame(width: 8, height: 8)
                                        Text("\(mood.displayName) \(count)")
                                            .font(.mulishSmall)
                                            .foregroundColor(.solaceInk500)
                                    }
                                }
                            }
                        }
                        .padding(.top, 24)
                        .padding(.horizontal, Spacing.xxl)
                    }

                    // Today card
                    if let entry = todayEntry, calendar.isDate(displayMonth, equalTo: .now, toGranularity: .month) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("TODAY")
                                    .font(.mulish(11, weight: .bold))
                                    .foregroundColor(.solaceTerra400)
                                    .tracking(1.6)
                                Spacer()
                                Text("1 entry")
                                    .font(.mulishSmall)
                                    .foregroundColor(.solaceInk500)
                            }
                            Text(entry.title.isEmpty ? "(untitled)" : entry.title)
                                .font(.newsreader(18, weight: .medium))
                                .foregroundColor(.solaceInk900)
                        }
                        .padding(18)
                        .background(Color.solaceTerra50)
                        .clipShape(RoundedRectangle(cornerRadius: Radius.feature))
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    }

                    Spacer().frame(height: 40)
                }
            }
        }
        .navigationBarHidden(true)
    }

    private var monthName: String {
        displayMonth.formatted(.dateTime.month(.wide))
    }

    private var monthYear: String {
        displayMonth.formatted(.dateTime.year())
    }

    private func isDayToday(_ day: Int) -> Bool {
        let todayDay = calendar.component(.day, from: .now)
        return day == todayDay && calendar.isDate(displayMonth, equalTo: .now, toGranularity: .month)
    }

    private func navArrow(systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.solaceInk700)
                .frame(width: 32, height: 32)
                .background(Color.solaceBgCream)
                .clipShape(Circle())
        }
    }
}

// MARK: - Calendar extension

extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }
}

// MARK: - Simple flow layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > width {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        return CGSize(width: width, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

#Preview {
    NavigationStack {
        CalendarView()
    }
    .modelContainer(for: [Entry.self], inMemory: true)
}
