# Capturing Results

Capturing errors and output values.


## Overview

Test setup and teardown sometimes can be much more involved than the actual action under test.
This can mean that your test is more boilerplate than interesting code.

This can especially happen when:
* trying to catch errors
* determining if an `@Published` publisher is publishing on the main thread.
* recording values that an `@Published` publisher is publishing.
* recording values based on an `@Published` publisher.

These helpers will help to remove the boilerplate and keep your tests tight and focused.


### Capture Error

- ``XCTest/XCTestCase/XCTCaptureError(from:_:file:line:)``

The `do`-`try`-`catch` dance with optional captured errors can add a lot of boilerplate to your tests. 

This helps by turning the error capture into a single line. A non-optional error is returned 
or a test failure happens if an error is not thrown.

```swift
func test_failingGetUsername_createPoem_fails() async throws {
    let error = XCTAnyError()
    let (sut, _) = makeSUT(getUsernameResult: .failure(error))
    
    let capturedError = await XCTCaptureError(from: try await sut.createPoem())
    
    XCTAssertCastEqual(capturedError, error)
}
```

The equivalent test without helpers:

```swift
func test_failingGetUsername_createPoem_fails() async throws {
    let error = XCTAnyError()
    let (sut, _) = makeSUT(getUsernameResult: .failure(error))
    var capturedError: Error?

    do {
        try await sut.createPoem()
    } catch {
        capturedError = error
    }

    XCTAssertCastEqual(capturedError, error)
}
```


### Capture is Main Thread

- ``XCTest/XCTestCase/XCTCaptureIsMainThread(for:droppingFirst:when:)``

Subscribing to a Publisher and managing the `AnyCancellable` in a test leads to a lot of typing, 
and can distract from the main focus of the test.

This function helps to make your code more clear. Put the actions which will cause the publishes
in the block and `XCTCaptureIsMainThread` will return the results.

```swift
func test_refreshTitle_publishesOnMainThread() async throws {
    let (sut, _) = makeSUT()

    let capturedIsMainThread = await XCTCaptureIsMainThread(for: sut.$title) {
        await sut.refreshTitle()
    }

    XCTAssertCountEqual(capturedIsMainThread, [true])
}
```

The equivalent test without helpers:

```swift
func test_refreshTitle_publishesOnMainThread() async throws {
    let (sut, _) = makeSUT()
    var capturedIsMainThread: [Bool] = []
    let publishing = sut.$title
        .dropFirst(1)
        .sink { _ in capturedIsMainThread.append(Thread.isMainThread) }

    await sut.refreshTitle()

    publishing.cancel()
    XCTAssertCountEqual(capturedIsMainThread, [true])
}
```


### Capture Output

- ``XCTest/XCTestCase/XCTCaptureOutput(for:droppingFirst:when:)``

Subscribing to a Publisher and managing the `AnyCancellable` in a test leads to a lot of typing, 
and can distract from the main focus of the test.

This function helps to make your code more clear. Put the actions which will cause the publishes
in the block and `XCTCaptureOutput` will return the results.

```swift
func test_refreshTitle_setsIsLoading() async throws {
    let (sut, _) = makeSUT()

    let capturedOutput = await XCTCaptureOutput(for: sut.$isLoading) {
        await sut.refreshTitle()
    }

    XCTAssertCountEqual(capturedOutput, [true, false])
}
```

The equivalent test without helpers:

```swift
func test_refreshTitle_publishesOnMainThread() async throws {
    let (sut, _) = makeSUT()
    var capturedOutput: [Output] = []
    let publishing = sut.$isLoading
        .dropFirst(1)
        .sink { capturedOutput.append($0) }

    await sut.refreshTitle()

    publishing.cancel()
    XCTAssertCountEqual(capturedIsMainThread, [true])
}
```


### Capture Output Of

- ``XCTest/XCTestCase/XCTCaptureOutput(of:for:droppingFirst:when:)``

Subscribing to a Publisher and managing the `AnyCancellable` in a test leads to a lot of typing, 
and can distract from the main focus of the test. When sampling a var that depends on the output, 
adding an additional sample is even more boilerplate.

This function helps to make your code more clear. Provide a closure to compute the result and 
put the actions which will cause the publishes in the block and `XCTCaptureOutput` will return the results.

Usage:
```swift
func test_refreshTitle_setsLoadingText() async throws {
    let (sut, _) = makeSUT()

    let capturedOutput = await XCTCaptureOutput(of: { sut.loadingText }, for: sut.$isLoading) {
        await sut.refreshTitle()
    }

    XCTAssertCountEqual(capturedOutput, ["Loading...", "Finished"])
}
```

The equivalent test without helpers:

```swift
func test_refreshTitle_publishesOnMainThread() async throws {
    let (sut, _) = makeSUT()
    var capturedOutput: [Output] = []
    let publishing = sut.$isLoading
        .dropFirst(2)
        .sink { _ in capturedOutput.append(sut.loadingText) }

    await sut.refreshTitle()

    capturedOutput.append(sut.loadingText)
    publishing.cancel()
    XCTAssertCountEqual(capturedIsMainThread, [true])
}
```
