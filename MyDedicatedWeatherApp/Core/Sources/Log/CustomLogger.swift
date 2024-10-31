//
//  CustomLogger.swift
//
//
//  Created by 윤형석 on 11/1/24.
//

import os

extension Logger {
    public static let `default` = Logger(subsystem: "com.myWeatherApp", category: "log")
}

public struct CustomLogger {
    public static func debug(_ message: String) {
        Logger.default.debug("\(message)")
    }
    
    public static func error(_ message: String) {
        Logger.default.error("\(message)")
    }
}
