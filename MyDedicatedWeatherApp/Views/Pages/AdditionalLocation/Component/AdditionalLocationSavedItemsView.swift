//
//  AdditionalLocationSavedItemsView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/2/23.
//

import SwiftUI

struct AdditionalLocationSavedItemsView: View {
    let currentFullAddress: String
    let allLocalities: [AllLocality]
    let tempItems: [Weather.WeatherImageAndMinMax]
    let itemOnTapGesture: (AllLocality, Bool) -> Void
    let itemDeleteAction: (AllLocality) -> Void
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            ForEach(allLocalities.indices, id: \.self) { i in
                AdditionalLocationSavedItemView(
                    allLocality: allLocalities[i],
                    tempItem: tempItems[i],
                    onTapGesture: itemOnTapGesture,
                    deleteAction: itemDeleteAction
                )
                .overlay(alignment: .topLeading) {
                    if currentFullAddress == allLocalities[i].fullAddress {
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
        allLocalities: [],
        tempItems: [],
        itemOnTapGesture: { _, _ in },
        itemDeleteAction: { _ in }
    )
}


