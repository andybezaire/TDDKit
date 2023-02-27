![test status](https://github.com/andybezaire/TestHelpers/actions/workflows/swift.yml/badge.svg)
![license MIT](https://badgen.net/github/license/andybezaire/TestHelpers)

# TestHelpers
<p>
  <a href="https://twitter.com/andy_bezaire">
    <img src="https://img.shields.io/twitter/url?url=http%3A%2F%2Fgithub.com%2Fandybezaire%2FTestHelpers=" alt="Twitter: @andy_bezaire" />
  </a>
</p>

Some small helpers used to improve the testing experience.

TDD is a great way to write code. It improves code quality and brings great joy.

But it also brings a lot of boilerplate. 

These test helpers are designed with TDD in mind. 
They can help with writing tests that are clear and reduce boilerplate code.


## Helpers

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


## Sample Code

For sample code showing how to use a helper function, check out the test code for that helper. 


## Installation

### Xcode Project
 
Add this package as a dependency to the test target of your Xcode project.

1. Xcode Menu > File > Add Packages...
1. Paste this project's URL to the "Search or Enter Package URL" field. (https://github.com/andybezaire/TestHelpers)
1. Select `TestHelpers` product and add it to your project's **test target** Note: **NOT your main target.**
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
        .package(name: "TestHelpers", url: "https://github.com/andybezaire/TestHelpers.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "SampleProduct", dependencies: []),
        .testTarget(name: "SampleProductTests", dependencies: ["SampleProduct", "TestHelpers"])
    ]
)
```swift


## More Info and Feature Requests

Please do not hesitate to open a GitHub issue for any questions or feature requests. 
(https://github.com/andybezaire/TestHelpers/issues) 


## License

"TestHelpers" is available under the MIT license. See the LICENSE file for more info.


## Credit

Copyright (c) 2023 andybezaire

Created by: Andy Bezaire
