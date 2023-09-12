//
//  LineChartBaseView.swift
//  WeatherWidgetExtension
//
//  Created by 윤형석 on 2023/09/12.
//

import SwiftUI
import WidgetKit

struct LineChartBaseView: View {
    @Binding var lineStepSize: CGSize
    @Binding var xTextSize: CGSize
    @Binding var xStepSize: CGSize
    @Binding var yTextSize: CGSize
    @Binding var yStepSize: CGSize
    
    let width: CGFloat
    let height: CGFloat
    let xList: [(String, String)]
    let yList: [Int]
    
    var lineHeight: CGFloat = 3
    var xItemFontSize: CGFloat = 8
    var yItemFontSize: CGFloat = 7
    var fontWeight: Font.Weight = .bold
    
    var body: some View {
        ZStack {
            
            Color.blue.opacity(0.3)
            
            Rectangle()
                .fill(Color.red.opacity(0.7))
                .frame(width: width, height: height)
                .overlay {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(0...4, id: \.self) { i in
                            Rectangle()
                                .fill(Color.white.opacity(0.2))
                                .frame(height: lineHeight)
                            
                            if i != 4 {
                                Spacer()
                                    .getSize(size: $lineStepSize)
                            }
                        }
                    }
                }
                // X축 요일
                .overlay(alignment: .bottom) {
                    HStack(alignment: .center, spacing: 0) {
                        ForEach(xList.indices, id: \.self) { i in
                            Text("\(xList[i].0)")
                                .font(.system(size: xItemFontSize, weight: fontWeight))
                                .foregroundColor(Color.white)
                                .getSize(size: $xTextSize)

                            if i != xList.count - 1 {
                                Spacer()
                                    .getSize(size: $xStepSize)
                            }
                        }
                    }
                    .offset(y: xTextSize.height + 14)
                }
                // X축 날짜
                .overlay(alignment: .bottom) {
                    HStack(alignment: .center, spacing: 0) {
                        ForEach(xList.indices, id: \.self) { i in
                            Text("\(xList[i].1)")
                                .font(.system(size: xItemFontSize - 2))
                                .foregroundColor(Color.white.opacity(0.7))
                            
                            if i != xList.count - 1 {
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, -2)
                    .offset(y: (xTextSize.height * 2) + 22)
                }
                // y축 기온
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(yList, id: \.self) { y in
                            Text("\(y)°")
                                .font(.system(size: yItemFontSize, weight: fontWeight))
                                .foregroundColor(Color.white)
                                .getSize(size: $yTextSize)
                            
                            if yList[yList.count - 1] != y {
                                Spacer()
                                    .getSize(size: $yStepSize)
                            }
                        }
                    }
                    .offset(x: -yTextSize.width - 16)
                }
        }
        
    }
    
    struct LineChartBaseView_Previews: PreviewProvider {
        
        static var previews: some View {
            LineChartBaseView(
                lineStepSize: .constant(CGSize()),
                xTextSize: .constant(CGSize()),
                xStepSize: .constant(CGSize()),
                yTextSize: .constant(CGSize()),
                yStepSize: .constant(CGSize()),
                width: 270,
                height: 130,
                xList: [("월", "8/24"), ("화", "8/25"), ("수", "8/26"), ("목", "8/27"), ("금", "8/28"), ("토", "8/29"), ("일", "8/30")],
                yList: [30, 25, 20, 15, 10]
            )
            .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
