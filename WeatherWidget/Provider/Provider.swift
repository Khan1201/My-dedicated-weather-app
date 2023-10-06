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
            
            let currentDate = Date()
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let result = await performWidgetData()
                entries.append(result)
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
        
    }
    
    // MARK: - ETC Funcs..
    
    func performWidgetData() async -> SimpleEntry {
        var result: SimpleEntry = Dummy.simpleEntry()
        let veryShortForecastItems = await requestVeryShortItems()
        let shortForecastItems = await requestShortForecastItems()
        applyVeryShortForecastData(veryShortForecastItems, to: &result)
        applyShortForecastData(shortForecastItems, to: &result)
        
        return result
    }
    
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
            CommonUtil.shared.printSuccess(funcTitle: "requestVeryShortItems()", values: result.item ?? [])
            return result.item ?? []
            
        case .failure(_):
            return []
        }
    }
    
    /**
     Request 단기예보 Items
     
     - parameter xy: 공공데이터 값으로 변환된 X, Y
     - parameter baseTime: Request param 의 `baseTime`
     
     `baseTime` == nil -> 앱 첫 진입 시 자동 계산되어 호출
     `baseTime` != nil -> 앱 첫 진입 시 호출이 아닌, 수동 호출
     
     Response:
     - 1시간 별 데이터 12개 (13:00 -> 12개, 14:00 -> 12개)
     - 요청 basetime 별 response 값이 다름
     
     시간 별 Index:
     - 0: TMP (온도)
     - 1: UUU (풍속 동서성분)
     - 2: VVV (풍속 남북성분)
     - 3: VEC (풍향)
     - 4: WSD (풍속)
     - 5: SKY (하늘 상태)
     - 6: PTY (강수 형태)
     - 7: POP (강수 확률)
     - 8: WAV (파고)
     - 9: PCP (1시간 강수량)
     - 10: REH (습도)
     - 11: SNO (1시간 신적설)
     
     요청 basetime 별 데이터 크기:
     - 0200: '+1시간' ~ '+70시간'
     - 0500: '+1시간' ~ '+67시간'
     - 0800: '+1시간' ~ '+64시간'
     - 1100: '+1시간' ~ '+61시간'
     - 1400: '+1시간' ~ '+58시간' (0200 ~ 1400 : 오늘 ~ 모레까지)
     - 1700: '+1시간' ~ '+79시간'
     - 2000: '+1시간' ~ '+76시간'
     - 2300: '+1시간' ~ '+73시간' (17:00 ~ 2300: 오늘 ~ 모레+1일 까지)
     */
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
        )
            .serializingDecodable(OpenDataRes<VeryShortOrShortTermForecastBase<ShortTermForecastCategory>>.self)
        
        let result = await dataTask.result
        
        switch result {
            
        case .success(let result):
            CommonUtil.shared.printSuccess(funcTitle: "requestShortItems()", values: result.item ?? [])
            return result.item ?? []
            
        case .failure(_):
            return []
        }
    }
    
    func applyVeryShortForecastData(
        _ items: [VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>],
        to result: inout SimpleEntry
    ) {
        
        if items.count > 55 {
            let currentTemperature = items[24].fcstValue
            let currentWindSpeed = items[54].fcstValue
            let currentWetPercent = items[30].fcstValue
            let currentOneHourPrecipitation = items[12].fcstValue
            
            let rainState = items[6].fcstValue
            let skyState = items[18].fcstValue
            
            result.smallFamilyData.currentWeatherItem.currentTemperature = currentTemperature
            result.smallFamilyData.currentWeatherItem.wind = Util.remakeWindSpeedValueForToString(value: currentWindSpeed).0
            result.smallFamilyData.currentWeatherItem.wetPercent = currentWetPercent
            result.smallFamilyData.currentWeatherItem.precipitation = Util.remakePrecipitationValueForToString(value: currentOneHourPrecipitation).0
            result.smallFamilyData.currentWeatherItem.weatherImage = Util.remakeRainStateAndSkyStateForWeatherImage(
                rainState: rainState,
                skyState: skyState
            )
            
        } else {
            print("items의 개수가 55개를 넘지 못합니다. index 접근 불가")
            return
        }
    }
    
    func applyShortForecastData(
        _ items: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>],
        to result: inout SimpleEntry
    ) {
        var tempIndex = 0
        var skyIndex = 5
        var ptyIndex = 6
        var popIndex = 7
        
        var step = 12
        let loopCount = 24
        
        var minTemperature: Int = 0
        var maxTemperature: Int = 0
        
        if items.count >= step * loopCount {
            
        } else {
            CommonUtil.shared.printError(
                funcTitle: "applyShortForecastData()",
                description: "현재 날씨에서 +1 ~ 24시간까지의 데이터가 존재하지 않습니다."
            )
        }
        
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
                    skyState: items[skyIndex].fcstValue
                )
                let precipitation = items[popIndex].fcstValue
                let temperature = items[tempIndex].fcstValue
                
                result.mediumFamilyData.todayWeatherItems.append(
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
    }
}
