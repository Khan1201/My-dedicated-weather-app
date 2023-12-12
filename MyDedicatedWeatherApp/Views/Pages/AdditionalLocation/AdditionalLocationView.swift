//
//  AdditionalLocationView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/2/23.
//

import SwiftUI

struct AdditionalLocationView: View {
    @Binding var isPresented: Bool
    @Binding var progress: AdditionalLocationProgress
    let finalLocationOnTapGesture: (String, String, String, Bool) -> Void
    
    @StateObject var vm: AdditionalLocationVM = AdditionalLocationVM()
    @EnvironmentObject var currentLocationVM: CurrentLocationVM

    @State private var navNextView: Bool = false
    
    
    var body: some View {
        let isLoading: Bool = progress == .loading
        
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                CustomNavigationBar(
                    isPresented: $isPresented,
                    isNavigationUsed: false,
                    title: "추가 위치"
                )
                .padding(.top, 10)
                
                /// 현재 gps item
                AdditionalLocationSavedGPSItemView(
                    fullAddress: currentLocationVM.gpsFullAddress,
                    locality: currentLocationVM.gpsLocality,
                    subLocality: currentLocationVM.gpsSubLocality,
                    tempItem: vm.gpsTempItem,
                    currentLocation: currentLocationVM.fullAddress,
                    finalLocationOnTapGesture: finalLocationOnTapGesture
                )
                .padding(.top, 20)
                .padding(.horizontal, 20)

                /// 추가 등록 items
                AdditionalLocationSavedItemsView(
                    currentFullAddress: currentLocationVM.fullAddress,
                    fullAddresses: vm.fullAddresses,
                    localities: vm.localities,
                    subLocalities: vm.subLocalities,
                    tempItems: vm.tempItems,
                    itemOnTapGesture: finalLocationOnTapGesture, 
                    itemDeleteAction: vm.itemDeleteAction(fullAddress:locality:subLocality:)
                )
                .padding(.top, 16)
                .padding(.horizontal, 20)
                
                HStack(alignment: .center, spacing: 5) {
                    Image(systemName: "plus.magnifyingglass")
                        .resizable()
                        .frame(width: 15, height: 15)
                    
                    Text("추가하기")
                        .fontSpoqaHanSansNeo(size: 15, weight: .medium)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 25)
                .onTapGesture {
                    navNextView = true
                }
                
                Spacer()
            }
            .opacity(isLoading ? 0.4 : 1)
            
            if isLoading {
                ProgressView()
            }
        }
        .preferredColorScheme(.dark)
        .background(Color.black)
        .task {
            vm.additinalLocationViewTaskAction(gpsFullAddress: currentLocationVM.gpsFullAddress)
        }
        .navToNextView(
            isPresented: $navNextView,
            view: AdditionalLocationLocalityListView(
                isPresented: $isPresented,
                progress: $progress,
                finalLocationOnTapGesture: finalLocationOnTapGesture
            )
        )
    }
}

#Preview {
    AdditionalLocationView(
        isPresented: .constant(true),
        progress: .constant(.none),
        finalLocationOnTapGesture: {_, _, _, _ in }
    )
}
