import SwiftUI
import SwiftData

struct EntryDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let entry: Entry
    let entries: [Entry]
    let currentIndex: Int

    @State private var showEllipsis = false

    private var positionText: String {
        "\(currentIndex + 1) of \(entries.count)"
    }

    private var dateHeader: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE · d MMM"
        return "\(formatter.string(from: entry.date).uppercased()) | \(entry.timeOfDay)"
    }

    private var entryParagraphs: [String] {
        entry.body.components(separatedBy: "\n\n").filter { !$0.isEmpty }
    }

    var body: some View {
        ZStack {
            Color.solaceBgPaper.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Top bar
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.solaceInk700)
                                .frame(width: 36, height: 36)
                                .background(Color.solaceBgCream)
                                .clipShape(Circle())
                        }

                        Spacer()

                        Text(positionText)
                            .font(.mulishSmall)
                            .foregroundColor(.solaceInk500)

                        Spacer()

                        HStack(spacing: 8) {
                            Button {
                                entry.isFavorite.toggle()
                                try? modelContext.save()
                            } label: {
                                Image(systemName: entry.isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 14))
                                    .foregroundColor(entry.isFavorite ? .solaceTerra300 : .solaceInk700)
                                    .frame(width: 36, height: 36)
                                    .background(Color.solaceBgCream)
                                    .clipShape(Circle())
                            }

                            Button { showEllipsis = true } label: {
                                Image(systemName: "ellipsis")
                                    .font(.system(size: 14))
                                    .foregroundColor(.solaceInk700)
                                    .frame(width: 36, height: 36)
                                    .background(Color.solaceBgCream)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.top, 46)
                    .padding(.horizontal, 20)

                    // Date / time header
                    HStack(spacing: 10) {
                        Text(dateHeader)
                            .font(.mulish(11, weight: .bold))
                            .foregroundColor(.solaceTerra400)
                            .tracking(1.6)
                    }
                    .padding(.top, 36)
                    .padding(.horizontal, Spacing.pageHPad)

                    // Title
                    Text(entry.title.isEmpty ? "(untitled)" : entry.title)
                        .font(.newsreaderH1Entry)
                        .foregroundColor(.solaceInk900)
                        .lineSpacing(4)
                        .padding(.top, 14)
                        .padding(.horizontal, Spacing.pageHPad)

                    // Stats row
                    HStack(spacing: 8) {
                        if let mood = entry.mood {
                            Circle()
                                .fill(mood.dotColor)
                                .frame(width: 6, height: 6)
                            Text(mood.displayName)
                                .font(.mulishSmall)
                                .foregroundColor(.solaceInk500)
                            dotSeparator
                        }
                        Text("\(entry.wordCount) words")
                            .font(.mulishSmall)
                            .foregroundColor(.solaceInk500)
                    }
                    .padding(.top, 18)
                    .padding(.horizontal, Spacing.pageHPad)

                    // Decorative divider
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.solaceHairlineStrong)
                            .frame(height: 1)
                        Circle()
                            .fill(Color.solaceTerra200)
                            .frame(width: 5, height: 5)
                            .padding(.horizontal, 8)
                        Rectangle()
                            .fill(Color.solaceHairlineStrong)
                            .frame(height: 1)
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, Spacing.pageHPad)

                    // Body
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(Array(entryParagraphs.enumerated()), id: \.offset) { index, paragraph in
                            if index == 0 && !paragraph.isEmpty {
                                dropCapParagraph(paragraph)
                            } else if paragraph.hasPrefix("> ") {
                                pullQuote(String(paragraph.dropFirst(2)))
                            } else {
                                Text(paragraph)
                                    .font(.newsreaderBody)
                                    .foregroundColor(.solaceInk700)
                                    .lineSpacing(6)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, Spacing.pageHPad)
                    .padding(.bottom, 60)
                }
            }
        }
        .navigationBarHidden(true)
        .confirmationDialog("Entry", isPresented: $showEllipsis) {
            Button("Delete entry", role: .destructive) {
                modelContext.delete(entry)
                try? modelContext.save()
                dismiss()
            }
        }
    }

    private var dotSeparator: some View {
        Circle()
            .fill(Color.solaceInk300)
            .frame(width: 3, height: 3)
    }

    private func dropCapParagraph(_ text: String) -> some View {
        let firstChar = text.prefix(1)
        let rest = text.dropFirst()
        return HStack(alignment: .top, spacing: 0) {
            Text(firstChar)
                .font(.newsreader(56))
                .foregroundColor(.solaceTerra300)
                .baselineOffset(-8)
                .padding(.trailing, 4)
                .padding(.top, 2)
            Text(rest)
                .font(.newsreaderBody)
                .foregroundColor(.solaceInk700)
                .lineSpacing(6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func pullQuote(_ text: String) -> some View {
        Text(text)
            .font(.newsreader(18, italic: true))
            .foregroundColor(.solaceInk900)
            .lineSpacing(4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)
            .overlay(alignment: .leading) {
                Rectangle()
                    .fill(Color.solaceTerra200)
                    .frame(width: 2)
            }
    }
}
