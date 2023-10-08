//
//  Provider.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/31.
//

import WidgetKit
import Alamofire

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        Dummy.simpleEntry()
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        Task {
            let result = await performWidgetData()
            completion(result)
        }
        
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        
        Task {
            var entries: [SimpleEntry] = []
            let reloadDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
            
            let result = await performWidgetData()
            entries.append(result)
            
            let timeline = Timeline(entries: entries, policy: .after(reloadDate))
            completion(timeline)
        }
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
        
    }
    
    // MARK: - ETC Funcs..
    
    func performWidgetData() async -> SimpleEntry {
        var result: SimpleEntry = Dummy.simpleEntry()
        let veryShortForecastItems = await requestVeryShortItems()
        let shortForecastItems = await requestShortForecastItems()
        let sunriseAndSunset = await requestSunriseSunset()
        let realTimefindDustItems = await requestRealTimeFindDustAndUltraFindDustItems()
        
        applyVeryShortForecastData(veryShortForecastItems, to: &result, sunrise: sunriseAndSunset.0, sunset: sunriseAndSunset.1)
        applyShortForecastData(shortForecastItems, to: &result, sunrise: sunriseAndSunset.0, sunset: sunriseAndSunset.1)
        applyRealTimeFindDustAndUltraFindDustItems(realTimefindDustItems, to: &result)
        
        return result
    }
    
    
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
            CommonUtil.shared.printSuccess(
                funcTitle: "requestVeryShortItems()",
                value: "\(result.item?.count ?? 0)개의 초단기 예보 데이터 get"
            )
            return result.item ?? []
            
        case .failure(_):
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
            numOfRows: "300",
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
            CommonUtil.shared.printSuccess(
                funcTitle: "requestShortItems()",
                value: "\(result.item?.count ?? 0)개의 단기 예보 데이터 get"
            )
            return result.item ?? []
            
        case .failure(_):
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
            
            CommonUtil.shared.printSuccess(
                funcTitle: "requestSunriseSunset()",
                value: """
                일출시간: \(parser.result.sunrise)
                일몰시간: \(parser.result.sunset)
                """
            )
            
            return (parser.result.sunrise, parser.result.sunset)
            
        } catch {
            CommonUtil.shared.printError(
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
            CommonUtil.shared.printSuccess(
                funcTitle: "requestRealTimeFindDustAndUltraFindDustItems()",
                value: "\(result.items?.count ?? 0)개의 미세먼지, 초 미세먼지 데이터 get"
            )
            return result.items ?? []
            
        case .failure(_):
            return []
        }
    }
    
    func requestMidTermForecastTempItems() {
        
    }
    
    func requestMidTermForecastSkyStateItems() {
        
    }
    
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
            
            CommonUtil.shared.printSuccess(
                funcTitle: "applyVeryShortForecastData",
                value: """
                현재 온도: \(currentTemperature),
                현재 바람: \(Util.remakeWindSpeedValueForToString(value: currentWindSpeed).0),
                현재 습도: \(currentWetPercent),
                현재 강수량: \(Util.remakePrecipitationValueForToString(value: currentOneHourPrecipitation).0)
                현재 날씨 image: \(Util.remakeRainStateAndSkyStateForWeatherImage(
                rainState: rainState,
                skyState: skyState,
                hhMM: targetTime,
                sunrise: sunrise,
                sunset: sunset)
                )
                """
            )
            
        } else {
            CommonUtil.shared.printError(
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
                    let time = CommonUtil.shared.convertAMOrPMFromHHmm(items[tempIndex].fcstTime)
                    
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
            
            CommonUtil.shared.printSuccess(
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
            CommonUtil.shared.printError(
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
            CommonUtil.shared.printError(
                funcTitle: "applyRealTimeFindDustAndUltraFindDustItems()",
                description: "items가 존재하지 않습니다."
            )
            return
            
        }
        let findDust: String = Util.remakeFindDustValue(value: item.pm10Value)
        let ultraFindDust: String = Util.remakeUltraFindDustValue(value: item.pm25Value)
        result.smallFamilyData.currentWeatherItem.findDust = (findDust, ultraFindDust)
        
        CommonUtil.shared.printSuccess(
            funcTitle: "applyRealTimeFindDustAndUltraFindDustItems()",
            value: """
            미세먼지: \(findDust),
            초미세먼지: \(ultraFindDust),
            """
        )
    }
}
