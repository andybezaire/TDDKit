import XCTest
import TDDKit

final class XCTAssertCountEqualTests: XCTestCase {
    func test_matchingArrays_example() {
        let a = ["one", "two", "three"]
        let b = ["one", "two", "three"]

        XCTAssertCountEqual(a, b)
        XCTAssertEqual(a.count, b.count)
        XCTAssertEqual(a, b)
    }

    func test_differentSizedArrays_example() {
        let a = ["one", "two", "three"]
        let b = ["one", "two"]

        XCTExpectFailure {
            XCTAssertCountEqual(a, b)
            XCTAssertEqual(a.count, b.count)
            XCTAssertEqual(a, b)
        }
    }

    func test_differentArrays_example() {
        let a = ["one", "two", "three"]
        let b = ["one", "two", "four"]

        XCTExpectFailure {
            XCTAssertCountEqual(a, b)
            XCTAssertEqual(a.count, b.count)
            XCTAssertEqual(a, b)
        }
    }

    // MARK: - with message
    func test_differentSizedArraysWithMessage_example() {
        let a = ["one", "two", "three"]
        let b = ["one", "two"]

        XCTExpectFailure {
            XCTAssertCountEqual(a, b, "Added message")
            XCTAssertEqual(a.count, b.count, "Added message")
            XCTAssertEqual(a, b, "Added message")
        }
    }

    func test_differentArraysWithMessage_example() {
        let a = ["one", "two", "three"]
        let b = ["one", "two", "four"]

        XCTExpectFailure {
            XCTAssertCountEqual(a, b, "Added message")
            XCTAssertEqual(a.count, b.count, "Added message")
            XCTAssertEqual(a, b, "Added message")
        }
    }
}
