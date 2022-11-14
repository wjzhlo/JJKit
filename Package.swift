// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JJKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "JJKit", targets: ["JJKit"]),
    ],
    targets: [
        .target(
            name: "JJKit",
            path: "Sources"),
        .testTarget(
            name: "JJKitTests",
            dependencies: ["JJKit"]),
    ]
)
