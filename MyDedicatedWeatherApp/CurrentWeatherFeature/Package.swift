// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CurrentWeatherFeature",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CurrentWeatherFeature",
            targets: ["CurrentWeatherFeature"]),
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../Data"),
        .package(path: "../Core"),
        .package(path: "../AdditionalLocationFeature")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CurrentWeatherFeature",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "Data", package: "Data"),
                .product(name: "Core", package: "Core"),
                .product(name: "AdditionalLocationFeature", package: "AdditionalLocationFeature")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "CurrentWeatherFeatureTests",
            dependencies: ["CurrentWeatherFeature"]),
    ]
)
