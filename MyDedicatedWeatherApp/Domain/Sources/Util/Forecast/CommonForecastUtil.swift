//
//  CommonForecastUtil.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/04.
//

import Foundation

public final class CommonForecastUtil {
    private init() { }

    public static let shared = CommonForecastUtil()
    /**
     초단기예보 or 단기예보에서 사용
     강수량 값, 하늘상태 값 -> (날씨 String,  날씨 이미지 String)
     
     - parameter ptyValue: 강수량 값,
     - parameter skyValue: 하늘상태 값
     */
    public func convertPrecipitationSkyStateOrSkyState(
        ptyValue: String,
        skyValue: String
    ) -> WeatherAPIValue {
        if ptyValue != "0" {
            return convertPrecipitationSkyState(rawValue: ptyValue)
            
        } else {
            return convertSkyState(rawValue: skyValue)
        }
    }
    
    public func convertPrecipitationSkyState(rawValue: String) -> WeatherAPIValue {
        return PrecipitationSkyStateConverter.convert(rawValue: rawValue)
    }
    
    public func convertSkyState(rawValue: String) -> WeatherAPIValue {
        return NoRainSkyStateConverter.convert(rawValue: rawValue)
    }
}
