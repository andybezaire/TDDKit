import XCTest

public extension XCTestCase {
    /// Capture the error from an asyncronous throwing function call.
    ///
    /// This function will return the error from a throwing call.
    /// If no error was thrown, it will record a test failure.
    ///
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
    /// 
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

// MARK: - synchronous
public extension XCTestCase {
    /// Capture the error from a throwing function call.
    ///
    /// This function will return the error from a throwing call.
    /// If no error was thrown, it will record a test failure.
    ///
    /// ```swift
    /// func test_failingGetUsername_createPoem_fails() throws {
    ///     let error = XCTAnyError()
    ///     let (sut, _) = makeSUT(getUsernameResult: .failure(error))
    ///
    ///     let capturedError = XCTCaptureError(from: try sut.createPoem())
    ///
    ///     XCTAssertCastEqual(capturedError, error)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - block: The function call under test.
    ///   - message: An optional description of a failure.
    ///   - file: The file where the failure occurs.
    ///   The default is the filename of the test case where you call this function.
    ///   - line: The line number where the failure occurs.
    ///   The default is the line number where you call this function.
    /// - Returns: The error thrown from the block or nil if no error thrown.
     func XCTCaptureError<T>(
        from block: @autoclosure () throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
     ) -> Error? {
        do {
            _ = try block()
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

// MARK: - result completion
public extension XCTestCase {
    /// Capture the error from function that completes with a `Result`.
    ///
    /// This function will return the error from a call that completes with a `Result`.
    /// If it doesn't complete with an error, it will record a test failure.
    ///
    /// ```swift
    /// func test_failingGetUsername_createPoem_fails() async {
    ///     let error = XCTAnyError()
    ///     let (sut, _) = makeSUT(getUsernameResult: .failure(error))
    ///
    ///     let capturedError = await XCTCaptureError(from: { sut.createPoem(completion: $0) })
    ///
    ///     XCTAssertCastEqual(capturedError, error)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - resultCompletionBlock: The function call under test that completes with a `Result`.
    ///   - message: An optional description of a failure.
    ///   - file: The file where the failure occurs.
    ///   The default is the filename of the test case where you call this function.
    ///   - line: The line number where the failure occurs.
    ///   The default is the line number where you call this function.
    /// - Returns: The error thrown from the block or nil if no error thrown.
    /// If no error is thrown, the function will record a test failure.
     func XCTCaptureError<T, Failure>(
        from resultCompletionBlock: @escaping (@escaping (Result<T, Failure>) -> Void) -> Void,
        _ message: @escaping @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
     ) async -> Failure? where Failure: Error {
         await withCheckedContinuation { continuation in
             resultCompletionBlock { result in
                 switch result {
                 case .success:
                     let description = ["XCTCaptureError failed: should have thrown an error", message()]
                         .filter { !$0.isEmpty }
                         .joined(separator: " - ")
                     let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
                     self.record(.init(type: .assertionFailure, compactDescription: description, sourceCodeContext: context))
                     continuation.resume(returning: nil)
                 case let .failure(error):
                     continuation.resume(returning: error)
                 }
             }
         }
    }
}

