//
//  AdditionalLocationSubLocalityListView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/23/23.
//

import SwiftUI

struct AdditionalLocationSubLocalityListView: View {
    @Binding var isPresented: Bool
    let selectedLocalityAndGu: String

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
                            isPresented = false
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
        selectedLocalityAndGu: ""
    )
}
