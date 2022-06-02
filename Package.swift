// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Utilities",
    products: [
        .library(
            name: "Utilities",
            targets: ["Utilities"]
        ),
    ],
    targets: [
        .target(
            name: "Utilities",
            dependencies: []
        ),
        .testTarget(
            name: "UtilitiesTests",
            dependencies: ["Utilities"]
        ),
    ]
)
