# TestHelpers

Some small helpers used to improve the testing experience.

TDD is a great way to write code. It improves code quality and brings great joy.

But it also brings a lot of boilerplate. 

These test helpers are designed with TDD in mind. 
They can help with writing tests that are clear and reduce boilerplate code.

## Helpers

### Array Subscript

Accessing an array with an index that is out of bounds will cause a runtime crash in swift. 
If this happens in a test, the default Xcode settings will pause execution and open the debugger. 
Also the error message is not very clear.

This array subscript helps by successfully failing the test and showing a nice error message at the point of access.

Usage:

```swift
let (sut, spy) = makeSUT()

sut.doLogin()

XCTAssertEqual(spy.messages.count, 1)
XCTAssertEqual(spy.messages[index: 0], .userLogin)
```

### Track Memory Leaks

Memory leaks occur when an object is not properly released from memory. 
This often happens when mistakenly creating a circular strong reference.

This method will help to catch these kinds of errors. It is most useful to use it in your makeSUT method.

Usage:

```swift
private func makeSUT(
    userLoginResult: Result<Void, Error> = .success(()),
    file: StaticString = #file,
    line: UInt = #line
) -> (sut: LoginFlow, spy: Spy) {

    let spy = Spy(userLoginResult: userLoginResult)
    let sut = LoginFlow(service: spy)

    trackMemoryLeaks(for: sut, file: file, line: line)
    trackMemoryLeaks(for: spy, file: file, line: line)

    return (sut, spy)
}
```

## Installation

### Add to Xcode project
 
Add this package as a dependency to the test target of your Xcode project.

### Add to Swift package

Add this package as a dependency to the test target of your Swift package. 
