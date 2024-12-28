//
//  ShortTermForecastUtil.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/04.
//

import Foundation

public struct ShortTermForecastUtil {
    public init() {
        
    }

    public var todayWeatherIndexSkipValue: Int {
        let currentHH: Int = Date().toString(format: "HH").toInt
        let allBaseTimeHHs: [Int] = [02, 05, 08, 11, 14, 17, 20, 23]
        
        var result: Int = 0
        
        allBaseTimeHHs.forEach {
           
            // 현재 시각이 01이면, 23 + 1 = 24가 아닌 01로 나와야 하므로
            if $0 == 23 {
                if $0 + 1 == 24 && currentHH == 0 {
                    result += 12

                } else if $0 + 2 == 25 && currentHH == 1 {
                    result += 24
                }
                
            } else {
                if $0 + 1 == currentHH {
                    result += 12

                } else if $0 + 2 == currentHH {
                    result += 24
                }
            }
        }
        
        return result
    }
    
    public var todayWeatherLoopCount: Int {
        let currentHH: Int = Date().toString(format: "HH").toInt
        let allBaseTimeHHs: [Int] = [02, 05, 08, 11, 14, 17, 20, 23]
        
        var result: Int = 24
        
        allBaseTimeHHs.forEach {
            
            // 현재 시각이 01이면, 23 + 1 = 24가 아닌 01로 나와야 하므로
            if $0 == 23 {
                if $0 + 1 == 24 && currentHH == 0 {
                    result = result - 1
                    
                } else if $0 + 2 == 25 && currentHH == 1 {
                    result = result - 2
                }
                
            } else {
                if $0 + 1 == currentHH {
                    result = result - 1
                    
                } else if $0 + 2 == currentHH {
                    result = result - 2
                }
            }
        }
        
        return result
    }
}
