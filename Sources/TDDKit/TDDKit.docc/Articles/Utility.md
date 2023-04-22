# Utility

Additional test helpers.


### Custom Debug String Convertible

- ``XCTCustomDebugStringConvertible``

Sometimes helper classes created in a test like `Spy`s and their `enum Message` values 
are very long when printed during a test failure. This can make it hard to see what the 
class or enum case was.

This protocol has a default conformance that can help by printing the class name or enum case only.  

For example, the default error output for a memory leak using 
``XCTest/XCTestCase/XCTAssertWillDeallocate(instance:_:file:line:)`` would be:

```swift
func test_selfReferencing_example() throws {
    let sut = Instance()
    sut.reference = sut

    XCTExpectFailure()
    XCTAssertWillDeallocate(instance: sut)
// Expected failure: XCTAssertWillDeallocate failed: should have been deallocated "TDDKitTests.XCTCustomStringConvertibleTests.(unknown context at $101e284bc).Spy"
}
```

But if you conform the instance to ``XCTCustomDebugStringConvertible`` and the error output will be nicer:

```swift
extension Spy: XCTCustomDebugStringConvertible { }

func test_selfReferencing_example() throws {
    let sut = Instance()
    sut.reference = sut

    XCTExpectFailure()
    XCTAssertWillDeallocate(instance: sut)
// Expected failure: XCTAssertWillDeallocate failed: should have been deallocated "Spy"
}
```

Also enum output can be extremely bad:

````swift
func test_createPoem_callsServices() async throws {
    let (sut, spy) = makeSUT()

    _ = try await sut.createPoem()

    XCTExpectFailure {
        XCTAssertEqual(spy.messages, [.getAge, .getUsername])
// Expected failure: XCTAssertEqual failed: ("[TDDKitTests.XCTAssertContainsEqualTests.(unknown context at $101f271c8).Spy.Message.getUsername, TDDKitTests.XCTAssertContainsEqualTests.(unknown context at $101f271c8).Spy.Message.getAge]") is not equal to ("[TDDKitTests.XCTAssertContainsEqualTests.(unknown context at $101f271c8).Spy.Message.getAge, TDDKitTests.XCTAssertContainsEqualTests.(unknown context at $101f271c8).Spy.Message.getUsername]")
    }
}
````

But if `Spy.Messages` conforms to ``XCTCustomDebugStringConvertible``, then there will be a much nicer output:


````swift
func test_createPoem_callsServices() async throws {
    let (sut, spy) = makeSUT()

    _ = try await sut.createPoem()

    XCTExpectFailure {
        XCTAssertEqual(spy.messages, [.getAge, .getUsername])
// Expected failure: XCTAssertEqual failed: ("[.getUsername, .getAge]") is not equal to ("[.getAge, .getUsername]")
    }
}
````

- Note: Does not handle nested enums.
[Feature request](https://github.com/andybezaire/TDDKit/issues) if needed.
- Note: Uses the `@_silgen_name` property wrapper.

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
