//
//  TodayWeatherVC.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/05/10.
//

import SwiftUI

struct TodayWeatherVC: View {
    
    let imageString: String
    let time: String
    let temperature: String
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 5) {
            
            Image(imageString)
                .resizable()
                .frame(width: 70, height: 70)
            
            VStack(alignment: .center, spacing: 20) {
                Text(time)
                    .font(.system(size: 16, weight: .bold))
                Text(temperature + "°")
                    .font(.system(size: 16, weight: .medium))
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 10)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 15)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray)
        }
    }
}

struct TodayWeatherVC_Previews: PreviewProvider {
    static var previews: some View {
        TodayWeatherVC(
            imageString: "weather_blur",
            time: "13:00",
            temperature: "25"
        )
    }
}
