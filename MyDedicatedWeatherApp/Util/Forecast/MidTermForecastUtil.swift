//
//  MidTermForecastUtil.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/04.
//

import Foundation

struct MidTermForecastUtil {
    
    /// Return 요청 날짜 (yyyyMMddHHmm 형식)
    func requestTmFc() -> String {
        
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
    /// RegId: 기온, 육상예보 조회
    /// StnId: 전망 조회 (뉴스)
    /// 기온 조회 할 때 subLocality 필요, 나머지 조회엔 nil
    func requestRegOrStnId(locality: String, reqType: MidtermReqType, subLocality: String? = nil) -> String {

        var result: String = ""
        
        switch reqType {
        case .temperature:
            guard let subLocality = subLocality else { return "" }
            
            if locality.contains("서울") {
                result = "11B10101"
                
            } else if locality.contains("경기도") {
                if subLocality.contains("수원") {
                     result = "11B20601"
                } else if subLocality.contains("파주") {
                    result = "11B20305"
                } else if subLocality.contains("연천") {
                    result = "11B20402"
                } else if subLocality.contains("포천") {
                    result = "11B20403"
                } else if subLocality.contains("동두천") {
                    result = "11B20401"
                } else if subLocality.contains("양주") {
                    result = "11B20304"
                } else if subLocality.contains("의정부") {
                    result = "11B20301"
                } else if subLocality.contains("가평") {
                    result = "11B20404"
                } else if subLocality.contains("고양") {
                    result = "11B20302"
                } else if subLocality.contains("구리") {
                    result = "11B20501"
                } else if subLocality.contains("남양주") {
                    result = "11B20502"
                } else if subLocality.contains("하남") {
                    result = "11B20504"
                } else if subLocality.contains("양평") {
                    result = "11B20503"
                } else if subLocality.contains("광주") {
                    result = "11B20702"
                } else if subLocality.contains("여주") {
                    result = "11B20703"
                } else if subLocality.contains("김포") {
                    result = "11B20102"
                } else if subLocality.contains("부천") {
                    result = "11B20204"
                } else if subLocality.contains("광명") {
                    result = "11B10103"
                } else if subLocality.contains("시흥") {
                    result = "11B20202"
                } else if subLocality.contains("안양") {
                    result = "11B20602"
                } else if subLocality.contains("과천") {
                    result = "11B10102"
                } else if subLocality.contains("의왕") {
                    result = "11B20609"
                } else if subLocality.contains("군포") {
                    result = "11B20610"
                } else if subLocality.contains("안산") {
                    result = "11B20203"
                } else if subLocality.contains("성남") {
                    result = "11B20605"
                } else if subLocality.contains("용인") {
                    result = "11B20612"
                } else if subLocality.contains("이천") {
                    result = "11B20701"
                } else if subLocality.contains("화성") {
                    result = "11B20604"
                } else if subLocality.contains("오산") {
                    result = "11B20603"
                } else if subLocality.contains("평택") {
                    result = "11B20606"
                } else if subLocality.contains("안성") {
                    result = "11B20611"
                }
                
            } else if locality.contains("인천") {
                result = "11B20201"
                
            } else if locality.contains("춘천") || subLocality.contains("춘천") {
                result = "11D10301"
                
            } else if locality.contains("원주") || subLocality.contains("원주") {
                result = "11D10401"
                
            } else if locality.contains("강릉") || subLocality.contains("강릉") {
                result = "11D20501"
                
            } else if locality.contains("대전") {
                result = "11C20401"
                
            } else if locality.contains("서산") || subLocality.contains("서산") {
                result = "11C20101"
                
            } else if locality.contains("세종") || subLocality.contains("세종") {
                result = "11C20404"
                
            } else if locality.contains("청주") || subLocality.contains("청주") {
                result = "11C103011"
                
            } else if locality.contains("제주") || subLocality.contains("제주") {
                result = "11G00201"
                
            } else if locality.contains("서귀포") || subLocality.contains("서귀포") {
                result = "11G00401"
                
            } else if locality.contains("광주") || subLocality.contains("광주") {
                result = "11F20501"
                
            } else if locality.contains("목포") || subLocality.contains("목포") {
                result = "21F20801"
                
            } else if locality.contains("여수") || subLocality.contains("여수") {
                result = "11F20401"
                
            } else if locality.contains("전주") || subLocality.contains("전주") {
                result = "11F10201"
                
            } else if locality.contains("군산") || subLocality.contains("군산") {
                result = "21F10501"
                
            } else if locality.contains("부산") || subLocality.contains("부산") {
                result = "11H20201"
                
            } else if locality.contains("울산") {
                result = "11H20101"
                
            } else if locality.contains("창원") || subLocality.contains("창원") {
                result = "11H20301"
                
            } else if locality.contains("대구") {
                result = "11H10701"
                
            } else if locality.contains("안동") {
                result = "11H10501"
                
            } else if locality.contains("포항") {
                result = "11H10201"
                
            } else {
                result = ""
            }
            
        case .skystate:
            if locality.contains("서울") || locality.contains("인천") || locality.contains("경기도") {
                result = "11B00000"
                
            } else if locality.contains("강원도") {
                result = "11D10000"
                
            } else if locality.contains("대전") || locality.contains("세종") || locality.contains("충청남도") {
                result = "11C20000"
                
            } else if locality.contains("충청북도") {
                result = "11C10000"
                
            } else if locality.contains("광주") || locality.contains("전라남도") {
                result = "11F20000"
                
            } else if locality.contains("전라북도") {
                result = "11F10000"
                
            } else if locality.contains("대구") || locality.contains("경상북도") {
                result = "11H10000"
                
            } else if locality.contains("부산") || locality.contains("울산") || locality.contains("경상남도") {
                result = "11H20000"
                
            } else if locality.contains("제주도") {
                result = "11G00000"
                
            } else {
                result = ""
            }

        case .news:
            if locality.contains("강원도") {
                result = "105"
                
            } else if locality.contains("서울") || locality.contains("인천") || locality.contains("경기도") {
                result = "109"
                
            } else if locality.contains("충청북도") {
                result = "131"
                
            }  else if locality.contains("대전") || locality.contains("세종") || locality.contains("충청남도") {
                result = "133"
                
            }  else if locality.contains("전라북도") {
                result = "146"
                
            }  else if locality.contains("광주") || locality.contains("전라남도") {
                result = "156"
                
            }  else if locality.contains("대구") || locality.contains("경상북도") {
                result = "143"
                
            }  else if locality.contains("부산") || locality.contains("울산") || locality.contains("경상남도") {
                result = "159"
                
            }  else if locality.contains("제주도") {
                result = "184"
                
            } else {
                result = ""
            }
        }
        
        return result
    }
    
    func remakeSkyStateValueToImageString(value: String) -> String {
                
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
}
