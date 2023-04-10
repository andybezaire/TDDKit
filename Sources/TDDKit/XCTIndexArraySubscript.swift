import XCTest

extension Collection {
    /// Access a `Collection`'s `Element` at a given index and `XCTFail` if out-of-bounds.
    ///
    /// Use this function to access an element of a collection without stopping execution.
    /// If the `xctIndex` is out-of-bounds it will result in a test failure.
    ///
    /// For example:
    /// ```swift
    /// func test_doLogin_callsServices() async throws {
    ///     let (sut, spy) = makeSUT()
    ///
    ///     sut.doLogin()
    ///
    ///     XCTAssertEqual(spy.messages.count, 1)
    ///     XCTAssertEqual(spy.messages[xctIndex: 0], .userLogin)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - xctIndex: The index of the element in the array.
    ///   - file: The file where the failure occurs. The default is the filename of the test case where you call this function.
    ///   - line: The line number where the failure occurs. The default is the line number where you call this function.
    /// - Returns: The element at that index or nil and fails with `XCTFail`.
    public subscript(xctIndex index: Index, file: StaticString = #file, line: UInt = #line) -> Element? {
        guard indices.contains(index) else {
            XCTFail("index \(index) out of range \(startIndex) ..< \(endIndex).", file: file, line: line)
            return nil
        }

        return self[index]
    }
}
