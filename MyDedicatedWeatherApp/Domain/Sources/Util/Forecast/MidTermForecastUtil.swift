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
    
    /// Return 요청 날짜 (yyyyMMddHHmm 형식)
    public var tmFcPar: String {
        
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
    
    /// Return 지역정보 코드
    /// - parameter fullAddress: 전체 주소,
    /// - parameter reqType: 요청 타입
    public func regOrStnIdPar(fullAddress: String, reqType: MidtermReqType) -> String {
        
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
    
    public func remakeSkyStateValueToImageString(value: String) -> String {
        
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
        
        let convertedCurrentMin: Int = currentMin.toInt <= yAxisMin.toInt ? yAxisMin.toInt : currentMin.toInt
        let convertedCurrentMax: Int = currentMax.toInt >= yAxisMax.toInt ? yAxisMax.toInt : currentMax.toInt
        
        // y 최저 ~ 현재 최저
        for _ in yAxisMin.toInt...convertedCurrentMin {
            minCount += 1
        }
        
        // 현재 최대 ~ y 최대
        for _ in convertedCurrentMax...yAxisMax.toInt {
            maxCount += 1
        }
        
        return minCount > maxCount
    }
}
