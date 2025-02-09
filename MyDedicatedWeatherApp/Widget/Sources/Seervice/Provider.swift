//
//  Provider.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/31.
//

import WidgetKit

struct Provider: TimelineProvider {
    
    let widgetVM: WeatherWidgetVM 
    
    func placeholder(in context: Context) -> SimpleEntry {
        Dummy.simpleEntry()
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        Task {
            switch context.family {
                
            case .systemSmall, .systemMedium:
                let result = await widgetVM.performSmallOrMediumWidgetEntrySetting()
                completion(result)

            case .systemLarge:
                let result = await widgetVM.performLargeWidgetEntrySetting()
                completion(result)

            default:
                ()
            }
        }
        
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        Task {
            var entries: [SimpleEntry] = []
            let reloadDate = Calendar.current.date(byAdding: .minute, value: 10, to: Date())!
                        
            switch context.family {
                
            case .systemSmall, .systemMedium:
                let result = await widgetVM.performSmallOrMediumWidgetEntrySetting()
                entries.append(result)
                
            case .systemLarge:
                let result = await widgetVM.performLargeWidgetEntrySetting()
                entries.append(result)
           
            default:
                ()
            }

            let timeline = Timeline(entries: entries, policy: .after(reloadDate))
            completion(timeline)
        }
    }
}
