//
//  AdditionalLocationSubLocalityListView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/23/23.
//

import SwiftUI
import Domain
import Core

struct AdditionalLocationSubLocalityListView: View {
    @Binding var isPresented: Bool
    @Binding var progress: AdditionalLocationProgress
    let selectedLocality: String
    let selectedLocalityAndGu: String
    let finalLocationOnTapGesture: (LocationInformation, Bool) -> Void
    
    @State private var showFailFloater: Bool = false
    
    var body: some View {
        let filtedData: [String] = KoreaLocationList.allDatas.filter { $0.contains(selectedLocalityAndGu) }.sorted()
        let isLoading: Bool = progress == .loading
        
        ZStack(alignment: .center) {
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
                                finalLocationOnTapGesture(
                                    .init(
                                        longitude: "",
                                        latitude: "",
                                        xy: ("", ""),
                                        locality: selectedLocality,
                                        subLocality: subLocality,
                                        fullAddress: fullAddress
                                    ),
                                    true
                                )
                            }
                    }
                }
            }
            .opacity(isLoading ? 0.4 : 1)
            .allowsHitTesting(!isLoading)
            
            if isLoading {
                ProgressView()
            }
        }
        .preferredColorScheme(.dark)
        .onChange(of: progress) { newValue in
            if newValue == .notFound {
                showFailFloater = true
            }
        }
        .onChange(of: showFailFloater) { newValue in
            if !newValue {
                progress = .none
            }
        }
        .bottomNoticeFloater(
            isPresented: $showFailFloater,
            view: BottomNoticeFloaterView(title: "해당 위치에 대한 정보가 없습니다.")
        )
        .onDisappear {
            progress = .none
        }
    }
}

#Preview {
    AdditionalLocationSubLocalityListView(
        isPresented: .constant(true),
        progress: .constant(.none),
        selectedLocality: "",
        selectedLocalityAndGu: "",
        finalLocationOnTapGesture: {_, _ in }
    )
}
