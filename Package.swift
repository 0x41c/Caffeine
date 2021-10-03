// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Caffeine",
    products: [
        .library(
            name: "Caffeine",
            targets: ["Caffeine"]),
        .executable(name: "decaf", targets: [
            "Decaf",
            "Caffeine"
        ])
    ],
    dependencies: [
        .package(name: "swift-argument-parser", url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.4.0")),
    ],
    targets: [
        .target(
            name: "Caffeine",
            dependencies: []),
        .testTarget(
            name: "CaffeineTests",
            dependencies: ["Caffeine"]),
        .executableTarget(
            name: "Decaf",
            dependencies: [
                "Caffeine",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        )
    ]
)
