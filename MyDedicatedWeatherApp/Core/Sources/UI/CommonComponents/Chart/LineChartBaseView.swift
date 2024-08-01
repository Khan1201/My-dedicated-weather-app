//
//  LineChartBaseView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/21.
//

import SwiftUI

public struct LineChartBaseView: View {
    @Binding var lineStepSize: CGSize
    @Binding var xTextSize: CGSize
    @Binding var xStepSize: CGSize
    @Binding var yTextSize: CGSize
    @Binding var yStepSize: CGSize
    
    let width: CGFloat
    let height: CGFloat
    let xList: [(String, String)]
    let yList: [Int]
    
    var lineHeight: CGFloat
    var xItemFontSize: CGFloat
    var yItemFontSize: CGFloat
    var fontWeight: Font.Weight
    
    public init(lineStepSize: Binding<CGSize>, xTextSize: Binding<CGSize>, xStepSize: Binding<CGSize>, yTextSize: Binding<CGSize>, yStepSize: Binding<CGSize>, width: CGFloat, height: CGFloat, xList: [(String, String)], yList: [Int], lineHeight: CGFloat = 3, xItemFontSize: CGFloat = 14, yItemFontSize: CGFloat = 13, fontWeight: Font.Weight = .bold) {
        self._lineStepSize = lineStepSize
        self._xTextSize = xTextSize
        self._xStepSize = xStepSize
        self._yTextSize = yTextSize
        self._yStepSize = yStepSize
        self.width = width
        self.height = height
        self.xList = xList
        self.yList = yList
        self.lineHeight = lineHeight
        self.xItemFontSize = xItemFontSize
        self.yItemFontSize = yItemFontSize
        self.fontWeight = fontWeight
    }
    
    public var body: some View {
        Rectangle()
            .fill(Color.clear)
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
                .padding(.horizontal, -5)
                .offset(y: xTextSize.height + 24)
            }
            // X축 날짜
            .overlay(alignment: .bottom) {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(xList.indices, id: \.self) { i in
                        Text("\(xList[i].1)")
                            .font(.system(size: xItemFontSize - 5))
                            .foregroundColor(Color.white.opacity(0.7))
                        
                        if i != xList.count - 1 {
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, -10)
                .offset(y: (xTextSize.height * 2) + 24)
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
                .padding(.vertical, -5)
                .offset(x: -yTextSize.width - 7)
            }
    }
}
