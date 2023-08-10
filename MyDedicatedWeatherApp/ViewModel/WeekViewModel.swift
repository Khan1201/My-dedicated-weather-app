//
//  WeekViewModel.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/24.
//

import Foundation

final class WeekViewModel: ObservableObject {
    
    @Published var weeklyWeatherInformations: [Weather.WeeklyWeatherInformation] = []
    @Published var errorMessage: String = ""
    
    var tommorowAndTwoDaysLaterInformations: [Weather.TommorowAndTwoDaysLaterInformation] = []
    var minMaxTemperaturesByThreeToTenDay: [(Int, Int)] = []
    var weatherImageAndRainfallPercentsByThreeToTenDay: [(String, Int)] = []
    
    private let locality: String = UserDefaults.standard.string(forKey: "locality") ?? ""
    private let subLocality: String = UserDefaults.standard.string(forKey: "subLocality") ?? ""
    private let xy: (Int, Int) = (UserDefaults.standard.integer(forKey: "x"), UserDefaults.standard.integer(forKey: "y"))
    
    private let shortTermForecastUtil: ShortTermForecastUtil = ShortTermForecastUtil()
    private let commonForecastUtil: CommonForecastUtil = CommonForecastUtil()
    private let env: Env = Env()
    private let jsonRequest: JsonRequest = JsonRequest()
    private let midTermForecastUtil: MidTermForecastUtil = MidTermForecastUtil()
    
    /**
     Request 단기예보 Items
     
     - parameter xy: 공공데이터 값으로 변환된 X, Y
     */
    func requestShortForecastItems() async {
        
        let parameters = VeryShortOrShortTermForecastReq(
            serviceKey: env.openDataApiResponseKey,
            baseDate: shortTermForecastUtil.requestBaseDate(),
            baseTime: shortTermForecastUtil.requestBaseTime(),
            nx: String(xy.0),
            ny: String(xy.1)
        )
        
        do {
            let result = try await jsonRequest.newRequest(
                url: Route.GET_WEATHER_SHORT_TERM_FORECAST.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: OpenDataRes<VeryShortOrShortTermForecastBase<ShortTermForecastCategory>>.self,
                requestName: "requestShortForecastItems(xy:)"
            )
            
            DispatchQueue.main.async {
                let tommorrowDate: String = Date().toString(byAdding: 1, format: "yyyyMMdd")
                let twoDaysLaterDate: String = Date().toString(byAdding: 2, format: "yyyyMMdd")
                
                var precipitationPercentes: [String] = []
                var skyStateImageStrings: [String] = []
                var minMaxTemperaturesByThreeToTenDay: [(String, String)] = []
                
                let tommorowTempFilteredItems: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>] = result.item?.filter({ item in
                    item.category == .TMP && item.fcstDate == tommorrowDate
                }) ?? []
                
                let twoDaysLaterTempFilteredItems: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>] = result.item?.filter({ item in
                    item.category == .TMP && item.fcstDate == twoDaysLaterDate
                }) ?? []
                
                let skyStateFilteredItems: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>] = result.item?.filter({ item in
                    item.category == .SKY && (item.fcstDate == tommorrowDate || item.fcstDate == twoDaysLaterDate) && item.fcstTime == "1200"
                }) ?? []
                
                let percentFilteredItems: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>] = result.item?.filter({ item in
                    item.category == .POP && (item.fcstDate == tommorrowDate || item.fcstDate == twoDaysLaterDate) && item.fcstTime == "1200"
                }) ?? []
                                
                
                for item in percentFilteredItems {
                    precipitationPercentes.append(item.fcstValue)
                }
                
                for item in skyStateFilteredItems {
                    skyStateImageStrings.append(
                        self.commonForecastUtil.remakeSkyStateValueByVeryShortTermOrShortTermForecast(
                            item.fcstValue,
                            hhMMForDayOrNightImage: "1200",
                            sunrise: "0600",
                            sunset: "2000",
                            isAnimationImage: false
                        ).imageString
                    )
                }
                
                var tommorowMinTemp = 0
                var tommorowMaxTemp = 0
                var twoDaysLaterMinTemp = 0
                var twoDaysLaterMaxTemp = 0
                
                for (index, item) in tommorowTempFilteredItems.enumerated() {
                    if index == 0 {
                        tommorowMinTemp = item.fcstValue.toInt
                        tommorowMaxTemp = item.fcstValue.toInt
                        
                    } else {
                        if item.fcstValue.toInt > tommorowMaxTemp {
                            tommorowMaxTemp = item.fcstValue.toInt
                        } else if item.fcstValue.toInt < tommorowMinTemp {
                            tommorowMinTemp = item.fcstValue.toInt
                        }
                    }
                }
                
                for (index, item) in twoDaysLaterTempFilteredItems.enumerated() {
                    if index == 0 {
                        twoDaysLaterMinTemp = item.fcstValue.toInt
                        twoDaysLaterMaxTemp = item.fcstValue.toInt
                        
                    } else {
                        if item.fcstValue.toInt > twoDaysLaterMaxTemp {
                            twoDaysLaterMaxTemp = item.fcstValue.toInt
                        } else if item.fcstValue.toInt < twoDaysLaterMinTemp {
                            twoDaysLaterMinTemp = item.fcstValue.toInt
                        }
                    }
                }
                
                minMaxTemperaturesByThreeToTenDay.append((tommorowMinTemp.toString, tommorowMaxTemp.toString))
                minMaxTemperaturesByThreeToTenDay.append((twoDaysLaterMinTemp.toString, twoDaysLaterMaxTemp.toString))
                
                for i in minMaxTemperaturesByThreeToTenDay.indices {
                    self.tommorowAndTwoDaysLaterInformations.append(
                        .init(
                            weatherImage: skyStateImageStrings[i],
                            minTemperature: minMaxTemperaturesByThreeToTenDay[i].0,
                            maxTemperature: minMaxTemperaturesByThreeToTenDay[i].1,
                            precipitationPercent: precipitationPercentes[i]
                        )
                    )
                }
 
                print(self.tommorowAndTwoDaysLaterInformations)
            }
            
        } catch APIError.transportError {
            
            DispatchQueue.main.async {
                self.errorMessage = "API 통신 에러"
            }
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "알 수 없는 오류"
            }
        }
    }
    
    /**
     Request 중기예보 (3~ 10일) 최저, 최고 기온  Items
     */
    func requestMidTermForecastTempItems() async {
        
        let parameters: MidTermForecastReq = MidTermForecastReq(
            serviceKey: env.openDataApiResponseKey,
            regId: midTermForecastUtil.requestRegOrStnId(locality: locality, reqType: .temperature, subLocality: subLocality),
            stnId: nil,
            tmFc: midTermForecastUtil.requestTmFc()
        )
        
        do {
            let result = try await jsonRequest.newRequest(
                url: Route.GET_WEATHER_MID_TERM_FORECAST_TEMP.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: OpenDataRes<MidTermForecastTemperatureBase>.self,
                requestName: "requestMidTermForecastTempItems()"
            )
            DispatchQueue.main.async {
                if let item = result.item?.first {
                    self.minMaxTemperaturesByThreeToTenDay.append((item.taMin3, item.taMax3))
                    self.minMaxTemperaturesByThreeToTenDay.append((item.taMin4, item.taMax4))
                    self.minMaxTemperaturesByThreeToTenDay.append((item.taMin5, item.taMax5))
                    self.minMaxTemperaturesByThreeToTenDay.append((item.taMin6, item.taMax6))
                    self.minMaxTemperaturesByThreeToTenDay.append((item.taMin7, item.taMax7))
                    self.minMaxTemperaturesByThreeToTenDay.append((item.taMin8, item.taMax8))
                    self.minMaxTemperaturesByThreeToTenDay.append((item.taMin8, item.taMax8))
                    self.minMaxTemperaturesByThreeToTenDay.append((item.taMin9, item.taMax9))
                    self.minMaxTemperaturesByThreeToTenDay.append((item.taMin10, item.taMax10))
                }
                
            }
        } catch APIError.transportError {
            
            DispatchQueue.main.async {
                self.errorMessage = "API 통신 에러"
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "알 수 없는 오류"
            }
        }
    }
    
    /**
     Request 중기예보 (3~ 10일) 하늘 상태, 강수 확률 items
     */
    func requestMidTermForecastSkyStateItems() async {
        
        let parameters: MidTermForecastReq = MidTermForecastReq(
            serviceKey: env.openDataApiResponseKey,
            regId: midTermForecastUtil.requestRegOrStnId(locality: locality, reqType: .skystate),
            stnId: nil,
            tmFc: midTermForecastUtil.requestTmFc()
        )
        
        do {
            let result = try await jsonRequest.newRequest(
                url: Route.GET_WEATHER_MID_TERM_FORECAST_SKYSTATE.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: OpenDataRes<MidTermForecastSkyStateBase>.self,
                requestName: "requestMidTermForecastSkyStateItems()"
            )
            DispatchQueue.main.async {
                if let item = result.item?.first {
                    self.weatherImageAndRainfallPercentsByThreeToTenDay.append(weatherImageAndRainfallPercent(wf: item.wf3Am, rnSt: item.rnSt3Am))
                    self.weatherImageAndRainfallPercentsByThreeToTenDay.append(weatherImageAndRainfallPercent(wf: item.wf4Am, rnSt: item.rnSt4Am))
                    self.weatherImageAndRainfallPercentsByThreeToTenDay.append(weatherImageAndRainfallPercent(wf: item.wf5Am, rnSt: item.rnSt5Am))
                    self.weatherImageAndRainfallPercentsByThreeToTenDay.append(weatherImageAndRainfallPercent(wf: item.wf6Am, rnSt: item.rnSt6Am))
                    self.weatherImageAndRainfallPercentsByThreeToTenDay.append(weatherImageAndRainfallPercent(wf: item.wf7Am, rnSt: item.rnSt7Am))
                    self.weatherImageAndRainfallPercentsByThreeToTenDay.append(weatherImageAndRainfallPercent(wf: item.wf8, rnSt: item.rnSt8))
                    self.weatherImageAndRainfallPercentsByThreeToTenDay.append(weatherImageAndRainfallPercent(wf: item.wf9, rnSt: item.rnSt9))
                    self.weatherImageAndRainfallPercentsByThreeToTenDay.append(weatherImageAndRainfallPercent(wf: item.wf10, rnSt: item.rnSt10))
                    
                    func weatherImageAndRainfallPercent(wf: String, rnSt: Int) -> (String, Int){
                        let wfToImageString = self.midTermForecastUtil.remakeSkyStateValueToImageString(value: wf)
                        return (wf, rnSt)
                    }
                }
                
            }
        } catch APIError.transportError {
            
            DispatchQueue.main.async {
                self.errorMessage = "API 통신 에러"
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "알 수 없는 오류"
            }
        }
    }
}
