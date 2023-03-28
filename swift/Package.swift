// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Trivia",
    targets: [
        .executableTarget(
            name: "Trivia",
            dependencies: [],
            path: "Trivia"),
        .testTarget(
            name: "TriviaTests",
            dependencies: ["Trivia"],
            path: "TriviaTests",
            exclude: [
                "Info.plist",
            ]),
    ]
)
