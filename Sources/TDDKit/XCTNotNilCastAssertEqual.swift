import XCTest

public extension XCTestCase {
    /// Asserts that the first value is not nil and can be cast to the type of the second value and that they are equal.
    ///
    /// Use this function to compare two values of different types, where the first type is optional and can be cast to the second type.
    /// For example:
    /// ```
    /// func test_failingFetchX_fetchY_fails() async throws {
    ///     let error = AnyError()
    ///     let (sut, _) = makeSUT(fetchXResult: .failure(error))
    ///
    ///     let capturedError: Error? = await captureError(from: try await sut.fetchY())
    ///
    ///     XCTNotNilCastAssertEqual(capturedError, error)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - expression1: An expression of type V?. This will be unwrapped and cast to T.
    ///   - expression2: An expression of type T, where T is Equatable.
    ///   - message: An optional description of a failure.
    ///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
    ///   - line: The line number where the failure occurs. The default is the line number where you call this function.
    func XCTNotNilCastAssertEqual<V, T>(
        _ expression1: @autoclosure () throws -> V?,
        _ expression2: @autoclosure () throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) where T: Equatable {
        do {
            guard let value = (try expression1()) as? T else {
                let issue: XCTIssue = .init(
                    type: .assertionFailure,
                    compactDescription: "XCTCastAssertEqual failed: unable to cast first value " +
                    "from type \"\(V.self)\" to \"\(T.self)\" " + message(),
                    sourceCodeContext: .init(location: .init(filePath: file, lineNumber: line))
                )
                record(issue)
                return
            }
            XCTAssertEqual(value, try expression2(), message(), file: file, line: line)
        } catch {
            let issue: XCTIssue = .init(
                type: .thrownError,
                compactDescription: "XCTAssertNotNilEqual failed: threw error \"\(error)\" "
                + message(),
                sourceCodeContext: .init(location: .init(filePath: file, lineNumber: line))
            )
            record(issue)
        }
    }
}
