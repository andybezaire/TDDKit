import XCTest

public extension XCTestCase {
    /// Assert the first value is not nil and can be cast to the type of the second value and that they are equal.
    ///
    /// Use this function to compare two values of different types, where the first type is optional and can be cast to the second type.
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
    ///   - expression1: An expression of type `V?`. This will be unwrapped and cast to `T`.
    ///   - expression2: An expression of type T`, where `T` is `Equatable`.
    ///   - message: An optional description of a failure.
    ///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
    ///   - line: The line number where the failure occurs. The default is the line number where you call this function.
    func XCTAssertCastEqual<V, T>(
        _ expression1: @autoclosure () throws -> V?,
        _ expression2: @autoclosure () throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) where T: Equatable {
        do {
            guard let unwrappedValue = (try expression1()) else {
                let description = ["XCTAssertCastEqual failed: first value was nil", message()]
                    .filter { !$0.isEmpty }
                    .joined(separator: " - ")
                let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
                record(.init(type: .assertionFailure, compactDescription: description, sourceCodeContext: context))
                return
            }
            guard let castValue = unwrappedValue as? T else {
                let description = [
                    "XCTAssertCastEqual failed: unable to cast first value from type \"\(V.self)\" to \"\(T.self)\"",
                    message()
                ]
                    .filter { !$0.isEmpty }
                    .joined(separator: " - ")
                let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
                record(.init(type: .assertionFailure, compactDescription: description, sourceCodeContext: context))
                return
            }
            XCTAssertEqual(castValue, try expression2(), message(), file: file, line: line)
        } catch {
            let description = ["XCTAssertCastEqual failed: threw error \"\(error)\"", message()]
                .filter { !$0.isEmpty }
                .joined(separator: " - ")
            let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
            record(.init(type: .thrownError, compactDescription: description, sourceCodeContext: context))
        }
    }
}
