//
//  WeatherWidgetEntryView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/31.
//


import SwiftUI

struct WeatherWidgetEntryView : View {
    let entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        let location: String = UserDefaults.shared.string(forKey: "locality") ?? ""
        
        if #available(iOS 17.0, *) {
            VStack(alignment: .leading, spacing: 0) {
                if family == .systemSmall {
                    WeatherWidgetSmallView(entry: entry, location: location)
                    
                } else if family == .systemMedium {
                    WeatherWidgetMediumView(entry: entry, location: location)
                    
                } else if family == .systemLarge {
                    WeatherWidgetLargeView(entry: entry, location: location)
                    
                } else {
                    EmptyView()
                }
            }
            .containerBackground(
                entry.isDayMode ? Color.dayBackground : Color.nightBackground,
                for: .widget
            )
            
        } else {
            ZStack {
                if entry.isDayMode {
                    Color.dayBackground
                    
                } else {
                    Color.nightBackground
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    if family == .systemSmall {
                        WeatherWidgetSmallView(entry: entry, location: location)
                        
                    } else if family == .systemMedium {
                        WeatherWidgetMediumView(entry: entry, location: location)
                        
                    } else if family == .systemLarge {
                        WeatherWidgetLargeView(entry: entry, location: location)
                        
                    } else {
                        EmptyView()
                    }
                }
            }
        }
    }
}
