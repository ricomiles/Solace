import XCTest
@testable import Solace

final class MoodTypeTests: XCTestCase {
    func testAllCasesHaveDistinctRawValues() {
        let rawValues = MoodType.allCases.map(\.rawValue)
        XCTAssertEqual(Set(rawValues).count, MoodType.allCases.count, "All mood rawValues should be distinct")
    }

    func testRawValueRoundTrip() {
        for mood in MoodType.allCases {
            let roundTripped = MoodType(rawValue: mood.rawValue)
            XCTAssertEqual(roundTripped, mood, "\(mood.rawValue) should round-trip")
        }
    }

    func testAllCasesHaveNonEmptyDisplayName() {
        for mood in MoodType.allCases {
            XCTAssertFalse(mood.displayName.isEmpty)
        }
    }

    func testAllCasesHaveDistinctDotColors() {
        let descriptions = MoodType.allCases.map { "\($0.dotColor)" }
        XCTAssertEqual(Set(descriptions).count, MoodType.allCases.count, "All mood dot colors should be distinct")
    }
}
