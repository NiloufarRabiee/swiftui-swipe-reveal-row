// swift-tools-version: 5.9
import PackageDescription
let package = Package(name: "SwipeRevealRow", platforms: [.iOS(.v16), .macOS(.v13)], products: [.library(name: "SwipeRevealRow", targets: ["SwipeRevealRow"])], targets: [.target(name: "SwipeRevealRow"), .testTarget(name: "SwipeRevealRowTests", dependencies: ["SwipeRevealRow"])])
