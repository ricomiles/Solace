import Foundation
import SwiftData

@Model
final class Entry {
    var id: UUID
    var date: Date
    var title: String
    var body: String
    var moodRaw: String?
    var tags: [String]
    var wordCount: Int
    var promptUsed: String?
    var isFavorite: Bool
    var timeOfDay: String

    var mood: MoodType? {
        get { moodRaw.flatMap { MoodType(rawValue: $0) } }
        set { moodRaw = newValue?.rawValue }
    }

    init(
        date: Date = .now,
        title: String = "",
        body: String = "",
        mood: MoodType? = nil,
        tags: [String] = [],
        promptUsed: String? = nil
    ) {
        self.id = UUID()
        self.date = date
        self.title = title
        self.body = body
        self.moodRaw = mood?.rawValue
        self.tags = tags
        self.wordCount = 0
        self.promptUsed = promptUsed
        self.isFavorite = false
        self.timeOfDay = Entry.timeOfDayLabel(for: date)
    }

    func updateWordCount() {
        wordCount = body.split(whereSeparator: \.isWhitespace).count
    }

    static func timeOfDayLabel(for date: Date = .now) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 5..<12:  return "MORNING"
        case 12..<18: return "AFTERNOON"
        case 18..<22: return "EVENING"
        default:      return "NIGHT"
        }
    }
}
