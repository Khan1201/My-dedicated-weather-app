//
//  TestView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/09/15.
//

import SwiftUI
import WidgetKit

struct TestView: View {
    var body: some View {
        ZStack {
            Color.init(hexCode: "#000080")
                .opacity(0.7)
            
            LineChartView(weeklyChartInformation: .constant(Dummy.weeklyChartInformation()))
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
