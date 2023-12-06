//
//  AdditionalLocationSavedItemsView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/2/23.
//

import SwiftUI

struct AdditionalLocationSavedItemsView: View {
    let currentFullAddress: String
    let fullAddresses: [String]
    let localities: [String]
    let subLocalities: [String]
    let tempItems: [Weather.WeatherImageAndMinMax]
    let itemOnTapGesture: ((String, String, String, Bool) -> Void)
    let itemDeleteAction: (String, String, String) -> Void
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            ForEach(fullAddresses.indices, id: \.self) { i in
                AdditionalLocationSavedItemView(
                    fullAddress: fullAddresses[i],
                    locality: localities[i],
                    subLocality: subLocalities[i],
                    tempItem: tempItems[i],
                    onTapGesture: itemOnTapGesture,
                    deleteAction: itemDeleteAction
                )
                .overlay(alignment: .topLeading) {
                    if currentFullAddress == fullAddresses[i] {
                        Image("current_location")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .offset(y: -8)
                    }
                }
            }
        }
    }
}

#Preview {
    AdditionalLocationSavedItemsView(
        currentFullAddress: "서울특별시",
        fullAddresses: ["서울특별시", "대구광역시"],
        localities: [],
        subLocalities: [],
        tempItems: [],
        itemOnTapGesture: { _, _, _, _ in },
        itemDeleteAction: {_, _, _ in }
    )
}


