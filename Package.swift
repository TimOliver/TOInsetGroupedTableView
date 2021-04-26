// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TOInsetGroupedTableView",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(name: "TOInsetGroupedTableView", targets: ["TOInsetGroupedTableView"]),
    ],
    targets: [
        .target(
            name: "TOInsetGroupedTableView",
			dependencies: [],
			path: "./TOInsetGroupedTableView/",
			publicHeadersPath: "include")
	]
)
