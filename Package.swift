// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "NystagmuSenseShared",
    platforms: [.iOS(.v17)],
    products: [.library(name: "Shared", targets: ["Shared"])],
    targets: [
        .target(name: "Shared"),
        .testTarget(name: "SharedTests", dependencies: ["Shared"]),
    ]
)
