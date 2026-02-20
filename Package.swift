// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RepoVerse",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "RepoVerseShared", targets: ["RepoVerseShared"]),
        .executable(name: "RepoVerseApp", targets: ["RepoVerseApp"]),
    ],
    targets: [
        .target(
            name: "RepoVerseShared",
            path: "Shared/Sources/RepoVerseShared"
        ),
        .executableTarget(
            name: "RepoVerseApp",
            dependencies: ["RepoVerseShared"],
            path: "App/Sources/RepoVerseApp"
        ),
    ]
)
