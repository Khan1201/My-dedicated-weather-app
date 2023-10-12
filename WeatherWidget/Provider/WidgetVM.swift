//
//  WidgetVM.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 10/12/23.
//

import Foundation
import Alamofire

struct WidgetVM {
    
    func performWidgetData() async -> SimpleEntry {
        var result: SimpleEntry = Dummy.simpleEntry()
        let veryShortForecastItems = await requestVeryShortItems()
        let shortForecastItems = await requestShortForecastItems()
        let sunriseAndSunset = await requestSunriseSunset()
        let realTimefindDustItems = await requestRealTimeFindDustAndUltraFindDustItems()
        let midForecastTemperatureItems = await requestMidTermForecastTempItems()
        let midForecastSkyStateItems = await requestMidTermForecastSkyStateItems()
        
        applyVeryShortForecastData(veryShortForecastItems, to: &result, sunrise: sunriseAndSunset.0, sunset: sunriseAndSunset.1)
        applyShortForecastData(shortForecastItems, to: &result, sunrise: sunriseAndSunset.0, sunset: sunriseAndSunset.1)
        applyRealTimeFindDustAndUltraFindDustItems(realTimefindDustItems, to: &result)
        applyMidtermForecastTemperatureSkyStateItems(midForecastTemperatureItems, midForecastSkyStateItems, to: &result)
        
        return result
    }
}

// MARK: - Reqeust funcs..

extension WidgetVM {
    
    /// Return 초단기예보 items
    func requestVeryShortItems() async -> [VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>] {
        let veryShortTermForecastUtil = VeryShortTermForecastUtil()
        let baseTime = veryShortTermForecastUtil.requestBaseTime()
        let baseDate = veryShortTermForecastUtil.requestBaseDate(baseTime: baseTime)
        let x = UserDefaults.shared.string(forKey: "x") ?? ""
        let y = UserDefaults.shared.string(forKey: "y") ?? ""
        
        let parameters: VeryShortOrShortTermForecastReq = VeryShortOrShortTermForecastReq(
            serviceKey: Env.shared.openDataApiResponseKey,
            numOfRows: "300",
            baseDate: baseDate,
            baseTime: baseTime,
            nx: x,
            ny: y
        )
        
        let dataTask = AF.request(
            Route.GET_WEATHER_VERY_SHORT_TERM_FORECAST.val,
            method: .get,
            parameters: parameters
        )
            .serializingDecodable(OpenDataRes<VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>>.self)
        
        let result = await dataTask.result
        
        switch result {
            
        case .success(let result):
            Util.printSuccess(
                funcTitle: "requestVeryShortItems()",
                value: "\(result.item?.count ?? 0)개의 초단기 예보 데이터 get"
            )
            return result.item ?? []
            
        case .failure(_):
            Util.printError(
                funcTitle: "requestVeryShortItems()",
                description: "초단기예보 request 실패"
            )
            return []
        }
    }
    
    /// Return 단기예보 items
    func requestShortForecastItems() async -> [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>] {
        
        let shortTermForecastUtil: ShortTermForecastUtil = ShortTermForecastUtil()
        let baseDate = shortTermForecastUtil.requestBaseDate()
        let baseTime = shortTermForecastUtil.requestBaseTime()
        let x = UserDefaults.shared.string(forKey: "x") ?? ""
        let y = UserDefaults.shared.string(forKey: "y") ?? ""
        
        let parameters = VeryShortOrShortTermForecastReq(
            serviceKey: Env.shared.openDataApiResponseKey,
            numOfRows: "737",
            baseDate: baseDate,
            baseTime: baseTime,
            nx: x,
            ny: y
        )
        
        let dataTask = AF.request(
            Route.GET_WEATHER_SHORT_TERM_FORECAST.val,
            method: .get,
            parameters: parameters
        ).serializingDecodable(OpenDataRes<VeryShortOrShortTermForecastBase<ShortTermForecastCategory>>.self)
        
        let result = await dataTask.result
        
        switch result {
            
        case .success(let result):
            Util.printSuccess(
                funcTitle: "requestShortItems()",
                value: "\(result.item?.count ?? 0)개의 단기 예보 데이터 get"
            )
            return result.item ?? []
            
        case .failure(_):
            Util.printError(
                funcTitle: "requestShortForecastItems()",
                description: "단기예보 request 실패"
            )
            return []
        }
    }
    
    /// Return (일출시간, 일몰시간)
    func requestSunriseSunset() async -> (String, String) {
        let latitude = UserDefaults.shared.string(forKey: "latitude") ?? ""
        let longitude = UserDefaults.shared.string(forKey: "longitude") ?? ""
        
        do {
            let parser = try await SunriseAndSunsetGetService(
                queryItem: .init(
                    serviceKey: Env.shared.openDataApiResponseKey,
                    locdate: Date().toString(format: "yyyyMMdd"),
                    longitude: longitude,
                    latitude: latitude
                )
            )
            
            Util.printSuccess(
                funcTitle: "requestSunriseSunset()",
                value: """
                일출시간: \(parser.result.sunrise)
                일몰시간: \(parser.result.sunset)
                """
            )
            
            return (parser.result.sunrise, parser.result.sunset)
            
        } catch {
            Util.printError(
                funcTitle: "requestSunriseSunset()",
                description: "일출 일물 시간 request 실패"
            )
            
            return ("", "")
        }
    }
    
    /// Return 미세먼지 및 초미세먼지 items
    func requestRealTimeFindDustAndUltraFindDustItems() async -> [RealTimeFindDustForecastBase] {
        
        let stationName: String = UserDefaults.shared.string(forKey: "dustStationName") ?? ""
        
        let parameters: RealTimeFindDustForecastReq = RealTimeFindDustForecastReq(
            serviceKey: Env.shared.openDataApiResponseKey,
            stationName: stationName
        )
        
        let dataTask = AF.request(
            Route.GET_REAL_TIME_FIND_DUST_FORECAST.val,
            method: .get,
            parameters: parameters
        ).serializingDecodable(OpenDataRes<RealTimeFindDustForecastBase>.self)
        
        let result = await dataTask.result
        
        switch result {
            
        case .success(let result):
            Util.printSuccess(
                funcTitle: "requestRealTimeFindDustAndUltraFindDustItems()",
                value: "\(result.items?.count ?? 0)개의 미세먼지, 초 미세먼지 데이터 get"
            )
            return result.items ?? []
            
        case .failure(_):
            Util.printError(
                funcTitle: "requestRealTimeFindDustAndUltraFindDustItems()",
                description: "미세먼지 request 실패"
            )
            return []
        }
    }
    
    /// Return 중기예보(3~ 10일)의 temperature items
    func requestMidTermForecastTempItems() async -> [MidTermForecastTemperatureBase] {
        
        let locality: String = UserDefaults.shared.string(forKey: "locality") ?? ""
        let subLocality: String = UserDefaults.shared.string(forKey: "subLocality") ?? ""
        
        let parameters: MidTermForecastReq = MidTermForecastReq(
            serviceKey: Env.shared.openDataApiResponseKey,
            regId: Util.midtermReqRegOrStnId(
                locality: locality,
                reqType: .temperature,
                subLocality: subLocality
            ),
            stnId: nil,
            tmFc: Util.midtermReqTmFc()
        )
        
        let dataTask = AF.request(
            Route.GET_WEATHER_MID_TERM_FORECAST_TEMP.val,
            method: .get,
            parameters: parameters
        ).serializingDecodable(OpenDataRes<MidTermForecastTemperatureBase>.self)
        
        let result = await dataTask.result
        
        switch result {
            
        case .success(let result):
            Util.printSuccess(
                funcTitle: "requestMidTermForecastTempItems()",
                value: "\(result.item?.count ?? 0)개의 중기예보의 temperature 데이터 get"
            )
            return result.item ?? []
            
        case .failure(_):
            Util.printError(
                funcTitle: "requestMidTermForecastTempItems()",
                description: "중기예보 온도 request 실패"
            )
            return []
        }
    }
    
    /// Return 중기예보(3~ 10일)의 하늘상태 items
    func requestMidTermForecastSkyStateItems() async -> [MidTermForecastSkyStateBase] {
        
        let locality: String = UserDefaults.shared.string(forKey: "locality") ?? ""
        let parameters: MidTermForecastReq = MidTermForecastReq(
            serviceKey: Env.shared.openDataApiResponseKey,
            regId: Util.midtermReqRegOrStnId(
                locality: locality,
                reqType: .skystate
            ),
            stnId: nil,
            tmFc: Util.midtermReqTmFc()
        )
        
        let dataTask = AF.request(
            Route.GET_WEATHER_MID_TERM_FORECAST_SKYSTATE.val,
            method: .get,
            parameters: parameters
        ).serializingDecodable(OpenDataRes<MidTermForecastSkyStateBase>.self)
        
        let result = await dataTask.result
        
        switch result {
            
        case .success(let result):
            Util.printSuccess(
                funcTitle: "rrequestMidTermForecastSkyStateItems()",
                value: "\(result.item?.count ?? 0)개의 중기예보의 skyState 데이터 get"
            )
            return result.item ?? []
            
        case .failure(_):
            Util.printError(
                funcTitle: "requestMidTermForecastSkyStateItems()",
                description: "중기예보 하늘상태 request 실패"
            )
            return []
        }
    }
}

// MARK: - Apply funcs..

extension WidgetVM {
    
    func applyVeryShortForecastData(
        _ items: [VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>],
        to result: inout SimpleEntry,
        sunrise: String,
        sunset: String
    ) {
        
        if items.count > 55 {
            let currentTemperature = items[24].fcstValue
            let currentWindSpeed = items[54].fcstValue
            let currentWetPercent = items[30].fcstValue
            let currentOneHourPrecipitation = items[12].fcstValue
            
            let targetTime = items[6].fcstTime // 날씨 이미지 day or night 인지 구분위한 target time
            let rainState = items[6].fcstValue
            let skyState = items[18].fcstValue
            
            result.smallFamilyData.currentWeatherItem.currentTemperature = currentTemperature
            result.smallFamilyData.currentWeatherItem.wind = Util.remakeWindSpeedValueForToString(value: currentWindSpeed).0
            result.smallFamilyData.currentWeatherItem.wetPercent = currentWetPercent
            result.smallFamilyData.currentWeatherItem.precipitation = Util.remakePrecipitationValueForToString(value: currentOneHourPrecipitation).0
            result.smallFamilyData.currentWeatherItem.weatherImage =
            Util.remakeRainStateAndSkyStateForWeatherImage(rainState: rainState, skyState: skyState, hhMM: targetTime, sunrise: sunrise, sunset: sunset)
            result.isDayMode = Util.isDayMode(
                targetHHmm: Date().toString(format: "HHmm"),
                sunrise: sunrise,
                sunset: sunset
            )
            
            Util.printSuccess(
                funcTitle: "applyVeryShortForecastData",
                value: """
            현재 온도: \(result.smallFamilyData.currentWeatherItem.currentTemperature),
            현재 바람: \(result.smallFamilyData.currentWeatherItem.wind),
            현재 습도: \(result.smallFamilyData.currentWeatherItem.wetPercent),
            현재 강수량: \(result.smallFamilyData.currentWeatherItem.precipitation)
            현재 날씨 image: \(result.smallFamilyData.currentWeatherItem.weatherImage)
            현재 dayMode: \(result.isDayMode)
            """
            )
            
        } else {
            Util.printError(
                funcTitle: "applyVeryShortForecastData",
                description: "초단기예보 데이터 세팅에 items의 55개의 데이터가 필요합니다. items의 개수가 55개를 넘지 못하므로, index 접근 불가"
            )
            return
        }
    }
    
    func applyShortForecastData(
        _ items: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>],
        to result: inout SimpleEntry,
        sunrise: String,
        sunset: String
    ) {
        func setMinMaxTemperature(i: Int) {
            if i == 0 {
                minTemperature = items[tempIndex].fcstValue.toInt
                maxTemperature = items[tempIndex].fcstValue.toInt
            }
            
            if items[tempIndex].fcstValue.toInt < minTemperature {
                minTemperature = items[tempIndex].fcstValue.toInt
                
            } else if items[tempIndex].fcstValue.toInt > maxTemperature {
                maxTemperature = items[tempIndex].fcstValue.toInt
            }
        }
        
        var tempIndex = 0
        var skyIndex = 5
        var ptyIndex = 6
        var popIndex = 7
        
        var step = 12
        let loopCount = 24
        
        var tempResult: [MediumFamilyData.TodayWeatherItem] = []
        var minTemperature: Int = 0
        var maxTemperature: Int = 0
        
        if items.count >= step * loopCount {
            
            // 각 index 해당하는 값(시간에 해당하는 값) append
            for i in 0..<loopCount {
                
                // 1시간 별 데이터 중 TMX(최고온도), TMN(최저온도) 가 있는지
                // 존재하면 1시간 별 데이터 기존 12개 -> 13이 됨
                let isExistTmxOrTmn = items[tempIndex + 12].category == .TMX ||
                items[tempIndex + 12].category == .TMN
                
                step = isExistTmxOrTmn ? 13 : 12
                setMinMaxTemperature(i: i)
                
                if i <= 5 {
                    let time = Util.convertAMOrPMFromHHmm(items[tempIndex].fcstTime)
                    
                    let weatherImage = Util.remakeRainStateAndSkyStateForWeatherImage(
                        rainState: items[ptyIndex].fcstValue,
                        skyState: items[skyIndex].fcstValue,
                        hhMM: items[ptyIndex].fcstTime, // // 날씨 이미지 day or night 인지 구분위한 target time
                        sunrise: sunrise,
                        sunset: sunset
                    )
                    let precipitation = items[popIndex].fcstValue
                    let temperature = items[tempIndex].fcstValue
                    
                    tempResult.append(
                        .init(
                            time: time,
                            image: weatherImage,
                            precipitation: precipitation,
                            temperature: temperature
                        )
                    )
                    
                    skyIndex += step
                    ptyIndex += step
                    popIndex += step
                }
                
                tempIndex += step
            }
            
            result.smallFamilyData.currentWeatherItem.minMaxTemperature = (
                String(minTemperature), String(maxTemperature)
            )
            result.mediumFamilyData.todayWeatherItems = tempResult
            
            result.largeFamilyData.weeklyWeatherItems = weeklyWeatherItemsByOneToTwoDays(items)
            
            Util.printSuccess(
                funcTitle: "applyShortForecastData",
                value: """
            최저온도: \(minTemperature),
            최대온도: \(maxTemperature),
            todayWeatherItems:
            \(result.mediumFamilyData.todayWeatherItems)
            set 완료
            """
            )
            
        } else {
            Util.printError(
                funcTitle: "applyShortForecastData()",
                description: "현재 날씨에서 +1 ~ 24시간까지의 데이터가 존재하지 않습니다."
            )
        }
    }
    
    func applyRealTimeFindDustAndUltraFindDustItems(
        _ items: [RealTimeFindDustForecastBase],
        to result: inout SimpleEntry
    ) {
        guard let item = items.first else {
            Util.printError(
                funcTitle: "applyRealTimeFindDustAndUltraFindDustItems()",
                description: "items가 존재하지 않습니다."
            )
            return
            
        }
        let findDust: String = Util.remakeFindDustValue(value: item.pm10Value)
        let ultraFindDust: String = Util.remakeUltraFindDustValue(value: item.pm25Value)
        result.smallFamilyData.currentWeatherItem.findDust = (findDust, ultraFindDust)
        
        Util.printSuccess(
            funcTitle: "applyRealTimeFindDustAndUltraFindDustItems()",
            value: """
        미세먼지: \(findDust),
        초미세먼지: \(ultraFindDust),
        """
        )
    }
    
    func applyMidtermForecastTemperatureSkyStateItems(
        _ temperatureItems: [MidTermForecastTemperatureBase],
        _ skyStateItems: [MidTermForecastSkyStateBase],
        to result: inout SimpleEntry
    ) {
        result.largeFamilyData.weeklyWeatherItems.append(
            contentsOf: weeklyWeatherItemsByThreeToFiveDays(
                temperatureItems, skyStateItems
            )
        )
    }
}

// MARK: - Return funcs..

extension WidgetVM {
    
    /// Return +3 ~ 5일의 weekly weather items
    func weeklyWeatherItemsByThreeToFiveDays(
        _ temperatureItems: [MidTermForecastTemperatureBase],
        _ skyStateItems: [MidTermForecastSkyStateBase]) -> [LargeFamilyData.WeeklyWeatherItem] {
            
            let minMaxTemperatureItems: [(String, String)] = midtermForcastMinMaxTemperatureItems(temperatureItems)
            let weatherImageItems: [String] = midtermForecastWeatherImageItems(skyStateItems)
            let rainPercentItems: [String] = midtermForecastRainPercentItems(skyStateItems)
            var result: [LargeFamilyData.WeeklyWeatherItem] = []
            let currentDate: Date = Date()
            
            guard minMaxTemperatureItems.count >= 3 && weatherImageItems.count >= 3 && rainPercentItems.count >= 3 else {
                
                Util.printError(
                    funcTitle: "weeklyWeatherItemsByThreeToFiveDays()",
                    description: "+3 ~ 5일에 해당되는 temperature or weather image or rainpercent items가 충분하지 않습니다."
                )
                
                return []
            }
            
            for i in 0..<minMaxTemperatureItems.count {
                result.append(
                    .init(
                        weekDay: currentDate.toString(byAdding: i + 3, format: "EE요일"),
                        dateString: currentDate.toString(byAdding: i + 3, format: "MM/dd"),
                        image: weatherImageItems[i],
                        rainPercent: rainPercentItems[i],
                        minMaxTemperature: minMaxTemperatureItems[i]
                    )
                )
            }
            
            return result
            
        }
    
    /// Return +3 ~ 5일의 min max temperatures
    func midtermForcastMinMaxTemperatureItems(
        _ items: [MidTermForecastTemperatureBase]
    ) -> [(String, String)] {
        guard let item = items.first else {
            Util.printError(
                funcTitle: "midtermForcastMinMaxTemperatureItems()",
                description: "items array의 first가 존재하지 않습니다."
            )
            return []
        }
        
        var tempResult: [(String, String)] = []
        tempResult.append((item.taMin3.toString, item.taMax3.toString))
        tempResult.append((item.taMin4.toString, item.taMax4.toString))
        tempResult.append((item.taMin5.toString, item.taMax5.toString))
        
        return tempResult
    }
    
    /// Return +3 ~ 5일의 weather image items
    func midtermForecastWeatherImageItems(
        _ items: [MidTermForecastSkyStateBase]
    ) -> [String] {
        guard let item = items.first else {
            Util.printError(
                funcTitle: "midtermForecastWeatherImageItems()",
                description: "items array의 first가 존재하지 않습니다."
            )
            return []
        }
        var tempResult: [String] = []
        tempResult.append(Util.remakeMidforecastSkyStateForWeatherImage(value: item.wf3Am))
        tempResult.append(Util.remakeMidforecastSkyStateForWeatherImage(value: item.wf4Am))
        tempResult.append(Util.remakeMidforecastSkyStateForWeatherImage(value: item.wf5Am))
        
        return tempResult
    }
    
    /// Return +3 ~ 5일의 rain percent items
    func midtermForecastRainPercentItems(
        _ items: [MidTermForecastSkyStateBase]
    ) -> [String] {
        guard let item = items.first else {
            Util.printError(
                funcTitle: "midtermForecastRainPercentItems()",
                description: "items array의 first가 존재하지 않습니다."
            )
            return []
        }
        var tempResult: [String] = []
        tempResult.append(item.rnSt3Am.toString)
        tempResult.append(item.rnSt4Am.toString)
        tempResult.append(item.rnSt5Am.toString)
        
        return tempResult
    }
    
    /// Return +1 ~ 2일의 weekly weather items
    func weeklyWeatherItemsByOneToTwoDays(
        _ items: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>]) -> [LargeFamilyData.WeeklyWeatherItem] {
            
            let minMaxTemperatureItems: [(String, String)] = shortTermForecastMinMaxTemperatureItems(items)
            let weatherImageItems: [String] = shortTermForecastWeatherImageItems(items)
            let rainPercentItems: [String] = shortTermForecastRainPearcentItems(items)
            var result: [LargeFamilyData.WeeklyWeatherItem] = []
            let currentDate: Date = Date()
            
            guard minMaxTemperatureItems.count >= 2 && weatherImageItems.count >= 2 && rainPercentItems.count >= 2 else {
                
                Util.printError(
                    funcTitle: "weeklyWeatherItemsByOneToTwoDays()",
                    description: "+1 ~ 2일에 해당되는 temperature or weather image or rainpercent items가 충분하지 않습니다.",
                    value: """
                    temperatureItems: \(minMaxTemperatureItems)
                    weatherImageItems: \(weatherImageItems)
                    rainpercentItems: \(rainPercentItems)
                    """
                )
                
                return []
            }
            
            for i in 0..<minMaxTemperatureItems.count {
                result.append(
                    .init(
                        weekDay: currentDate.toString(byAdding: i + 1, format: "EE요일"),
                        dateString: currentDate.toString(byAdding: i + 1, format: "MM/dd"),
                        image: weatherImageItems[i],
                        rainPercent: rainPercentItems[i],
                        minMaxTemperature: minMaxTemperatureItems[i]
                    )
                )
            }
            
            return result
        }
    
    /// Return +1 ~ 2일의 min max temperatures
    func shortTermForecastMinMaxTemperatureItems(
        _ items: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>]
    ) -> [(String, String)]
    {
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
        
        let tommorrowDate: String = Date().toString(byAdding: 1, format: "yyyyMMdd")
        let twoDaysLaterDate: String = Date().toString(byAdding: 2, format: "yyyyMMdd")
        var result: [(String, String)] = []
        
        let tommorowTempFilteredItems = items.filter { item in
            item.category == .TMP && item.fcstDate == tommorrowDate
        }
        
        let twoDaysLaterTempFilteredItems = items.filter { item in
            item.category == .TMP && item.fcstDate == twoDaysLaterDate
        }
        
        let tommorowMinMaxTemp: (String, String) = minMaxItem(by: tommorowTempFilteredItems)
        let twoDaysLaterMinMaxTemp: (String, String) = minMaxItem(by: twoDaysLaterTempFilteredItems)
        
        result.append(tommorowMinMaxTemp)
        result.append(twoDaysLaterMinMaxTemp)
        
        return result
    }
    
    /// Return +1 ~ 2일의 weather image items
    func shortTermForecastWeatherImageItems(
        _ items: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>]
    ) -> [String] {
        let tommorrowDate: String = Date().toString(byAdding: 1, format: "yyyyMMdd")
        let twoDaysLaterDate: String = Date().toString(byAdding: 2, format: "yyyyMMdd")
        var result: [String] = []
        
        let skyStateFilteredItems = items.filter { item in
            item.category == .SKY && (item.fcstDate == tommorrowDate || item.fcstDate == twoDaysLaterDate) && item.fcstTime == "1200"
        }
        
        for i in 0..<skyStateFilteredItems.count {
            result.append(
                Util
                    .remakeSkyStateForWeatherImage(skyStateFilteredItems[i].fcstValue, hhMM: "1200", sunrise: "0600", sunset: "2000")
            )
        }
        
        return result
    }
    
    /// Return +1 ~ 2일의 rain percent items
    func shortTermForecastRainPearcentItems(
        _ items: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>]
    ) -> [String] {
        let tommorrowDate: String = Date().toString(byAdding: 1, format: "yyyyMMdd")
        let twoDaysLaterDate: String = Date().toString(byAdding: 2, format: "yyyyMMdd")
        var result: [String] = []
        
        let percentFilteredItems = items.filter { item in
            item.category == .POP && (item.fcstDate == tommorrowDate || item.fcstDate == twoDaysLaterDate) && item.fcstTime == "1200"
        }
        
        for i in 0..<percentFilteredItems.count {
            result.append(percentFilteredItems[i].fcstValue)
        }
        
        return result
    }
}
