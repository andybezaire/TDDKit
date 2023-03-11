import XCTest

public extension XCTestCase {
    /// Helper to extract the error from an asyncronous throwing function call.
    ///
    /// This helps reduce boilerplate code when writing error tests for TDD.
    /// For example:
    /// ```
    /// func test_failingFetchX_fetchY_fails() async throws {
    ///     let error = AnyError()
    ///     let (sut, _) = makeSUT(fetchXResult: .failure(error))
    ///
    ///     let capturedError = await captureError(from: try await sut.fetchY())
    ///
    ///     XCTAssertNotNil(error)
    ///     XCTAssertEqual(capturedError as? AnyError, error)
    /// }
    /// ```
    /// - Parameter block: The function call under test.
    /// - Returns: The error thrown from the block or nil if no error thrown.
     func captureError<T>(
        from block: @autoclosure () async throws -> T,
        file: StaticString = #file,
        line: UInt = #line
     ) async -> Error {
        do {
            _ = try await block()
            XCTFail("Should have thrown an Error.", file: file, line: line)
            return CaptureError.noErrorThrown
        } catch {
            return error
        }
    }
}

public enum CaptureError: Error { case noErrorThrown }
