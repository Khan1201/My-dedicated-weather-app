//
//  Util.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation
import SwiftUI

struct Util {
    
    //MARK: - Common..
    
    /**
     Current date String by adding day
     
     - parameter currentDate:current date,
     - parameter day: for adding day,
     - parameter dateFormat: for current date format type
     */
    func dateToStringByAddingDay(currentDate: Date, day: Int, dateFormat: String) -> String {
        
        let calender: Calendar = Calendar.current
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        let dateComponent: DateComponents = DateComponents(day: day)
        
        let yesterdayDate: Date = calender.date(byAdding: dateComponent, to: currentDate) ?? Date()
        let yesterdayDateToString = dateFormatter.string(from: yesterdayDate)
        return yesterdayDateToString
    }
    
    /**
     ex) 현재시각 AM 10시
     1000 -> 10:00 변환
     
     - parameter HHmm: hour minute (HHmm) String
     */
    func convertHHmmToHHColonmm(HHmm: String) -> String {
        
        let lastIndex = HHmm.index(before: HHmm.endIndex)
        
        let hourIndex = HHmm.index(HHmm.startIndex, offsetBy: 1)
        let hour = HHmm[HHmm.startIndex...hourIndex]
        
        let minuteIndex = HHmm.index(HHmm.startIndex, offsetBy: 2)
        let minute = HHmm[minuteIndex...lastIndex]
        
        return hour + ":" + minute
    }
    
    /**
     현재 Date -> dateFormat 에 따른 Date
     
     - parameter dateFormat: dateFormat String
     */
    func currentDateByCustomFormatter(dateFormat: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "ko")
        
        return formatter.string(from: Date())
    }
    
    /**
     return `Bool` by 일출 및 일몰 시간
     
     - parameter hhMM: 비교 대상 시간 (시간 분)
     - parameter sunrise: 일출 시간
     - parameter sunset: 일몰 시간
     */
    func isDayMode(hhMM: String, sunrise: String, sunset: String) -> Bool {
        
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
    func decideAnimationWhetherDayOrNight(
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
    func decideImageWhetherDayOrNight(
        hhMM: String,
        sunrise: String,
        sunset:  String ,
        dayImageString: String,
        nightImgString: String
    ) -> String {
        let currentHH = Int(currentDateByCustomFormatter(dateFormat: "HH")) ?? 0
        
        if isDayMode(hhMM: hhMM, sunrise: sunrise, sunset: sunset) {
            return dayImageString
            
        } else {
            return nightImgString
        }
    }
    
    /**
     Return AM or PM by 현재시간
     
     - parameter HH: Hour
     */
    func convertAMOrPM(_ HH: String) -> String {
        
        let hourToInt = Int(HH) ?? 0
        
        if hourToInt - 12 > 0 {
            return "\(hourToInt - 12)PM"
            
        } else if hourToInt == 12 {
            return "12PM"
            
        } else if hourToInt == 00 {
            return "12AM"
            
        } else {
            
            if hourToInt < 10 { // 2 digit -> 1digit (remove 0)
                return "\(String(hourToInt).last ?? "0")AM"
                
            } else {
                return "\(hourToInt)AM"
            }
        }
    }
    
    
    //MARK: - For Mid Term Forecast.. (중기 예보)
    
    /**
     Return 현재시간 -> baseDate (중기예보 Requst 타입)
     
     */
    func midTermForecastRequestDate() -> String {
        
        var result: String = ""
        
        let dateFormatter0600: DateFormatter = DateFormatter()
        dateFormatter0600.dateFormat = "yyyyMMdd0600"
        
        let dateFormatter1800: DateFormatter = DateFormatter()
        dateFormatter1800.dateFormat = "yyyyMMdd1800"
        
        let dateFormatterCurrent: DateFormatter = DateFormatter()
        dateFormatterCurrent.dateFormat = "yyyyMMddHHmm"
        
        let currentDate: Date = Date()
        
        let currentDate0600ToString = dateFormatter0600.string(from: currentDate)
        let currentDate1800ToString = dateFormatter1800.string(from: currentDate)
        let yesterdayDate1800ToString = dateToStringByAddingDay(
            currentDate: currentDate,
            day: -1,
            dateFormat: "yyyyMMddHHmm"
        )
        let currentDateToString = dateFormatterCurrent.string(from: currentDate)
        
        
        if currentDateToString < currentDate0600ToString {
            result = yesterdayDate1800ToString
            
        } else if (currentDateToString > currentDate0600ToString) &&
                    (currentDateToString < currentDate1800ToString) {
            result = currentDate0600ToString
            
        } else if (currentDateToString > currentDate0600ToString) &&
                    (currentDateToString > currentDate1800ToString) {
            result = currentDate1800ToString
        }
        
        return result
    }
    
    // MARK: - For Very Short or Short Term Forecast.. (초 단기 예보, 단기 예보)
    
    /**
     초단기예보의 Category 타입에 따른 값 Remake
     
     - parameter category: 예보 조회 response category 타입
     - parameter value: 예보 조회 response category 타입의 value
     */
    //    func veryShortTermForecastCategoryValue(category: VeryShortTermForecastCategory, value: String) -> Weather.DescriptionAndImageString {
    //
    //        switch category {
    //
    //        case .T1H: // 기온
    //            return Weather.DescriptionAndImageString(description: "\(value)°", imageString: "")
    //
    //        case .RN1: // 1시간 강수량
    //            return Weather.DescriptionAndImageString(
    //                description: remakeOneHourPrecipitationValueByVeryShortTermOrShortTermForecast(value: value),
    //                imageString: ""
    //            )
    //
    //        case .PTY: // 강수 형태
    //            return remakePrecipitaionTypeValueByVeryShortTermOrShortTermForecast(value: value)
    //
    //        case .SKY: // 하늘 상태
    //            return remakeSkyStateValueByVeryShortTermOrShortTermForecast(value: value)
    //
    //        case .REH: // 습도
    //            return Weather.DescriptionAndImageString(description: "\(value)%", imageString: "")
    //
    //        case .WSD: // 풍속
    //            return Weather.DescriptionAndImageString(
    //                description: remakeWindSpeedValueByVeryShortTermOrShortTermForecast(value: value),
    //                imageString: ""
    //            )
    //
    //        case .UUU: // 동서 바람 성분 (사용 x)
    //            return Weather.DescriptionAndImageString(description: "", imageString: "")
    //
    //        case .VVV: // 남북 바람 성분 (사용 x)
    //            return Weather.DescriptionAndImageString(description: "", imageString: "")
    //
    //        case .LGT: // 낙뢰 (사용 x)
    //            return Weather.DescriptionAndImageString(description: "", imageString: "")
    //
    //        case .VEC: // 풍향 (사용 x)
    //            return Weather.DescriptionAndImageString(description: "", imageString: "")
    //
    //        }
    //    }
    
    /**
     단기예보의 Category 타입에 따른 값 Remake
     
     - parameter category: 예보 조회 response category 타입
     - parameter value: 예보 조회 response category 타입의 value
     */
    //    func shortTermForecastCategoryValue(category: ShortTermForecastCategory, value: String) -> Weather.DescriptionAndImageString {
    //
    //        switch category {
    //
    //        case .POP: // 강수 확률
    //            return Weather.DescriptionAndImageString(description: "\(value)%", imageString: "")
    //
    //        case .PTY: // 강수 형태
    //            return remakePrecipitaionTypeValueByVeryShortTermOrShortTermForecast(value: value)
    //
    //        case .PCP: // 1시간 강수량
    //            return Weather.DescriptionAndImageString(
    //                description: remakeOneHourPrecipitationValueByVeryShortTermOrShortTermForecast(value: value),
    //                imageString: ""
    //            )
    //
    //        case .REH: // 습도
    //            return Weather.DescriptionAndImageString(description: "\(value)%", imageString: "")
    //
    //        case .SKY: // 하늘 상태
    //            return remakeSkyStateValueByVeryShortTermOrShortTermForecast(value: value)
    //
    //        case .TMP: // 1시간 기온
    //            return Weather.DescriptionAndImageString(description: "\(value)°", imageString: "")
    //
    //        case .TMN: // 일 최저기온
    //            return Weather.DescriptionAndImageString(description: "\(value)°", imageString: "")
    //
    //        case .TMX: // 일 최고기온
    //            return Weather.DescriptionAndImageString(description: "\(value)°", imageString: "")
    //
    //        case .WSD: // 풍속
    //            return Weather.DescriptionAndImageString(
    //                description: remakeWindSpeedValueByVeryShortTermOrShortTermForecast(value: value),
    //                imageString: ""
    //            )
    //        }
    //    }
    
    /**
     초단기예보 or 단기예보의 1시간 강수량 값 -> (String, String)
     
     - parameter value: 예보 조회 response 1시간 강수량 값
     */
    func remakeOneHourPrecipitationValueByVeryShortTermOrShortTermForecast(value: String) -> (String, String) {
        
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
    func remakePrecipitaionTypeValueByVeryShortTermOrShortTermForecast(
        _ value: String,
        hhMMForDayOrNightImage: String,
        sunrise: String,
        sunset: String,
        isAnimationImage: Bool
    ) -> Weather.DescriptionAndImageString {
        
        switch value {
            
        case "0":
            return Weather.DescriptionAndImageString(description: "없음", imageString: "")
            
        case "1":
            let animationJson = self.decideAnimationWhetherDayOrNight(
                hhMM: hhMMForDayOrNightImage,
                sunrise: sunrise,
                sunset: sunset,
                dayJson: "Rain",
                nightJson: "RainNight"
            )
            return Weather.DescriptionAndImageString(
                description: "비",
                imageString: isAnimationImage ? animationJson : "weather_rain"
            )
            
        case "2":
            return Weather.DescriptionAndImageString(description: "비/눈", imageString: "weather_rain_snow")
            
        case "3":
            let animationJson = self.decideAnimationWhetherDayOrNight(
                hhMM: hhMMForDayOrNightImage,
                sunrise: sunrise,
                sunset: sunset,
                dayJson: "Snow",
                nightJson: "SnowNight"
            )
            return Weather.DescriptionAndImageString(
                description: "눈",
                imageString: isAnimationImage ? animationJson : "weather_snow"
            )
        case "4":
            return Weather.DescriptionAndImageString(description: "소나기", imageString: "weather_rain_small")
            
        case "5":
            return Weather.DescriptionAndImageString(description: "빗방울", imageString: "weather_rain_small")
            
        case "6":
            return Weather.DescriptionAndImageString(description: "빗방울 / 눈날림", imageString: "weather_rain_snow")
            
        default:
            return Weather.DescriptionAndImageString(description: "알 수 없음", imageString: "load_fail")
        }
    }
    
    /**
     초단기예보 or 단기예보의 하늘상태  값 -> (하늘상태 String, 하늘상태 Img String)
     
     - parameter value: 예보 조회 response 하늘상태 값,
     - parameter isAnimationImage: is image is animation or basic
     */
    func remakeSkyStateValueByVeryShortTermOrShortTermForecast(
        _ value: String,
        hhMMForDayOrNightImage: String,
        sunrise: String,
        sunset: String,
        isAnimationImage: Bool
    ) -> Weather.DescriptionAndImageString {
        
        switch value {
        case "1":
            let animationJson = self.decideAnimationWhetherDayOrNight(
                hhMM: hhMMForDayOrNightImage,
                sunrise: sunrise,
                sunset: sunset,
                dayJson: "Sunny",
                nightJson: "SunnyNight"
            )
            let imageString = self.decideImageWhetherDayOrNight(
                hhMM: hhMMForDayOrNightImage,
                sunrise: sunrise,
                sunset: sunset,
                dayImageString: "weather_sunny",
                nightImgString: "weather_sunny_night"
            )
            return Weather.DescriptionAndImageString(
                description: "맑음",
                imageString: isAnimationImage ? animationJson : imageString
            )
            
        case "3":
            let animationJson = self.decideAnimationWhetherDayOrNight(
                hhMM: hhMMForDayOrNightImage,
                sunrise: sunrise,
                sunset: sunset,
                dayJson: "CloudMany",
                nightJson: "CloudManyNight"
            )
            let imageString = self.decideImageWhetherDayOrNight(
                hhMM: hhMMForDayOrNightImage,
                sunrise: sunrise,
                sunset: sunset,
                dayImageString: "weather_cloud_many",
                nightImgString: "weather_cloud_many_night"
            )
            return Weather.DescriptionAndImageString(
                description: "구름많음",
                imageString: isAnimationImage ? animationJson : imageString
            )
            
        case "4":
            return Weather.DescriptionAndImageString(
                description: "흐림",
                imageString: isAnimationImage ? "Cloudy" : "weather_blur"
            )
            
        default:
            return Weather.DescriptionAndImageString(description: "알 수 없음", imageString: "load_fail")
        }
    }
    
    /**
     초단기예보 or 단기예보의 바람속도 값 ->( String, String)
     
     - parameter value: 예보 조회 response 바람속도 값
     */
    func remakeWindSpeedValueByVeryShortTermOrShortTermForecast(value: String) -> (String, String) {
        
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
    
    /**
     Return 현재시간 -> baseTime (단기예보 Requst 타입)
     
     */
    func shortTermForecastBaseTime() -> String {
        
        //        let dateFormatterYearMonthDay = DateFormatter()
        //        dateFormatterYearMonthDay.dateFormat = "yyyyMMdd"
        
        let dateFormatterHourMinute = DateFormatter()
        dateFormatterHourMinute.dateFormat = "HHmm"
        
        let todayDate: Date = Date()
        
        //        let yesterdayYearMonthDay: String = dateToStringByAddingDay(currentDate: todayDate, day: -1, dateFormat: "yyyyMMdd")
        //        let currentYearMonthDay: String = dateFormatterYearMonthDay.string(from: todayDate)
        let currentHourMinute: Int = Int(dateFormatterHourMinute.string(from: todayDate)) ?? 0
        
        switch currentHourMinute {
            
        case 0000...0159:
            return "2300"
            
        case 0200...0459:
            return "0200"
            
        case 0500...0759:
            return "0500"
            
        case 0800...1059:
            return "0800"
            
        case 1100...1359:
            return "1100"
            
        case 1400...1659:
            return "1400"
            
        case 1700...1959:
            return "1700"
            
        case 2000...2259:
            return "2000"
            
        case 2300...2359:
            return "2300"
            
        default:
            return "알 수 없음"
        }
    }
    
    func shortTermForcastBaseDate() -> String {
        
        let currentYearMonthDay = currentDateByCustomFormatter(dateFormat: "yyyyMMdd")
        let currentHour = currentDateByCustomFormatter(dateFormat: "HH")
        
        let currentYearMonthDayToInt = Int(currentYearMonthDay) ?? 0
        let currentHourToInt = Int(currentHour) ?? 0
        
        switch currentHourToInt {
            
        case 00...02:
            return String(currentYearMonthDayToInt - 1)
        default:
            return currentYearMonthDay
        }
    }
    
    /**
     Return 현재시간 -> baseTime (초단기예보 Requst 타입)
     
     */
    func veryShortTermForecastBaseTime() -> String {
        
        let dateFormatterHour: DateFormatter = DateFormatter()
        dateFormatterHour.dateFormat = "HH"
        
        let dateFormatterMinute: DateFormatter = DateFormatter()
        dateFormatterMinute.dateFormat = "mm"
        
        let currentDay: Date = Date()
        
        let currentHour: String = dateFormatterHour.string(from: currentDay)
        let currentMinute: Int = Int(dateFormatterMinute.string(from: currentDay)) ?? 0
        
        if currentMinute < 30 {
            if currentHour == "00" {
                return "2330"
                
            } else {
                let currentHourToInt = Int(currentHour) ?? 0
                let currentHourMinusOneHour = currentHourToInt - 1
                var toString = String(currentHourMinusOneHour)
                
                if toString.count == 1 {
                    toString.insert("0", at: toString.startIndex)
                }
                
                return toString + "30"
            }
            
        } else { // currentMinute >= 30
            return currentHour + "30"
        }
    }
    
    
    /**
     초단기예보 Reqeust baseTime(시간)에 따른 baseDate(날짜) 설정
     
     - parameter baseTime: '단기예보 request 시간'
     */
    func veryShortTermForecastBaseDate(baseTime: String) -> String {
        
        return dateToStringByAddingDay(
            currentDate: Date(),
            day: baseTime == "2330" ? -1 : 0,
            dateFormat: "yyyyMMdd"
        )
    }
    
    /**
     초단기예보 강수량 값, 하늘상태 값 -> (날씨 String,  날씨 이미지 String)
     
     - parameter ptyValue: 강수량 값,
     - parameter skyValue: 하늘상태 값
     */
    func veryShortOrShortTermForecastWeatherDescriptionWithImageString(
        ptyValue: String,
        skyValue: String,
        hhMMForDayOrNightImage: String,
        sunrise: String,
        sunset: String,
        isAnimationImage: Bool
    ) -> Weather.DescriptionAndImageString {
        
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
     Latitude(위도) ,Longitude(경도) -> nx, ny (단기예보, 초단기예보 전용 x, y 좌표 값)
     
     - parameter ptyValue: 강수량 값,
     - parameter skyValue: 하늘상태 값
     */
    func convertGPS2XY(mode: LocationConvertMode, lat_X: Double, lng_Y: Double) -> LatXLngY {
        
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
        var rs = LatXLngY(lat: 0, lng: 0, x: 0, y: 0)
        
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
    
    struct LatXLngY {
        public var lat: Double
        public var lng: Double
        
        public var x: Int
        public var y: Int
    }
    
    enum LocationConvertMode: String {
        case toXY
        case toGPS
    }
    
    //MARK: - For realtime find dust forecast.. (실시간 미세먼지)
    
    /**
     미세먼지 api response value 값 -> UI 보여질 값으로 remake
     
     - parameter value: 미세먼지 값
     */
    func remakeFindDustValue(value: String) -> Weather.DescriptionAndColor { // 미세먼지
        
        let valueToInt: Int = Int(value) ?? 0
        
        switch valueToInt {
            
        case 0...30:
            return Weather.DescriptionAndColor(description: "좋음", color: .blue)
        case 31...81:
            return Weather.DescriptionAndColor(description: "보통", color: .green)
        case 81...150:
            return Weather.DescriptionAndColor(description: "나쁨", color: .orange)
        case _ where valueToInt >= 151:
            return Weather.DescriptionAndColor(description: "매우 나쁨", color: .red)
        default:
            return Weather.DescriptionAndColor(description: "알 수 없음", color: .clear)
        }
    }
    
    /**
     초 미세먼지 api response value 값 -> UI 보여질 값으로 remake
     
     - parameter value: 초미세먼지 값
     */
    func remakeUltraFindDustValue(value: String) -> Weather.DescriptionAndColor { // 초 미세먼지
        
        let valueToInt: Int = Int(value) ?? 0
        
        switch valueToInt {
            
        case 0...15:
            return Weather.DescriptionAndColor(description: "좋음", color: .blue)
        case 16...35:
            return Weather.DescriptionAndColor(description: "보통", color: .green)
        case 36...75:
            return Weather.DescriptionAndColor(description: "나쁨", color: .orange)
        case _ where valueToInt >= 76:
            return Weather.DescriptionAndColor(description: "매우 나쁨", color: .red)
        default:
            return Weather.DescriptionAndColor(description: "알 수 없음", color: .clear)
        }
    }
}

