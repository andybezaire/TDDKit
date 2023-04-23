import XCTest
import TDDKit

final class XCTCaptureErrorTests: XCTestCase {
    func test_succedingBlock_captureError_capturesNil() async throws {
        let block: () async throws -> Void = { }

        XCTExpectFailure()
        let capturedError = await XCTCaptureError(from: try await block())

        XCTAssertNil(capturedError)
    }

    func test_failingBlock_captureError_succeeds() async throws {
        let error = XCTAnyError()
        let block: () async throws -> Void = { throw error }

        let capturedError = await XCTCaptureError(from: try await block())

        XCTAssertCastEqual(capturedError, error)
    }

    // MARK: - With message
    func test_succedingBlockWithMessage_captureError_fails() async throws {
        let block: () async throws -> Void = { }

        XCTExpectFailure()
        let capturedError = await XCTCaptureError(from: try await block(), "Added message")

        XCTAssertNil(capturedError)
    }
}
