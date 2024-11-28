//
//  CommonForecastUtil.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/04.
//

import Foundation

public struct CommonForecastUtil {
    
    public init() {}
    
    /**
     Latitude(위도) ,Longitude(경도) -> nx, ny (단기예보, 초단기예보 전용 x, y 좌표 값)
     
     - parameter ptyValue: 강수량 값,
     - parameter skyValue: 하늘상태 값
     */
    public func convertGPS2XY(mode: Gps2XY.LocationConvertMode, lat_X: Double, lng_Y: Double) -> Gps2XY.LatXLngY {
        
        let RE = 6371.00877 // 지구 반경(km)
        let GRID = 5.0 // 격자 간격(km)
        let SLAT1 = 30.0 // 투영 위도1(degree)
        let SLAT2 = 60.0 // 투영 위도2(degree)
        let OLON = 126.0 // 기준점 경도(degree)
        let OLAT = 38.0 // 기준점 위도(degree)
        let XO:Double = 43 // 기준점 X좌표(GRID)
        let YO:Double = 136 // 기1준점 Y좌표(GRID)
        
        //
        // LCC DFS 좌표변환 ( code : "TO_GRID"(위경도->좌표, lat_X:위도,  lng_Y:경도), "TO_GPS"(좌표->위경도,  lat_X:x, lng_Y:y) )
        //
        
        let DEGRAD = Double.pi / 180.0
        let RADDEG = 180.0 / Double.pi
        
        let re = RE / GRID
        let slat1 = SLAT1 * DEGRAD
        let slat2 = SLAT2 * DEGRAD
        let olon = OLON * DEGRAD
        let olat = OLAT * DEGRAD
        
        var sn = tan(Double.pi * 0.25 + slat2 * 0.5) / tan(Double.pi * 0.25 + slat1 * 0.5)
        sn = log(cos(slat1) / cos(slat2)) / log(sn)
        var sf = tan(Double.pi * 0.25 + slat1 * 0.5)
        sf = pow(sf, sn) * cos(slat1) / sn
        var ro = tan(Double.pi * 0.25 + olat * 0.5)
        ro = re * sf / pow(ro, sn)
        var rs = Gps2XY.LatXLngY(lat: 0, lng: 0, x: 0, y: 0)
        
        if mode == .toXY { // 위경도 -> 좌표
            rs.lat = lat_X
            rs.lng = lng_Y
            var ra = tan(Double.pi * 0.25 + (lat_X) * DEGRAD * 0.5)
            ra = re * sf / pow(ra, sn)
            var theta = lng_Y * DEGRAD - olon
            if theta > Double.pi {
                theta -= 2.0 * Double.pi
            }
            if theta < -Double.pi {
                theta += 2.0 * Double.pi
            }
            
            theta *= sn
            rs.x = Int(floor(ra * sin(theta) + XO + 0.5))
            rs.y = Int(floor(ro - ra * cos(theta) + YO + 0.5))
        }
        else { // 좌표 -> 위경도
            rs.x = Int(lat_X)
            rs.y = Int(lng_Y)
            let xn = lat_X - XO
            let yn = ro - lng_Y + YO
            var ra = sqrt(xn * xn + yn * yn)
            if (sn < 0.0) {
                ra = -ra
            }
            var alat = pow((re * sf / ra), (1.0 / sn))
            alat = 2.0 * atan(alat) - Double.pi * 0.5
            
            var theta = 0.0
            if (abs(xn) <= 0.0) {
                theta = 0.0
            }
            else {
                if (abs(yn) <= 0.0) {
                    theta = Double.pi * 0.5
                    if (xn < 0.0) {
                        theta = -theta
                    }
                }
                else {
                    theta = atan2(xn, yn)
                }
            }
            let alon = theta / sn + olon
            rs.lat = alat * RADDEG
            rs.lng = alon * RADDEG
        }
        return rs
    }
    
    /**
     초단기예보 or 단기예보의 1시간 강수량 값 -> (String, String)
     
     - parameter value: 예보 조회 response 1시간 강수량 값
     */
    public func convertPrecipitationAmount(rawValue: String) -> String {
        return PrecipitationAmountConverter.convert(rawValue: rawValue).toDescription
    }
    
    public func precipitationValueToShort(rawValue: String) -> String {
        return PrecipitationAmountConverter.toShortValue(rawValue)
    }

    /**
     초단기예보 강수량 값, 하늘상태 값 -> (날씨 String,  날씨 이미지 String)
     
     - parameter ptyValue: 강수량 값,
     - parameter skyValue: 하늘상태 값
     */
    public func convertPrecipitationSkyStateOrSkyState(
        ptyValue: String,
        skyValue: String
    ) -> APIValue {
        if ptyValue != "0" {
            return convertPrecipitationSkyState(rawValue: ptyValue)
            
        } else {
            return convertSkyState(rawValue: skyValue)
        }
    }
    
    public func convertPrecipitationSkyState(rawValue: String) -> APIValue {
        return PrecipitationSkyStateConverter.convert(rawValue: rawValue)
    }
    
    public func convertSkyState(rawValue: String) -> APIValue {
        return SkyStateConverter.convert(rawValue: rawValue)
    }
    
    /**
     초단기예보 or 단기예보의 바람속도 값 ->( String, String)
     
     - parameter value: 예보 조회 response 바람속도 값
     */
    public func convertWindSpeed(rawValue: String) -> APIValue {
        return WindSpeedConverter.convert(rawValue: rawValue)
    }
}
