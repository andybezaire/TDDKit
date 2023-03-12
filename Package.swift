// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "TDDKit",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .library(name: "TDDKit", targets: ["TDDKit"])
    ],
    dependencies: [],
    targets: [
        .target(name: "TDDKit", dependencies: []),
        .testTarget(name: "TDDKitTests", dependencies: ["TDDKit"])
    ]
)
