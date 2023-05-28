// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

import PackageDescription

let package = Package(
    name: "ScreenshotsGenerator",
    platforms: [
            .macOS(.v13)
        ],
    products: [
        .executable(name: "generateScreenshots", targets: ["ScreenshotsGenerator"])
    ],
    dependencies: [
         .package(url: "https://github.com/pakLebah/ANSITerminal.git", exact: "0.0.3"),
         .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.0"),
         .package(url: "https://github.com/tagheuercw/xcparse.git", from: "2.3.2"),
    ],
    targets: [
        .executableTarget(name: "ScreenshotsGenerator",
                          dependencies: [
                            .product(name: "ArgumentParser", package: "swift-argument-parser"),
                            "ANSITerminal", "xcparse",
                          ])
    ]
)
