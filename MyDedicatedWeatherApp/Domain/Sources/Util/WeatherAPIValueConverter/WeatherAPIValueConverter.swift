//
//  APIValueConverter.swift
//
//
//  Created by 윤형석 on 11/3/24.
//

import Foundation
import SwiftUI

protocol WeatherAPIValueConverter {
    static func convert(rawValue: String) -> WeatherAPIValue
}

public protocol WeatherAPIValue {
    var toDescription: String { get }
    var backgroundImage: String { get }
    var color: Color { get }
    func backgroundLottie(isDayMode: Bool) -> String
    func image(isDayMode: Bool) -> String
    func lottie(isDayMode: Bool) -> String
    func lottieOffset(isDayMode: Bool) -> Double
}

extension WeatherAPIValue {
    public var backgroundImage: String { return "" }
    public var color: Color { return .clear }
    public func backgroundLottie(isDayMode: Bool) -> String { return "" }
    public func image(isDayMode: Bool) -> String { return "" }
    public func lottie(isDayMode: Bool) -> String { return "" }
    public func lottieOffset(isDayMode: Bool) -> Double { return 0 }
}
