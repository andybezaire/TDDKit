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
