import XCTest
import TDDKit

final class XCTCastAssertEqualTests: XCTestCase {
    func test_successfulCast_example() throws {
        let error = AnyError()

        let capturedError: Error? = error

        XCTCastAssertEqual(capturedError, error)
    }

    func test_failedCast_example() throws {
        struct NotCastable: Error, Equatable { }
        let error = NotCastable()

        let capturedError: Error? = AnyError()

        XCTExpectFailure {
            XCTCastAssertEqual(capturedError, error)
        }
    }

    func test_successfulCastNotEqual_example() throws {
        let error = AnyError()

        let capturedError: Error? = AnyError()

        XCTExpectFailure {
            XCTCastAssertEqual(capturedError, error)
        }
    }
}
