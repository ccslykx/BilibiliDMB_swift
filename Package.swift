// swift-tools-version: 5.5

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "BilibiliDMB_Preview",
    platforms: [
        .iOS("15.2")
    ],
    products: [
        .iOSApplication(
            name: "BilibiliDMB_Preview",
            targets: ["AppModule"],
            displayVersion: "0.0.1",
            bundleVersion: "1",
            iconAssetName: "AppIcon",
            accentColorAssetName: "AccentColor",
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/daltoniam/Starscream.git", "4.0.4"..<"5.0.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", "5.0.1"..<"6.0.0"),
        .package(url: "https://github.com/tsolomko/SWCompression.git", "4.8.0"..<"5.0.0")
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: [
                .product(name: "Starscream", package: "Starscream"),
                .product(name: "SwiftyJSON", package: "SwiftyJSON"),
                .product(name: "SWCompression", package: "SWCompression")
            ],
            path: ".",
            resources: [
                .process("Resources")
            ]
        )
    ]
)