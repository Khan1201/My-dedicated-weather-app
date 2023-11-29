//
//  AdditionalLocationGuListView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/23/23.
//

import SwiftUI

struct AdditionalLocationGuListView: View {
    @Binding var isPresented: Bool
    @Binding var progress: AdditionalLocationProgress
    let selectedLocality: String
    let subLocalityOnTapGesture: (String, String, String) -> Void

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
                                subLocalityOnTapGesture(fullAddress, selectedLocality, gu)
                                
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
                progress: $progress,
                selectedLocality: selectedLocality,
                selectedLocalityAndGu: selectedLocalityAndGu,
                subLocalityOnTapGesture: subLocalityOnTapGesture
            )
        )
    }
}

#Preview {
    AdditionalLocationGuListView(
        isPresented: .constant(true),
        progress: .constant(.none),
        selectedLocality: "",
        subLocalityOnTapGesture: {_, _, _ in }
    )
}
