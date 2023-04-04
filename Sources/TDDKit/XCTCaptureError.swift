import XCTest

public extension XCTestCase {
    /// Helper to extract the error from an asyncronous throwing function call.
    ///
    /// This helps reduce boilerplate code when writing error tests for TDD.
    /// For example:
    /// ```
    /// func test_failingFetchX_fetchY_fails() async throws {
    ///     let error = XCTError()
    ///     let (sut, _) = makeSUT(fetchXResult: .failure(error))
    ///
    ///     let capturedError = await XCTCaptureError(from: try await sut.fetchY())
    ///
    ///     XCTCastAssertEqual(capturedError, error)
    /// }
    /// ```
    /// - Parameter block: The function call under test.
    /// - Returns: The error thrown from the block or nil if no error thrown.
     func XCTCaptureError<T>(
        from block: @autoclosure () async throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
     ) async -> Error? {
        do {
            _ = try await block()
            let description = ["XCTCaptureError failed: should have thrown an error", message()]
                .filter { !$0.isEmpty }
                .joined(separator: " - ")
            let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
            record(.init(type: .assertionFailure, compactDescription: description, sourceCodeContext: context))
            return nil
        } catch {
            return error
        }
    }
}
