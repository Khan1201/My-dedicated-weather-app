//
//  WeatherWidgetEntryView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/31.
//


import SwiftUI

struct WeatherWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        
        if family == .systemSmall {
            WeatherWidgetSmallView()
            
        } else if family == .systemMedium {
            WeatherWidgetMediumView()
            
        } else if family == .systemLarge {
            WeatherWidgetLargeView()
            
        } else {
            EmptyView()
        }
    }
}
