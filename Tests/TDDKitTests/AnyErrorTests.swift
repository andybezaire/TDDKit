import XCTest
import TDDKit

final class AnyErrorTests: XCTestCase {
    func test_anyError_isEquatable() throws {
        let error1 = AnyError()
        let error2 = AnyError()

        XCTAssertEqual(error1, error1)
        XCTExpectFailure {
            XCTAssertEqual(error1, error2)
        }
    }

    func test_anyError_throwsError() throws {
        try XCTExpectFailure {
            throw AnyError()
        }
    }
}
