import SwiftUI

struct WritingToolbarView: View {
    let wordCount: Int
    var onFormat: ((FormatAction) -> Void)? = nil

    enum FormatAction { case bold, italic, quote }

    var body: some View {
        HStack(spacing: 0) {
            // Format buttons
            HStack(spacing: 4) {
                formatButton("bold", action: .bold)
                formatButton("italic", action: .italic)
                formatButton("text.quote", action: .quote)
            }

            Spacer()

            // Word count
            Text("\(wordCount) words")
                .font(.mulish(11, weight: .semibold))
                .foregroundColor(.solaceInk500)

            Spacer()

            // Voice button
            Button {} label: {
                Image(systemName: "mic.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.solaceTerra200)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.solaceBgCream)
        .clipShape(Capsule())
        .shadow(color: Color.solaceInk900.opacity(0.06), radius: 8, x: 0, y: 2)
        .padding(.horizontal, 16)
    }

    private func formatButton(_ iconName: String, action: FormatAction) -> some View {
        Button {
            onFormat?(action)
        } label: {
            Image(systemName: iconName)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.solaceInk700)
                .frame(width: 36, height: 36)
        }
    }
}

#Preview {
    WritingToolbarView(wordCount: 247)
        .padding()
        .background(Color.solaceBgPaper)
}
