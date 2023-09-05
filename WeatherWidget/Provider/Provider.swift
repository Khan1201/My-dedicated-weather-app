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
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        requestVeryShortItems()
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        
        requestVeryShortItems()
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func requestVeryShortItems() {
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
        
        AF.request(Route.GET_WEATHER_VERY_SHORT_TERM_FORECAST.val, method: .get, parameters: parameters)
            .responseDecodable(of: OpenDataRes<VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>>.self) { response in
                switch response.result {
                case .success:
                    print("성공")

                case .failure(let error):
                    print(error)
                }
            }
        
    }
    
    
}
