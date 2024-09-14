//
//  CurrentTempAndMinMaxTempView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/28.
//

import SwiftUI
import Domain

struct CurrentTempAndMinMaxTempView: View {
    
    let temp: String
    let minMaxTemp: (String, String)
    let isDayMode: Bool
    
    var body: some View {
        let isNotNocheDevice: Bool = CommonUtil.shared.isNotNocheDevice

        VStack(alignment: .center, spacing: 0) {
            
            HStack(alignment: .top, spacing: 2) {
                Text(temp)
                    .fontSpoqaHanSansNeo(size: isNotNocheDevice ? 50 : 55, weight: .bold)
                    .foregroundColor(.white)
                    .padding(.top, 5)
                
                Text("° C")
                    .fontSpoqaHanSansNeo(size: 18, weight: .medium)
                    .foregroundColor(.white)
            }
            
            HStack(alignment: .center, spacing: 0) {
                Image(systemName: "arrow.down")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color.blue.opacity(isDayMode ? 1 : 0.6))
                    .frame(width: 15, height: 15)
                
                Text(minMaxTemp.0)
                    .fontSpoqaHanSansNeo(size: 16, weight: .regular)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.leading, 3)
                
                Image(systemName: "arrow.up")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color.red.opacity(isDayMode ? 1 : 0.6))
                    .frame(width: 15, height: 15)
                    .padding(.leading, 10)
                
                Text(minMaxTemp.1)
                    .fontSpoqaHanSansNeo(size: 16, weight: .regular)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.leading, 3)
            }
            .padding(.top, isNotNocheDevice ? 6 : 10)
        }
    }
}

struct CurrentTempAndMinMaxTempView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentTempAndMinMaxTempView(
            temp: "",
            minMaxTemp: ("", ""),
            isDayMode: false
        )
    }
}
