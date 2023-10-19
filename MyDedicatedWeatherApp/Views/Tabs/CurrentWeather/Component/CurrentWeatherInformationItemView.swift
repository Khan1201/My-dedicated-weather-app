//
//  CurrentWeatherInformationItemView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/30.
//

import SwiftUI

struct CurrentWeatherInformationItemView: View {
    
    let imageString: String
    let imageColor: Color
    let title: String
    let value: (String, String)
    let isDayMode: Bool
    var backgroundColor: Color?
    
    func currentBackgroundColor() -> Color {
        
        if backgroundColor != nil {
            return backgroundColor!.opacity(0.45)
            
        } else if isDayMode {
            return CustomColor.lightNavy.toColor.opacity(0.2)
            
        } else {
            return .defaultAreaColor
        }
    }
    
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
                .foregroundColor(.white)
                .padding(.leading, 14)
            
            Spacer()
            
            HStack(alignment: .center, spacing: 0) {
                Text(value.0)
                    .fontSpoqaHanSansNeo(size: 14, weight: .medium)
                    .foregroundColor(.white)
                
                if value.1 != "" {
                    Text("(\(value.1))")
                        .fontSpoqaHanSansNeo(size: 12, weight: .regular)
                        .foregroundColor(.white)
                }
            }
            .padding(.trailing, 17)
            
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 8)
        .background(
            currentBackgroundColor()
        )
        .cornerRadius(10)
    }
}

struct CurrentWeatherInformationItem_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherInformationItemView(imageString: "fine_dust", imageColor: .red.opacity(0.7), title: "미세먼지", value: ("나쁨", ""), isDayMode: true)
    }
}
