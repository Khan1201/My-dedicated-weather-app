//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by 윤형석 on 2023/08/30.
//

import WidgetKit
import SwiftUI

public struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"
    
    public init() {}

    public var body: some WidgetConfiguration {
        let widgetVM: WeatherWidgetVM = DI.weatherWidgetVM()
        return StaticConfiguration(kind: kind, provider: Provider(widgetVM: widgetVM)) { entry in
            WeatherWidgetEntryView(entry: entry, locality: widgetVM.currentLocation.locality)
        }
        .contentMarginsDisabled()
        .configurationDisplayName("날씨모아 Widget")
        .description("가장 최근 현재위치(GPS)의 날씨정보를 제공합니다. 변경을 원하면 앱을 실행하여 GPS 날씨를 업데이트 해주세요.")
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(entry: Dummy.simpleEntry(), locality: "")
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
