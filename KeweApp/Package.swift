// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KeweApp",
    platforms: [
            .macOS(.v10_13),
            .iOS(.v13),
            .watchOS(.v4),
        ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "KeweApp",
            targets: ["KeweApp"]),
    ],
    dependencies: [
//        .package(url: "https://github.com/devxoul/Then", from: "3.0.0"),
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.15.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "KeweApp",
            dependencies: [
//                .product(name: "FirebaseAuth", package: "Firebase"),
                .product(name: "FirebaseAnalyticsSwift", package: "Firebase"),
                .product(name: "FirebaseRemoteConfigSwift", package: "Firebase"),
//                "FirebaseAnalyticsSwift",
//                "FirebaseRemoteConfigSwift"
            ]),
        .testTarget(
            name: "KeweAppTests",
            dependencies: ["KeweApp"]),
    ]
)
