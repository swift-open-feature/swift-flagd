// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "swift-flagd",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13),
    ],
    products: [
        .library(name: "Flagd", targets: ["Flagd"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-open-feature/swift-open-feature.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Flagd",
            dependencies: [
                .product(name: "OpenFeature", package: "swift-open-feature")
            ]
        ),
        .testTarget(
            name: "FlagdTests",
            dependencies: [
                .target(name: "Flagd")
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
