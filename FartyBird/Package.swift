// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "FartyBird",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "FartyBird",
            targets: ["FartyBird"])
    ],
    dependencies: [
        .package(url: "https://github.com/typelift/SwiftCheck.git", from: "0.12.0")
    ],
    targets: [
        .target(
            name: "FartyBird",
            dependencies: []),
        .testTarget(
            name: "FartyBirdTests",
            dependencies: [
                "FartyBird",
                "SwiftCheck"
            ])
    ]
)
