import SwiftUI

struct SearchResultCard: View {
    let entry: Entry
    let query: String

    private func snippetViews() -> (Text, Text, Text) {
        let text = entry.body.isEmpty ? entry.title : entry.body
        let windowSize = 120

        let lowered = text.lowercased()
        let queryLowered = query.lowercased()

        guard !queryLowered.isEmpty, let matchRange = lowered.range(of: queryLowered) else {
            let prefix = String(text.prefix(windowSize))
            return (Text(prefix + (text.count > windowSize ? "…" : "")), Text(""), Text(""))
        }

        let startOffset = max(0, text.distance(from: text.startIndex, to: matchRange.lowerBound) - 40)
        let startIndex = text.index(text.startIndex, offsetBy: startOffset)
        let endOffset = min(text.count, startOffset + windowSize)
        let endIndex = text.index(text.startIndex, offsetBy: endOffset)
        let window = String(text[startIndex..<endIndex])

        let windowLowered = window.lowercased()
        guard let winMatchRange = windowLowered.range(of: queryLowered) else {
            return (Text(window), Text(""), Text(""))
        }

        let before = String(window[window.startIndex..<winMatchRange.lowerBound])
        let match  = String(window[winMatchRange])
        let afterStartIndex = winMatchRange.upperBound
        let afterStr = String(window[afterStartIndex...]) + (endOffset < text.count ? "…" : "")

        return (Text(before), Text(match), Text(afterStr))
    }

    var body: some View {
        let (before, match, after) = snippetViews()

        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(entry.title.isEmpty ? "(untitled)" : entry.title)
                    .font(.newsreader(16, weight: .medium))
                    .foregroundColor(.solaceInk900)
                    .lineLimit(1)
                Spacer()
                Text(entry.date.formatted(.dateTime.day().month(.abbreviated).year()))
                    .font(.mulish(11, weight: .medium))
                    .foregroundColor(.solaceInk500)
            }

            (before.font(.newsreader(14)).foregroundColor(.solaceInk700)
             + match.font(.newsreader(14, weight: .semibold)).foregroundColor(.solaceTerra400)
             + after.font(.newsreader(14)).foregroundColor(.solaceInk700))
                .lineSpacing(4)
                .lineLimit(3)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.solaceBgPaper)
        .clipShape(RoundedRectangle(cornerRadius: Radius.card))
    }
}
