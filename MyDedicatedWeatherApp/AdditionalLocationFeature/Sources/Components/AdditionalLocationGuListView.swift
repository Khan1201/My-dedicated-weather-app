//
//  AdditionalLocationGuListView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/23/23.
//

import SwiftUI
import Domain
import Core

struct AdditionalLocationGuListView: View {
    @Binding var isPresented: Bool
    let selectedLocality: String
    let finalLocationOnTapGesture: (LocationInformation, Bool) -> Void

    @State private var navNextView: Bool = false
    @State private var selectedLocalityAndGu: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomNavigationBar(
                isPresented: $isPresented,
                isNavigationUsed: true
            )
            .padding(.top, 10)

            List {
                ForEach(KoreaLocationList.guList[selectedLocality] ?? [], id: \.self) { gu in
                    Text(gu)
                        .onTapGesture {
                            if selectedLocality == "세종특별자치시" {
                                let fullAddress: String = selectedLocality + " \(gu)"
                                finalLocationOnTapGesture(
                                    .init(
                                        locality: selectedLocality,
                                        subLocality: gu,
                                        fullAddress: fullAddress
                                    ),
                                    true
                                )
                                
                            } else {
                                selectedLocalityAndGu = selectedLocality + " " + gu + " "
                                navNextView = true
                            }
                            
                        }
                }
            }
        }
        .preferredColorScheme(.dark)
        .navToNextView(
            isPresented: $navNextView,
            view: AdditionalLocationSubLocalityListView(
                isPresented: $isPresented, 
                selectedLocality: selectedLocality,
                selectedLocalityAndGu: selectedLocalityAndGu,
                finalLocationOnTapGesture: finalLocationOnTapGesture
            )
        )
    }
}

#Preview {
    AdditionalLocationGuListView(
        isPresented: .constant(true),
        selectedLocality: "",
        finalLocationOnTapGesture: {_, _ in }
    )
}
