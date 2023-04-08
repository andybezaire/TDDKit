import XCTest

public extension XCTestCase {
    /// Fail a test if the instance was not deallocted.
    ///
    /// Memory leaks occur when an object is not properly released from memory.
    /// This often happens when mistakenly creating a circular strong reference.
    ///
    /// This method will help to catch these kinds of errors by making sure
    /// that your object has been deallocated by the end of the test.
    /// It is most useful to use it in your makeSUT method.
    ///
    /// - Note: A test may finish without deallocating an object.
    /// This is especially likely to occur in tests involving asyncronity.
    /// It is recommended that you track all objects created for a test and make sure to
    /// wait for all long lived processes to finish before the test ends.
    ///
    /// Usage:
    ///
    /// ```swift
    /// private func makeSUT(
    ///     userLoginResult: Result<Void, Error> = .success(()),
    ///     file: StaticString = #file,
    ///     line: UInt = #line
    /// ) -> (sut: LoginFlow, spy: Spy) {
    ///
    ///     let spy = Spy(userLoginResult: userLoginResult)
    ///     let sut = LoginFlow(service: spy)
    ///
    ///     XCTAssertWillDeallocate(instance: sut, file: file, line: line)
    ///     XCTAssertWillDeallocate(instance: spy, file: file, line: line)
    ///
    ///     return (sut, spy)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - instance: The object that is expected to be deallocted.
    ///   - message: An optional description of a failure.
    ///   - file: The file where the failure occurs.
    ///   The default is the filename of the test case where you call this function.
    ///   - line: The line number where the failure occurs.
    ///   The default is the line number where you call this function.
    func XCTAssertWillDeallocate(
        instance: AnyObject,
        _ message: @escaping @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            if let instance {
                let description = [
                    "XCTAssertWillDeallocate failed: should have been deallocated \"\(String(describing: instance))\"",
                    message()
                ]
                    .filter { !$0.isEmpty }
                    .joined(separator: " - ")
                let context: XCTSourceCodeContext = .init(location: .init(filePath: file, lineNumber: line))
                self.record(.init(type: .assertionFailure, compactDescription: description, sourceCodeContext: context))
            }
        }
    }
}
