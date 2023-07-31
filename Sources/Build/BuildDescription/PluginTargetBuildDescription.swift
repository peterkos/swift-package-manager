//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift open source project
//
// Copyright (c) 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import struct Basics.AbsolutePath
import class PackageGraph.ResolvedTarget
import class PackageLoading.ManifestLoader
import struct PackageModel.ToolsVersion
import class PackageModel.UserToolchain

struct PluginTargetBuildDescription: BuildTarget {
    public let target: ResolvedTarget
    private let toolsVersion: ToolsVersion

    init(target: ResolvedTarget, toolsVersion: ToolsVersion) {
        assert(target.type == .plugin)
        self.target = target
        self.toolsVersion = toolsVersion
    }

    var sources: [AbsolutePath] {
        return target.sources.paths
    }

    func compileArguments() throws -> [String] {
        // FIXME: This is very odd and we should clean this up by merging `ManifestLoader` and `DefaultPluginScriptRunner` again.
        let loader = ManifestLoader(toolchain: try UserToolchain(swiftSDK: .hostSwiftSDK()))
        return loader.interpreterFlags(for: self.toolsVersion)
    }
    

}
