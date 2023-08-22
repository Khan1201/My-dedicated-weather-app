//
//  LineChartBaseView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/21.
//

import SwiftUI

struct LineChartBaseView: View {
    @Binding var lineStepSize: CGSize
    @Binding var xTextSize: CGSize
    @Binding var xStepSize: CGSize
    @Binding var yTextSize: CGSize
    @Binding var yStepSize: CGSize
    
    let width: CGFloat
    let height: CGFloat
    let xList: [IdentifiableValue<String>]
    let yList: [Int]
    
    var lineHeight: CGFloat = 3
    var xItemFontSize: CGFloat = 14
    var yItemFontSize: CGFloat = 13
    var fontWeight: Font.Weight = .bold
    
    var body: some View {
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
            .overlay(alignment: .bottom) {
                HStack(alignment: .center, spacing: 0) {
                    ForEach(xList.indices, id: \.self) { i in
                        Text("\(xList[i].value)")
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
                .offset(y: xTextSize.height + 14)
            }
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
    
    struct LineChartBaseView_Previews: PreviewProvider {
        
        static var previews: some View {
            LineChartBaseView(
                lineStepSize: .constant(CGSize()),
                xTextSize: .constant(CGSize()),
                xStepSize: .constant(CGSize()),
                yTextSize: .constant(CGSize()),
                yStepSize: .constant(CGSize()),
                width: 280,
                height: 200,
                xList: [.init(value: "월"), .init(value: "화"), .init(value: "수"), .init(value: "목"), .init(value: "금"), .init(value: "토"), .init(value: "일"), .init(value: "월"), .init(value: "화"), .init(value: "수")
                       ],
                yList: [5, 4, 3, 2, 1]
            )
        }
    }
}
