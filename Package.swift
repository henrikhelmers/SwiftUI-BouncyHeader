// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUI BouncyHeader",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        .library(name: "SwiftUI BouncyHeader", targets: ["SwiftUI BouncyHeader"]),
    ],
    targets: [
        .target(name: "SwiftUI BouncyHeader")
    ]
)
