// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "GenericJSONType",
    products: [
        .library(name: "GenericJSONType", targets: ["GenericJSONType"]),
    ],
    targets: [
        .target(name: "GenericJSONType", path: "Sources"),
        .testTarget(name: "GenericJSONTypeTests", dependencies: ["GenericJSONType"]),
    ]
)
