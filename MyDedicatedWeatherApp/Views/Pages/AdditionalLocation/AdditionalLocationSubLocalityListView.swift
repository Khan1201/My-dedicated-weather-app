//
//  AdditionalLocationSubLocalityListView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/23/23.
//

import SwiftUI

struct AdditionalLocationSubLocalityListView: View {
    @Binding var isPresented: Bool
    let selectedLocality: String
    let selectedLocalityAndGu: String
    let subLocalityOnTapGesture: (String, String, String) -> Void
    
    var body: some View {
        let filtedData: [String] = KoreaLocationList.allDatas.filter { $0.contains(selectedLocalityAndGu) }
        
        VStack(alignment: .leading, spacing: 0) {
            CustomNavigationBar(
                isPresented: $isPresented,
                isNavigationUsed: true
            )
            .padding(.top, 10)
            
            List {
                ForEach(filtedData, id: \.self) { data in
                    let index = data.index(data.startIndex, offsetBy: selectedLocalityAndGu.count)
                    Text(data[index...])
                        .onTapGesture {
                            let subLocality: String = String(data[index...])
                            let fullAddress: String = selectedLocalityAndGu + subLocality
                            subLocalityOnTapGesture(fullAddress, selectedLocality, subLocality)
                        }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    AdditionalLocationSubLocalityListView(
        isPresented: .constant(true),
        selectedLocality: "",
        selectedLocalityAndGu: "",
        subLocalityOnTapGesture: {_, _, _ in }
    )
}
