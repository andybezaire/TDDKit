# Utility

Additional test helpers.


### XCTAnyError

- ``XCTest/XCTestCase/XCTAnyError``

This `Equatable` `Identifiable` `Error` can be used to help test errors thrown by dependencies.

Usage:
```swift
func test_failingGetUsername_createPoem_fails() async throws {
    let error = XCTAnyError()
    let (sut, _) = makeSUT(getUsernameResult: .failure(error))
    
    let capturedError = await XCTCaptureError(from: try await sut.createPoem())
    
    XCTAssertCastEqual(capturedError, error)
}
```


### Index Array Subscript

- ``Swift/Collection/subscript(xctIndex:_:_:)``

Accessing an array with an index that is out of bounds will cause a runtime crash in swift. 
If this happens in a test, the default Xcode settings will pause execution and open the debugger. 
Also the error message is not very clear.

This array subscript helps by successfully failing the test and showing a nice error message at the point of access.

Usage:
```swift
func test_doLogin_callsServices() async throws {
    let (sut, spy) = makeSUT()

    sut.doLogin()

    XCTAssertEqual(spy.messages.count, 1)
    XCTAssertEqual(spy.messages[xctIndex: 0], .userLogin)
}
```
