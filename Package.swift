// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "TestHelpers",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "TestHelpers", targets: ["TestHelpers"])
    ],
    dependencies: [],
    targets: [
        .target(name: "TestHelpers", dependencies: []),
        .testTarget(name: "TestHelpersTests", dependencies: ["TestHelpers"])
    ]
)
