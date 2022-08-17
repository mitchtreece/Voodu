// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    
    name: "Voodu",
    
    platforms: [
        
        .iOS(.v13)
        
    ],
    
    products: [

        .library(
            name: "Voodu",
            targets: ["Voodu"]
        )

    ],
    
    targets: [

        .target(name: "Voodu")

    ]
    
)