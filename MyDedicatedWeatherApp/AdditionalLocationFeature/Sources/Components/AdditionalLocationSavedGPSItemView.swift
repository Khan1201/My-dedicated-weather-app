//
//  AdditionalLocationSavedGPSItemView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/7/23.
//

import SwiftUI
import Domain

struct AdditionalLocationSavedGPSItemView: View {
    let locationInf: LocationInformation
    let tempItem: Weather.WeatherImageAndMinMax
    let currentLocation: String
    let fetchNewLocation: (LocationInformation, Bool) -> Void

    @State private var tempSize: CGSize = CGSize()

    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text(locationInf.fullAddress)
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
                
                VStack(alignment: .center, spacing: 2) {
                    Text(" \(tempItem.currentTemp)°")
                        .fontSpoqaHanSansNeo(size: 18, weight: .medium)
                        .foregroundStyle(Color.white)
                    
                    Text("\(tempItem.minMaxTemp.0)°/\(tempItem.minMaxTemp.1)°")
                        .fontSpoqaHanSansNeo(size: 12, weight: .regular)
                        .foregroundStyle(Color.white.opacity(0.7))
                }
                .frame(maxWidth: tempSize.width)
            }
            .padding(.vertical, 12)
            .padding(.leading, 5)
            .padding(.trailing, 8)
            .loadingProgressLottie(
                isLoadingCompleted: tempItem.currentTemp != "" &&
                tempItem.minMaxTemp != ("", "")
                && tempItem.weatherImage != "",
                width: 65,
                height: 65
                                   
            )
        }
        .padding(.leading, 15)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(alignment: .topLeading) {
            if locationInf.fullAddress == currentLocation {
                Image("current_location")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .offset(y: -8)
            }
        }
        .overlay {
            VStack(alignment: .leading, spacing: 2) {
                Text(" -00°")
                    .fontSpoqaHanSansNeo(size: 18, weight: .medium)
                    .foregroundStyle(Color.white)
                
                Text("-00°/-0°")
                    .fontSpoqaHanSansNeo(size: 12, weight: .regular)
                    .foregroundStyle(Color.white.opacity(0.7))
            }
            .getSize(size: $tempSize)
            .opacity(0)
        }
        .onTapGesture {
            fetchNewLocation(
                locationInf,
                false
            )
        }
    }
}
