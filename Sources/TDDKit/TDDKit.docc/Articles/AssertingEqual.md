# Asserting Equal

Helpers similar to `XCTAssertEqual`.

## Overview

`XCTAssertEqual` is a handy function to use in tests. 
It is a quick way to compare two values for equality, and gives a nice failure method 
when the values don't match. It can be used with values, optionals, collections. 
Just pass them to the function and it works. Very helpful. 👍

But often we want more feedback about why the comparison failed. 
* were the types mismached or was the value actually `nil`?
* were the collections containing the same elements, but just in the wrong order?
* did the collections have a different number of elements, or did they have the same `count`but different elements?

Often we need to write multiple assertions so that the test error can give us clues as to why the comparison failed.
This leads to longer than needed tests. This group of helpers will help improve that.


### Assert Cast Equal

Sometimes and optional value needs to be cast and compared with a real result. 
If the cast is performed inside the assert equal, it is not clear if 
the captured value was the wrong type or if it was nil. This can lead to 
using a separate assert is not nil check, adding boilerplate.

This method will first check to see if the value is not nil and then 
will perform the cast and assert equal, giving nice error messages for each case.

```swift
func test_failingGetUsername_createPoem_fails() async throws {
    let error = XCTAnyError()
    let (sut, _) = makeSUT(getUsernameResult: .failure(error))
    
    let capturedError = await XCTCaptureError(from: try await sut.createPoem())
    
    XCTAssertCastEqual(capturedError, error)
}
```

The equivalent test using only standard `XCTest` asserts:

```swift
func test_failingGetUsername_createPoem_fails() async throws {
    let error = XCTAnyError()
    let (sut, _) = makeSUT(getUsernameResult: .failure(error))
    
    let capturedError = await XCTCaptureError(from: try await sut.createPoem())
    
    XCTAssertNotNil(capturedError)
    XCTAssertCastEqual(capturedError as? XCTAnyError, error)
}
```


### Assert Contains Equal

When comparing two collections for equality, sometimes it is not clear if 
the captured collection was the same but just in a different order, 
or if the collections were actually containing different elements. This can lead to 
using separate asserts to compare the `count`s and check for `contains`, adding boilerplate.

This method will check to see if the collections have the same elements 
and will give a nice error messages when elements are missing or extra.

Usage:
```swift
func test_createPoem_callsServices() async throws {
    let (sut, spy) = makeSUT()

    _ = try await sut.createPoem()
    
    XCTAssertContainsEqual(spy.messages, [.getAge, .getUsername])
}
```

The equivalent test using only standard `XCTest` asserts:

```swift
func test_createPoem_callsServices() async throws {
    let (sut, spy) = makeSUT()

    _ = try await sut.createPoem()
    
    XCTAssertEqual(spy.messages.count, 2)
    XCTAssertTrue(spy.messages.contains(.getAge))
    XCTAssertTrue(spy.messages.contains(.getUsername))
}
```


### Assert Count Equal

When comparing two collections for equality, sometimes it is not clear if 
the captured collection was the wrong size or if it had differnt values. This can lead to 
using a separate assert to compare the `count`s, adding boilerplate.

This method will first check to see if the collections have the same `count` and then 
will assert equal on the elements, giving nice error messages for each case.

Usage:
```swift
func test_fetch_succeeds() async throws {
    let (values, response) = uniqueValuesSet()
    let (sut, _) = makeSUT(fetchResult: .success(response))

    let capturedValues = try await sut.fetch()
    
    XCTAssertCountEqual(capturedValues, values)
}
```

The equivalent test using only standard `XCTest` asserts:

```swift
func test_fetch_succeeds() async throws {
    let (values, response) = uniqueValuesSet()
    let (sut, _) = makeSUT(fetchResult: .success(response))

    let capturedValues = try await sut.fetch()
    
    XCTAssertEqual(capturedValues.count, values.count)
    XCTAssertEqual(capturedValues, values)
}
```
