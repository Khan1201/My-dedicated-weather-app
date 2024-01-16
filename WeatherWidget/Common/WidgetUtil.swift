//
//  Util.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 2023/10/06.
//

import Foundation

struct Util {
    /**
     초단기예보 or 단기예보의 바람속도 값 -> (약한 바람, 3.5m/s)
     
     - parameter value: 예보 조회 response 바람속도 값
     */
    public static func remakeWindSpeedValueForToString(value: String) -> (String, String) {
        
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
     초단기예보 or 단기예보의 1시간 강수량 값 -> (약한 비, 1.5)
     
     - parameter value: 예보 조회 response 1시간 강수량 값
     */
    public static func remakePrecipitationValueForToString(value: String) -> (String, String) {
        
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
     초단기예보 or 단기예보의 비 상태 값, 하늘 상태 값 -> 날씨 image
     
     - parameter rainState: 예보 조회 response의 비 상태 값
     - parameter skyState: 예보 조회 response의 하늘 상태 값
     */
    public static func remakeRainStateAndSkyStateForWeatherImage(
        rainState: String,
        skyState: String,
        hhMM: String,
        sunrise: String,
        sunset: String
    ) -> String {
        if rainState != "0" {
            return remakeRainStateForWeatherImage(rainState, hhMM: hhMM, sunrise: sunrise, sunset: sunset)
            
        } else {
            return remakeSkyStateForWeatherImage(skyState, hhMM: hhMM, sunrise: sunrise, sunset: sunset)
        }
    }
    
    /**
     초단기예보 or 단기예보의 강수량 값 -> 날씨 image
     
     - parameter value: 예보 조회 response 강수 값
     */
    public static func remakeRainStateForWeatherImage(
        _ value: String,
        hhMM: String,
        sunrise: String,
        sunset: String
    ) -> String {
        
        switch value {
            
        case "0":
            return "load_fail"
            
        case "1":
            return "weather_rain"
            
        case "2":
            return "weather_rain_snow"
            
        case "3", "7":
            return "weather_snow"
            
        case "4":
            return "weather_rain_small"
            
        case "5":
            return "weather_rain_small"
            
        case "6":
            return "weather_rain_snow"
            
        default:
            return "load_fail"
        }
    }
    
    /**
     초단기예보 or 단기예보의 하늘상태  값 -> 날씨 imge
     
     - parameter value: 예보 조회 response 하늘상태 값,
     */
    public static func remakeSkyStateForWeatherImage(
        _ value: String,
        hhMM: String,
        sunrise: String,
        sunset: String
    ) -> String {
        
        switch value {
        case "1":
            return isDayMode(targetHHmm: hhMM, sunrise: sunrise, sunset: sunset) ? "weather_sunny" : "weather_sunny_night"
            
        case "3":
            return isDayMode(targetHHmm: hhMM, sunrise: sunrise, sunset: sunset) ? "weather_cloud_many" : "weather_cloud_many_night"
            
        case "4":
            return "weather_blur"
            
        default:
            return "load_fail"
        }
    }
    
    /**
    타겟 시간과 일출, 일몰 시간을 비교 -> return day or night (`Bool`)
     */
    
    public static func isDayMode(targetHHmm: String, sunrise: String, sunset: String) -> Bool {
        let targetHHmmToInt = Int(targetHHmm) ?? 0
        let sunriseToInt = Int(sunrise) ?? 0
        let sunsetToInt = Int(sunset) ?? 0
        
        if targetHHmmToInt > sunriseToInt && targetHHmmToInt < sunsetToInt {
            return true
            
        } else  {
            return false
        }
    }
    
    /**
     미세먼지 api response value 값 ->  값 String (`String`)
     
     - parameter value: api response 미세먼지 값
     */
    public static func remakeFindDustValue(value: String) -> String { // 미세먼지
        
        let valueToInt: Int = Int(value) ?? 0
        
        switch valueToInt {
            
        case 0...30:
            return "좋음"
        case 31...81:
            return "보통"
        case 81...150:
            return "나쁨"
        case _ where valueToInt >= 151:
            return "매우 나쁨"
        default:
            return "알 수 없음"
        }
    }
    
    /**
     초 미세먼지 api response value 값 ->  값 String (`String`)

     - parameter value: api response 초미세먼지 값
     */
    public static func remakeUltraFindDustValue(value: String) -> String { // 초 미세먼지
        
        let valueToInt: Int = Int(value) ?? 0
        
        switch valueToInt {
            
        case 0...15:
            return "좋음"
        case 16...35:
            return "보통"
        case 36...75:
            return "나쁨"
        case _ where valueToInt >= 76:
            return "매우 나쁨"
        default:
            return "알 수 없음"
        }
    }
    
    /// Return base time (초단기예보 requst parameter에 필요)
    public static func veryShortTermReqBaseTime() -> String {
        let currentDate: Date = Date()
        let currentHour: String = currentDate.toString(format: "HH")
        let currentMinute: String = currentDate.toString(format: "mm")
        let currentMinuteToInt: Int = Int(currentMinute) ?? 0
        
        if currentMinuteToInt < 30 {
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
    
    /// Return base date (초단기예보 requst parameter에 필요)
    public static func veryShortTermReqBaseDate(baseTime: String) -> String {
        let currentDate = Date()
        let currentHHmm = currentDate.toString(format: "HHmm").toInt
        
        return currentDate.toString(
            byAdding: currentHHmm < 0030 ? -1 : 0,
            format: "yyyyMMdd"
        )
    }
    
    /// Return base time (단기예보 requst parameter에 필요)
    public static func shortTermReqBaseTime() -> String {
        let dateFormatterHourMinute = DateFormatter()
        dateFormatterHourMinute.dateFormat = "HHmm"
        
        let todayDate: Date = Date()
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
    
    /// Return base date (단기예보 requst parameter에 필요)
    public static func shortTermReqBaseDate() -> String {
        let currentDate: Date = Date()
        let currentYearMonthDay = currentDate.toString(format: "yyyyMMdd")
        let currentHour = currentDate.toString(format: "HH")
        
        let currentYearMonthDayToInt = Int(currentYearMonthDay) ?? 0
        let currentHourToInt = Int(currentHour) ?? 0
        
        switch currentHourToInt {
            
        case 00...01:
            return String(currentYearMonthDayToInt - 1)
        default:
            return currentYearMonthDay
        }
    }
    
    // Return baseDate (최저, 최고온도 요청 parameter에 필요)
    public static func baseDateForTodayMinMaxReq() -> String {
        let currentDate = Date()
        let currentYyyyMMdd = currentDate.toString(format: "yyyyMMdd").toInt
        let currentHHmm = currentDate.toString(format: "HHmm").toInt
        
        if currentHHmm >= 0200 {
            return currentYyyyMMdd.toString
            
        } else {
            return (currentYyyyMMdd - 1).toString
        }
    }
    
    // Return baseTime (최저, 최고온도 요청 parameter에 필요)
    public static func baseTimeForTodayMinMaxReq() -> String {
        let currentHHmm = Date().toString(format: "HHmm").toInt
        
        if currentHHmm >= 0200 {
            return "0200"
            
        } else {
            return "2300"
        }
    }
    
    /// Return 지역정보 코드
    /// - parameter fullAddress: 전체 주소,
    /// - parameter reqType: 요청 타입
    public static func midtermReqRegOrStnId(fullAddress: String, reqType: MidtermReqType) -> String {

        var result: String = ""
        
        switch reqType {
            
        case .temperature:
            
            if fullAddress.contains("서울") {
                result = "11B10101"
            }
            else if fullAddress.contains("수원") {
                result = "11B20601"
            } else if fullAddress.contains("파주") {
                result = "11B20305"
            } else if fullAddress.contains("연천") {
                result = "11B20402"
            } else if fullAddress.contains("포천") {
                result = "11B20403"
            } else if fullAddress.contains("동두천") {
                result = "11B20401"
            } else if fullAddress.contains("양주") {
                result = "11B20304"
            } else if fullAddress.contains("의정부") {
                result = "11B20301"
            } else if fullAddress.contains("가평") {
                result = "11B20404"
            } else if fullAddress.contains("고양") {
                result = "11B20302"
            } else if fullAddress.contains("구리") {
                result = "11B20501"
            } else if fullAddress.contains("남양주") {
                result = "11B20502"
            } else if fullAddress.contains("하남") {
                result = "11B20504"
            } else if fullAddress.contains("양평") {
                result = "11B20503"
            } else if fullAddress.contains("광주") {
                result = "11B20702"
            } else if fullAddress.contains("여주") {
                result = "11B20703"
            } else if fullAddress.contains("김포") {
                result = "11B20102"
            } else if fullAddress.contains("부천") {
                result = "11B20204"
            } else if fullAddress.contains("광명") {
                result = "11B10103"
            } else if fullAddress.contains("시흥") {
                result = "11B20202"
            } else if fullAddress.contains("안양") {
                result = "11B20602"
            } else if fullAddress.contains("과천") {
                result = "11B10102"
            } else if fullAddress.contains("의왕") {
                result = "11B20609"
            } else if fullAddress.contains("군포") {
                result = "11B20610"
            } else if fullAddress.contains("안산") {
                result = "11B20203"
            } else if fullAddress.contains("성남") {
                result = "11B20605"
            } else if fullAddress.contains("용인") {
                result = "11B20612"
            } else if fullAddress.contains("이천") {
                result = "11B20701"
            } else if fullAddress.contains("화성") {
                result = "11B20604"
            } else if fullAddress.contains("오산") {
                result = "11B20603"
            } else if fullAddress.contains("평택") {
                result = "11B20606"
            } else if fullAddress.contains("안성") {
                result = "11B20611"
            } else if fullAddress.contains("인천") {
                result = "11B20201"
                
            } else if fullAddress.contains("서산") {
                result = "11C20101"
                
            } else if fullAddress.contains("세종") {
                result = "11C20404"
                
            } else if fullAddress.contains("청주") {
                result = "11C103011"
                
            } else if fullAddress.contains("제주") {
                result = "11G00201"
                
            } else if fullAddress.contains("서귀포") {
                result = "11G00401"
                
            } else if fullAddress.contains("광주") {
                result = "11F20501"
                
            } else if fullAddress.contains("목포") {
                result = "21F20801"
                
            } else if fullAddress.contains("여수") {
                result = "11F20401"
                
            } else if fullAddress.contains("전주") {
                result = "11F10201"
                
            } else if fullAddress.contains("군산") {
                result = "21F10501"
                
            } else if fullAddress.contains("부산") {
                result = "11H20201"
                
            } else if fullAddress.contains("울산") {
                result = "11H20101"
                
            } else if fullAddress.contains("창원") {
                result = "11H20301"
                
            } else if fullAddress.contains("대구") {
                result = "11H10701"
                
            } else if fullAddress.contains("안동") {
                result = "11H10501"
                
            } else if fullAddress.contains("포항") {
                result = "11H10201"
                
            } else if fullAddress.contains("충주") {
                result = "11H10201"
                
            } else if (fullAddress.contains("진천")) {
                result = "11C10102"
            } else if (fullAddress.contains("음성")) {
                result = "11C10103"
            } else if (fullAddress.contains("제천")) {
                result = "11C10201"
            } else if (fullAddress.contains("단양")) {
                result = "11C10202"
            } else if (fullAddress.contains("청주")) {
                result = "11C10301"
            } else if (fullAddress.contains("보은")) {
                result = "11C10302"
            } else if (fullAddress.contains("괴산")) {
                result = "11C10303"
            } else if (fullAddress.contains("증평")) {
                result = "11C10304"
            } else if (fullAddress.contains("추풍령")) {
                result = "11C10401"
            } else if (fullAddress.contains("영동군")) {
                result = "11C10402"
            } else if (fullAddress.contains("옥천군")) {
                result = "11C10403"
            } else if (fullAddress.contains("서산")) {
                result = "11C20101"
            } else if (fullAddress.contains("태안")) {
                result = "11C20102"
            } else if (fullAddress.contains("당진")) {
                result = "11C20103"
            } else if (fullAddress.contains("홍성")) {
                result = "11C20104"
            } else if (fullAddress.contains("보령")) {
                result = "11C20201"
            } else if (fullAddress.contains("서천")) {
                result = "11C20202"
            } else if (fullAddress.contains("천안")) {
                result = "11C20301"
            } else if (fullAddress.contains("아산")) {
                result = "11C20302"
            } else if (fullAddress.contains("예산")) {
                result = "11C20303"
            } else if (fullAddress.contains("대전광역시")) {
                result = "11C20401"
            } else if (fullAddress.contains("공주")) {
                result = "11C20402"
            } else if (fullAddress.contains("계룡")) {
                result = "11C20403"
            } else if (fullAddress.contains("세종특별시")) {
                result = "11C20404"
            } else if (fullAddress.contains("부여")) {
                result = "11C20501"
            } else if (fullAddress.contains("청양")) {
                result = "11C20502"
            } else if (fullAddress.contains("금산군")) {
                result = "11C20601"
            } else if (fullAddress.contains("논산")) {
                result = "11C20602"
            } else if (fullAddress.contains("철원")) {
                result = "11D10101"
            } else if (fullAddress.contains("화천")) {
                result = "11D10102"
            } else if (fullAddress.contains("인제")) {
                result = "11D10201"
            } else if (fullAddress.contains("양구군")) {
                result = "11D10202"
            } else if (fullAddress.contains("춘천")) {
                result = "11D10301"
            } else if (fullAddress.contains("홍천")) {
                result = "11D10302"
            } else if (fullAddress.contains("원주")) {
                result = "11D10401"
            } else if (fullAddress.contains("횡성")) {
                result = "11D10402"
            } else if (fullAddress.contains("영월")) {
                result = "11D10501"
            } else if (fullAddress.contains("정선")) {
                result = "11D10502"
            } else if (fullAddress.contains("평창")) {
                result = "11D10503"
            } else if (fullAddress.contains("대관령")) {
                result = "11D20201"
            } else if (fullAddress.contains("태백")) {
                result = "11D20301"
            } else if (fullAddress.contains("속초")) {
                result = "11D20401"
            } else if (fullAddress.contains("고성")) {
                result = "11D20402"
            } else if (fullAddress.contains("양양")) {
                result = "11D20403"
            } else if (fullAddress.contains("강릉")) {
                result = "11D20501"
            } else if (fullAddress.contains("동해")) {
                result = "11D20601"
            } else if (fullAddress.contains("삼척")) {
                result = "11D20602"
            } else if (fullAddress.contains("울릉도")) {
                result = "11E00101"
            } else if (fullAddress.contains("독도")) {
                result = "11E00102"
            } else if (fullAddress.contains("전주")) {
                result = "11F10201"
            } else if (fullAddress.contains("익산")) {
                result = "11F10202"
            } else if (fullAddress.contains("정읍")) {
                result = "11F10203"
            } else if (fullAddress.contains("완주")) {
                result = "11F10204"
            } else if (fullAddress.contains("장수군")) {
                result = "11F10301"
            } else if (fullAddress.contains("무주")) {
                result = "11F10302"
            } else if (fullAddress.contains("진안군")) {
                result = "11F10303"
            } else if (fullAddress.contains("남원")) {
                result = "11F10401"
            } else if (fullAddress.contains("임실")) {
                result = "11F10402"
            } else if (fullAddress.contains("순창")) {
                result = "11F10403"
            } else if (fullAddress.contains("군산")) {
                result = "21F10501"
            } else if (fullAddress.contains("김제")) {
                result = "21F10502"
            } else if (fullAddress.contains("고창")) {
                result = "21F10601"
            } else if (fullAddress.contains("부안군")) {
                result = "21F10602"
            } else if (fullAddress.contains("함평")) {
                result = "21F20101"
            } else if (fullAddress.contains("영광")) {
                result = "21F20102"
            } else if (fullAddress.contains("진도")) {
                result = "21F20201"
            } else if (fullAddress.contains("완도")) {
                result = "11F20301"
            } else if (fullAddress.contains("해남")) {
                result = "11F20302"
            } else if (fullAddress.contains("강진군")) {
                result = "11F20303"
            } else if (fullAddress.contains("장흥군")) {
                result = "11F20304"
            } else if (fullAddress.contains("여수시")) {
                result = "11F20401"
            } else if (fullAddress.contains("광양")) {
                result = "11F20402"
            } else if (fullAddress.contains("고흥")) {
                result = "11F20403"
            } else if (fullAddress.contains("보성")) {
                result = "11F20404"
            } else if (fullAddress.contains("순천시")) {
                result = "11F20405"
            } else if (fullAddress.contains("광주")) {
                result = "11F20501"
            } else if (fullAddress.contains("장성")) {
                result = "11F20502"
            } else if (fullAddress.contains("나주")) {
                result = "11F20503"
            } else if (fullAddress.contains("담양")) {
                result = "11F20504"
            } else if (fullAddress.contains("화순")) {
                result = "11F20505"
            } else if (fullAddress.contains("구례")) {
                result = "11F20601"
            } else if (fullAddress.contains("곡성")) {
                result = "11F20602"
            } else if (fullAddress.contains("순천")) {
                result = "11F20603"
            } else if (fullAddress.contains("흑산도")) {
                result = "11F20701"
            } else if (fullAddress.contains("목포")) {
                result = "21F20801"
            } else if (fullAddress.contains("영암")) {
                result = "21F20802"
            } else if (fullAddress.contains("신안군")) {
                result = "21F20803"
            } else if (fullAddress.contains("무안군")) {
                result = "21F20804"
            } else if (fullAddress.contains("성산구")) {
                result = "11G00101"
            } else if (fullAddress.contains("제주")) {
                result = "11G00201"
            } else if (fullAddress.contains("성판악")) {
                result = "11G00302"
            } else if (fullAddress.contains("서귀포")) {
                result = "11G00401"
            } else if (fullAddress.contains("울진")) {
                result = "11H10101"
            } else if (fullAddress.contains("영덕군")) {
                result = "11H10102"
            } else if (fullAddress.contains("포항")) {
                result = "11H10201"
            } else if (fullAddress.contains("경주")) {
                result = "11H10202"
            } else if (fullAddress.contains("문경")) {
                result = "11H10301"
            } else if (fullAddress.contains("상주")) {
                result = "11H10302"
            } else if (fullAddress.contains("예천군")) {
                result = "11H10303"
            } else if (fullAddress.contains("영주시")) {
                result = "11H10401"
            } else if (fullAddress.contains("봉화")) {
                result = "11H10402"
            } else if (fullAddress.contains("영양")) {
                result = "11H10403"
            } else if (fullAddress.contains("안동시")) {
                result = "11H10501"
            } else if (fullAddress.contains("의성")) {
                result = "11H10502"
            } else if (fullAddress.contains("청송")) {
                result = "11H10503"
            } else if (fullAddress.contains("김천")) {
                result = "11H10601"
            } else if (fullAddress.contains("구미시")) {
                result = "11H10602"
            } else if (fullAddress.contains("군위")) {
                result = "11H10603"
            } else if (fullAddress.contains("고령")) {
                result = "11H10604"
            } else if (fullAddress.contains("성주")) {
                result = "11H10605"
            } else if (fullAddress.contains("대구")) {
                result = "11H10701"
            } else if (fullAddress.contains("영천시")) {
                result = "11H10702"
            } else if (fullAddress.contains("경산")) {
                result = "11H10703"
            } else if (fullAddress.contains("청도")) {
                result = "11H10704"
            } else if (fullAddress.contains("칠곡")) {
                result = "11H10705"
            } else if (fullAddress.contains("울산")) {
                result = "11H20101"
            } else if (fullAddress.contains("양산시")) {
                result = "11H20102"
            } else if (fullAddress.contains("부산")) {
                result = "11H20201"
            } else if (fullAddress.contains("창원")) {
                result = "11H20301"
            } else if (fullAddress.contains("김해")) {
                result = "11H20304"
            } else if (fullAddress.contains("통영")) {
                result = "11H20401"
            } else if (fullAddress.contains("사천")) {
                result = "11H20402"
            } else if (fullAddress.contains("거제")) {
                result = "11H20403"
            } else if (fullAddress.contains("고성")) {
                result = "11H20404"
            } else if (fullAddress.contains("남해")) {
                result = "11H20405"
            } else if (fullAddress.contains("함양")) {
                result = "11H20501"
            } else if (fullAddress.contains("거창")) {
                result = "11H20502"
            } else if (fullAddress.contains("합천")) {
                result = "11H20503"
            } else if (fullAddress.contains("밀양")) {
                result = "11H20601"
            } else if (fullAddress.contains("의령")) {
                result = "11H20602"
            } else if (fullAddress.contains("함안")) {
                result = "11H20603"
            } else if (fullAddress.contains("창녕")) {
                result = "11H20604"
            } else if (fullAddress.contains("진주")) {
                result = "11H20701"
            } else if (fullAddress.contains("산청")) {
                result = "11H20703"
            } else if (fullAddress.contains("하동군")) {
                result = "11H20704"
            } else {
                result = ""
            }
            
        case .skystate:
            if fullAddress.contains("서울") || fullAddress.contains("인천") || fullAddress.contains("경기도") {
                result = "11B00000"
                
            } else if fullAddress.contains("강원") {
                result = "11D10000"
                
            } else if fullAddress.contains("대전") || fullAddress.contains("세종") || fullAddress.contains("충청남도") {
                result = "11C20000"
                
            } else if fullAddress.contains("충청북도") {
                result = "11C10000"
                
            } else if fullAddress.contains("광주") || fullAddress.contains("전라남도") {
                result = "11F20000"
                
            } else if fullAddress.contains("전라북도") {
                result = "11F10000"
                
            } else if fullAddress.contains("대구") || fullAddress.contains("경상북도") {
                result = "11H10000"
                
            } else if fullAddress.contains("부산") || fullAddress.contains("울산") || fullAddress.contains("경상남도") {
                result = "11H20000"
                
            } else if fullAddress.contains("제주") {
                result = "11G00000"
                
            } else {
                result = ""
            }
            
        case .news:
            if fullAddress.contains("강원") {
                result = "105"
                
            } else if fullAddress.contains("서울") || fullAddress.contains("인천") || fullAddress.contains("경기도") {
                result = "109"
                
            } else if fullAddress.contains("충청북도") {
                result = "131"
                
            }  else if fullAddress.contains("대전") || fullAddress.contains("세종") || fullAddress.contains("충청남도") {
                result = "133"
                
            }  else if fullAddress.contains("전라북도") {
                result = "146"
                
            }  else if fullAddress.contains("광주") || fullAddress.contains("전라남도") {
                result = "156"
                
            }  else if fullAddress.contains("대구") || fullAddress.contains("경상북도") {
                result = "143"
                
            }  else if fullAddress.contains("부산") || fullAddress.contains("울산") || fullAddress.contains("경상남도") {
                result = "159"
                
            }  else if fullAddress.contains("제주") {
                result = "184"
                
            } else {
                result = ""
            }
        }
        
        return result
    }
    
    /// Return 요청 날짜 (yyyyMMddHHmm 형식)
    public static func midtermReqTmFc() -> String {
        
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
        let yesterdayDate1800ToString = currentDate.toString(byAdding: -1, format: "yyyyMMdd1800")
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
    
    // 중기예보 skystate value -> image string
    public static func remakeMidforecastSkyStateForWeatherImage(value: String) -> String {
                
        if value == "맑음" {
            return "weather_sunny"
            
        } else if value == "구름많음" {
            return "weather_cloud_many"
            
        } else if value == "흐림" {
            return "weather_blur"
            
        } else if value == "구름많고 비" || value == "구름많고 소나기" || value == "흐리고 비" || value == "흐리고 소나기" {
            return "weather_rain"
            
        } else if value == "구름많고 눈" || value == "구름많고 비/눈" || value == "흐리고 눈" || value == "흐리고 비/눈" {
            return "weather_snow"
            
        } else {
            return "load_fail"
        }
    }
    
    public static func printError(funcTitle: String, description: String, value: Any? = nil, values: [Any]? = nil) {
        print("""
        ***********************************************************
        ⚠️ Error
        -----------------------------------------------------------
        ●Function Name: \(funcTitle)
        -----------------------------------------------------------
        ●Description:
        \(description)
        -----------------------------------------------------------
        ●Value(s):
          → Value: \(value ?? "")
          → Values: \(values ?? [])
        ***********************************************************
        """)
    }
    
    public static func printSuccess(funcTitle: String, value: Any? = nil, values: [Any]? = nil) {
        print("""
        ***********************************************************
        👍 Success
        -----------------------------------------------------------
        ●Function Name: \(funcTitle)
        -----------------------------------------------------------
        ●Value(s):
          → Value: \(value ?? "")
          → Values: \(values ?? [])
        ***********************************************************
        """)
    }
    
    /**
     ex) 현재시각 AM 10시
     1000 -> 10:00 변환
     
     - parameter HHmm: hour minute (HHmm) String
     */
    public static func convertHHmmToHHColonmm(HHmm: String) -> String {
        
        let lastIndex = HHmm.index(before: HHmm.endIndex)
        
        let hourIndex = HHmm.index(HHmm.startIndex, offsetBy: 1)
        let hour = HHmm[HHmm.startIndex...hourIndex]
        
        let minuteIndex = HHmm.index(HHmm.startIndex, offsetBy: 2)
        let minute = HHmm[minuteIndex...lastIndex]
        
        return hour + ":" + minute
    }
    
    /**
     Return AM or PM by 현재시간
     
     - parameter HH: Hour
     */
    public static func convertAMOrPMFromHHmm(_ HHmm: String) -> String {
        
        let hourEndIndex = HHmm.index(
            HHmm.startIndex, offsetBy: 1
        )
        let hour = String(HHmm[...hourEndIndex])
        let hourToInt = Int(hour) ?? 0
        
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
    
    /// Return 오늘 날씨 조회 인덱스 스킵 값
    /// baseTime: 02:00이고 현재 time: 03:00 일 때, 04:00 ~ 부터 set 위해 skip 지정
    public static func todayWeatherIndexSkipValue() -> Int {
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
    
    /// Return 오늘 날씨 조회 loop 횟수
    /// baseTime: 02:00이고 현재 time: 03:00 일 때, 04:00 ~ 부터 set 위해 기존 24에서 -
    public static func todayWeatherLoopCount() -> Int {
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
