//
//  APIValueConverter.swift
//
//
//  Created by 윤형석 on 11/3/24.
//

import Foundation

protocol APIValueConverter {
    static func convert(rawValue: String) -> String
}
