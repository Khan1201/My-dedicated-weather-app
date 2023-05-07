//
//  Util.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation

struct Util {
    
    //MARK: - For Mid Term Forecast.. (중기 예보)
    
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
    
    func dateToStringByAddingDay(currentDate: Date, day: Int, dateFormat: String) -> String {
        
        let calender: Calendar = Calendar.current
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        let dateComponent: DateComponents = DateComponents(day: day)
        
        let yesterdayDate: Date = calender.date(byAdding: dateComponent, to: currentDate) ?? Date()
        let yesterdayDateToString = dateFormatter.string(from: yesterdayDate)
        return yesterdayDateToString
    }
    
    // MARK: - For Very Short or Short Term Forecast.. (초 단기 예보, 단기 예보)
    
    func veryShortTermForecastCategoryValue(category: VeryShortTermForecastCategory, value: String) -> (String, String) {
        
        switch category {
            
        case .T1H: // 기온
            return ("\(value)°", "")
            
        case .RN1: // 1시간 강수량
            return (remakeOneHourPrecipitationValue(value: value), "")
            
        case .PTY: // 강수 형태
            return remakePrecipitaionTypeValue(value: value)
            
        case .SKY: // 하늘 상태
            return remakeSkyStateValue(value: value)
            
        case .REH: // 습도
            return ("\(value)%", "")
            
        case .WSD: // 풍속
            return (remakeWindSpeedValue(value: value), "")
            
        case .UUU: // 동서 바람 성분 (사용 x)
            return ("","")
            
        case .VVV: // 남북 바람 성분 (사용 x)
            return ("","")
            
        case .LGT: // 낙뢰 (사용 x)
            return ("","")
            
        case .VEC: // 풍향 (사용 x)
            return ("","")

        }
    }
    
    func shortTermForecastCategoryValue(category: ShortTermForecastCategory, value: String) -> (String, String) {
        
        switch category {
            
        case .POP: // 강수 확률
            return ("\(value)%", "")
            
        case .PTY: // 강수 형태
            return remakePrecipitaionTypeValue(value: value)
            
        case .PCP: // 1시간 강수량
            return (remakeOneHourPrecipitationValue(value: value), "")
            
        case .REH: // 습도
            return ("\(value)%", "")
            
        case .SKY: // 하늘 상태
            return remakeSkyStateValue(value: value)
            
        case .TMP: // 1시간 기온
            return ("\(value)°", "")
            
        case .TMN: // 일 최저기온
            return ("\(value)°", "")
            
        case .TMX: // 일 최고기온
            return ("\(value)°", "")
            
        case .WSD: // 풍속
            return (remakeWindSpeedValue(value: value), "")
        }
    }
    
    func remakeOneHourPrecipitationValue(value: String) -> String {
        
        if value == "강수없음" {
            return "비 없음"
            
        } else if value == "30.0~50.0mm" || value == "50.0mm 이상" {
            return "매우 강한 비"
            
        } else {
            
            let stringToDouble: Double = Double(value.replacingOccurrences(of: "mm", with: "")) ?? 0
            switch stringToDouble {
                
            case 1.0...2.9:
                return "약한 비"
            case 3.0...14.9:
                return "보통 비"
            case 15.0...29.9:
                return "강한 비"
            default:
                return "알 수 없음"
            }
        }
    }
    
    func remakePrecipitaionTypeValue(value: String) -> (String, String) {
        
        switch value {
            
        case "0":
            return ("없음", "")
        case "1":
            return ("비", "weather_rain")
        case "2":
            return ("비/눈", "weather_rain_snow")
        case "3":
            return ("눈", "weather_snow")
        case "5":
            return ("빗방울", "weather_rain_small")
        case "6":
            return ("빗방울 / 눈날림", "")
        default:
            return ("알 수 없음", "")
        }
    }
    
    func remakeSkyStateValue(value: String) -> (String, String) {
        
        switch value {
        case "1":
            return ("맑음", "weather_sunny")
        case "3":
            return ("구름많음", "weather_cloud_many")
        case "4":
            return ("흐림", "weather_blur")
        default:
            return ("알 수 없음", "")
        }
    }
    
    func remakeWindSpeedValue(value: String) -> String {
        
        let stringToDouble = Double(value) ?? 0.0
        
        switch stringToDouble {
        case 0.0...3.9:
            return "약한 바람"
        case 4.0...8.9:
            return "약간 강한 바람"
        case 9.0...13.9:
            return "강한 바람"
        case _ where stringToDouble > 13.9:
            return "매우 강한 바람"
            
        default:
            return "알 수 없음"
        }
    }
    
    func shortTermForecastBaseTime() -> String {
                
        let dateFormatterYearMonthDay = DateFormatter()
        dateFormatterYearMonthDay.dateFormat = "yyyyMMdd"
        
        let dateFormatterHourMinute = DateFormatter()
        dateFormatterHourMinute.dateFormat = "HHmm"
        
        let todayDate: Date = Date()
        
        let yesterdayYearMonthDay: String = dateToStringByAddingDay(currentDate: todayDate, day: -1, dateFormat: "yyyyMMdd")
        let currentYearMonthDay: String = dateFormatterYearMonthDay.string(from: todayDate)
        let currentHourMinute: Int = Int(dateFormatterHourMinute.string(from: todayDate)) ?? 0
        
        switch currentHourMinute {
            
        case 0000...0159:
            return yesterdayYearMonthDay + "2300"
        case 0200...0459:
            return currentYearMonthDay + "0200"
        case 0500...0759:
            return currentYearMonthDay + "0500"
        case 0800...1059:
            return currentYearMonthDay + "0800"
        case 1100...1359:
            return currentYearMonthDay + "1100"
        case 1400...1659:
            return currentYearMonthDay + "1400"
        case 1700...1959:
            return currentYearMonthDay + "1700"
        case 2000...2259:
            return currentYearMonthDay + "2000"
        case 2300...2359:
            return currentYearMonthDay + "2300"
            
        default:
            return "알 수 없음"
        }
    }
    
    func veryShortTermForecastBaseTime() -> String {
        
        
        let dateFormatterHour: DateFormatter = DateFormatter()
        dateFormatterHour.dateFormat = "HH"
        
        let dateFormatterMinute: DateFormatter = DateFormatter()
        dateFormatterMinute.dateFormat = "mm"
        
        let currentDay: Date = Date()
        
        let currentHour: Int = Int(dateFormatterHour.string(from: currentDay)) ?? 0
        let currentMinute: Int = Int(dateFormatterMinute.string(from: currentDay)) ?? 0
        
        if currentMinute < 30 {
            if currentHour == 00 {
               return "2330"
                
            } else {
                return String(currentHour - 1) + "30"
            }
            
        } else { // currentMinute >= 30
            return String(currentHour) + "30"
        }
    }
    
    func currentYYYYMMdd() -> String {
        
        let dateFormatterYearMonthDay: DateFormatter = DateFormatter()
        dateFormatterYearMonthDay.dateFormat = "yyyyMMdd"
        
        return dateFormatterYearMonthDay.string(from: Date())
    }
    
    //////////////// GPS -> GRID ///////////////
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
    
    //MARK: -
}




