//
//  EntryView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/31.
//


import SwiftUI

struct WeatherWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(entry.date, style: .time)
            Image("weather_rain")
                .resizable()
                .frame(width: 24, height: 24)
            Text(UserDefaults.shared.string(forKey: "dustStationName") ?? "")
            Text(UserDefaults.shared.string(forKey: "x") ?? "")
            Text(UserDefaults.shared.string(forKey: "y") ?? "")

        }
    }
}
