import XCTest
@testable import Solace

final class ExportServiceTests: XCTestCase {
    func testEmptyEntriesDocument() {
        let doc = ExportService.shared.plainTextDocument(from: [])
        XCTAssertTrue(doc.contains("No entries to export"))
    }

    func testDocumentContainsTitles() {
        let entry = Entry(title: "TestTitle", body: "Some body text")
        entry.updateWordCount()
        let doc = ExportService.shared.plainTextDocument(from: [entry])
        XCTAssertTrue(doc.contains("TestTitle"))
    }

    func testDocumentChronologicalOrder() {
        let older = Entry(date: Date(timeIntervalSince1970: 1_000_000), title: "First")
        let newer = Entry(date: Date(timeIntervalSince1970: 2_000_000), title: "Second")
        let doc = ExportService.shared.plainTextDocument(from: [newer, older])
        let firstPos = doc.range(of: "First")!.lowerBound
        let secondPos = doc.range(of: "Second")!.lowerBound
        XCTAssertLessThan(firstPos, secondPos, "Older entry should appear first")
    }

    func testDocumentIncludesMood() {
        let entry = Entry(mood: .calm)
        let doc = ExportService.shared.plainTextDocument(from: [entry])
        XCTAssertTrue(doc.contains("Calm"))
    }

    func testDocumentNoMoodShowsDash() {
        let entry = Entry()
        let doc = ExportService.shared.plainTextDocument(from: [entry])
        XCTAssertTrue(doc.contains("Mood: —"))
    }
}
