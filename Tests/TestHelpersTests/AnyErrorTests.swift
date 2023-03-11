import XCTest
import TestHelpers

final class AnyErrorTests: XCTestCase {
    func test_anyError_isEquatable() throws {
        let error1 = AnyError()
        let error2 = AnyError()

        XCTAssertEqual(error1, error1)
        XCTAssertNotEqual(error1, error2)
    }
}
