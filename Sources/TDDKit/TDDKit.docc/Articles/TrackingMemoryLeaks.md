# Tracking Memory Leaks

Track an object to see if it is deallocated at the end of the test.

## Overview

Memory leaks occur when an object is not properly released from memory.
This often happens when mistakenly creating a circular strong reference.

This helper uses the `XCTestCase().addTeardownBlock(_:)` to schedule a check at the
end of the test. If the instance was not released, a test failure will be recorded.

### Assert Will Deallocate Instance

- ``XCTest/XCTestCase/XCTAssertWillDeallocate(instance:_:file:line:)``

This method will help to catch these kinds of errors by making sure
that your object has been deallocated by the end of the test.
It is most useful to use it in your `makeSUT` method.

Usage:
```swift
private func makeSUT(
    userLoginResult: Result<Void, Error> = .success(()),
    file: StaticString = #file,
    line: UInt = #line
) -> (sut: LoginFlow, spy: Spy) {

    let spy = Spy(userLoginResult: userLoginResult)
    let sut = LoginFlow(service: spy)

    XCTAssertWillDeallocate(instance: sut, file: file, line: line)
    XCTAssertWillDeallocate(instance: spy, file: file, line: line)

    return (sut, spy)
}
```
