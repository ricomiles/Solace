import SwiftUI

struct EntryRowView: View {
    let entry: Entry
    let isFirst: Bool

    private var dayNumber: String {
        let day = Calendar.current.component(.day, from: entry.date)
        return String(day)
    }

    private var monthAbbrev: String {
        entry.date.formatted(.dateTime.month(.abbreviated)).uppercased()
    }

    var body: some View {
        HStack(alignment: .top, spacing: 18) {
            // Date column
            VStack(spacing: 2) {
                Text(dayNumber)
                    .font(.newsreader(28))
                    .foregroundColor(.solaceInk900)
                Text(monthAbbrev)
                    .font(.mulish(10, weight: .bold))
                    .foregroundColor(.solaceInk500)
                    .tracking(1.4)
            }
            .frame(width: 44)

            // Content column
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.title.isEmpty ? "(untitled)" : entry.title)
                    .font(.newsreader(17, weight: .medium))
                    .foregroundColor(.solaceInk900)
                    .lineSpacing(3)

                if !entry.body.isEmpty {
                    Text(entry.body)
                        .font(.mulishCaption)
                        .foregroundColor(.solaceInk500)
                        .lineLimit(2)
                }

                // Mood + word count
                HStack(spacing: 6) {
                    if let mood = entry.mood {
                        Circle()
                            .fill(mood.dotColor)
                            .frame(width: 6, height: 6)
                        Text(mood.displayName)
                            .font(.mulish(11, weight: .medium))
                            .foregroundColor(.solaceInk500)
                        Text("·")
                            .font(.mulish(11))
                            .foregroundColor(.solaceInk300)
                    }
                    Text("\(entry.wordCount) words")
                        .font(.mulish(11, weight: .medium))
                        .foregroundColor(.solaceInk500)
                }
                .padding(.top, 2)
            }

            Spacer()
        }
        .padding(.vertical, 18)
        .overlay(alignment: .top) {
            if isFirst {
                Rectangle()
                    .fill(Color.solaceHairlineStrong)
                    .frame(height: 1)
            }
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.solaceHairline)
                .frame(height: 1)
        }
    }
}
