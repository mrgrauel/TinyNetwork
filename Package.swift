// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TinyNetwork",
    platforms: [
        .iOS(.v11),
        .watchOS(.v5)
    ],
    products: [
        .library(
            name: "TinyNetwork",
            targets: ["TinyNetwork"]),
    ],
    dependencies: [
        .package(url: "https://github.com/BuzzFeed/MockDuck", .branch("main"))
    ],
    targets: [
        .target(
            name: "TinyNetwork",
            dependencies: []),
        .testTarget(
            name: "TinyNetworkTests",
            dependencies: ["TinyNetwork", "MockDuck"]),
    ]
)
