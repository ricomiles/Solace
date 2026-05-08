import SwiftUI

struct CalendarDayCell: View {
    let day: Int
    let mood: MoodType?
    let isToday: Bool
    let hasEntry: Bool
    let isOutOfMonth: Bool

    var body: some View {
        ZStack {
            // Background
            RoundedRectangle(cornerRadius: Radius.small)
                .fill(cellBackground)

            VStack(spacing: 2) {
                Text("\(day)")
                    .font(.newsreader(16))
                    .foregroundColor(textColor)

                // Mood dot
                if hasEntry, let mood = mood {
                    Circle()
                        .fill(isToday ? Color.solaceTerra200 : mood.dotColor)
                        .frame(width: 5, height: 5)
                } else if isToday {
                    Circle()
                        .fill(Color.solaceTerra200)
                        .frame(width: 5, height: 5)
                } else {
                    Spacer().frame(width: 5, height: 5)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private var cellBackground: Color {
        if isToday { return .solaceInk900 }
        if hasEntry { return .solaceBgCream }
        return .clear
    }

    private var textColor: Color {
        if isToday { return .solaceBgPaper }
        if isOutOfMonth { return .solaceInk200 }
        return .solaceInk900
    }
}
