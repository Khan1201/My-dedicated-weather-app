//
//  ErrorType.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation

enum APIError: Error {
    
    case transportError
}

enum LocationError: Error {
    
    case notFound
}
