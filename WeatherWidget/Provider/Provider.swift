//
//  Provider.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/31.
//

import WidgetKit
import Alamofire

struct Provider: TimelineProvider {
    
    let widgetVM: WidgetVM = WidgetVM()
    
    func placeholder(in context: Context) -> SimpleEntry {
        Dummy.simpleEntry()
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        Task {
            let result = await widgetVM.performWidgetData()
            completion(result)
        }
        
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        Task {
            var entries: [SimpleEntry] = []
            let reloadDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
            
            let result = await widgetVM.performWidgetData()
            entries.append(result)
            
            let timeline = Timeline(entries: entries, policy: .after(reloadDate))
            completion(timeline)
        }
    }
}
