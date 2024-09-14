// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WeeklyWeatherFeature",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "WeeklyWeatherFeature",
            targets: ["WeeklyWeatherFeature"]),
    ],
    dependencies: [
        .package(name: "Core", path: "../Core"),
        .package(name: "Domain", path: "../Domain"),
        .package(name: "Data", path: "../Data")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "WeeklyWeatherFeature",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "Domain", package: "Domain"),
                .product(name: "Data", package: "Data")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "WeeklyWeatherFeatureTests",
            dependencies: ["WeeklyWeatherFeature"]),
    ]
)
