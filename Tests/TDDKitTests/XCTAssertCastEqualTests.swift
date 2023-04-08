import XCTest
import TDDKit

final class XCTAssertCastEqualTests: XCTestCase {
    func test_successfulCast_example() throws {
        let error = XCTAnyError()

        let capturedError: Error? = error

        XCTAssertCastEqual(capturedError, error)
        XCTAssertEqual(capturedError as? XCTAnyError, error)
    }

    func test_nil_example() throws {
        let error = XCTAnyError()

        let capturedError: Error? = nil

        XCTExpectFailure {
            XCTAssertCastEqual(capturedError, error)
            XCTAssertEqual(capturedError as? XCTAnyError, error)
        }
    }

    func test_wrongType_example() throws {
        struct OtherError: Error, Equatable { }
        let error = XCTAnyError()

        let capturedError: Error? = OtherError()

        XCTExpectFailure {
            XCTAssertCastEqual(capturedError, error)
            XCTAssertEqual(capturedError as? XCTAnyError, error)
        }
    }

    func test_sameTypeNotEqual_example() throws {
        let error = XCTAnyError()

        let capturedError: Error? = XCTAnyError()

        XCTExpectFailure {
            XCTAssertCastEqual(capturedError, error)
            XCTAssertEqual(capturedError as! XCTAnyError, error)
        }
    }

    func test_throwing_example() throws {
        let error = XCTAnyError()
        let thrownError = XCTAnyError()

        let throwing: () throws -> Error? = { throw thrownError }

        try XCTExpectFailure {
            XCTAssertCastEqual(try throwing(), error)
            XCTAssertEqual(try throwing() as? XCTAnyError, error)
        }
    }

    // MARK: - with message
    func test_nilWithMessage_example() throws {
        let error = XCTAnyError()

        let capturedError: Error? = nil

        XCTExpectFailure {
            XCTAssertCastEqual(capturedError, error, "Added message")
            XCTAssertEqual(capturedError as? XCTAnyError, error, "Added message")
        }
    }

    func test_wrongTypeWithMessage_example() throws {
        struct OtherError: Error, Equatable { }
        let error = XCTAnyError()

        let capturedError: Error? = OtherError()

        XCTExpectFailure {
            XCTAssertCastEqual(capturedError, error, "Added message")
            XCTAssertEqual(capturedError as? XCTAnyError, error, "Added message")
        }
    }

    func test_sameTypeNotEqualWithMessage_example() throws {
        let error = XCTAnyError()

        let capturedError: Error? = XCTAnyError()

        XCTExpectFailure {
            XCTAssertCastEqual(capturedError, error, "Added message")
            XCTAssertEqual(capturedError as! XCTAnyError, error, "Added message")
        }
    }

    func test_throwingWithMessage_example() throws {
        let error = XCTAnyError()
        let thrownError = XCTAnyError()

        let throwing: () throws -> Error? = { throw thrownError }

        try XCTExpectFailure {
            XCTAssertCastEqual(try throwing(), error, "Added message")
            XCTAssertEqual(try throwing() as? XCTAnyError, error, "Added message")
        }
    }
}
