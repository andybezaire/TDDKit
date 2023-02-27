import XCTest
@testable import TestHelpers

final class TestHelpersTests: XCTestCase {
    func test_outOfRange_index_example() throws {
        let array = [0, 1, 1, 2, 3, 5]

        XCTAssertEqual(array[index: 0], 0)
        XCTAssertEqual(array[index: 1], 1)
        XCTAssertEqual(array[index: 2], 1)
        XCTAssertEqual(array[index: 3], 2)
        XCTAssertEqual(array[index: 4], 3)
        XCTAssertEqual(array[index: 5], 5)
        XCTExpectFailure { XCTAssertEqual(array[index: 6], 8) }
    }
}
