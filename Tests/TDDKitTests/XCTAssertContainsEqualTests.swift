import XCTest

final class XCTAssertContainsEqualTests: XCTestCase {
    func test_equal_succeeds() {
        let sample = ["one", "two", "three"]

        let sut = ["one", "two", "three"].shuffled()

        XCTAssertContainsEqual(sut, sample)
    }

    func test_missingOne_showsMissingElement() {
        let sample = ["one", "two", "three"]

        let sut = ["one", "three"].shuffled()

        XCTExpectFailure {
            XCTAssertContainsEqual(sut, sample)
        }
    }

    func test_missingTwo_showsMissingElements() {
        let sample = ["one", "two", "three"]

        let sut = ["three"]

        XCTExpectFailure {
            XCTAssertContainsEqual(sut, sample)
        }
    }

    func test_oneExtra_showsExtraElement() {
        let sample = ["one", "two", "three"]

        let sut = ["one", "two", "three", "four"].shuffled()

        XCTExpectFailure {
            XCTAssertContainsEqual(sut, sample)
        }
    }

    func test_twoExtra_showsExtraElements() {
        let sample = ["one", "two", "three"]

        let sut = ["one", "two", "three", "four", "five"].shuffled()

        XCTExpectFailure {
            XCTAssertContainsEqual(sut, sample)
        }
    }
}

extension XCTestCase {
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
                "XCTAssertContainsEqual failed: expression1 missing elements (\"\(result)\")",
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
