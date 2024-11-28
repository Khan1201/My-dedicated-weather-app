//
//  APIValueConverter.swift
//
//
//  Created by 윤형석 on 11/3/24.
//

import Foundation

protocol APIValueConverter {
    static func convert(rawValue: String) -> APIValue
}

public protocol APIValue {
    var toDescription: String { get }
    var backgroundImage: String { get }
    func backgroundLottie(isDayMode: Bool) -> String
    func image(isDayMode: Bool) -> String
    func lottie(isDayMode: Bool) -> String
    func lottieOffset(isDayMode: Bool) -> Double
}

extension APIValue {
    public var backgroundImage: String { return "" }
    public func backgroundLottie(isDayMode: Bool) -> String { return "" }
    public func image(isDayMode: Bool) -> String { return "" }
    public func lottie(isDayMode: Bool) -> String { return "" }
    public func lottieOffset(isDayMode: Bool) -> Double { return 0 }
}
