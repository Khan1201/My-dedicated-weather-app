//
//  LineChartView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/21.
//

import SwiftUI
import Domain

public struct LineChartView: View {
    @Binding var weeklyChartInformation: Weather.WeeklyChartInformation

    @State private var xTextSize: CGSize = CGSize()
    @State private var yTextSize: CGSize = CGSize()
    @State private var xStepSize: CGSize = CGSize()
    @State private var yStepSize: CGSize = CGSize()
    @State private var lineStepSize: CGSize = CGSize()
    
    var minLineColor: Color
    var maxLineColor: Color
    var lineWidth: CGFloat
    
    public init(weeklyChartInformation: Binding<Weather.WeeklyChartInformation>, minLineColor: Color = Color.blue.opacity(0.6), maxLineColor: Color = Color.red.opacity(0.6), lineWidth: CGFloat = 2.5) {
        self._weeklyChartInformation = weeklyChartInformation
        self.minLineColor = minLineColor
        self.maxLineColor = maxLineColor
        self.lineWidth = lineWidth
    }
    
    public var body: some View {
        let width: CGFloat = UIScreen.screenWidth - 80
        let height: CGFloat = width * 1.1
        let vertexSize: CGSize = CGSize(width: 6, height: 6)
        let weatherImageSize: CGFloat = 22
        let rangeMin: CGFloat = CGFloat(weeklyChartInformation.yList.min() ?? 0)
        let rangeMax: CGFloat = CGFloat(weeklyChartInformation.yList.max() ?? 0)
        
        // Line
        var lineXValues: [CGFloat] {
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
        
        var maxTempLineYValues: [CGFloat] {
            // 0 = 바꿀 range의 최소값, height = 바꿀 range의 최대값
            return weeklyChartInformation.maxTemps.map { temp in
                let convertedTemp: CGFloat = temp > rangeMax ? rangeMax : temp
                
                return height - ((convertedTemp - rangeMin) * (CGFloat(height) - 0) / (rangeMax - rangeMin) + 0)
            }
        }
        
        var minTempLineYValues: [CGFloat] {
            // 0 = 바꿀 range의 최소값, height = 바꿀 range의 최대값
            return weeklyChartInformation.minTemps.map { temp in
                let convertedTemp: CGFloat = temp < rangeMin ? rangeMin : temp

                return height - (convertedTemp - rangeMin) * (CGFloat(height) - 0) / (rangeMax - rangeMin) + 0
            }
        }
        
        // Vertex
        var vertexLeadingPaddings: [CGFloat] {
            var result: [CGFloat] = []
            var xStepSum: CGFloat = 0
            
            for i in 0..<weeklyChartInformation.maxTemps.count {
                if i == 0 {
                    result.append(0)
                    
                } else {
                    xStepSum += xStepSize.width + xTextSize.width
                    result.append(xStepSum - 3)
                }
            }
            
            return result
        }
        
        var maxTempVertexBottomPaddings: [CGFloat] {
            // 0 = 바꿀 range의 최소값, height = 바꿀 range의 최대값
            return weeklyChartInformation.maxTemps.map { temp in
                let convertedTemp: CGFloat = temp > rangeMax ? rangeMax + 1 : temp
                
                return (convertedTemp - rangeMin) * (CGFloat(height) - 0) / (rangeMax - rangeMin) + 0 - (vertexSize.height / 2)
            }
        }
        
        var minTempVertexBottomPaddings: [CGFloat] {
            // 0 = 바꿀 range의 최소값, height = 바꿀 range의 최대값
            return weeklyChartInformation.minTemps.map { temp in
                let convertedTemp: CGFloat = temp < rangeMin ? rangeMin - 1 : temp

                return (convertedTemp - rangeMin) * (CGFloat(height) - 0) / (rangeMax - rangeMin) + 0 - (vertexSize.height / 2)
            }
        }
        
        // MARK: - View
        
        VStack(alignment: .leading, spacing: 16) {
            
            VStack(alignment: .leading, spacing: 10) {
                
                HStack(alignment: .center, spacing: 3) {
                    Rectangle()
                        .fill(maxLineColor)
                        .frame(width: 20, height: 6)
                        .cornerRadius(12)
                    
                    Text("최대 기온")
                        .fontSpoqaHanSansNeo(size: 9, weight: .regular)
                        .foregroundColor(Color.white)
                }
                
                HStack(alignment: .center, spacing: 3) {
                    Rectangle()
                        .fill(minLineColor)
                        .frame(width: 20, height: 6)
                        .cornerRadius(12)
                    
                    Text("최저 기온")
                        .fontSpoqaHanSansNeo(size: 9, weight: .regular)
                        .foregroundColor(Color.white)
                }
            }
            .padding(.leading, -yTextSize.width)
            
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
            // MARK: - About Max Values
            
            // Max line
            .overlay(alignment: .bottomLeading) {
                                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: maxTempLineYValues[0]))
                    
                    guard weeklyChartInformation.maxTemps.count >= 6 else {
                        CommonUtil.shared.printError(
                            funcTitle: "LineChartView - Max line draw",
                            description: "weeklyChartInformation.maxTemps.count >= 6이 아닙니다."
                        )
                        
                        return
                    }
                    for i in 1...6 {
                        path.addLine(to: CGPoint(x: lineXValues[i], y: maxTempLineYValues[i]))
                    }
                }
                .stroke(maxLineColor, lineWidth: lineWidth)
            }
            // Vertex
            .overlay(alignment: .bottomLeading) {
                ZStack(alignment: .bottomLeading) {
                    ForEach(weeklyChartInformation.maxTemps.indices, id: \.self) { i in
                        if i <= 6 {
                            Circle()
                                .fill(Color.white)
                                .frame(width: vertexSize.width, height: vertexSize.height)
                                .padding(.leading, vertexLeadingPaddings[i])
                                .padding(.bottom, maxTempVertexBottomPaddings[i])
                                .overlay(alignment: .topTrailing) {
                                    Text("\(Int(weeklyChartInformation.maxTemps[i]))°")
                                        .fontSpoqaHanSansNeo(size: 10, weight: .bold)
                                        .foregroundColor(Int(weeklyChartInformation.maxTemps[i]) >= 30 ? Color.red.opacity(0.7) : Color.white.opacity(0.7))
                                        .offset(x: vertexSize.width, y: -vertexSize.width * 2.5)
                                        .fixedSize()
                                }
                        }
                    }
                }
            }
            
            // MARK: - About Min Values
            
            // Min line
            .overlay(alignment: .bottomLeading) {
                                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: minTempLineYValues[0]))
                    
                    guard weeklyChartInformation.minTemps.count >= 6 else {
                        CommonUtil.shared.printError(
                            funcTitle: "LineChartView - Min line draw",
                            description: "weeklyChartInformation.minTemps.count >= 6이 아닙니다."
                        )
                        
                        return
                    }
                    
                    for i in 1...6 {
                        path.addLine(to: CGPoint(x: lineXValues[i], y: minTempLineYValues[i]))
                    }
                }
                .stroke(minLineColor, lineWidth: lineWidth)
            }
            // Vertex
            .overlay(alignment: .bottomLeading) {
                ZStack(alignment: .bottomLeading) {
                    ForEach(weeklyChartInformation.minTemps.indices, id: \.self) { i in
                        if i <= 6 {
                            Circle()
                                .fill(Color.white)
                                .frame(width: vertexSize.width, height: vertexSize.height)
                                .padding(.leading, vertexLeadingPaddings[i])
                                .padding(.bottom, minTempVertexBottomPaddings[i])
                                .overlay(alignment: .topTrailing) {
                                    Text("\(Int(weeklyChartInformation.minTemps[i]))°")
                                        .fontSpoqaHanSansNeo(size: 10, weight: .bold)
                                        .foregroundColor(Int(weeklyChartInformation.maxTemps[i]) >= 30 ? Color.red.opacity(0.7) : Color.white.opacity(0.7))
                                        .offset(x: vertexSize.width, y: -vertexSize.width * 2)
                                        .fixedSize()
                                }
                        }
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
                            .padding(.leading, lineXValues[i])
                    }
                }
            }
            // Weather image and Rain percent
            .overlay(alignment: .bottomLeading) {
                ZStack(alignment: .bottomLeading) {

                    ForEach(weeklyChartInformation.imageAndRainPercents.indices, id: \.self) { i in
                        let isFiveTemperatureDifference: Bool = weeklyChartInformation.maxTemps[i] - weeklyChartInformation.minTemps[i] >= 5
                        let isMinMaxTempRangeIn: Bool = weeklyChartInformation.maxTemps[i] <= rangeMax && weeklyChartInformation.minTemps[i] >= rangeMin
                        let weatherImageBottomPadding: CGFloat = isFiveTemperatureDifference && isMinMaxTempRangeIn ? minTempVertexBottomPaddings[i] + ((maxTempVertexBottomPaddings[i] - minTempVertexBottomPaddings[i]) / 2) : MidTermForecastUtil.isWeatherImageUnderMinTemperatureLocated(
                            currentMin: weeklyChartInformation.minTemps[i],
                            yAxisMin: rangeMin,
                            currentMax: weeklyChartInformation.maxTemps[i],
                            yAxisMax: rangeMax
                        )  ? minTempVertexBottomPaddings[i] - 50  : maxTempVertexBottomPaddings[i] + 50

                        VStack(alignment: .center, spacing: 0) {
                            Image(weeklyChartInformation.imageAndRainPercents[i].0)
                                .resizable()
                                .frame(width: weatherImageSize, height: weatherImageSize)

                            if weeklyChartInformation.imageAndRainPercents[i].1 != "0" {
                                Text("\(weeklyChartInformation.imageAndRainPercents[i].1)%")
                                    .fontSpoqaHanSansNeo(size: 7, weight: .medium)
                                    .foregroundColor(CustomColor.lightBlue.toColor)
                                    .offset(y: -2)
                            }
                        }
                        .padding(.leading, vertexLeadingPaddings[i] - (weatherImageSize / 2.5))
                        .padding(.bottom, weatherImageBottomPadding)
                    }
                }
            }
        }
    }
}

struct IdentifiableValue<T>: Identifiable {
    let id = UUID()
    let value: T
}
