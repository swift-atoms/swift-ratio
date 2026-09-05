// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-ratio",
    platforms: [
        .macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27),
    ],
    products: [
        .library(name: "Ratio", targets: ["Ratio"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-multiplication.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-magnitude.git", branch: "main"),
        .package(
            url: "https://github.com/swift-atoms/swift-cardinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-polarity.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-property.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-carrier.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Ratio",
            dependencies: [
                .product(name: "Multiplication", package: "swift-multiplication"),
                .product(name: "Magnitude", package: "swift-magnitude"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Polarity", package: "swift-polarity"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Carrier Protocol", package: "swift-carrier"),
            ]
        ),
        .testTarget(
            name: "Ratio Tests",
            dependencies: [
                .target(name: "Ratio"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Magnitude", package: "swift-magnitude"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
