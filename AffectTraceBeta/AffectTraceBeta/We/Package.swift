// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "We",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .executable(name: "We", targets: ["We"])
    ],
    targets: [
        .executableTarget(
            name: "We",
            path: "We"
        )
    ]
)
