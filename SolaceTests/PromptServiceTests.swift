import XCTest
@testable import Solace

final class PromptServiceTests: XCTestCase {
    func testTodayPromptIsNonNil() {
        let prompt = PromptService.shared.todayPrompt()
        XCTAssertFalse(prompt.text.isEmpty, "Today's prompt should not be empty")
    }

    func testSameDateAlwaysReturnsSamePrompt() {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let p1 = PromptService.shared.todayPrompt(for: date)
        let p2 = PromptService.shared.todayPrompt(for: date)
        XCTAssertEqual(p1.text, p2.text, "Same date should yield same prompt")
    }

    func testNoCrashForAnyDayOfYear() {
        let calendar = Calendar.current
        var date = calendar.date(from: DateComponents(year: 2026, month: 1, day: 1))!
        for _ in 1...365 {
            let prompt = PromptService.shared.todayPrompt(for: date)
            XCTAssertFalse(prompt.text.isEmpty)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
    }

    func testAllPromptsReturnsAtLeast90() {
        XCTAssertGreaterThanOrEqual(PromptService.shared.allPrompts().count, 90)
    }
}
