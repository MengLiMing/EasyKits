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
            targets: ["EasyMediator"]),
        .library(
            name: "EasyPermission",
            targets: ["EasyPermission"]),
        .library(
            name: "EasyCamera",
            targets: ["EasyCamera"]),
        .library(
            name: "EasyLocation",
            targets: ["EasyLocation"]),
        .library(
            name: "EasyMicrophone",
            targets: ["EasyMicrophone"]),
        .library(
            name: "EasyNotification",
            targets: ["EasyNotification"]),
        .library(
            name: "EasyPhoto",
            targets: ["EasyPhoto"]),
        .library(
            name: "EasyPermissionRx",
            targets: ["EasyPermissionRx"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.5.0")),
        /// https://github.com/Instagram/IGListKit/issues/1557
        .package(url: "https://github.com/Instagram/IGListKit.git", revision: "d2f12cd92c998a1b0fecabfa14a253bd9cb2b82f"),
//        .package(url: "https://github.com/Instagram/IGListKit.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/devxoul/Then.git", .upToNextMajor(from: "3.0.0")),
    ],
    targets: [
        // EasyPopup
        .target(
            name: "EasyPopup",
            dependencies: [
                .product(name: "SnapKit", package: "SnapKit")
            ]
        ),
        // EasyResponder
        .target(name: "EasyResponder"),
        // EasyListView
        .target(name: "EasyListView"),
        // EasySyncScroll
        .target(
            name: "EasySyncScroll",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift")
            ],
            linkerSettings: [
                .linkedFramework("WebKit", .when(platforms: [.iOS]))
            ]
        ),
        // EasyCarouseView
        .target(
            name: "EasyCarouseView",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift")
            ]
        ),
        // EasySegmentedView
        .target(name: "EasySegmentedView"),
        // EasyPagingContainerView
        .target(name: "EasyPagingContainerView"),
        // EasyExtension
        .target(
            name: "EasyExtension",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift")
            ]
        ),
        // EasyIGListKit
        .target(
            name: "EasyIGListKit",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "IGListKit", package: "IGListKit"),
                .product(name: "IGListDiffKit", package: "IGListKit"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "Then", package: "Then"),
                .target(name: "EasyResponder"),
                .target(name: "EasyExtension"),
                .target(name: "EasySyncScroll")
            ]
        ),
        // EasyMediator
        .target(
            name: "EasyMediator",
            dependencies: [.target(name: "EasyExtension")]
        ),
        // EasyPermission
        .target(
            name: "EasyPermission",
            path: "Sources/EasyPermission/Core"
        ),
        .target(
            name: "EasyCamera",
            dependencies: [
                .target(name: "EasyPermission")
            ],
            path: "Sources/EasyPermission/EasyCamera",
            swiftSettings: [
                .define("PERMISSION_EASYCAMERA"),
            ]
        ),
        .target(
            name: "EasyLocation",
            dependencies: [
                .target(name: "EasyPermission")
            ],
            path: "Sources/EasyPermission/EasyLocation",
            swiftSettings: [
                .define("PERMISSION_EASYLOCATION"),
            ]
        ),
        .target(
            name: "EasyMicrophone",
            dependencies: [
                .target(name: "EasyPermission")
            ],
            path: "Sources/EasyPermission/EasyMicrophone",
            swiftSettings: [
                .define("PERMISSION_EASYMICROPHONE"),
            ]
        ),
        .target(
            name: "EasyNotification",
            dependencies: [
                .target(name: "EasyPermission")
            ],
            path: "Sources/EasyPermission/EasyNotification",
            swiftSettings: [
                .define("PERMISSION_EASYNOTIFICATION"),
            ]
        ),
        .target(
            name: "EasyPhoto",
            dependencies: [
                .target(name: "EasyPermission")
            ],
            path: "Sources/EasyPermission/EasyPhoto",
            swiftSettings: [
                .define("PERMISSION_EASYPHOTO"),
            ]
        ),
        .target(
            name: "EasyPermissionRx",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .target(name: "EasyPermission")
            ],
            path: "Sources/EasyPermission/Rx"
        ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
