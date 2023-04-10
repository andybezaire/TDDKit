import XCTest

public extension XCTestCase {
    /// Asserts that the collections are the same size and that they are equal.
    /// Fails with a different message for each case.
    ///
    /// Use this function to compare two collections to easily see if they are the same size and equal.
    /// For example:
    /// ```swift
    /// func test_fetch_succeeds() async throws {
    ///     let valuesSet = uniqueValuesSet()
    ///     let values = valuesSet.map(\.value)
    ///     let responses = valuesSet.map(\.response)
    ///     let (sut, _) = makeSUT(fetchResult: .success(responses))
    ///
    ///     let capturedValues = try await sut.fetch()
    ///
    ///     XCTAssertCountEqual(capturedValues, values)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - expression1: An expression of type `T`, where `T` is an `Equatable` `Collection`.
    ///   - expression2: A second expression of type `T`, where `T` is an `Equatable` `Collection`.
    ///   - message: An optional description of a failure.
    ///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
    ///   - line: The line number where the failure occurs. The default is the line number where you call this function.
    func XCTAssertCountEqual<T>(
        _ expression1: @autoclosure () throws -> T,
        _ expression2: @autoclosure () throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) where T: Collection, T: Equatable {
        do {
            let value1 = try expression1()
            let value2 = try expression2()
            guard value1.count == value2.count else {
                let description = [
                    "XCTAssertCountEqual failed: count (\"\(value1.count)\") is not equal to (\"\(value2.count)\") for (\"\(value1)\") is not equal to (\"\(value2)\")",
                    message()
                ]
                    .filter { !$0.isEmpty }
                    .joined(separator: " - ")
                let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
                record(.init(type: .assertionFailure, compactDescription: description, sourceCodeContext: context))
                return
            }
            guard value1 == value2 else {
                let description = [
                    "XCTAssertCountEqual failed: (\"\(value1)\") is not equal to (\"\(value2)\")",
                    message()
                ]
                    .filter { !$0.isEmpty }
                    .joined(separator: " - ")
                let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
                record(.init(type: .assertionFailure, compactDescription: description, sourceCodeContext: context))
                return
            }
        } catch {
            let description = ["XCTAssertCountEqual failed: threw error \"\(error)\"", message()]
                .filter { !$0.isEmpty }
                .joined(separator: " - ")
            let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
            record(.init(type: .thrownError, compactDescription: description, sourceCodeContext: context))
        }
    }
}
