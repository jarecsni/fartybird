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
            dependencies: [],
            path: "FartyBird",
            exclude: ["Info.plist", "Assets.xcassets", "Assets"],
            sources: [
                "AppDelegate.swift",
                "GameViewController.swift",
                "Managers/AssetManager.swift",
                "Managers/AudioManager.swift",
                "Managers/ObstacleManager.swift",
                "Managers/PhysicsManager.swift",
                "Managers/ScoreManager.swift",
                "Models/AssetConfiguration.swift",
                "Models/GameConfiguration.swift",
                "Models/GameState.swift",
                "Nodes/CharacterNode.swift",
                "Nodes/FartParticleEmitter.swift",
                "Nodes/ObstacleNode.swift",
                "Scenes/GameScene.swift",
                "Scenes/MenuScene.swift"
            ]),
        .testTarget(
            name: "FartyBirdTests",
            dependencies: [
                "FartyBird",
                "SwiftCheck"
            ],
            path: "FartyBirdTests")
    ]
)
