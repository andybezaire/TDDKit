import XCTest

final class XCTAssertContainsEqualTests: XCTestCase {
    func test_equal_succeeds() {
        let sample1 = ["one", "two", "three"]

        let sut = ["one", "two", "three"].shuffled()

        XCTAssertContainsEqual(sut, sample1)
    }
}

extension XCTestCase {
    func XCTAssertContainsEqual<T>(
        _ expression1: @autoclosure () throws -> T,
        _ expression2: @autoclosure () throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) where T: Collection, T: Equatable {
    }
}
