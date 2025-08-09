//
//  Logger.swift
//  AutodocTest
//
//  Created by Kirill Sklyarov on 09.08.2025.
//

import Foundation
import os

enum Log {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "AutodocTest"

    static let app = Logger(subsystem: subsystem, category: "App")
    static let imageLoader = Logger(subsystem: subsystem, category: "ImageLoader")
    static let cache = Logger(subsystem: subsystem, category: "Cache")
    static let router = Logger(subsystem: subsystem, category: "Router")
}

extension Logger {
    func debugOnly(_ message: @autoclosure @escaping () -> String,
               file: StaticString = #fileID,
               function: StaticString = #function,
               line: UInt = #line) {
#if DEBUG
        debug("\(file):\(line) \(function) — \(message(), privacy: .public)")
#endif
    }
    
    func errorAlways(_ message: @autoclosure @escaping () -> String,
               file: StaticString = #fileID,
               function: StaticString = #function,
               line: UInt = #line) {
        error("\(file):\(line) \(function) — \(message(), privacy: .public)")
    }
}
