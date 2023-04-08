import XCTest

public extension XCTestCase {
    func XCTAssertContainsEqual<T>(
        _ expression1: @autoclosure () throws -> T,
        _ expression2: @autoclosure () throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) where T: Collection, T.Element: Equatable {
        let c1 = try! expression1()
        let c2 = try! expression2()
        let a1 = Array(c1)
        let a2 = Array(c2)

        let result = c1.reduce(a2) { partial, element in
            var partialResult = partial
            if let index = partialResult.firstIndex(of: element) {
                partialResult.remove(at: index)
            }
            return partialResult
        }

        let extraResult = c2.reduce(a1) { partial, element in
            var partialResult = partial
            if let index = partialResult.firstIndex(of: element) {
                partialResult.remove(at: index)
            }
            return partialResult
        }

        guard result.isEmpty else {
            let description = [
                "XCTAssertContainsEqual failed: expression1 missing elements (\"\(result)\")" +
                (extraResult.isEmpty ? "" : " and has extra elements (\"\(extraResult)\")"),
                message()
            ]
                .filter { !$0.isEmpty }
                .joined(separator: " - ")
            let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
            record(.init(type: .assertionFailure, compactDescription: description, sourceCodeContext: context))
            return
        }

        guard extraResult.isEmpty else {
            let description = [
                "XCTAssertContainsEqual failed: expression1 has extra elements (\"\(extraResult)\")",
                message()
            ]
                .filter { !$0.isEmpty }
                .joined(separator: " - ")
            let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
            record(.init(type: .assertionFailure, compactDescription: description, sourceCodeContext: context))
            return
        }
    }
}
