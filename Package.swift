// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EasyKits",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "EasyResponder",
            targets: ["EasyResponder"]),
        .library(
            name: "EasyCarouseView",
            targets: ["EasyCarouseView"]),
        .library(
            name: "EasyExtension",
            targets: ["EasyExtension"]),
        .library(
            name: "EasyListView",
            targets: ["EasyListView"]),
        .library(
            name: "EasyPagingContainerView",
            targets: ["EasyPagingContainerView"]),
        .library(
            name: "EasyPopup",
            targets: ["EasyPopup"]),
        .library(
            name: "EasySegmentedView",
            targets: ["EasySegmentedView"]),
        .library(
            name: "EasySyncScroll",
            targets: ["EasySyncScroll"]),
        .library(
            name: "EasyIGListKit",
            targets: ["EasyIGListKit"]),
        .library(
            name: "EasyMediator",
            targets: ["EasyMediator"])
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.5.0")),
        /// https://github.com/Instagram/IGListKit/issues/1557
        .package(url: "https://github.com/Instagram/IGListKit.git", revision: "b22a10e47ffa87c79993ea19db7b52605e83ebbf"),
        .package(url: "https://github.com/devxoul/Then.git", .upToNextMajor(from: "2.7.0")),
    ],
    targets: [
        // EasyPopup
        .target(
            name: "EasyPopup",
            dependencies: ["SnapKit"]),
        // EasyResponder
        .target(name: "EasyResponder"),
        // EasyListView
        .target(name: "EasyListView"),
        // EasySyncScroll
        .target(name: "EasySyncScroll",
                dependencies: [
                    .product(name: "RxSwift", package: "RxSwift"),
                    .product(name: "RxCocoa", package: "RxSwift")
                ],
                linkerSettings: [
                    .linkedFramework("WebKit", .when(platforms: [.iOS]))
                ]),
        // EasyCarouseView
        .target(name: "EasyCarouseView",
                dependencies: [
                    .product(name: "RxSwift", package: "RxSwift"),
                    .product(name: "RxCocoa", package: "RxSwift")
                ]),
        // EasySegmentedView
        .target(name: "EasySegmentedView"),
        // EasyPagingContainerView
        .target(name: "EasyPagingContainerView"),
        // EasyExtension
        .target(name: "EasyExtension",
                dependencies: [
                    .product(name: "RxSwift", package: "RxSwift"),
                    .product(name: "RxCocoa", package: "RxSwift")
                ]),
        // EasyIGListKit
        .target(name: "EasyIGListKit",
                dependencies: [
                    .product(name: "RxSwift", package: "RxSwift"),
                    .product(name: "RxCocoa", package: "RxSwift"),
                    .product(name: "IGListKit", package: "IGListKit"),
                    .product(name: "IGListDiffKit", package: "IGListKit"),
                    "Then", "SnapKit", "EasyResponder", "EasyExtension", "EasySyncScroll"]),
        // EasyMediator
        .target(name: "EasyMediator",
                dependencies: ["EasyExtension"])
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
