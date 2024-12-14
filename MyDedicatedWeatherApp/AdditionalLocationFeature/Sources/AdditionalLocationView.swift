//
//  AdditionalLocationView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/2/23.
//

import SwiftUI
import Domain
import Core

public struct AdditionalLocationView: View {
    @Binding var isPresented: Bool
    @Binding var progress: AdditionalLocationProgress
    let finalLocationOnTapGesture: (AllLocality, Bool) -> Void // 주소 struct, isNewAdd
    
    @StateObject var vm: AdditionalLocationVM = AdditionalLocationVM()
    @EnvironmentObject var currentLocationEO: CurrentLocationEO
    
    @State private var navNextView: Bool = false
    
    public init(isPresented: Binding<Bool>, progress: Binding<AdditionalLocationProgress>, finalLocationOnTapGesture: @escaping (AllLocality, Bool) -> Void) {
        self._isPresented = isPresented
        self._progress = progress
        self.finalLocationOnTapGesture = finalLocationOnTapGesture
    }
    
    
    public var body: some View {
        let isLoading: Bool = progress == .loading
        
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                CustomNavigationBar(
                    isPresented: $isPresented,
                    isNavigationUsed: false,
                    title: "추가 위치"
                )
                .padding(.top, 10)
                
                ScrollView(.vertical, showsIndicators: false) {
                    /// 현재 gps item
                    AdditionalLocationSavedGPSItemView(
                        allLocality: .init(
                            fullAddress: currentLocationEO.gpsFullAddress,
                            locality: currentLocationEO.gpsLocality,
                            subLocality: currentLocationEO.gpsSubLocality
                        ),
                        tempItem: vm.gpsTempItem,
                        currentLocation: currentLocationEO.fullAddress,
                        finalLocationOnTapGesture: finalLocationOnTapGesture
                    )
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    
                    /// 추가 등록 items
                    AdditionalLocationSavedItemsView(
                        currentFullAddress: currentLocationEO.fullAddress,
                        allLocalities: vm.allLocalities,
                        tempItems: vm.tempItems,
                        itemOnTapGesture: finalLocationOnTapGesture,
                        itemDeleteAction: vm.itemDeleteAction(allLocality:)
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
            }
            .opacity(isLoading ? 0.4 : 1)
            .allowsHitTesting(!isLoading)
            
            if isLoading {
                ProgressView()
            }
        }
        .preferredColorScheme(.dark)
        .background(Color.black)
        .task {
            vm.additinalLocationViewTaskAction(gpsFullAddress: currentLocationEO.gpsFullAddress)
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
        finalLocationOnTapGesture: {_, _ in }
    )
}
