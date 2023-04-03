 <p> <a href="https://twitter.com/andy_bezaire"> <img src="https://img.shields.io/twitter/url?url=http%3A%2F%2Fgithub.com%2Fandybezaire%2FTDDKit=" alt="Twitter: @andy_bezaire" /> </a> </p>

# TDDKit ![test status](https://github.com/andybezaire/TDDKit/actions/workflows/swift.yml/badge.svg) ![license MIT](https://img.shields.io/github/license/andybezaire/TDDKit)
A grouping of helpers used to improve the testing experience.

TDD is a great way to write code. It improves code quality and brings great joy.

But it also brings a lot of boilerplate. 

These test helpers are designed with TDD in mind. 
They can help with writing tests that are clear and reduce boilerplate code.


## Helpers

### Any Error

This Equatable Identifiable Error can be used to help test errors thrown by dependencies.

Usage:

```swift
func test_failingFetchX_fetchY_fails() async throws {
    let error = AnyError()
    let (sut, _) = makeSUT(fetchXResult: .failure(error))

    let capturedError = await captureError(from: try await sut.fetchY())

    XCTAssertNotNil(error)
    XCTAssertEqual(capturedError as? AnyError, error)
}
```

### Array Subscript Index

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

### Capture Error

The `do`-`try`-`catch` dance with optional captured errors can add a lot of boilerplate to your tests. 

This helps by turning the error capture into a single line. A non-optional error is returned 
or a test failure happens if an error is not thrown.

Usage:
 
```swift
func test_failingFetchX_fetchY_fails() async throws {
    let error = AnyError()
    let (sut, _) = makeSUT(fetchXResult: .failure(error))

    let capturedError = await captureError(from: try await sut.fetchY())

    XCTAssertEqual(capturedError as? AnyError, error)
}
```

### Capture is Main Thread

Subscribing to a Publisher and managing the AnyCancellable in a test leads to a lot of typing, 
and can distract from the main focus of the test.

This function helps to make your code more clear. Put the actions which will cause the publishes
in the block and `captureIsMainThread` will return the results.

Usage:
 
```swift
func test_refreshTitle_publishesOnMainThread() async throws {
    let (sut, _) = makeSUT()

    let capturedIsMainThread = await captureIsMainThread(for: sut.$title) {
        await sut.refreshTitle()
    }

    XCTAssertEqual(capturedIsMainThread.count, 1)
    XCTAssertEqual(capturedIsMainThread[index: 0], true)
}
```

### Capture Output

Subscribing to a Publisher and managing the AnyCancellable in a test leads to a lot of typing, 
and can distract from the main focus of the test.

This function helps to make your code more clear. Put the actions which will cause the publishes
in the block and `captureOutput` will return the results.

Usage:
 
```swift
func test_refreshTitle_setsIsRefreshing() async throws {
    let (sut, _) = makeSUT()

    let capturedOutput = await captureOutput(for: sut.$isLoading) {
        await sut.refreshTitle()
    }

    XCTAssertEqual(capturedOutput.count, 2)
    XCTAssertEqual(capturedOutput[index: 0], true)
    XCTAssertEqual(capturedOutput[index: 1], false)
}
```

### Expect Will Deallocate Instance

Memory leaks occur when an object is not properly released from memory. 
This often happens when mistakenly creating a circular strong reference.

This method will help to catch these kinds of errors by making sure 
that your object has been deallocated by the end of the test. 
It is most useful to use it in your makeSUT method.

Usage:

```swift
private func makeSUT(
    userLoginResult: Result<Void, Error> = .success(()),
    file: StaticString = #file,
    line: UInt = #line
) -> (sut: LoginFlow, spy: Spy) {

    let spy = Spy(userLoginResult: userLoginResult)
    let sut = LoginFlow(service: spy)

    expectWillDeallocate(for: sut, file: file, line: line)
    expectWillDeallocate(for: spy, file: file, line: line)

    return (sut, spy)
}
```

### Cast Assert Equal

Sometimes and optional value needs to be cast and compared with a real result. 
If the cast is performed inside the assert equal, it is not clear if 
the captured value was the wrong type or if it was nil. This can lead to 
using a separate assert is not nil check, adding boilerplate.

This method will first check to see if the value is not nil and then 
will perform the cast and assert equal, giving nice error messages for each case.

Usage:

```swift
func test_failingFetchX_fetchY_fails() async throws {
    let error = AnyError()
    let (sut, _) = makeSUT(fetchXResult: .failure(error))

    let capturedError: Error? = await captureError(from: try await sut.fetchY())

    XCTCastAssertEqual(capturedError, error)
}
```


## Sample Code

For sample code showing how to use a helper function, check out the test code for that helper. 


## Installation

### Xcode Project
 
Add this package as a dependency to the test target of your Xcode project.

1. Xcode Menu > File > Add Packages...
1. Paste this project's URL to the "Search or Enter Package URL" field. (https://github.com/andybezaire/TDDKit)
1. Select `TDDKit` product and add it to your project's **test target** Note: **NOT your main target.**
1. Press "Add Package" button.

### Swift Package Manager (SPM)

Add this package as a dependency to the test target of your Swift package. 

```swift
// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "SampleProduct",
    products: [
        .library(name: "SampleProduct", targets: ["SampleProduct"])
    ],
    dependencies: [
        .package(name: "TDDKit", url: "https://github.com/andybezaire/TDDKit.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "SampleProduct", dependencies: []),
        .testTarget(name: "SampleProductTests", dependencies: ["SampleProduct", "TDDKit"])
    ]
)
```


## More Info and Feature Requests

Please do not hesitate to open a [GitHub issue](https://github.com/andybezaire/TDDKit/issues) 
for any questions or feature requests.  


## License

"TDDKit" is available under the MIT license. 
See the [LICENSE](https://github.com/andybezaire/TDDKit/blob/main/LICENSE) file for more info.


## Credit

Copyright (c) 2023 Andy Bezaire

Created by: andybezaire
