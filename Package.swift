// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DiiaUIComponents",
    defaultLocalization: "uk",
    platforms: [
        .iOS(.v15), .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DiiaUIComponents",
            targets: ["DiiaUIComponents"]),
    ],
    dependencies: [
        .package(url: "https://github.com/diia-open-source/ios-commontypes.git", .upToNextMinor(from: Version(1, 0, 0))),
        .package(url: "https://github.com/diia-open-source/ios-mvpmodule.git", .upToNextMinor(from: Version(1, 0, 0))),
        .package(url: "https://github.com/SwiftKickMobile/SwiftMessages", exact: Version(9, 0, 9)),
        .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: "7.12.0")),
        .package(url: "https://github.com/airbnb/lottie-spm.git", exact: Version(4, 6, 0))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DiiaUIComponents",
            dependencies: [
                .product(name: "DiiaMVPModule", package: "ios-mvpmodule"),
                .product(name: "DiiaCommonTypes", package: "ios-commontypes"),
                .product(name: "SwiftMessages", package: "SwiftMessages"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "Lottie", package: "lottie-spm"),
            ],
            resources: [.process("Resources/Animations")]
        ),
        .testTarget(
            name: "DiiaUIComponentsTests",
            dependencies: ["DiiaUIComponents"]),
    ]
)
