// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pokemon-XD-Code",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_13),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "GoD-CLI",
            dependencies: [],
            path: "spm/virt/GoD-CLI",
            swiftSettings: [
                .define("GAME_XD"),
            ]),
        .target(
            name: "Colosseum-CLI",
            dependencies: [],
            path: "spm/virt/Colosseum-CLI",
            swiftSettings: [
                .define("GAME_COLO"),
            ]),
        .target(
            name: "PBR-CLI",
            dependencies: [],
            path: "spm/virt/PBR-CLI",
            swiftSettings: [
                .define("GAME_PBR"),
            ]),
    ]
)
