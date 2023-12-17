import XCTest

public extension XCTestCase {
    /// Assert the first collection exactly contains all the elements of the second collection.
    ///
    /// The assert will fail with a different message for missing elements, extra elements, or both.
    /// This is an order independent compare.
    /// Use this function to compare two collections to easily see if they contain exactly the same elements.
    /// 
    /// ```swift
    /// func test_createPoem_callsServices() async throws {
    ///     let (sut, spy) = makeSUT()
    ///
    ///     _ = try await sut.createPoem()
    ///
    ///     XCTAssertContainsEqual(spy.messages, [.getAge, .getUsername])
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - expression1: An expression of type `T`, where `T` is a `Collection`  whose `Element`s are `Equatable`.
    ///   - expression2: A second expression of type `T`, where `T` is a `Collection`  whose `Element`s are `Equatable`.
    ///   - message: An optional description of a failure.
    ///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
    ///   - line: The line number where the failure occurs. The default is the line number where you call this function.
    func XCTAssertContainsEqual<T>(
        _ expression1: @autoclosure () throws -> T,
        _ expression2: @autoclosure () throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) where T: Collection, T.Element: Equatable {
        do {
            let collection1 = Array(try expression1())
            let collection2 = Array(try expression2())

            let missingResult = collection1.reduce(collection2) { partial, element in
                var partialResult = partial
                if let index = partialResult.firstIndex(of: element) {
                    partialResult.remove(at: index)
                }
                return partialResult
            }

            let extraResult = collection2.reduce(collection1) { partial, element in
                var partialResult = partial
                if let index = partialResult.firstIndex(of: element) {
                    partialResult.remove(at: index)
                }
                return partialResult
            }

            guard missingResult.isEmpty else {
                let missing = missingResult.count
                let extra = extraResult.count
                let description = [
                    "XCTAssertContainsEqual failed: expression1 missing \(missing) element(s) (\"\(missingResult)\")" +
                    (extraResult.isEmpty ? "" : " and has \(extra) extra element(s) (\"\(extraResult)\")"),
                    message()
                ]
                    .filter { !$0.isEmpty }
                    .joined(separator: " - ")
                let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
                record(.init(type: .assertionFailure, compactDescription: description, sourceCodeContext: context))
                return
            }

            guard extraResult.isEmpty else {
                let extra = extraResult.count
                let description = [
                    "XCTAssertContainsEqual failed: expression1 has \(extra) extra element(s) (\"\(extraResult)\")",
                    message()
                ]
                    .filter { !$0.isEmpty }
                    .joined(separator: " - ")
                let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
                record(.init(type: .assertionFailure, compactDescription: description, sourceCodeContext: context))
                return
            }
        } catch {
            let description = ["XCTAssertContainsEqual failed: threw error \"\(error)\"", message()]
                .filter { !$0.isEmpty }
                .joined(separator: " - ")
            let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
            record(.init(type: .thrownError, compactDescription: description, sourceCodeContext: context))
        }
    }
}
