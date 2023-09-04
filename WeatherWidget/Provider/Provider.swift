//
//  Provider.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/31.
//

import WidgetKit

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
        var urlComponents = URLComponents(string: Route.GET_WEATHER_VERY_SHORT_TERM_FORECAST.val)!
        urlComponents.queryItems = [
            URLQueryItem(name: "serviceKey", value: parameters.serviceKey),
            URLQueryItem(name: "pageNo", value: parameters.pageNo),
            URLQueryItem(name: "numOfRows", value: parameters.numOfRows),
            URLQueryItem(name: "dataType", value: parameters.dataType),
            URLQueryItem(name: "base_date", value: parameters.baseDate),
            URLQueryItem(name: "base_time", value: parameters.baseTime),
            URLQueryItem(name: "nx", value: parameters.nx),
            URLQueryItem(name: "ny", value: parameters.ny)
        ]
        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")

        
        let urlRequest = URLRequest(url: urlComponents.url!)
        print(urlComponents.url!)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            do {
                let dataTask = try JSONDecoder().decode(OpenDataRes<VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>>.self, from: data ?? Data())
                print("아이템: \(dataTask.item)")
                print("아이템: \(dataTask.items)")
    
            } catch {
                print(error)
            }
            
        }.resume()
        
    }
    
    
}
