//
//  MidTermForecastUtil.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/04.
//

import Foundation

public struct MidTermForecastUtil {
    public init() {
        
    }
    
    public func remakeSkyStateValueToImageString(value: String) -> WeatherAPIValue {
        
        if value == "맑음" {
            return SkyState.sunny
            
        } else if value == "구름많음" {
            return SkyState.cloudy
            
        } else if value == "흐림" {
            return SkyState.blur
            
        } else if value == "구름많고 비" || value == "구름많고 소나기" || value == "흐리고 비" || value == "흐리고 소나기" {
            return SkyState.rainy
            
        } else if value == "구름많고 눈" || value == "구름많고 비/눈" || value == "흐리고 눈" || value == "흐리고 비/눈" {
            return SkyState.snow
            
        } else {
            return SkyState.none
        }
    }
    
    public func temperatureChartYList(maxTemp: Int) -> [Int] {
        
        switch maxTemp {
            
        case 31...35:
            return fiveUnitRange(maxOfRange: 35)
            
        case 26...30:
            return fiveUnitRange(maxOfRange: 30)
            
        case 21...25:
            return fiveUnitRange(maxOfRange: 25)
            
        case 16...20:
            return fiveUnitRange(maxOfRange: 20)
            
        case 11...15:
            return fiveUnitRange(maxOfRange: 15)
            
        case 6...10:
            return fiveUnitRange(maxOfRange: 10)
            
        case 1...5:
            return fiveUnitRange(maxOfRange: 5)
            
        case -4...0:
            return fiveUnitRange(maxOfRange: 0)
            
        case -9 ... -5:
            return fiveUnitRange(maxOfRange: -5)
            
        case -14 ... -10:
            return fiveUnitRange(maxOfRange: -10)
            
        case -19 ... -15:
            return fiveUnitRange(maxOfRange: -15)
            
        default:
            CommonUtil.shared.printError(
                funcTitle: "setTemperatureChartInformation()의 switch문",
                description: "yList 범위를 지정할 수 없습니다."
            )
            return []
        }
        
        func fiveUnitRange(maxOfRange: Int) -> [Int] {
            var max: Int = maxOfRange
            var yList: [Int] = []
            
            for i in 0..<5 {
                if i == 0 {
                    yList.append(max)
                    
                } else {
                    max -= 5
                    yList.append(max)
                }
            }
            
            return yList
        }
    }
    
    
    /// 주간 예보 - 차트 안 날씨 이미지 - 최저 온도 밑 ? or 최대 온도 위 ?
    public static func isWeatherImageUnderMinTemperatureLocated(currentMin: CGFloat, yAxisMin: CGFloat, currentMax: CGFloat, yAxisMax: CGFloat) -> Bool {
        var minCount: Int = 0
        var maxCount: Int = 0
        
        let convertedCurrentMin: Int = Int(currentMin) <= Int(yAxisMin) ? Int(yAxisMin) : Int(currentMin)
        let convertedCurrentMax: Int = Int(currentMax) >= Int(yAxisMax) ? Int(yAxisMax) : Int(currentMax)
        
        // y 최저 ~ 현재 최저
        for _ in Int(yAxisMin)...convertedCurrentMin {
            minCount += 1
        }
        
        // 현재 최대 ~ y 최대
        for _ in convertedCurrentMax...Int(yAxisMax) {
            maxCount += 1
        }
        
        return minCount > maxCount
    }
}
