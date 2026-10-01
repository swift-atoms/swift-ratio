// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-ratio",
    platforms: [
        .macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27),
    ],
    products: [
        .library(name: "Ratio", targets: ["Ratio"]),

        .library(name: "Ratio Foundation Integration", targets: ["Ratio Foundation Integration"]),
        .library(name: "Ratio Test Support", targets: ["Ratio Test Support"]),
    ],
    traits: [
        .trait(name: "Bit", description: "Bit Pack integration", enabledTraits: ["Ordinal"]),
        .trait(name: "Memory", description: "Memory Ratio integration"),
        .trait(name: "Ordinal", description: "Ordinal Ratio integration"),
        .trait(name: "Difference", description: "Difference Ratio integration"),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-index.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-bit.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-memory.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-ordinal.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-rational.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-division.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-difference.git", branch: "main", traits: ["Tagged"]),
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
        .testTarget(
            name: "Ratio Bit Integration Tests",
            dependencies: [
                .target(name: "Ratio"),
                .target(name: "Ratio Test Support"),
                .product(name: "Bit", package: "swift-bit"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Difference", package: "swift-difference"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Magnitude", package: "swift-magnitude"),
                .product(name: "Rational", package: "swift-rational"),
            ],
            path: "Tests/Ratio Bit Integration Tests"
        ),
        .testTarget(
            name: "Ratio Memory Integration Tests",
            dependencies: [
                .target(name: "Ratio"),
                .target(name: "Ratio Test Support"),
                .product(name: "Memory", package: "swift-memory"),
            ],
            path: "Tests/Ratio Memory Integration Tests"
        ),
        .testTarget(
            name: "Ratio Ordinal Integration Tests",
            dependencies: [
                .target(name: "Ratio"),
                .target(name: "Ratio Test Support"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Carrier", package: "swift-carrier"),
                .product(name: "Difference", package: "swift-difference"),
                .product(name: "Magnitude", package: "swift-magnitude"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Tagged", package: "swift-tagged"),
            ],
            path: "Tests/Ratio Ordinal Integration Tests"
        ),
        .testTarget(
            name: "Ratio Difference Integration Tests",
            dependencies: [
                .target(name: "Ratio"),
                .target(name: "Ratio Test Support"),
                .product(name: "Carrier", package: "swift-carrier"),
                .product(name: "Difference", package: "swift-difference"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Tagged", package: "swift-tagged"),
            ],
            path: "Tests/Ratio Difference Integration Tests"
        ),
        .target(
            name: "Ratio",
            dependencies: [
                .product(name: "Bit", package: "swift-bit"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Rational", package: "swift-rational"),
                .product(name: "Division", package: "swift-division"),
                .product(name: "Difference", package: "swift-difference"),
                .product(name: "Multiplication", package: "swift-multiplication"),
                .product(name: "Magnitude", package: "swift-magnitude"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Polarity", package: "swift-polarity"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Carrier", package: "swift-carrier"),
            ],
            path: "Sources/Ratio"
        ),

        .target(
            name: "Ratio Foundation Integration",
            dependencies: [
                .target(name: "Ratio"),
            ],
            path: "Sources/Ratio Foundation Integration"
        ),
        .target(
            name: "Ratio Test Support",
            dependencies: [
                .target(name: "Ratio"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Ratio Tests",
            dependencies: [
                .target(name: "Ratio"),
                .product(name: "Rational", package: "swift-rational"),
                .product(name: "Difference", package: "swift-difference"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Magnitude", package: "swift-magnitude"),
                .target(name: "Ratio Test Support"),
                .target(name: "Ratio Foundation Integration"),
            ],
            path: "Tests/Ratio Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("Lifetimes"),
        .treatAllWarnings(as: .error),
    ]
}
