import XCTest

public extension XCTestCase {
    func XCTCountAssertEqual<T>(
        _ expression1: @autoclosure () throws -> T,
        _ expression2: @autoclosure () throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) where T: Equatable, T: Collection {
        do {
            let value1 = try expression1()
            let value2 = try expression2()
            guard value1.count == value2.count else {
                let description = [
                    "XCTAssertEqual failed: count (\"\(value1.count)\") is not equal to (\"\(value2.count)\") for (\"\(value1)\") is not equal to (\"\(value2)\")",
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
                    "XCTAssertEqual failed: (\"\(value1)\") is not equal to (\"\(value2)\")",
                    message()
                ]
                    .filter { !$0.isEmpty }
                    .joined(separator: " - ")
                let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
                record(.init(type: .assertionFailure, compactDescription: description, sourceCodeContext: context))
                return
            }
        } catch {
            let description = ["XCTAssertNotNilEqual failed: threw error \"\(error)\"", message()]
                .filter { !$0.isEmpty }
                .joined(separator: " - ")
            let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
            record(.init(type: .thrownError, compactDescription: description, sourceCodeContext: context))
        }
    }
}
