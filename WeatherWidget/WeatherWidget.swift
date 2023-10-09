//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by 윤형석 on 2023/08/30.
//

import WidgetKit
import SwiftUI

struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .contentMarginsDisabled()
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(entry: Dummy.simpleEntry())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
