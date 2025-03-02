//
//  CurrentWeatherInformationItemView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/30.
//

import SwiftUI
import Core
import Domain

struct CurrentWeatherInformationItemView: View {
    
    let loadCompleted: Bool
    let imageString: String
    let imageColor: Color
    let title: String
    let value: (String, String)? // (약한 비, 5mm)
    let isDayMode: Bool
    var backgroundColor: Color?
    
    func currentBackgroundColor() -> Color {
        
        if backgroundColor != nil {
            return backgroundColor!.opacity(0.6)
            
        } else if isDayMode {
            return CustomColor.lightNavy.toColor.opacity(0.2)
            
        } else {
            return .defaultAreaColor
        }
    }
    
    var body: some View {
        
        let isNotNocheDevice: Bool = CommonUtil.shared.isNotNocheDevice
        let imageWidth: CGFloat = UIScreen.screenWidth / (isNotNocheDevice ? 12.0 : 10.41)
        let imageHeight: CGFloat = UIScreen.screenHeight / (isNotNocheDevice ? 24 : 22.55)
        let iconWidthHeight: CGFloat = imageWidth / (isNotNocheDevice ? 2 : 1.63)

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
                .fontSpoqaHanSansNeo(size: isNotNocheDevice ? 13 : 14, weight: .regular)
                .foregroundColor(.white)
                .padding(.leading, 14)
            
            Spacer()
            
            HStack(alignment: .center, spacing: 0) {
                Text(value?.0 ?? "")
                    .fontSpoqaHanSansNeo(size: isNotNocheDevice ? 13 : 14, weight: .medium)
                    .foregroundColor(.white)
                
                if value?.1 != "" {
                    Text("(\(value?.1 ?? ""))")
                        .fontSpoqaHanSansNeo(size: isNotNocheDevice ? 11 : 12, weight: .regular)
                        .foregroundColor(.white)
                }
            }
            .padding(.trailing, 17)
            /// 위 HStack에 modifier로 loading animation으로 하면, default value가 빈 값이므로, loading animation사이즈가 너무 작게 나옴.
            .overlay(alignment: .trailing) {
                EmptyView()
                    .loadingProgressLottie(
                        isLoadingCompleted: loadCompleted,
                        width: 70,
                        height: 70
                    )
            }
            
        }
        .padding(.horizontal, 11)
        .padding(.vertical, isNotNocheDevice ? 7 : 8)
        .background(
            currentBackgroundColor()
        )
        .cornerRadius(10)
    }
}

struct CurrentWeatherInformationItem_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherInformationItemView(loadCompleted: true, imageString: "fine_dust", imageColor: .red.opacity(0.7), title: "미세먼지", value: ("나쁨", ""), isDayMode: true)
    }
}
