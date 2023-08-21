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
    let chartValues: [IdentifiableValue<CGFloat>] = [.init(value: 20), .init(value: 25), .init(value: 27), .init(value: 30), .init(value: 32), .init(value: 27), .init(value: 28)]
    
    let circleSize: CGSize = CGSize(width: 6, height: 6)
    
    var body: some View {
        let width: CGFloat = UIScreen.screenWidth - 80
        let height: CGFloat = width / 1.3
        
        var convertedValues: [CGFloat] {
            let rangeMin: CGFloat = CGFloat(yList.min() ?? 0)
            let rangeMax: CGFloat = CGFloat(yList.max() ?? 0)
            
            // 0 = 바꿀 range의 최소값, height = 바꿀 range의 최대값
            return chartValues.map { chartValue in
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
            
            for i in 0..<chartValues.count {
                if i == 0 {
                    result.append(0)
                    
                } else {
                    xStepSum += xStepSize.width + xTextSize.width
                    result.append(xStepSum)
                }
            }
            
            return result
        }
        
        VStack(alignment: .leading, spacing: 0) {
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
                    path.move(to: CGPoint(x: 0, y: height - convertedValues[0]))
                    coordinates.append((0, height - convertedValues[0]))
                    
                    for i in 1..<chartValues.count {
                        path.addLine(to: CGPoint(x: xSteps[i], y: height - convertedValues[i]))
                        coordinates.append((xSteps[i], height - convertedValues[i]))
                    }
                }
                .stroke(Color.blue.opacity(0.6), lineWidth: 3)
                .overlay(alignment: .bottomLeading) {
                    ZStack(alignment: .bottomLeading) {
                        ForEach(coordinates.indices, id: \.self) { i in
                            Circle()
                                .fill(Int(chartValues[i].value) >= 30 ? Color.red :Color.white)
                                .frame(width: circleSize.width, height: circleSize.height)
                                .padding(.leading, xSteps[i] - (circleSize.width / 2))
                                .padding(.bottom, convertedValues[i] - (circleSize.height / 2))
                        }
                    }
                }
                .overlay(alignment: .bottomLeading) {
                    ZStack(alignment: .bottomLeading) {
                        ForEach(coordinates.indices, id: \.self) { i in
                            Text("\(Int(chartValues[i].value))°")
                                .foregroundColor(Int(chartValues[i].value) >= 30 ? Color.red.opacity(0.7) : Color.white.opacity(0.7))
                                .fontSpoqaHanSansNeo(size: 11, weight: .bold)
                                .padding(.leading, i == coordinates.count - 1 ? xSteps[i] - 17 : xSteps[i] - 5)
                                .padding(.bottom, convertedValues[i] + 10)
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
