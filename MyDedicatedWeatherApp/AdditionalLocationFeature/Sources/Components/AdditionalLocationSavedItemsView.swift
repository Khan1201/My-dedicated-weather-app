//
//  AdditionalLocationSavedItemsView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/2/23.
//

import SwiftUI
import Domain

struct AdditionalLocationSavedItemsView: View {
    let currentFullAddress: String
    let locationInfs: [LocationInformation]
    let tempItems: [Weather.WeatherImageAndMinMax]
    let fetchNewLocation: (LocationInformation, Bool) -> Void
    let itemDeleteAction: (LocationInformation) -> Void
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            ForEach(locationInfs.indices, id: \.self) { i in
                AdditionalLocationSavedItemView(
                    locationInf: locationInfs[i],
                    tempItem: tempItems[i],
                    onTapGesture: fetchNewLocation,
                    deleteAction: itemDeleteAction
                )
                .overlay(alignment: .topLeading) {
                    if currentFullAddress == locationInfs[i].fullAddress {
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
        locationInfs: [],
        tempItems: [],
        fetchNewLocation: { _, _ in },
        itemDeleteAction: { _ in }
    )
}


