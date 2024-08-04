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
     return `Bool` by 일출 및 일몰 시간
     
     - parameter hhMM: 비교 대상 시간 (시간 분)
     - parameter sunrise: 일출 시간
     - parameter sunset: 일몰 시간
     */
    public func isDayMode(hhMM: String, sunrise: String, sunset: String) -> Bool {
        
        let hhMMToInt = Int(hhMM) ?? 0
        let sunriseToInt = Int(sunrise) ?? 0
        let sunsetToInt = Int(sunset) ?? 0
        
        if hhMMToInt > sunriseToInt && hhMMToInt < sunsetToInt {
            return true
            
        } else  {
            return false
        }
    }
    
    /**
     현재 시간에 따른  낮 or 밤 Json File Name
     
     - parameter dayJson: 05 ~ 18 시 json file name
     - parameter nightJson: 19 ~ 04 시 json file name
     */
    public func decideAnimationWhetherDayOrNight(
        hhMM: String,
        sunrise: String,
        sunset: String,
        dayJson: String,
        nightJson: String
    ) -> String {
        
        if isDayMode(hhMM: hhMM, sunrise: sunrise, sunset: sunset) {
            return dayJson
            
        } else {
            return nightJson
        }
    }
    
    /**
     현재 시간에 따른  낮 or 밤 Image String
     
     - parameter dayImageString: 05 ~ 18 시 image string
     - parameter nightImageString: 19 ~ 04 시 image string
     */
    public func decideImageWhetherDayOrNight(
        hhMM: String,
        sunrise: String,
        sunset:  String ,
        dayImageString: String,
        nightImgString: String
    ) -> String {
        
        if isDayMode(hhMM: hhMM, sunrise: sunrise, sunset: sunset) {
            return dayImageString
            
        } else {
            return nightImgString
        }
    }
    
    /**
     초단기예보 or 단기예보의 1시간 강수량 값 -> (String, String)
     
     - parameter value: 예보 조회 response 1시간 강수량 값
     */
    public func remakeOneHourPrecipitationValueByVeryShortTermOrShortTermForecast(value: String) -> (String, String) {
        
        if value == "강수없음" {
            return ("비 없음", "")
            
        } else if value == "30.0~50.0mm" || value == "50.0mm 이상" {
            return ("매우 강한 비", "30mm 이상")
            
        } else {
            let stringToDouble: Double = Double(value.replacingOccurrences(of: "mm", with: "")) ?? 0
            
            switch stringToDouble {
                
            case 1.0...2.9:
                return ("약한 비", value)
                
            case 3.0...14.9:
                return ("보통 비", value)
                
            case 15.0...29.9:
                return ("강한 비", value)
                
            default:
                return ("알 수 없음", "")
            }
        }
    }
    
    /**
     초단기예보 or 단기예보의 강수량 값 -> (강수량 String, 강수량 Img String)
     
     - parameter value: 예보 조회 response 바람속도 값
     */
    public func remakePrecipitaionTypeValueByVeryShortTermOrShortTermForecast(
        _ value: String,
        hhMMForDayOrNightImage: String,
        sunrise: String,
        sunset: String,
        isAnimationImage: Bool
    ) -> Weather.DescriptionAndSkyTypeAndImageString {
        
        switch value {
            
        case "0":
            return Weather.DescriptionAndSkyTypeAndImageString(
                description: "없음",
                skyType: .none,
                imageString: ""
            )
            
        case "1":
            return Weather.DescriptionAndSkyTypeAndImageString(
                description: "비",
                skyType: .rainy,
                imageString: isAnimationImage ? "RainManyLottie" : "weather_rain"
            )
            
        case "2":
            return Weather.DescriptionAndSkyTypeAndImageString(
                description: "비/눈",
                skyType: .snow,
                imageString: isAnimationImage ? "RainSnowLottie" : "weather_rain_snow"
            )
            
        case "3", "7":
            let animationJson = self.decideAnimationWhetherDayOrNight(
                hhMM: hhMMForDayOrNightImage,
                sunrise: sunrise,
                sunset: sunset,
                dayJson: "SnowLottie",
                nightJson: "SnowNightLottie"
            )
            return Weather.DescriptionAndSkyTypeAndImageString(
                description: "눈",
                skyType: .snow,
                imageString: isAnimationImage ? animationJson : "weather_snow"
            )
        case "4":
            let animationJson = self.decideAnimationWhetherDayOrNight(
                hhMM: hhMMForDayOrNightImage,
                sunrise: sunrise,
                sunset: sunset,
                dayJson: "RainShowerLottie",
                nightJson: "RainShowerNightLottie"
            )
            
            return Weather.DescriptionAndSkyTypeAndImageString(
                description: "소나기",
                skyType: .rainy,
                imageString: isAnimationImage ? animationJson : "weather_rain_small"
            )
            
        case "5":
            let animationJson = self.decideAnimationWhetherDayOrNight(
                hhMM: hhMMForDayOrNightImage,
                sunrise: sunrise,
                sunset: sunset,
                dayJson: "RainShowerLottie",
                nightJson: "RainShowerNightLottie"
            )
            
            return Weather.DescriptionAndSkyTypeAndImageString(
                description: "빗방울",
                skyType: .rainy,
                imageString: isAnimationImage ? animationJson : "weather_rain_small"
            )
            
        case "6":
//            let animationJson = self.decideAnimationWhetherDayOrNight(
//                hhMM: hhMMForDayOrNightImage,
//                sunrise: sunrise,
//                sunset: sunset,
//                dayJson: "SnowLottie",
//                nightJson: "SnowNightLottie"
//            )
 
            return Weather.DescriptionAndSkyTypeAndImageString(
                description: "빗방울 / 눈날림",
                skyType: .snow,
                imageString: isAnimationImage ? "RainSnowLottie" : "weather_rain_snow"
            )
            
        default:
            return Weather.DescriptionAndSkyTypeAndImageString(
                description: "알 수 없음",
                skyType: .none,
                imageString: "load_fail"
            )
        }
    }
    
    /**
     초단기예보 or 단기예보의 하늘상태  값 -> (하늘상태 String, 하늘상태 Img String)
     
     - parameter value: 예보 조회 response 하늘상태 값,
     - parameter isAnimationImage: is image is animation or basic
     */
    public func remakeSkyStateValueByVeryShortTermOrShortTermForecast(
        _ value: String,
        hhMMForDayOrNightImage: String,
        sunrise: String,
        sunset: String,
        isAnimationImage: Bool
    ) -> Weather.DescriptionAndSkyTypeAndImageString {
        
        switch value {
        case "1":
            let animationJson = self.decideAnimationWhetherDayOrNight(
                hhMM: hhMMForDayOrNightImage,
                sunrise: sunrise,
                sunset: sunset,
                dayJson: "SunnyLottie",
                nightJson: "SunnyNightLottie"
            )
            let imageString = self.decideImageWhetherDayOrNight(
                hhMM: hhMMForDayOrNightImage,
                sunrise: sunrise,
                sunset: sunset,
                dayImageString: "weather_sunny",
                nightImgString: "weather_sunny_night"
            )
            return Weather.DescriptionAndSkyTypeAndImageString(
                description: "맑음",
                skyType: .sunny,
                imageString: isAnimationImage ? animationJson : imageString
            )
            
        case "3":
            let animationJson = self.decideAnimationWhetherDayOrNight(
                hhMM: hhMMForDayOrNightImage,
                sunrise: sunrise,
                sunset: sunset,
                dayJson: "CloudManyLottie",
                nightJson: "CloudManyNightLottie"
            )
            let imageString = self.decideImageWhetherDayOrNight(
                hhMM: hhMMForDayOrNightImage,
                sunrise: sunrise,
                sunset: sunset,
                dayImageString: "weather_cloud_many",
                nightImgString: "weather_cloud_many_night"
            )
            return Weather.DescriptionAndSkyTypeAndImageString(
                description: "구름많음",
                skyType: .cloudy,
                imageString: isAnimationImage ? animationJson : imageString
            )
            
        case "4":
            return Weather.DescriptionAndSkyTypeAndImageString(
                description: "흐림",
                skyType: .blur,
                imageString: isAnimationImage ? "BlurLottie" : "weather_blur"
            )
            
        default:
            return Weather.DescriptionAndSkyTypeAndImageString(
                description: "알 수 없음",
                skyType: .none,
                imageString: isAnimationImage ? "LoadFailLottie" :  "load_fail"
            )
        }
    }
    
    /**
     초단기예보 강수량 값, 하늘상태 값 -> (날씨 String,  날씨 이미지 String)
     
     - parameter ptyValue: 강수량 값,
     - parameter skyValue: 하늘상태 값
     */
    public func veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
        ptyValue: String,
        skyValue: String,
        hhMMForDayOrNightImage: String,
        sunrise: String,
        sunset: String,
        isAnimationImage: Bool
    ) -> Weather.DescriptionAndSkyTypeAndImageString {
        
        if ptyValue != "0" {
            return remakePrecipitaionTypeValueByVeryShortTermOrShortTermForecast(
                ptyValue,
                hhMMForDayOrNightImage: hhMMForDayOrNightImage,
                sunrise: sunrise,
                sunset: sunset,
                isAnimationImage: isAnimationImage
            )
            
        } else {
            return remakeSkyStateValueByVeryShortTermOrShortTermForecast(
                skyValue,
                hhMMForDayOrNightImage: hhMMForDayOrNightImage,
                sunrise: sunrise,
                sunset: sunset,
                isAnimationImage: isAnimationImage
            )
        }
    }
    
    /**
     초단기예보 or 단기예보의 바람속도 값 ->( String, String)
     
     - parameter value: 예보 조회 response 바람속도 값
     */
    public func remakeWindSpeedValueByVeryShortTermOrShortTermForecast(value: String) -> (String, String) {
        
        let stringToDouble = Double(value) ?? 0.0
        
        switch stringToDouble {
            
        case 0.0...3.9:
            return ("약한 바람", "\(value)m/s")
            
        case 4.0...8.9:
            return ("약간 강한 바람", "\(value)m/s")
            
        case 9.0...13.9:
            return ("강한 바람", "\(value)m/s")
            
        case _ where stringToDouble > 13.9:
            
            return ("매우 강한 바람", "\(value)m/s")
            
        default:
            return ("알 수 없음", "")
        }
    }
}
