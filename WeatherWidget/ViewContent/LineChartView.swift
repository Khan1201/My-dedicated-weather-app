//
//  LineChartView.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 2023/09/12.
//

import SwiftUI
import WidgetKit

struct LineChartView: View {
    @Binding var weeklyChartInformation: Weather.WeeklyChartInformation

    @State private var xTextSize: CGSize = CGSize()
    @State private var yTextSize: CGSize = CGSize()
    @State private var xStepSize: CGSize = CGSize()
    @State private var yStepSize: CGSize = CGSize()
    @State private var lineStepSize: CGSize = CGSize()

    var minLineColor: Color = Color.blue.opacity(0.6)
    var maxLineColor: Color = Color.red.opacity(0.6)
    var lineWidth: CGFloat = 1
    var temperatureFontSize: CGFloat = 6
    
    var body: some View {
        let width: CGFloat = 260
        let height: CGFloat = 130
        let circleSize: CGSize = CGSize(width: 3, height: 3)
        let rangeMin: CGFloat = CGFloat(weeklyChartInformation.yList.min() ?? 0)
        let rangeMax: CGFloat = CGFloat(weeklyChartInformation.yList.max() ?? 0)
        
        var convertedMaxValues: [CGFloat] {
            // 0 = 바꿀 range의 최소값, height = 바꿀 range의 최대값
            return weeklyChartInformation.maxTemps.map { temp in
                if temp == 0 {
                    return 0
                    
                } else {
                    return (temp - rangeMin) * (CGFloat(height) - 0) / (rangeMax - rangeMin) + 0
                }
            }
        }
        
        var convertedMinValues: [CGFloat] {
            // 0 = 바꿀 range의 최소값, height = 바꿀 range의 최대값
            return weeklyChartInformation.minTemps.map { temp in
                if temp == 0 {
                    return 0
                    
                } else {
                    return (temp - rangeMin) * (CGFloat(height) - 0) / (rangeMax - rangeMin) + 0
                }
            }
        }
        
        var xSteps: [CGFloat] {
            var result: [CGFloat] = []
            var xStepSum: CGFloat = 0
            
            for i in 0..<weeklyChartInformation.maxTemps.count {
                if i == 0 {
                    result.append(0)
                    
                } else {
                    xStepSum += xStepSize.width + xTextSize.width
                    result.append(xStepSum)
                }
            }
            
            return result
        }
        ZStack {
            Color.init(hexCode: "#000080")
                .opacity(0.7)
            
            VStack(alignment: .leading, spacing: 16) {
                LineChartBaseView(
                    lineStepSize: $lineStepSize,
                    xTextSize: $xTextSize,
                    xStepSize: $xStepSize,
                    yTextSize: $yTextSize,
                    yStepSize: $yStepSize,
                    width: width,
                    height: height,
                    xList: weeklyChartInformation.xList,
                    yList: weeklyChartInformation.yList
                )
                .frame(width: width, height: height)
                // MARK: - About Max Values
                
                // Max line
                .overlay(alignment: .bottomLeading) {

                    Path { path in
                        path.move(to: CGPoint(x: 0, y: height - convertedMaxValues[0]))

                        for i in 1..<weeklyChartInformation.maxTemps.count {
                            path.addLine(to: CGPoint(x: xSteps[i], y: height - convertedMaxValues[i]))
                        }
                    }
                    .stroke(maxLineColor, lineWidth: lineWidth)
                }
    //            // Vertex
                .overlay(alignment: .bottomLeading) {
                    ZStack(alignment: .bottomLeading) {
                        ForEach(weeklyChartInformation.maxTemps.indices, id: \.self) { i in
                            Circle()
                                .fill(Color.white)
                                .frame(width: circleSize.width, height: circleSize.height)
                                .padding(.leading, xSteps[i] - (circleSize.width / 2))
                                .padding(.bottom, convertedMaxValues[i] - (circleSize.height / 2))
                        }
                    }
                }
                // Temperature
                .overlay(alignment: .bottomLeading) {
                    ZStack(alignment: .bottomLeading) {
                        ForEach(weeklyChartInformation.maxTemps.indices, id: \.self) { i in
                            Text("\(Int(weeklyChartInformation.maxTemps[i]))°")
                                .font(.system(size: temperatureFontSize, weight: .bold))
                                .foregroundColor(Int(weeklyChartInformation.maxTemps[i]) >= 30 ? Color.red.opacity(0.7) : Color.white.opacity(0.7))
                                .padding(.leading, i == 0 ? xSteps[i] : xSteps[i] - 5)
                                .padding(.bottom, convertedMaxValues[i] + 5)
                        }
                    }
                }
                
                // MARK: - About Min Values
    //
                // Min line
                .overlay(alignment: .bottomLeading) {

                    Path { path in
                        path.move(to: CGPoint(x: 0, y: height - convertedMinValues[0]))

                        for i in 1..<weeklyChartInformation.minTemps.count {
                            path.addLine(to: CGPoint(x: xSteps[i], y: height - convertedMinValues[i]))
                        }
                    }
                    .stroke(minLineColor, lineWidth: lineWidth)
                }
                // Vertex
                .overlay(alignment: .bottomLeading) {
                    ZStack(alignment: .bottomLeading) {
                        ForEach(weeklyChartInformation.minTemps.indices, id: \.self) { i in
                            Circle()
                                .fill(Color.white)
                                .frame(width: circleSize.width, height: circleSize.height)
                                .padding(.leading, xSteps[i] - (circleSize.width / 2))
                                .padding(.bottom, convertedMinValues[i] - (circleSize.height / 2))
                        }
                    }
                }
                // Temperature
                .overlay(alignment: .bottomLeading) {
                    ZStack(alignment: .bottomLeading) {
                        ForEach(weeklyChartInformation.minTemps.indices, id: \.self) { i in
                            Text("\(Int(weeklyChartInformation.minTemps[i]))°")
                                .font(.system(size: temperatureFontSize, weight: .bold))
                                .foregroundColor(Color.white.opacity(0.7))
                                .padding(.leading, i == 0 ? xSteps[i] : xSteps[i] - 5)
                                .padding(.bottom, convertedMinValues[i] + 5)
                        }
                    }
                }
                // X축 base line
                .overlay(alignment: .bottomLeading) {
                    ZStack(alignment: .bottomLeading) {
                        ForEach(weeklyChartInformation.minTemps.indices, id: \.self) { i in
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 1, height: height)
                                .padding(.leading, xSteps[i])
                        }
                    }
                }
                // Weather image and Rain percent
                .overlay(alignment: .bottomLeading) {
                    ZStack(alignment: .bottomLeading) {
                        let imageWidth: CGFloat = 14

                        ForEach(weeklyChartInformation.imageAndRainPercents.indices, id: \.self) { i in
                            VStack(alignment: .center, spacing: 0) {
                                Image(weeklyChartInformation.imageAndRainPercents[i].0)
                                    .resizable()
                                    .frame(width: imageWidth, height: imageWidth)

                                if weeklyChartInformation.imageAndRainPercents[i].1 != "0" {
                                    Text("\(weeklyChartInformation.imageAndRainPercents[i].1)%")
                                        .font(.system(size: 6, weight: .medium))
                                        .foregroundColor(Color.blue.opacity(0.9))
                                        .offset(y: -2)
                                }
                            }
                            .padding(.leading, i == 0 ?
                                     xSteps[i] - 4 : xSteps[i] - (imageWidth / 2)
                            )
                            .padding(.bottom, convertedMinValues[i] - 30)
                        }
                    }
                }
            }
        }
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(
            weeklyChartInformation: .constant(Dummy.weeklyChartInformation())
        )
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}


struct IdentifiableValue<T>: Identifiable {
    let id = UUID()
    let value: T
}
