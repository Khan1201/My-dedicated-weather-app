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
    
    var tommorowAndTwoDaysLaterInformations: [Weather.WeeklyWeatherInformation] = []
    var minMaxTemperaturesByThreeToTenDay: [(String, String)] = []
    var weatherImageAndRainfallPercentsByThreeToTenDay: [(String, String)] = []
    
    private let locality: String = UserDefaults.standard.string(forKey: "locality") ?? ""
    private let subLocality: String = UserDefaults.standard.string(forKey: "subLocality") ?? ""
    private let xy: (Int, Int) = (UserDefaults.standard.integer(forKey: "x"), UserDefaults.standard.integer(forKey: "y"))
    
    private let shortTermForecastUtil: ShortTermForecastUtil = ShortTermForecastUtil()
    private let commonForecastUtil: CommonForecastUtil = CommonForecastUtil()
    private let midTermForecastUtil: MidTermForecastUtil = MidTermForecastUtil()
}

// MARK: - Request funcs..

extension WeekViewModel {
    /**
     Request 단기예보 Items
     
     - parameter xy: 공공데이터 값으로 변환된 X, Y
     */
    func requestShortForecastItems() async {
        
        let parameters = VeryShortOrShortTermForecastReq(
            serviceKey: Env.shared.openDataApiResponseKey,
            numOfRows: "701",
            baseDate: shortTermForecastUtil.requestBaseDate(),
            baseTime: shortTermForecastUtil.requestBaseTime(),
            nx: String(xy.0),
            ny: String(xy.1)
        )
        
        do {
            let result = try await JsonRequest.shared.newRequest(
                url: Route.GET_WEATHER_SHORT_TERM_FORECAST.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: OpenDataRes<VeryShortOrShortTermForecastBase<ShortTermForecastCategory>>.self,
                requestName: "requestShortForecastItems(xy:)"
            )
            
            DispatchQueue.main.async {
                if let item = result.item {
                    self.setTommorowAndTwoDaysLaterInformations(by: item)
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
     Request 중기예보 (3~ 10일) 최저, 최고 기온  Items
     */
    func requestMidTermForecastTempItems() async {
        
        let parameters: MidTermForecastReq = MidTermForecastReq(
            serviceKey: Env.shared.openDataApiResponseKey,
            regId: midTermForecastUtil.requestRegOrStnId(locality: locality, reqType: .temperature, subLocality: subLocality),
            stnId: nil,
            tmFc: midTermForecastUtil.requestTmFc()
        )
        
        do {
            let result = try await JsonRequest.shared.newRequest(
                url: Route.GET_WEATHER_MID_TERM_FORECAST_TEMP.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: OpenDataRes<MidTermForecastTemperatureBase>.self,
                requestName: "requestMidTermForecastTempItems()"
            )
            DispatchQueue.main.async {
                if let item = result.item?.first {
                    self.setMinMaxTemperaturesByThreeToTenDay(by: item)
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
            serviceKey: Env.shared.openDataApiResponseKey,
            regId: midTermForecastUtil.requestRegOrStnId(locality: locality, reqType: .skystate),
            stnId: nil,
            tmFc: midTermForecastUtil.requestTmFc()
        )
        
        do {
            let result = try await JsonRequest.shared.newRequest(
                url: Route.GET_WEATHER_MID_TERM_FORECAST_SKYSTATE.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: OpenDataRes<MidTermForecastSkyStateBase>.self,
                requestName: "requestMidTermForecastSkyStateItems()"
            )
            DispatchQueue.main.async {
                if let item = result.item?.first {
                    self.setWeatherImageAndRainfallPercentsByThreeToTenDay(by: item)
                    self.setWeeklyWeatherInformations()
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
    
    func performWeekRequests() async {
        await requestShortForecastItems()
        await requestMidTermForecastTempItems()
        await requestMidTermForecastSkyStateItems()
    }
}

// MARK: - Set funcs..

extension WeekViewModel {
    /**
     Set `tommorowAndTwoDaysLaterInformations`(오늘 ~ 내일까지의 최저, 최고 온도 및 하늘정보 image, 강수확률 데이터)
     - parameter items: requestShortForecastItems() 결과 데이터
     */
    func setTommorowAndTwoDaysLaterInformations(by items: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>]) {
        let tommorrowDate: String = Date().toString(byAdding: 1, format: "yyyyMMdd")
        let twoDaysLaterDate: String = Date().toString(byAdding: 2, format: "yyyyMMdd")
        
        // 각 변수에는 오늘, 내일 데이터 포함 (count == 2)
        var precipitationPercentes: [String] = []
        var skyStateImageStrings: [String] = []
        var minMaxTemperatures: [(String, String)] = []
        
        let tommorowTempFilteredItems = items.filter { item in
            item.category == .TMP && item.fcstDate == tommorrowDate
        }
        
        let twoDaysLaterTempFilteredItems = items.filter { item in
            item.category == .TMP && item.fcstDate == twoDaysLaterDate
        }
        
        let skyStateFilteredItems = items.filter { item in
            item.category == .SKY && (item.fcstDate == tommorrowDate || item.fcstDate == twoDaysLaterDate) && item.fcstTime == "1200"
        }
        
        let percentFilteredItems = items.filter { item in
            item.category == .POP && (item.fcstDate == tommorrowDate || item.fcstDate == twoDaysLaterDate) && item.fcstTime == "1200"
        }
                        
        for i in 0..<skyStateFilteredItems.count {
            precipitationPercentes.append(percentFilteredItems[i].fcstValue)
            skyStateImageStrings.append(
                self.commonForecastUtil.remakeSkyStateValueByVeryShortTermOrShortTermForecast(
                    skyStateFilteredItems[i].fcstValue,
                    hhMMForDayOrNightImage: "1200",
                    sunrise: "0600",
                    sunset: "2000",
                    isAnimationImage: false
                ).imageString
            )
        }
        
        let tommorowMinMaxTemp: (String, String) = minMaxItem(by: tommorowTempFilteredItems)
        let twoDaysLaterMinMaxTemp: (String, String) = minMaxItem(by: twoDaysLaterTempFilteredItems)
        
        minMaxTemperatures.append(tommorowMinMaxTemp)
        minMaxTemperatures.append(twoDaysLaterMinMaxTemp)
        
        for i in 0..<2 {
            self.tommorowAndTwoDaysLaterInformations.append(
                .init(
                    weatherImage: skyStateImageStrings[i],
                    rainfallPercent: precipitationPercentes[i],
                    minTemperature: minMaxTemperatures[i].0,
                    maxTemperature: minMaxTemperatures[i].1
                )
            )
        }
        
        func minMaxItem(by filteredItems: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>]) -> (String, String) {
            var minMaxResult: (Int, Int) = (0, 0)
            
            for (index, item) in filteredItems.enumerated() {
                if index == 0 {
                    minMaxResult = (item.fcstValue.toInt, item.fcstValue.toInt)
                    
                } else {
                    if item.fcstValue.toInt > minMaxResult.1 {
                        minMaxResult.1 = item.fcstValue.toInt
                    } else if item.fcstValue.toInt < minMaxResult.0 {
                        minMaxResult.0 = item.fcstValue.toInt
                    }
                }
            }
            
            return (minMaxResult.0.toString, minMaxResult.1.toString)
        }
    }
    
    /**
     Set `setMinMaxTemperaturesByThreeToTenDay`(3일 ~ 10일 까지의 최소, 최고 온도 데이터)
     - parameter item: requestMidTermForecastTempItems() 결과 데이터
     */
    func setMinMaxTemperaturesByThreeToTenDay(by item: MidTermForecastTemperatureBase) {
        self.minMaxTemperaturesByThreeToTenDay.append((item.taMin3.toString, item.taMax3.toString))
        self.minMaxTemperaturesByThreeToTenDay.append((item.taMin4.toString, item.taMax4.toString))
        self.minMaxTemperaturesByThreeToTenDay.append((item.taMin5.toString, item.taMax5.toString))
        self.minMaxTemperaturesByThreeToTenDay.append((item.taMin6.toString, item.taMax6.toString))
        self.minMaxTemperaturesByThreeToTenDay.append((item.taMin7.toString, item.taMax7.toString))
        self.minMaxTemperaturesByThreeToTenDay.append((item.taMin8.toString, item.taMax8.toString))
        self.minMaxTemperaturesByThreeToTenDay.append((item.taMin9.toString, item.taMax9.toString))
        self.minMaxTemperaturesByThreeToTenDay.append((item.taMin10.toString, item.taMax10.toString))
    }
    
    /**
     Set `weatherImageAndRainfallPercentsByThreeToTenDay`(3일 ~ 10일 까지의 하늘정보 image, 강수확률 데이터)
     - parameter item: requestMidTermForecastSkyStateItems() 결과 데이터
     */
    func setWeatherImageAndRainfallPercentsByThreeToTenDay(by item: MidTermForecastSkyStateBase) {
        self.weatherImageAndRainfallPercentsByThreeToTenDay.append(weatherImageAndRainfallPercent(wf: item.wf3Am, rnSt: item.rnSt3Am))
        self.weatherImageAndRainfallPercentsByThreeToTenDay.append(weatherImageAndRainfallPercent(wf: item.wf4Am, rnSt: item.rnSt4Am))
        self.weatherImageAndRainfallPercentsByThreeToTenDay.append(weatherImageAndRainfallPercent(wf: item.wf5Am, rnSt: item.rnSt5Am))
        self.weatherImageAndRainfallPercentsByThreeToTenDay.append(weatherImageAndRainfallPercent(wf: item.wf6Am, rnSt: item.rnSt6Am))
        self.weatherImageAndRainfallPercentsByThreeToTenDay.append(weatherImageAndRainfallPercent(wf: item.wf7Am, rnSt: item.rnSt7Am))
        self.weatherImageAndRainfallPercentsByThreeToTenDay.append(weatherImageAndRainfallPercent(wf: item.wf8, rnSt: item.rnSt8))
        self.weatherImageAndRainfallPercentsByThreeToTenDay.append(weatherImageAndRainfallPercent(wf: item.wf9, rnSt: item.rnSt9))
        self.weatherImageAndRainfallPercentsByThreeToTenDay.append(weatherImageAndRainfallPercent(wf: item.wf10, rnSt: item.rnSt10))
        
        func weatherImageAndRainfallPercent(wf: String, rnSt: Int) -> (String, String){
            let wfToImageString = midTermForecastUtil.remakeSkyStateValueToImageString(value: wf)
            return (wfToImageString, rnSt.toString)
        }
    }
    
    func setWeeklyWeatherInformations() {
        if tommorowAndTwoDaysLaterInformations.count == 2 && minMaxTemperaturesByThreeToTenDay.count == 8 && weatherImageAndRainfallPercentsByThreeToTenDay.count == 8 {
            
            var threeToTenDayInformations: [Weather.WeeklyWeatherInformation] = []
            for i in 0..<8 {
                let threeToTenDayInformation: Weather.WeeklyWeatherInformation = .init(
                    weatherImage: weatherImageAndRainfallPercentsByThreeToTenDay[i].0,
                    rainfallPercent: weatherImageAndRainfallPercentsByThreeToTenDay[i].1,
                    minTemperature: minMaxTemperaturesByThreeToTenDay[i].0,
                    maxTemperature: minMaxTemperaturesByThreeToTenDay[i].1)
                
                threeToTenDayInformations.append(threeToTenDayInformation)
            }
            weeklyWeatherInformations.append(contentsOf: tommorowAndTwoDaysLaterInformations)
            weeklyWeatherInformations.append(contentsOf: threeToTenDayInformations)
            CommonUtil.shared.printSuccess(funcTitle: "setWeeklyWeatherInformations()", values: weeklyWeatherInformations)
            
        } else {
            CommonUtil.shared.printError(
                funcTitle: "setWeeklyWeatherInformations()",
                description: """
                주간 예보 날씨 정보 Set 실패
                tommorowAndTwoDaysLaterInformations,
                minMaxTemperaturesByThreeToTenDay,
                weatherImageAndRainfallPercentsByThreeToTenDay
                의 값이 제대로 들어있는지 확인하세요.
                """,
                values: [
                    tommorowAndTwoDaysLaterInformations.count,
                    minMaxTemperaturesByThreeToTenDay.count,
                    weatherImageAndRainfallPercentsByThreeToTenDay.count
                ]
            )
        }
    }
}
