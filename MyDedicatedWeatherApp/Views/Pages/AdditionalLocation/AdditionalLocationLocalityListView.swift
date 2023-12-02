//
//  AdditionalLocationLocalityListView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/23/23.
//

import SwiftUI

struct AdditionalLocationLocalityListView: View {
    @Binding var isPresented: Bool
    @Binding var progress: AdditionalLocationProgress
    let subLocalityOnTapGesture: (String, String, String) -> Void
    
    @State private var navNextView: Bool = false
    @State private var selectedLocality: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CustomNavigationBar(
                isPresented: $isPresented,
                isNavigationUsed: false
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
                progress: $progress,
                selectedLocality: selectedLocality,
                subLocalityOnTapGesture: subLocalityOnTapGesture
            )
        )
    }
}

#Preview {
    AdditionalLocationLocalityListView(
        isPresented: .constant(true), 
        progress: .constant(.none),
        subLocalityOnTapGesture: {_, _, _ in }
    )
}