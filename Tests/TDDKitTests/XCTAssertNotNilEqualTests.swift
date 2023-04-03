import XCTest
import TDDKit

final class XCTAssertNotNilEqualTests: XCTestCase {
    func test_successfulCast_example() throws {
        let error = AnyError()

        let capturedError: Error? = error

        XCTAssertNotNilEqual(capturedError, error)
        XCTAssertEqual(capturedError as? AnyError, error)
    }

    func test_nil_example() throws {
        let error = AnyError()

        let capturedError: Error? = nil

        XCTExpectFailure {
            XCTAssertNotNilEqual(capturedError, error)
            XCTAssertEqual(capturedError as? AnyError, error)
        }
    }

    func test_wrongType_example() throws {
        struct OtherError: Error, Equatable { }
        let error = AnyError()

        let capturedError: Error? = OtherError()

        XCTExpectFailure {
            XCTAssertNotNilEqual(capturedError, error)
            XCTAssertEqual(capturedError as? AnyError, error)
        }
    }

    func test_sameTypeNotEqual_example() throws {
        let error = AnyError()

        let capturedError: Error? = AnyError()

        XCTExpectFailure {
            XCTAssertNotNilEqual(capturedError, error)
            XCTAssertEqual(capturedError as? AnyError, error)
        }
    }

    func test_throwing_example() throws {
        let error = AnyError()

        let throwing: () throws -> Error? = { throw AnyError() }

        try XCTExpectFailure {
            XCTAssertNotNilEqual(try throwing(), error)
            XCTAssertEqual(try throwing() as? AnyError, error)
        }
    }
}
