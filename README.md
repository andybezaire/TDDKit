 <p> <a href="https://twitter.com/andy_bezaire"> <img src="https://img.shields.io/twitter/url?url=http%3A%2F%2Fgithub.com%2Fandybezaire%2FTDDKit=" alt="Twitter: @andy_bezaire" /> </a> </p>

# TDDKit ![test status](https://github.com/andybezaire/TDDKit/actions/workflows/swift.yml/badge.svg) ![license MIT](https://img.shields.io/github/license/andybezaire/TDDKit)

You are now leveled up in your test driven development experience in *Swift*. 🚀


## Overview

TDD is a great way to write code. It improves code quality and brings *great joy*. 😊

But it also brings a lot of **boilerplate**. 🤬 

`TDDKit` is designed with TDD in mind. These opinionated helpers keep 
you writing great tests that are clear, concise and to-the-point.

🫵😎🎉

For a full list of features and usage please see the
[documentation](#documentation)

## Sample Use

```swift
final class SampleUseTests: XCTestCase {
    func test_failingGetUsername_createPoem_fails() async throws {
        let error = XCTAnyError()
        let (sut, _) = makeSUT(getUsernameResult: .failure(error))

        let capturedError = await XCTCaptureError(from: try await sut.createPoem())

        XCTAssertCastEqual(capturedError, error)
    }

    func test_createPoem_callsService() async throws {
        let (sut, spy) = makeSUT()

        _ = try await sut.createPoem()

        XCTAssertContainsEqual(spy.messages, [.getUsername])
    }

    func test_createPoem_succeeds() async throws {
        let name = UUID().uuidString
        let (sut, _) = makeSUT(getUsernameResult: .success(name))

        let capturedPoem = try await sut.createPoem()

        XCTAssertContainsEqual(capturedPoem, "Once upon a time... there was a \(name)")
    }

    // MARK: - helpers
    private func makeSUT(
        getUsernameResult: Result<String, Error> = .success(.init()),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: PoemCreator, spy: Spy) {
        let spy = Spy(getUsernameResult: getUsernameResult)
        let sut = OUATPoemCreator(service: spy)

        XCTAssertWillDeallocate(instance: sut, file: file, line: line)
        XCTAssertWillDeallocate(instance: spy, file: file, line: line)

        return (sut, spy)
    }

    private final class Spy: XCTCustomDebugStringConvertible, UserService, UserServiceDefaults {
        enum Message: XCTCustomDebugStringConvertible { case getUsername }

        private let getUsernameResult: Result<String, Error>

        init(getUsernameResult: Result<String, Error>) {
            self.getUsernameResult = getUsernameResult
        }

        private(set) var messages: [Message] = []

        // MARK: - UserService
        func getUsername() async throws -> String {
            messages.append(.getUsername)
            await Task.yield()
            return try getUsernameResult.get()
        }
    }
}
```

Check out the full test: 
[SampleUseTests.swift](https://github.com/andybezaire/TDDKit/blob/main/Tests/TDDKitTests/SampleUseTests.swift)

## Installation

### Xcode Project
 
Add this package as a dependency to the test target of your Xcode project.

1. Xcode Menu > File > Add Packages...
1. Paste this project's URL to the "Search or Enter Package URL" field. (https://github.com/andybezaire/TDDKit)
1. Select `TDDKit` product and add it to your project's **test target** Note: **NOT your main target.**
1. Press "Add Package" button.

### Swift Package Manager (SPM)

Add this package as a dependency to the **test target** of your Swift package. 

```swift
// swift-tools-version: 5.8
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

## Documentation

It is recommended to add the documentation to your documentation browser
for the most immersive experience. 😎

The documentation can be generated from this package using: 

```bash
swift package generate-documentation --include-extended-types
```

> Note: This package includes mainly extensions,
> so the `--include-extended-types` flag is neccesary.

The documentation for **the latest version** is also 
[available on GitHub](https://andybezaire.github.io/TDDKit/documentation/tddkit/)

## More Info and Feature Requests

Please do not hesitate to open a [GitHub issue](https://github.com/andybezaire/TDDKit/issues) 
for any questions or feature requests.  


## License

"TDDKit" is available under the MIT license. 
See the [LICENSE](https://github.com/andybezaire/TDDKit/blob/main/LICENSE) file for more info.


## Credit

Copyright (c) 2023 Andy Bezaire

Created by: andybezaire
