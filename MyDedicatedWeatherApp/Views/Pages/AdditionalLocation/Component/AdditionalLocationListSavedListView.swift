//
//  AdditionalLocationSavedListView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/2/23.
//

import SwiftUI

struct AdditionalLocationSavedListView: View {
    let savedAddresses: [String]
    let tempItems: [Weather.WeatherImageAndMinMax]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            ForEach(savedAddresses.indices, id: \.self) { i in
                AdditionalLocationSavedListItemView(address: savedAddresses[i], tempItem: tempItems[i])
            }
        }
    }
}

#Preview {
    AdditionalLocationSavedListView(savedAddresses: [], tempItems: [])
}

struct AdditionalLocationSavedListItemView: View {
    let address: String
    let tempItem: Weather.WeatherImageAndMinMax
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            Text(address)
                .fontSpoqaHanSansNeo(size: 15, weight: .medium)
                .foregroundStyle(Color.white)
            
            Spacer()
            
            Image(tempItem.weatherImage)
                .resizable()
                .frame(width: 34, height: 34)
                .loadingProgressLottie(isLoadingCompleted: tempItem.weatherImage != "")
            
            VStack(alignment: .leading, spacing: 2) {
                Text(" \(tempItem.currentTemp)°")
                    .fontSpoqaHanSansNeo(size: 18, weight: .medium)
                    .foregroundStyle(Color.white)

                Text("\(tempItem.minMaxTemp.0)°/\(tempItem.minMaxTemp.1)°")
                    .fontSpoqaHanSansNeo(size: 12, weight: .regular)
                    .foregroundStyle(Color.white.opacity(0.7))
            }
            .padding(.leading, 5)
            .loadingProgressLottie(isLoadingCompleted: tempItem.currentTemp != "" && tempItem.minMaxTemp != ("", ""))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 15)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
