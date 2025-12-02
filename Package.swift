// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Clippy",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "Clippy",
            targets: ["Clippy"])
    ],
    targets: [
        .executableTarget(
            name: "Clippy",
            dependencies: [],
            path: "Sources/Clippy"
        ),
        .testTarget(
            name: "ClippyTests",
            dependencies: ["Clippy"],
            path: "Tests/ClippyTests"
        )
    ]
)
