import XCTest
import SwiftData
@testable import Solace

final class EntryTests: XCTestCase {
    func testWordCountTwoWords() {
        let entry = Entry()
        entry.body = "Hello world"
        entry.updateWordCount()
        XCTAssertEqual(entry.wordCount, 2)
    }

    func testWordCountEmptyBody() {
        let entry = Entry()
        entry.body = ""
        entry.updateWordCount()
        XCTAssertEqual(entry.wordCount, 0)
    }

    func testWordCountAcrossNewlines() {
        let entry = Entry()
        entry.body = "Line one\nLine two\n\nLine three"
        entry.updateWordCount()
        XCTAssertEqual(entry.wordCount, 6)
    }

    func testWordCountSingleWord() {
        let entry = Entry()
        entry.body = "solace"
        entry.updateWordCount()
        XCTAssertEqual(entry.wordCount, 1)
    }

    func testMoodRoundTrip() {
        let entry = Entry()
        entry.mood = .calm
        XCTAssertEqual(entry.moodRaw, "calm")
        XCTAssertEqual(entry.mood, .calm)
    }

    func testMoodNilWhenRawInvalid() {
        let entry = Entry()
        entry.moodRaw = "unknown_mood"
        XCTAssertNil(entry.mood)
    }

    func testTimeOfDayEvening() {
        // 19:00
        var components = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        components.hour = 19
        let date = Calendar.current.date(from: components)!
        XCTAssertEqual(Entry.timeOfDayLabel(for: date), "EVENING")
    }

    func testTimeOfDayMorning() {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        components.hour = 9
        let date = Calendar.current.date(from: components)!
        XCTAssertEqual(Entry.timeOfDayLabel(for: date), "MORNING")
    }
}
