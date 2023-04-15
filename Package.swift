// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Voodu",
    platforms: [.iOS(.v13)],
    products: [

        .library(
            name: "Voodu", 
            targets: ["Voodu"]
        )

    ],
    dependencies: [],
    targets: [

        .target(
            name: "Voodu",
            dependencies: [],
            path: "Sources/Core"
        )

    ],
    swiftLanguageVersions: [.v5]
)
