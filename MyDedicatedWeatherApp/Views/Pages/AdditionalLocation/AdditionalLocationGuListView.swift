//
//  AdditionalLocationGuListView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/23/23.
//

import SwiftUI

struct AdditionalLocationGuListView: View {
    @Binding var isPresented: Bool
    let selectedLocality: String
    
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
                            selectedLocalityAndGu = selectedLocality + " " + gu + " "
                            navNextView = true
                        }
                }
            }
        }
        .preferredColorScheme(.dark)
        .navToNextView(
            isPresented: $navNextView,
            view: AdditionalLocationSubLocalityListView(
                isPresented: $isPresented,
                selectedLocalityAndGu: selectedLocalityAndGu
            )
        )
    }
}

#Preview {
    AdditionalLocationGuListView(
        isPresented: .constant(true),
        selectedLocality: ""
    )
}
