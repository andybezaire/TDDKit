import XCTest
import TDDKit

final class XCTCastAssertEqualTests: XCTestCase {
    func test_successfulCast_example() throws {
        let anyError = AnyError()
        let error: Error = anyError

        XCTCastAssertEqual(error, anyError)
    }

    func test_failedCast_example() throws {
        struct NotCastable: Error, Equatable { }
        let notCastable = NotCastable()

        XCTExpectFailure {
            XCTCastAssertEqual(AnyError(), notCastable)
        }
    }

    func test_successfulCastNotEqual_example() throws {
        let error = AnyError()
        let anotherError = AnyError()

        XCTExpectFailure {
            XCTCastAssertEqual(anotherError, error)
        }
    }
}
