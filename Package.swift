// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Voodu",
    platforms: [.iOS(.v13)],
    swiftLanguageVersions: [.v5],
    dependencies: [],
    products: [

        .library(
            name: "Voodu", 
            targets: ["Core"]
        )

    ],
    targets: [

        .target(
            name: "Core",
            path: "Sources/Core",
            dependencies: []
        )

    ]
)
