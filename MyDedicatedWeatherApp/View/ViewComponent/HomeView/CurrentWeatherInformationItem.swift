//
//  CurrentWeatherInformationItem.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/30.
//

import SwiftUI

struct CurrentWeatherInformationItem: View {
    
    let imageString: String
    let imageColor: Color
    let title: String
    let value: String
    let isDayMode: Bool
    var backgroundColor: Color?

    var body: some View {
        
        let imageWidth: CGFloat = UIScreen.screenWidth / 10.41
        let imageHeight: CGFloat = UIScreen.screenHeight / 22.55
        let iconWidthHeight: CGFloat = imageWidth / 1.63
        
        HStack(alignment: .center, spacing: 0) {
            
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .frame(width: imageWidth, height: imageHeight)
                .overlay {
                    Image(imageString)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(imageColor)
                        .frame(width: iconWidthHeight, height: iconWidthHeight, alignment: .center)
                }
            
            Text(title)
                .fontSpoqaHanSansNeo(size: 14, weight: .regular)
                .foregroundColor(isDayMode ? CustomColor.black.toColor : .white)
                .padding(.leading, 14)
            
            Spacer()
            
            Text(value)
                .fontSpoqaHanSansNeo(size: 14, weight: .regular)
                .foregroundColor(isDayMode ? CustomColor.black.toColor : .white)
                .padding(.trailing, 17)
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 8)
        .background(
            backgroundColor != nil ?
            backgroundColor?.opacity(0.45) : .white.opacity(0.36)
        )
        .cornerRadius(10)
    }
}

struct CurrentWeatherInformationItem_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherInformationItem(imageString: "fine_dust", imageColor: .red.opacity(0.7), title: "미세먼지", value: "나쁨", isDayMode: true)
    }
}
