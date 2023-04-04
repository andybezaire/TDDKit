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
    ///     expectWillDeallocate(for: sut, file: file, line: line)
    ///     expectWillDeallocate(for: spy, file: file, line: line)
    ///
    ///     return (sut, spy)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - instance: The object that is expected to be deallocted.
    ///   - file: The file where the failure occurs.
    ///   The default is the filename of the test case where you call this function.
    ///   - line: The line number where the failure occurs.
    ///   The default is the line number where you call this function.
    func expectWillDeallocate(instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Should have been deallocated. Possible memory leak.", file: file, line: line)
        }
    }
}
