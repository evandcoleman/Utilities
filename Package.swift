// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Utilities",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "Utilities",
            targets: ["Utilities"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/SwiftUI-Introspect", from: "0.1.4"),
    ],
    targets: [
        .target(
            name: "Utilities",
            dependencies: [.product(name: "Introspect", package: "SwiftUI-Introspect")]
        ),
        .testTarget(
            name: "UtilitiesTests",
            dependencies: ["Utilities"]
        ),
    ]
)
