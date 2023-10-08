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

        
        if family == .systemSmall {
            WeatherWidgetSmallView(entry: entry, location: location)
            
        } else if family == .systemMedium {
            WeatherWidgetMediumView(entry: entry, location: location)
            
        } else if family == .systemLarge {
            WeatherWidgetLargeView()
            
        } else {
            EmptyView()
        }
    }
}
