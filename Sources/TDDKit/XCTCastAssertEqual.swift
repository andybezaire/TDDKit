import XCTest

public extension XCTestCase {
    /// Asserts that the first value can be cast to the type of the second value and they are equal.
    ///
    /// Use this function to compare two values of different types, where the first type can be cast to the second type.
    /// For example:
    /// ```
    /// func test_failingFetchX_fetchY_fails() async throws {
    ///     let error = AnyError()
    ///     let (sut, _) = makeSUT(fetchXResult: .failure(error))
    ///
    ///     let capturedError = await captureError(from: try await sut.fetchY())
    ///
    ///     XCTCastAssertEqual(capturedError, error)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - expression1: An expression of type V, where V will be cast to T.
    ///   - expression2: An expression of type T, where T is Equatable.
    ///   - message: An optional description of a failure.
    ///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
    ///   - line: The line number where the failure occurs. The default is the line number where you call this function.
    func XCTCastAssertEqual<V, T>(
        _ expression1: @autoclosure () throws -> V,
        _ expression2: @autoclosure () throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) where T: Equatable {
        guard let value = (try? expression1()) as? T else {
            XCTFail("Failed cast from type '\(V.self)' to '\(T.self)'" + message(), file: file, line: line)
            return
        }
        XCTAssertEqual(value, try expression2(), message(), file: file, line: line)
    }
}
