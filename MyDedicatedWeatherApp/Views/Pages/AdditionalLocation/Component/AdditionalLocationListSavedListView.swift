//
//  AdditionalLocationSavedListView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/2/23.
//

import SwiftUI

struct AdditionalLocationSavedListView: View {
    let fullAddresses: [String]
    let localities: [String]
    let subLocalities: [String]
    let tempItems: [Weather.WeatherImageAndMinMax]
    let itemOnTapGesture: ((String, String, String, Bool) -> Void)
    let itemDeleteAction: (String, String, String) -> Void
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            ForEach(fullAddresses.indices, id: \.self) { i in
                AdditionalLocationSavedListItemView(
                    fullAddress: fullAddresses[i],
                    locality: localities[i],
                    subLocality: subLocalities[i],
                    tempItem: tempItems[i],
                    onTapGesture: itemOnTapGesture,
                    deleteAction: itemDeleteAction
                )
            }
        }
    }
}

#Preview {
    AdditionalLocationSavedListView(
        fullAddresses: [],
        localities: [],
        subLocalities: [],
        tempItems: [],
        itemOnTapGesture: { _, _, _, _ in }, 
        itemDeleteAction: {_, _, _ in }
    )
}

struct AdditionalLocationSavedListItemView: View {
    let fullAddress: String
    let locality: String
    let subLocality: String
    let tempItem: Weather.WeatherImageAndMinMax
    let onTapGesture: ((String, String, String, Bool) -> Void)
    let deleteAction: (String, String, String) -> Void
    
    @State private var isDeleteMode: Bool = false
    @State private var itemSize: CGSize = CGSize()
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            Text(fullAddress)
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
            .padding(.vertical, 12)
            .padding(.leading, 5)
            .padding(.trailing, 15)
            .loadingProgressLottie(isLoadingCompleted: tempItem.currentTemp != "" && tempItem.minMaxTemp != ("", ""))
            
            if isDeleteMode {
                VStack(alignment: .leading, spacing: 0) {
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 70, height: itemSize.height)
                        .overlay {
                            Text("삭제")
                                .fontSpoqaHanSansNeo(size: 14, weight: .medium)
                                .foregroundStyle(Color.white)
                        }
                }
                .transition(.move(edge: .trailing))
                .onTapGesture {
                    deleteAction(fullAddress, locality, subLocality)
                    isDeleteMode = false
                }
            }
        }
        .padding(.leading, 15)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .getSize(size: $itemSize)
        .onTapGesture {
            if isDeleteMode {
                withAnimation(.easeIn(duration: 0.15)) {
                    isDeleteMode = false
                }
                
            } else {
                onTapGesture(fullAddress, locality, subLocality, false)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.width < 0 {
                        withAnimation(.easeIn(duration: 0.15)) {
                            isDeleteMode = true
                        }
                        
                    } else {
                        withAnimation(.easeIn(duration: 0.15)) {
                            isDeleteMode = false
                        }
                    }
                }
        )
    }
}
