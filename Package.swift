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
                .product(name: "Bit", package: "swift-bit", condition: .when(traits: ["Bit"])),
                .product(name: "Cardinal", package: "swift-cardinal", condition: .when(traits: ["Bit"])),
                .product(name: "Difference", package: "swift-difference", condition: .when(traits: ["Bit"])),
                .product(name: "Index", package: "swift-index", condition: .when(traits: ["Bit"])),
                .product(name: "Ordinal", package: "swift-ordinal", condition: .when(traits: ["Bit"])),
                .product(name: "Tagged", package: "swift-tagged", condition: .when(traits: ["Bit"])),
                .product(name: "Magnitude", package: "swift-magnitude", condition: .when(traits: ["Bit"])),
                .product(name: "Rational", package: "swift-rational", condition: .when(traits: ["Bit"])),
            ],
            path: "Tests/Ratio Bit Integration Tests"
        ),
        .testTarget(
            name: "Ratio Memory Integration Tests",
            dependencies: [
                .target(name: "Ratio"),
                .target(name: "Ratio Test Support"),
                .product(name: "Memory", package: "swift-memory", condition: .when(traits: ["Memory"])),
            ],
            path: "Tests/Ratio Memory Integration Tests"
        ),
        .testTarget(
            name: "Ratio Ordinal Integration Tests",
            dependencies: [
                .target(name: "Ratio"),
                .target(name: "Ratio Test Support"),
                .product(name: "Cardinal", package: "swift-cardinal", condition: .when(traits: ["Ordinal", "Bit"])),
                .product(name: "Carrier", package: "swift-carrier", condition: .when(traits: ["Ordinal", "Bit"])),
                .product(name: "Difference", package: "swift-difference", condition: .when(traits: ["Ordinal", "Bit"])),
                .product(name: "Magnitude", package: "swift-magnitude", condition: .when(traits: ["Ordinal", "Bit"])),
                .product(name: "Ordinal", package: "swift-ordinal", condition: .when(traits: ["Ordinal", "Bit"])),
                .product(name: "Tagged", package: "swift-tagged", condition: .when(traits: ["Ordinal", "Bit"])),
            ],
            path: "Tests/Ratio Ordinal Integration Tests"
        ),
        .testTarget(
            name: "Ratio Difference Integration Tests",
            dependencies: [
                .target(name: "Ratio"),
                .target(name: "Ratio Test Support"),
                .product(name: "Carrier", package: "swift-carrier", condition: .when(traits: ["Difference"])),
                .product(name: "Difference", package: "swift-difference", condition: .when(traits: ["Difference"])),
                .product(name: "Property", package: "swift-property", condition: .when(traits: ["Difference"])),
                .product(name: "Tagged", package: "swift-tagged", condition: .when(traits: ["Difference"])),
            ],
            path: "Tests/Ratio Difference Integration Tests"
        ),
        .target(
            name: "Ratio",
            dependencies: [
                .product(name: "Bit", package: "swift-bit", condition: .when(traits: ["Bit"])),
                .product(name: "Index", package: "swift-index", condition: .when(traits: ["Bit"])),
                .product(name: "Memory", package: "swift-memory", condition: .when(traits: ["Memory"])),
                .product(name: "Ordinal", package: "swift-ordinal", condition: .when(traits: ["Ordinal", "Bit"])),
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
