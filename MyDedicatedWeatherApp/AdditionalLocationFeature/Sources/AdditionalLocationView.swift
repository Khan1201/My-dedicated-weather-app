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
    let fetchNewLocation: (LocationInformation, Bool) -> Void
    
    @StateObject var vm: AdditionalLocationVM = DI.additionalLocationVM()
    @EnvironmentObject var currentLocationEO: CurrentLocationEO
    
    @State private var navNextView: Bool = false
    
    public init(isPresented: Binding<Bool>, fetchNewLocation: @escaping (LocationInformation, Bool) -> Void) {
        self._isPresented = isPresented
        self.fetchNewLocation = fetchNewLocation
    }
    
    public var body: some View {
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
                        locationInf: currentLocationEO.gpsLocationInf,
                        tempItem: vm.gpsTempItem,
                        currentLocation: currentLocationEO.fullAddress,
                        fetchNewLocation: fetchNewLocation
                    )
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    
                    /// 추가 등록 items
                    AdditionalLocationSavedItemsView(
                        currentFullAddress: currentLocationEO.fullAddress,
                        locationInfs: vm.locationInfs,
                        tempItems: vm.tempItems,
                        fetchNewLocation: fetchNewLocation,
                        itemDeleteAction: vm.deleteLocalLocationInf(locationInf:)
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
                finalLocationOnTapGesture: fetchNewLocation
            )
        )
    }
}
