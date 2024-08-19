// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Core",
            targets: ["Core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.1")),
        .package(url: "https://github.com/exyte/PopupView.git", .upToNextMajor(from: "2.7.0")),
        .package(url: "https://github.com/airbnb/lottie-ios.git", .upToNextMajor(from: "4.2.0")),
        .package(path: "../Domain")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Core",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "PopupView", package: "PopupView"),
                .product(name: "Lottie", package: "lottie-ios"),
                .product(name: "Domain", package: "Domain")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]),
    ]
)
