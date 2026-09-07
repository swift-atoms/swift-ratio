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
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-rational.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-division.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-difference.git", branch: "main"),
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

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
