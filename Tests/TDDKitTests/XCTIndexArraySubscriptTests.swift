import XCTest
import TDDKit

final class XCTIndexArraySubscriptTests: XCTestCase {
    func test_outOfRange_index_example() throws {
        let array = [0, 1, 1, 2, 3, 5]

        XCTAssertEqual(array[xctIndex: 0], 0)
        XCTAssertEqual(array[xctIndex: 1], 1)
        XCTAssertEqual(array[xctIndex: 2], 1)
        XCTAssertEqual(array[xctIndex: 3], 2)
        XCTAssertEqual(array[xctIndex: 4], 3)
        XCTAssertEqual(array[xctIndex: 5], 5)
        XCTExpectFailure { XCTAssertEqual(array[xctIndex: 6], 8) }
    }
}
