//
//  AdditionalLocationLocalityListView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/23/23.
//

import SwiftUI
import Domain
import Core

struct AdditionalLocationLocalityListView: View {
    @Binding var isPresented: Bool
    let finalLocationOnTapGesture: (LocationInformation, Bool) -> Void
    
    @State private var navNextView: Bool = false
    @State private var selectedLocality: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomNavigationBar(
                isPresented: .constant(false),
                isNavigationUsed: true
            )
            .padding(.top, 10)

            List {
                ForEach(KoreaLocationList.localities, id: \.self) { locality in
                    Text(locality)
                        .onTapGesture {
                            selectedLocality = locality
                            navNextView = true
                        }
                }
            }
        }
        .preferredColorScheme(.dark)
        .navToNextView(
            isPresented: $navNextView,
            view: AdditionalLocationGuListView(
                isPresented: $isPresented, 
                selectedLocality: selectedLocality,
                finalLocationOnTapGesture: finalLocationOnTapGesture
            )
        )
    }
}

#Preview {
    AdditionalLocationLocalityListView(
        isPresented: .constant(true), 
        finalLocationOnTapGesture: {_, _ in }
    )
}
