import XCTest
import TDDKit

final class XCTCastAssertEqualTests: XCTestCase {
    func test_successfulCast_example() throws {
        let error = XCTError()

        let capturedError: Error? = error

        XCTCastAssertEqual(capturedError, error)
        XCTAssertEqual(capturedError as? XCTError, error)
    }

    func test_nil_example() throws {
        let error = XCTError()

        let capturedError: Error? = nil

        XCTExpectFailure {
            XCTCastAssertEqual(capturedError, error)
            XCTAssertEqual(capturedError as? XCTError, error)
        }
    }

    func test_wrongType_example() throws {
        struct OtherError: Error, Equatable { }
        let error = XCTError()

        let capturedError: Error? = OtherError()

        XCTExpectFailure {
            XCTCastAssertEqual(capturedError, error)
            XCTAssertEqual(capturedError as? XCTError, error)
        }
    }

    func test_sameTypeNotEqual_example() throws {
        let error = XCTError()

        let capturedError: Error? = XCTError()

        XCTExpectFailure {
            XCTCastAssertEqual(capturedError, error)
            XCTAssertEqual(capturedError as! XCTError, error)
        }
    }

    func test_throwing_example() throws {
        let error = XCTError()
        let thrownError = XCTError()

        let throwing: () throws -> Error? = { throw thrownError }

        try XCTExpectFailure {
            XCTCastAssertEqual(try throwing(), error)
            XCTAssertEqual(try throwing() as? XCTError, error)
        }
    }

    // MARK: - with message
    func test_nilWithMessage_example() throws {
        let error = XCTError()

        let capturedError: Error? = nil

        XCTExpectFailure {
            XCTCastAssertEqual(capturedError, error, "Added message")
            XCTAssertEqual(capturedError as? XCTError, error, "Added message")
        }
    }

    func test_wrongTypeWithMessage_example() throws {
        struct OtherError: Error, Equatable { }
        let error = XCTError()

        let capturedError: Error? = OtherError()

        XCTExpectFailure {
            XCTCastAssertEqual(capturedError, error, "Added message")
            XCTAssertEqual(capturedError as? XCTError, error, "Added message")
        }
    }

    func test_sameTypeNotEqualWithMessage_example() throws {
        let error = XCTError()

        let capturedError: Error? = XCTError()

        XCTExpectFailure {
            XCTCastAssertEqual(capturedError, error, "Added message")
            XCTAssertEqual(capturedError as! XCTError, error, "Added message")
        }
    }

    func test_throwingWithMessage_example() throws {
        let error = XCTError()
        let thrownError = XCTError()

        let throwing: () throws -> Error? = { throw thrownError }

        try XCTExpectFailure {
            XCTCastAssertEqual(try throwing(), error, "Added message")
            XCTAssertEqual(try throwing() as? XCTError, error, "Added message")
        }
    }
}
