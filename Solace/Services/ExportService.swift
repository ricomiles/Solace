import SwiftUI
import UIKit

struct ExportService {
    static let shared = ExportService()

    private init() {}

    func plainTextDocument(from entries: [Entry]) -> String {
        guard !entries.isEmpty else {
            return "No entries to export.\n"
        }
        let sorted = entries.sorted { $0.date < $1.date }
        return sorted.map { entry in
            let dateStr = entry.date.formatted(date: .complete, time: .shortened)
            let moodStr = entry.mood?.displayName ?? "—"
            let titleStr = entry.title.isEmpty ? "(untitled)" : entry.title
            return "---\n\(dateStr)\n\(titleStr)\nMood: \(moodStr)\n\n\(entry.body)\n"
        }.joined(separator: "\n")
    }
}

// MARK: - UIActivityViewController representable

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

extension View {
    func exportSheet(isPresented: Binding<Bool>, entries: [Entry]) -> some View {
        sheet(isPresented: isPresented) {
            ActivityView(activityItems: [ExportService.shared.plainTextDocument(from: entries)])
                .presentationDetents([.medium, .large])
        }
    }
}
