//
//  AdditionalLocationSavedGPSItemView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/7/23.
//

import SwiftUI

struct AdditionalLocationSavedGPSItemView: View {
    let fullAddress: String
    let locality: String
    let subLocality: String
    let tempItem: Weather.WeatherImageAndMinMax
    let currentLocation: String
    let finalLocationOnTapGesture: (String, String, String, Bool) -> Void

    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text(fullAddress)
                    .fontSpoqaHanSansNeo(size: 15, weight: .medium)
                    .foregroundStyle(Color.white)
                
                Text(" (GPS 위치)")
                    .fontSpoqaHanSansNeo(size: 12, weight: .bold)
                    .foregroundStyle(Color.red.opacity(0.6))
            }
            
            Spacer()
            
            HStack(alignment: .center, spacing: 0) {
                Image(tempItem.weatherImage)
                    .resizable()
                    .frame(width: 34, height: 34)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(" \(tempItem.currentTemp)°")
                        .fontSpoqaHanSansNeo(size: 18, weight: .medium)
                        .foregroundStyle(Color.white)
                    
                    Text("\(tempItem.minMaxTemp.0)°/\(tempItem.minMaxTemp.1)°")
                        .fontSpoqaHanSansNeo(size: 12, weight: .regular)
                        .foregroundStyle(Color.white.opacity(0.7))
                }
            }
            .padding(.vertical, 12)
            .padding(.leading, 5)
            .padding(.trailing, 15)
            .loadingProgressLottie(isLoadingCompleted: 
                                    tempItem.currentTemp != "" && 
                                   tempItem.minMaxTemp != ("", "")
                                   && tempItem.weatherImage != ""
            )
        }
        .padding(.leading, 15)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(alignment: .topLeading) {
            if fullAddress == currentLocation {
                Image("current_location")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .offset(y: -8)
            }
        }
        .onTapGesture {
            finalLocationOnTapGesture(
                fullAddress,
                locality,
                subLocality,
                false
            )
        }
    }
}

#Preview {
    AdditionalLocationSavedGPSItemView(
        fullAddress: "",
        locality: "",
        subLocality: "",
        tempItem: .init(weatherImage: "", currentTemp: "", minMaxTemp: ("", "")),
        currentLocation: "",
        finalLocationOnTapGesture: {_, _, _, _ in }
    )
}
