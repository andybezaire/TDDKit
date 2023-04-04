import XCTest
import TDDKit

final class XCTErrorTests: XCTestCase {
    func test_xctError_isEquatable() throws {
        let error1 = XCTError()
        let error2 = XCTError()

        XCTAssertEqual(error1, error1)
        XCTExpectFailure {
            XCTAssertEqual(error1, error2)
        }
    }

    func test_xctError_throwsError() throws {
        try XCTExpectFailure {
            throw XCTError()
        }
    }
}
