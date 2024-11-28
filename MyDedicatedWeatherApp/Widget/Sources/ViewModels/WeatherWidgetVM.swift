//
//  WeatherWidgetVM.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 10/12/23.
//

import Foundation
import Data
import Domain
import Core

struct WeatherWidgetVM {
    
    private let veryShortForecastService: VeryShortForecastRequestable
    private let shortForecastService: ShortForecastRequestable
    private let midTermForecastService: MidtermForecastRequestable
    private let dustForecastService: DustForecastRequestable
    
    private let serviceKey: String = Bundle.main.object(forInfoDictionaryKey: "public_api_key") as? String ?? ""
    private let commonForecastUtil: CommonForecastUtil = .init()
    private let findDustLookUpUtil: FineDustLookUpUtil = .init()
    private let shortForecastUtil: ShortTermForecastUtil = .init()
    private let midTermForecastUtil: MidTermForecastUtil = .init()
    private let commonUtil: CommonUtil = .shared
    
    init(
        veryShortForecastService: VeryShortForecastRequestable = VeryShortForecastService(),
        shortForecastService: ShortForecastRequestable = ShortForecastService(),
        midTermForecastService: MidtermForecastRequestable = MidTermForecastService(),
        dustForecastService: DustForecastRequestable = DustForecastService()
    ) {
        self.veryShortForecastService = veryShortForecastService
        self.shortForecastService = shortForecastService
        self.midTermForecastService = midTermForecastService
        self.dustForecastService = dustForecastService
    }
    
        
    var sunriseAndSunsetHHmm: (String, String) {
        
        let currentDate: Date = Date()
        let latitude = UserDefaults.shared.string(forKey: UserDefaultsKeys.latitude) ?? ""
        let longitude = UserDefaults.shared.string(forKey: UserDefaultsKeys.longitude) ?? ""
                
        guard let sunriseDate = currentDate.sunrise(.init(latitude: Double(latitude) ?? 0, longitude: Double(longitude) ?? 0)) else { return ("", "") }
        guard let sunsetDate = currentDate.sunset(.init(latitude: Double(latitude) ?? 0, longitude: Double(longitude) ?? 0)) else { return ("", "") }
        
        let sunriseHHmm = sunriseDate.toString(format: "HHmm", timeZone: TimeZone(identifier: "UTC"))
        let sunsetHHmm = sunsetDate.toString(format: "HHmm", timeZone: TimeZone(identifier: "UTC"))
        
        return (sunriseHHmm, sunsetHHmm)
    }
    
    func performSmallOrMediumWidgetEntrySetting() async -> SimpleEntry {
        var result: SimpleEntry = Dummy.simpleEntry()
        
        let veryShortForecastItems = await requestVeryShortItems()
        
        let shortForecastItems = Task {
            let result = await requestShortForecastItems()
            return result
        }
        
        let shortForecastItemsForMinMaxTemperature = Task {
            let result = await requestTodayMinMaxTemp()
            return result
        }
        
        let realTimefindDustItems = Task {
            let result = await requestRealTimeFindDustAndUltraFindDustItems()
            return result
        }
        
        applyVeryShortForecastData(
            veryShortForecastItems,
            to: &result,
            sunrise: sunriseAndSunsetHHmm.0,
            sunset: sunriseAndSunsetHHmm.1
        )
        
        await applyShortForecastData(
            shortForecastItems.value,
            itemsForMinMaxTemperature: shortForecastItemsForMinMaxTemperature.value,
            currentTemperature: veryShortForecastItems[24].fcstValue,
            to: &result,
            sunrise: sunriseAndSunsetHHmm.0,
            sunset: sunriseAndSunsetHHmm.1
        )
        
        await applyRealTimeFindDustAndUltraFindDustItems(realTimefindDustItems.value, to: &result)
        
//        testCrashOccurrence(result: &result)
        
        return result
    }
    
    func performLargeWidgetEntrySetting() async -> SimpleEntry {
        var result: SimpleEntry = Dummy.simpleEntry()

        let veryShortForecastItems = await requestVeryShortItems()
        
        let shortForecastItems = Task {
            let result = await requestShortForecastItems()
            return result
        }
        
        let shortForecastItemsForMinMaxTemperature = Task {
            let result = await requestTodayMinMaxTemp()
            return result
        }
        
        let realTimefindDustItems = Task {
            let result = await requestRealTimeFindDustAndUltraFindDustItems()
            return result
        }
        
        let midForecastTemperatureItems = Task {
            let result = await requestMidTermForecastTempItems()
            return result
        }
        
        let midForecastSkyStateItems = Task {
            let result = await requestMidTermForecastSkyStateItems()
            return result
        }
        
        applyVeryShortForecastData(
            veryShortForecastItems,
            to: &result,
            sunrise: sunriseAndSunsetHHmm.0,
            sunset: sunriseAndSunsetHHmm.1
        )
        
        await applyShortForecastData(
            shortForecastItems.value,
            itemsForMinMaxTemperature: shortForecastItemsForMinMaxTemperature.value,
            currentTemperature: veryShortForecastItems[24].fcstValue,
            to: &result,
            sunrise: sunriseAndSunsetHHmm.0,
            sunset: sunriseAndSunsetHHmm.1
        )
        
        await applyRealTimeFindDustAndUltraFindDustItems(realTimefindDustItems.value, to: &result)
        
        await applyMidtermForecastTemperatureSkyStateItems(midForecastTemperatureItems.value, midForecastSkyStateItems.value, to: &result)
        
//        testCrashOccurrence(result: &result)
        
        return result
    }
}

// MARK: - Reqeust funcs..

extension WeatherWidgetVM {
    
    /// Return 초단기예보 items
    func requestVeryShortItems() async -> [VeryShortOrShortTermForecast<VeryShortTermForecastCategory>] {
        let x = UserDefaults.shared.string(forKey: UserDefaultsKeys.x) ?? ""
        let y = UserDefaults.shared.string(forKey: UserDefaultsKeys.y) ?? ""
        
        let result = await veryShortForecastService.requestVeryShortForecastItems(
            serviceKey: serviceKey,
            xy: .init(lat: 0, lng: 0, x: x.toInt, y: y.toInt)
        )
        
        switch result {
            
        case .success(let success):
            commonUtil.printSuccess(
                funcTitle: "requestVeryShortItems()",
                value: "\(success.item?.count ?? 0)개의 초단기 예보 데이터 get"
            )
            return success.item ?? []
            
        case .failure(_):
            commonUtil.printError(
                funcTitle: "requestVeryShortItems()",
                description: "초단기예보 request 실패"
            )
            return []
        }
    }
    
    /// Return 단기예보 items
    func requestShortForecastItems() async -> [VeryShortOrShortTermForecast<ShortTermForecastCategory>] {
        let x = UserDefaults.shared.string(forKey: UserDefaultsKeys.x) ?? ""
        let y = UserDefaults.shared.string(forKey: UserDefaultsKeys.y) ?? ""
        
        let result = await shortForecastService.requestShortForecastItems(
            serviceKey: serviceKey,
            xy: .init(lat: 0, lng: 0, x: x.toInt, y: y.toInt),
            reqRow: "737"
        )
                
        switch result {
            
        case .success(let result):
            commonUtil.printSuccess(
                funcTitle: "requestShortItems()",
                value: "\(result.item?.count ?? 0)개의 단기 예보 데이터 get"
            )
            return result.item ?? []
            
        case .failure(_):
            commonUtil.printError(
                funcTitle: "requestShortForecastItems()",
                description: "단기예보 request 실패"
            )
            return []
        }
    }
    
    /// '단기예보' 에서의 최소, 최대 온도 값 요청 위해 및
    /// 02:00 or 23:00 으로 호출해야 하므로, 따로 다시 요청한다.
    func requestTodayMinMaxTemp() async -> [VeryShortOrShortTermForecast<ShortTermForecastCategory>] {
        let x = UserDefaults.shared.string(forKey: UserDefaultsKeys.x) ?? ""
        let y = UserDefaults.shared.string(forKey: UserDefaultsKeys.y) ?? ""
        
        let result = await shortForecastService.requestTodayMinMaxTemp(
            serviceKey: serviceKey,
            xy: .init(lat: 0, lng: 0, x: x.toInt, y: y.toInt)
        )
        
        switch result {
            
        case .success(let result):
            commonUtil.printSuccess(
                funcTitle: "requestTodayMinMaxTemp()",
                value: "\(result.item?.count ?? 0)개의 단기예보(MinMax) 데이터 get"
            )
            return result.item ?? []
            
        case .failure(_):
            commonUtil.printError(
                funcTitle: "requestTodayMinMaxTemp()",
                description: "단기예보(MinMax) request 실패"
            )
            return []
        }
    }
    
    /// Return (일출시간, 일몰시간)
//    func requestSunriseSunset() async -> (String, String) {
//        let latitude = UserDefaults.shared.string(forKey: UserDefaultsKeys.latitude) ?? ""
//        let longitude = UserDefaults.shared.string(forKey: UserDefaultsKeys.longitude) ?? ""
//        
//        do {
//            let parser = try await SunriseAndSunsetGetService(
//                queryItem: .init(
//                    serviceKey: Env.shared.openDataApiResponseKey,
//                    locdate: Date().toString(format: "yyyyMMdd"),
//                    longitude: longitude,
//                    latitude: latitude
//                )
//            )
//            
//            commonUtil.printSuccess(
//                funcTitle: "requestSunriseSunset()",
//                value: """
//                일출시간: \(parser.result.sunrise)
//                일몰시간: \(parser.result.sunset)
//                """
//            )
//            
//            return (parser.result.sunrise, parser.result.sunset)
//            
//        } catch {
//            commonUtil.printError(
//                funcTitle: "requestSunriseSunset()",
//                description: "일출 일물 시간 request 실패"
//            )
//            
//            return ("", "")
//        }
//    }
    
    /// Return 미세먼지 및 초미세먼지 items
    func requestRealTimeFindDustAndUltraFindDustItems() async -> [RealTimeFindDustForecast] {
        let stationName: String = UserDefaults.shared.string(forKey: UserDefaultsKeys.dustStationName) ?? ""

        let result = await dustForecastService.requestRealTimeFindDustForecastItems(
            serviceKey: serviceKey,
            stationName: stationName
        )
        
        switch result {
            
        case .success(let result):
            commonUtil.printSuccess(
                funcTitle: "requestRealTimeFindDustAndUltraFindDustItems()",
                value: "\(result.items?.count ?? 0)개의 미세먼지, 초 미세먼지 데이터 get"
            )
            return result.items ?? []
            
        case .failure(_):
            commonUtil.printError(
                funcTitle: "requestRealTimeFindDustAndUltraFindDustItems()",
                description: "미세먼지 request 실패"
            )
            return []
        }
    }
    
    /// Return 중기예보(3~ 10일)의 temperature items
    func requestMidTermForecastTempItems() async -> [MidTermForecastTemperature] {
        let fullAddress: String = UserDefaults.shared.string(forKey: UserDefaultsKeys.fullAddress) ?? ""
        
        let result = await midTermForecastService.requestMidTermForecastTempItems(
            serviceKey: serviceKey,
            fullAddress: fullAddress
        )
        
        switch result {
            
        case .success(let result):
            commonUtil.printSuccess(
                funcTitle: "requestMidTermForecastTempItems()",
                value: "\(result.item?.count ?? 0)개의 중기예보의 temperature 데이터 get"
            )
            return result.item ?? []
            
        case .failure(_):
            commonUtil.printError(
                funcTitle: "requestMidTermForecastTempItems()",
                description: "중기예보 온도 request 실패"
            )
            return []
        }
    }
    
    /// Return 중기예보(3~ 10일)의 하늘상태 items
    func requestMidTermForecastSkyStateItems() async -> [MidTermForecastSkyState] {
        let fullAddress: String = UserDefaults.shared.string(forKey: UserDefaultsKeys.fullAddress) ?? ""
        
        let result = await midTermForecastService.requestMidTermForecastSkyStateItems(
            serviceKey: serviceKey,
            fullAddress: fullAddress
        )
        
        switch result {
            
        case .success(let result):
            commonUtil.printSuccess(
                funcTitle: "rrequestMidTermForecastSkyStateItems()",
                value: "\(result.item?.count ?? 0)개의 중기예보의 skyState 데이터 get"
            )
            return result.item ?? []
            
        case .failure(_):
            commonUtil.printError(
                funcTitle: "requestMidTermForecastSkyStateItems()",
                description: "중기예보 하늘상태 request 실패"
            )
            return []
        }
    }
}

// MARK: - Apply funcs..

extension WeatherWidgetVM {
    
    func applyVeryShortForecastData(
        _ items: [VeryShortOrShortTermForecast<VeryShortTermForecastCategory>],
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
            
            let sunTime: SunTime = .init(
                currentHHmm: targetTime,
                sunriseHHmm: sunrise,
                sunsetHHmm: sunset
            )
            
            result.smallFamilyData.currentWeatherItem.currentTemperature = currentTemperature
            result.smallFamilyData.currentWeatherItem.wind = commonForecastUtil.convertWindSpeed(rawValue: currentWindSpeed).toDescription
            result.smallFamilyData.currentWeatherItem.wetPercent = currentWetPercent
            result.smallFamilyData.currentWeatherItem.precipitation =
            commonForecastUtil.convertPrecipitation(rawValue: currentOneHourPrecipitation)
            result.smallFamilyData.currentWeatherItem.weatherImage =
            commonForecastUtil.skyTypeOfVeryShortOrShortForecast(
                ptyValue: rainState,
                skyValue: skyState
            ).image(isDayMode: sunTime.isDayMode)
            result.isDayMode = SunTime(
                currentHHmm: Date().toString(format: "HHmm"),
                sunriseHHmm: sunrise,
                sunsetHHmm: sunset
            ).isDayMode
            
            commonUtil.printSuccess(
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
            commonUtil.printError(
                funcTitle: "applyVeryShortForecastData",
                description: "초단기예보 데이터 세팅에 items의 55개의 데이터가 필요합니다. items의 개수가 55개를 넘지 못하므로, index 접근 불가"
            )
            return
        }
    }
    
    func applyShortForecastData(
        _ items: [VeryShortOrShortTermForecast<ShortTermForecastCategory>],
        itemsForMinMaxTemperature: [VeryShortOrShortTermForecast<ShortTermForecastCategory>],
        currentTemperature: String,
        to result: inout SimpleEntry,
        sunrise: String,
        sunset: String
    ) {
        func minMaxTemperature(_ items: [VeryShortOrShortTermForecast<ShortTermForecastCategory>]) -> (String, String) {
            let todayDate = Date().toString(format: "yyyyMMdd")
            
            let filteredItems = items.filter( {$0.category == .TMP && $0.fcstDate == todayDate} )
            var filteredTemps = filteredItems.map({ $0.fcstValue.toInt })
            filteredTemps.append(currentTemperature.toInt)
            
            let min = filteredTemps.min() ?? 0
            let max = filteredTemps.max() ?? 0
            
            return (min.toString, max.toString)
        }
        
        
        let skipValue = shortForecastUtil.todayWeatherIndexSkipValue

        var tempIndex = 0 + skipValue
        var skyIndex = 5 + skipValue
        var ptyIndex = 6 + skipValue
        var popIndex = 7 + skipValue
        
        var step = 12
        let loopCount = shortForecastUtil.todayWeatherLoopCount
        let sunTime: SunTime = .init(
            currentHHmm: items[ptyIndex].fcstTime,
            sunriseHHmm: sunrise,
            sunsetHHmm: sunset
        )

        var tempResult: [MediumFamilyData.TodayWeatherItem] = []
        
        if items.count >= step * loopCount {
            
            // 각 index 해당하는 값(시간에 해당하는 값) append
            for i in 0..<loopCount {
                
                // 1시간 별 데이터 중 TMX(최고온도), TMN(최저온도) 가 있는지
                // 존재하면 1시간 별 데이터 기존 12개 -> 13이 됨
                let isExistTmxOrTmn = items[tempIndex + 12].category == .TMX ||
                items[tempIndex + 12].category == .TMN
                
                step = isExistTmxOrTmn ? 13 : 12
                
                if i <= 5 {
                    let time = commonUtil.convertAMOrPMFromHHmm(items[tempIndex].fcstTime)
                    
                    let weatherImage = commonForecastUtil.skyTypeOfVeryShortOrShortForecast(
                        ptyValue: items[ptyIndex].fcstValue,
                        skyValue: items[skyIndex].fcstValue
                    ).image(isDayMode: sunTime.isDayMode)
                    
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
            
            let minMaxTemperature: (String, String) = minMaxTemperature(itemsForMinMaxTemperature)
            
            result.smallFamilyData.currentWeatherItem.minMaxTemperature = minMaxTemperature
            result.mediumFamilyData.todayWeatherItems = tempResult
            
            result.largeFamilyData.weeklyWeatherItems = weeklyWeatherItemsByOneToTwoDays(items)
            
            commonUtil.printSuccess(
                funcTitle: "applyShortForecastData",
                value: """
            최저온도: \(minMaxTemperature.0),
            최대온도: \(minMaxTemperature.1),
            todayWeatherItems:
            \(result.mediumFamilyData.todayWeatherItems)
            set 완료
            """
            )
            
        } else {
            
            commonUtil.printError(
                funcTitle: "applyShortForecastData()",
                description: "현재 날씨에서 +1 ~ 24시간까지의 데이터가 존재하지 않습니다."
            )
        }
    }
    
    func applyRealTimeFindDustAndUltraFindDustItems(
        _ items: [RealTimeFindDustForecast],
        to result: inout SimpleEntry
    ) {
        guard let item = items.first else {
            commonUtil.printError(
                funcTitle: "applyRealTimeFindDustAndUltraFindDustItems()",
                description: "items가 존재하지 않습니다."
            )
            return
            
        }
        
        let findDust: String = findDustLookUpUtil.remakeFindDustValue(value: item.pm10Value).description
        let ultraFindDust: String = findDustLookUpUtil.remakeUltraFindDustValue(value: item.pm25Value).description
        result.smallFamilyData.currentWeatherItem.findDust = (findDust, ultraFindDust)
        
        commonUtil.printSuccess(
            funcTitle: "applyRealTimeFindDustAndUltraFindDustItems()",
            value: """
        미세먼지: \(findDust),
        초미세먼지: \(ultraFindDust),
        """
        )
    }
    
    func applyMidtermForecastTemperatureSkyStateItems(
        _ temperatureItems: [MidTermForecastTemperature],
        _ skyStateItems: [MidTermForecastSkyState],
        to result: inout SimpleEntry
    ) {

        //
        guard let filteredTemperatureItem = temperatureItems.first else {
            commonUtil.printError(
                funcTitle: "applyMidtermForecastTemperatureSkyStateItems()",
                description: "temperatureItems array의 first가 존재하지 않습니다."
            )
            return
        }
        
        var temperatureResult: [(String, String)] = []
        temperatureResult.append((filteredTemperatureItem.taMin3.toString, filteredTemperatureItem.taMax3.toString))
        temperatureResult.append((filteredTemperatureItem.taMin4.toString, filteredTemperatureItem.taMax4.toString))
        temperatureResult.append((filteredTemperatureItem.taMin5.toString, filteredTemperatureItem.taMax5.toString))
        
        
        //
        guard let filteredSkyStateItem = skyStateItems.first else {
            commonUtil.printError(
                funcTitle: "applyMidtermForecastTemperatureSkyStateItems()",
                description: "skyStateItems array의 first가 존재하지 않습니다."
            )
            return
        }
        var skyStateResult: [String] = []
        
        skyStateResult.append(midTermForecastUtil.remakeSkyStateValueToImageString(value: filteredSkyStateItem.wf3Am))
        skyStateResult.append(midTermForecastUtil.remakeSkyStateValueToImageString(value: filteredSkyStateItem.wf4Am))
        skyStateResult.append(midTermForecastUtil.remakeSkyStateValueToImageString(value: filteredSkyStateItem.wf5Am))
        

        var rainPercentResult: [String] = []
        rainPercentResult.append(filteredSkyStateItem.rnSt3Am.toString)
        rainPercentResult.append(filteredSkyStateItem.rnSt4Am.toString)
        rainPercentResult.append(filteredSkyStateItem.rnSt5Am.toString)
        
        var weatherImageResult: [String] = []
        weatherImageResult.append(midTermForecastUtil.remakeSkyStateValueToImageString(value: filteredSkyStateItem.wf3Am))
        weatherImageResult.append(midTermForecastUtil.remakeSkyStateValueToImageString(value: filteredSkyStateItem.wf4Am))
        weatherImageResult.append(midTermForecastUtil.remakeSkyStateValueToImageString(value: filteredSkyStateItem.wf5Am))
                
        let currentDate: Date = Date()
        
        guard temperatureResult.count >= 3 && skyStateResult.count >= 3 && rainPercentResult.count >= 3 else {
            
            commonUtil.printError(
                funcTitle: "applyMidtermForecastTemperatureSkyStateItems()",
                description: "+3 ~ 5일에 해당되는 temperature or weather image or rainpercent items가 충분하지 않습니다."
            )
            
            return
        }
        
        for i in 0..<temperatureResult.count {
            result.largeFamilyData.weeklyWeatherItems.append(
                .init(
                    weekDay: currentDate.toString(byAdding: i + 3, format: "EE요일"),
                    dateString: currentDate.toString(byAdding: i + 3, format: "MM/dd"),
                    image: weatherImageResult[i],
                    rainPercent: rainPercentResult[i],
                    minMaxTemperature: temperatureResult[i]
                )
            )
        }
    }
}

// MARK: - Return funcs..

extension WeatherWidgetVM {
    
    /// Return +3 ~ 5일의 weekly weather items
    func weeklyWeatherItemsByThreeToFiveDays(
        _ temperatureItems: [MidTermForecastTemperature],
        _ skyStateItems: [MidTermForecastSkyState]) -> [LargeFamilyData.WeeklyWeatherItem] {
            
            var result: [LargeFamilyData.WeeklyWeatherItem] = []
            let currentDate: Date = Date()
            
            guard midtermForcastMinMaxTemperatureItems(temperatureItems).count >= 3 && midtermForecastWeatherImageItems(skyStateItems).count >= 3 && midtermForecastRainPercentItems(skyStateItems).count >= 3 else {
                
                commonUtil.printError(
                    funcTitle: "weeklyWeatherItemsByThreeToFiveDays()",
                    description: "+3 ~ 5일에 해당되는 temperature or weather image or rainpercent items가 충분하지 않습니다."
                )
                
                return []
            }
            
            for i in 0..<midtermForcastMinMaxTemperatureItems(temperatureItems).count {
                result.append(
                    .init(
                        weekDay: currentDate.toString(byAdding: i + 3, format: "EE요일"),
                        dateString: currentDate.toString(byAdding: i + 3, format: "MM/dd"),
                        image: midtermForecastWeatherImageItems(skyStateItems)[i],
                        rainPercent: midtermForecastRainPercentItems(skyStateItems)[i],
                        minMaxTemperature: midtermForcastMinMaxTemperatureItems(temperatureItems)[i]
                    )
                )
            }
            
            return result
            
        }
    
    /// Return +3 ~ 5일의 min max temperatures
    func midtermForcastMinMaxTemperatureItems(
        _ items: [MidTermForecastTemperature]
    ) -> [(String, String)] {
        guard let item = items.first else {
            commonUtil.printError(
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
        _ items: [MidTermForecastSkyState]
    ) -> [String] {
        guard let item = items.first else {
            commonUtil.printError(
                funcTitle: "midtermForecastWeatherImageItems()",
                description: "items array의 first가 존재하지 않습니다."
            )
            return []
        }
        var tempResult: [String] = []
                    
        tempResult.append(midTermForecastUtil.remakeSkyStateValueToImageString(value: item.wf3Am))
        tempResult.append(midTermForecastUtil.remakeSkyStateValueToImageString(value: item.wf4Am))
        tempResult.append(midTermForecastUtil.remakeSkyStateValueToImageString(value: item.wf5Am))
        
        return tempResult
    }
    
    /// Return +3 ~ 5일의 rain percent items
    func midtermForecastRainPercentItems(
        _ items: [MidTermForecastSkyState]
    ) -> [String] {
        guard let item = items.first else {
            commonUtil.printError(
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
        _ items: [VeryShortOrShortTermForecast<ShortTermForecastCategory>]) -> [LargeFamilyData.WeeklyWeatherItem] {
            
            let minMaxTemperatureItems: [(String, String)] = shortTermForecastMinMaxTemperatureItems(items)
            let weatherImageItems: [String] = shortTermForecastWeatherImageItems(items)
            let rainPercentItems: [String] = shortTermForecastRainPearcentItems(items)
            var result: [LargeFamilyData.WeeklyWeatherItem] = []
            let currentDate: Date = Date()
            
            guard minMaxTemperatureItems.count >= 2 && weatherImageItems.count >= 2 && rainPercentItems.count >= 2 else {
                
                commonUtil.printError(
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
        _ items: [VeryShortOrShortTermForecast<ShortTermForecastCategory>]
    ) -> [(String, String)]
    {
        func minMaxItem(by filteredItems: [VeryShortOrShortTermForecast<ShortTermForecastCategory>]) -> (String, String) {
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
        _ items: [VeryShortOrShortTermForecast<ShortTermForecastCategory>]
    ) -> [String] {
        let tommorrowDate: String = Date().toString(byAdding: 1, format: "yyyyMMdd")
        let twoDaysLaterDate: String = Date().toString(byAdding: 2, format: "yyyyMMdd")
        let sunTime: SunTime = .init(
            currentHHmm: "1200",
            sunriseHHmm: "0600",
            sunsetHHmm: "2000"
        )
        
        var result: [String] = []
        
        let skyStateFilteredItems = items.filter { item in
            item.category == .SKY && (item.fcstDate == tommorrowDate || item.fcstDate == twoDaysLaterDate) && item.fcstTime == "1200"
        }
        
        for i in 0..<skyStateFilteredItems.count {
            result.append(
                commonForecastUtil.skyStateOfVeryShortShortForecast(skyStateFilteredItems[i].fcstValue).image(isDayMode: sunTime.isDayMode)
            )
        }
        
        return result
    }
    
    /// Return +1 ~ 2일의 rain percent items
    func shortTermForecastRainPearcentItems(
        _ items: [VeryShortOrShortTermForecast<ShortTermForecastCategory>]
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

// MARK: - Test funcs..

extension WeatherWidgetVM {
    
    func testCrashOccurrence(result: inout SimpleEntry) {
        let weatherImage = "weather_sunny"
        
        result.smallFamilyData.currentWeatherItem.weatherImage = weatherImage

        let todayWeatherItem: [MediumFamilyData.TodayWeatherItem] = [
            .init(time: "3PM", image: weatherImage, precipitation: "30", temperature: "00"),
            .init(time: "3PM", image: weatherImage, precipitation: "30", temperature: "00"),
            .init(time: "3PM", image: weatherImage, precipitation: "30", temperature: "00"),
            .init(time: "3PM", image: weatherImage, precipitation: "30", temperature: "00"),
            .init(time: "3PM", image: weatherImage, precipitation: "30", temperature: "00"),
            .init(time: "3PM", image: weatherImage, precipitation: "30", temperature: "00")
        ]
        
        let weeklyWeatherItem: [LargeFamilyData.WeeklyWeatherItem] = [
            .init(weekDay: "금요일", dateString: "00/00", image: weatherImage, rainPercent: "30", minMaxTemperature: ("-00", "00")),
            .init(weekDay: "금요일", dateString: "00/00", image: weatherImage, rainPercent: "30", minMaxTemperature: ("-00", "00")),
            .init(weekDay: "금요일", dateString: "00/00", image: weatherImage, rainPercent: "30", minMaxTemperature: ("-00", "00")),
            .init(weekDay: "금요일", dateString: "00/00", image: weatherImage, rainPercent: "30", minMaxTemperature: ("-00", "00")),
            .init(weekDay: "금요일", dateString: "00/00", image: weatherImage, rainPercent: "30", minMaxTemperature: ("-00", "00"))
        ]
                
        result.mediumFamilyData.todayWeatherItems = todayWeatherItem
        result.largeFamilyData.weeklyWeatherItems = weeklyWeatherItem
    }
}
