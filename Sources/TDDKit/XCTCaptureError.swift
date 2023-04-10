import XCTest

public extension XCTestCase {
    /// Helper to extract the error from an asyncronous throwing function call.
    ///
    /// This helps reduce boilerplate code when writing error tests for TDD.
    /// For example:
    /// ```swift
    /// func test_failingGetUsername_createPoem_fails() async throws {
    ///     let error = XCTAnyError()
    ///     let (sut, _) = makeSUT(getUsernameResult: .failure(error))
    ///
    ///     let capturedError = await XCTCaptureError(from: try await sut.createPoem())
    ///
    ///     XCTAssertCastEqual(capturedError, error)
    /// }
    /// ```
    /// - Parameters:
    ///   - block: The function call under test.
    ///   - message: An optional description of a failure.
    ///   - file: The file where the failure occurs.
    ///   The default is the filename of the test case where you call this function.
    ///   - line: The line number where the failure occurs.
    ///   The default is the line number where you call this function.
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
