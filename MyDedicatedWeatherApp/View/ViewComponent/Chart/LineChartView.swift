//
//  LineChartView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/21.
//

import SwiftUI

struct LineChartView: View {
    @State private var xTextSize: CGSize = CGSize()
    @State private var yTextSize: CGSize = CGSize()
    @State private var xStepSize: CGSize = CGSize()
    @State private var yStepSize: CGSize = CGSize()
    @State private var lineStepSize: CGSize = CGSize()
    
    let xList: [IdentifiableValue] = [.init(value: "월"), .init(value: "화"), .init(value: "수"), .init(value: "목"), .init(value: "금"), .init(value: "토"), .init(value: "일")
    ]
    let yList: [Int] = [15, 20, 25, 30, 35].reversed()
    
    let minValues: [IdentifiableValue<CGFloat>] = [.init(value: 22), .init(value: 20), .init(value: 23), .init(value: 20), .init(value: 23), .init(value: 21), .init(value: 22)]
    
    let maxValues: [IdentifiableValue<CGFloat>] = [.init(value: 27), .init(value: 25), .init(value: 27), .init(value: 30), .init(value: 32), .init(value: 27), .init(value: 28)]
    
    var minLineColor: Color = Color.blue.opacity(0.6)
    var maxLineColor: Color = Color.red.opacity(0.6)
    var lineWidth: CGFloat = 2.5
    
    var body: some View {
        let width: CGFloat = UIScreen.screenWidth - 80
        let height: CGFloat = width * 1.0333
        let circleSize: CGSize = CGSize(width: 6, height: 6)

        var convertedMaxValues: [CGFloat] {
            let rangeMin: CGFloat = CGFloat(yList.min() ?? 0)
            let rangeMax: CGFloat = CGFloat(yList.max() ?? 0)
            
            // 0 = 바꿀 range의 최소값, height = 바꿀 range의 최대값
            return maxValues.map { chartValue in
                if chartValue.value == 0 {
                    return 0
                    
                } else {
                    return (chartValue.value - rangeMin) * (CGFloat(height) - 0) / (rangeMax - rangeMin) + 0
                }
            }
        }
        
        var convertedMinValues: [CGFloat] {
            let rangeMin: CGFloat = CGFloat(yList.min() ?? 0)
            let rangeMax: CGFloat = CGFloat(yList.max() ?? 0)
            
            // 0 = 바꿀 range의 최소값, height = 바꿀 range의 최대값
            return minValues.map { chartValue in
                if chartValue.value == 0 {
                    return 0
                    
                } else {
                    return (chartValue.value - rangeMin) * (CGFloat(height) - 0) / (rangeMax - rangeMin) + 0
                }
            }
        }
        
        var xSteps: [CGFloat] {
            var result: [CGFloat] = []
            var xStepSum: CGFloat = 0
            
            for i in 0..<maxValues.count {
                if i == 0 {
                    result.append(0)
                    
                } else {
                    xStepSum += xStepSize.width + xTextSize.width
                    result.append(xStepSum)
                }
            }
            
            return result
        }
        
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
                xList: xList,
                yList: yList
            )
            .overlay(alignment: .bottomLeading) {
                
                var coordinates: [(CGFloat, CGFloat)] = []
                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: height - convertedMaxValues[0]))
                    coordinates.append((0, height - convertedMaxValues[0]))
                    
                    for i in 1..<maxValues.count {
                        path.addLine(to: CGPoint(x: xSteps[i], y: height - convertedMaxValues[i]))
                        coordinates.append((xSteps[i], height - convertedMaxValues[i]))
                    }
                }
                .stroke(maxLineColor, lineWidth: lineWidth)
                .overlay(alignment: .bottomLeading) {
                    ZStack(alignment: .bottomLeading) {
                        ForEach(coordinates.indices, id: \.self) { i in
                            Circle()
                                .frame(width: circleSize.width, height: circleSize.height)
                                .padding(.leading, xSteps[i] - (circleSize.width / 2))
                                .padding(.bottom, convertedMaxValues[i] - (circleSize.height / 2))
                        }
                    }
                }
                .overlay(alignment: .bottomLeading) {
                    ZStack(alignment: .bottomLeading) {
                        ForEach(coordinates.indices, id: \.self) { i in
                            Text("\(Int(maxValues[i].value))°")
                                .fontSpoqaHanSansNeo(size: 10, weight: .bold)
                                .foregroundColor(Int(maxValues[i].value) >= 30 ? Color.red.opacity(0.7) : Color.white.opacity(0.7))
                                .padding(.leading, i == coordinates.count - 1 ? xSteps[i] - 17 : xSteps[i] - 5)
                                .padding(.bottom, convertedMaxValues[i] + 10)
                        }
                    }
                }
            }
            .overlay(alignment: .bottomLeading) {
                
                var coordinates: [(CGFloat, CGFloat)] = []
                
                Path { path in
                    path.move(to: CGPoint(x: 0, y: height - convertedMinValues[0]))
                    coordinates.append((0, height - convertedMinValues[0]))
                    
                    for i in 1..<minValues.count {
                        path.addLine(to: CGPoint(x: xSteps[i], y: height - convertedMinValues[i]))
                        coordinates.append((xSteps[i], height - convertedMinValues[i]))
                    }
                }
                .stroke(minLineColor, lineWidth: lineWidth)
                .overlay(alignment: .bottomLeading) {
                    ZStack(alignment: .bottomLeading) {
                        ForEach(coordinates.indices, id: \.self) { i in
                            Circle()
                                .fill(Color.white)
                                .frame(width: circleSize.width, height: circleSize.height)
                                .padding(.leading, xSteps[i] - (circleSize.width / 2))
                                .padding(.bottom, convertedMinValues[i] - (circleSize.height / 2))
                        }
                    }
                }
                .overlay(alignment: .bottomLeading) {
                    ZStack(alignment: .bottomLeading) {
                        ForEach(coordinates.indices, id: \.self) { i in
                            Text("\(Int(minValues[i].value))°")
                                .fontSpoqaHanSansNeo(size: 10, weight: .bold)
                                .foregroundColor(Color.white.opacity(0.7))
                                .padding(.leading, i == coordinates.count - 1 ? xSteps[i] - 17 : xSteps[i] - 5)
                                .padding(.bottom, convertedMinValues[i] + 10)
                        }
                    }
                }
                .overlay(alignment: .bottomLeading) {
                    ZStack(alignment: .bottomLeading) {
                        ForEach(coordinates.indices, id: \.self) { i in
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 1, height: height)
                                .padding(.leading, xSteps[i])
                        }
                    }
                }
            }
        }
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView()
    }
}


struct IdentifiableValue<T>: Identifiable {
    let id = UUID()
    let value: T
}
