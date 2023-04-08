import XCTest
import TDDKit

final class XCTAnyErrorTests: XCTestCase {
    func test_xctAnyError_isEquatable() throws {
        let error1 = XCTAnyError()
        let error2 = XCTAnyError()

        XCTAssertEqual(error1, error1)
        XCTExpectFailure {
            XCTAssertEqual(error1, error2)
        }
    }

    func test_xctAnyError_throwsError() throws {
        try XCTExpectFailure {
            throw XCTAnyError()
        }
    }
}
