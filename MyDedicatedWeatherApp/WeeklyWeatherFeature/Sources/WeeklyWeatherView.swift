//
//  WeeklyWeatherView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/24.
//

import SwiftUI
import Domain
import Core

public struct WeeklyWeatherView: View {
    
    @StateObject var viewModel: WeeklyWeatherVM = DI.weeklyWeatherVM()
    @EnvironmentObject var contentEO: ContentEO
    @EnvironmentObject var currentLocationEO: CurrentLocationEO
    
    @State private var graphOpacity: CGFloat = 0
    
    public init() {}
    
    public var body: some View {
        let currentDate: Date = Date()
        
        VStack(alignment: .leading, spacing: 0) {
            CurrentLocationAndDateView(
                location: currentLocationEO.currentLocationStore.state.locality,
                subLocation: currentLocationEO.currentLocationStore.state.subLocality,
                showRefreshButton: viewModel.isAllLoaded,
                openAdditionalLocationView: .constant(false),
                showLocationAddButton: false,
                refreshButtonOnTapGesture: viewModel.refreshButtonOnTapGesture(locationInf:)
            )
            .padding(.leading, 24)
            .padding(.top, 35)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 15) {
                        ForEach(viewModel.weeklyWeatherInformations.indices, id: \.self) { index in
                            WeekWeatherItemView(
                                item: viewModel.weeklyWeatherInformations[index],
                                day: currentDate.toString(byAdding: index + 1, format: "EE요일")
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    if viewModel.isAllLoaded {
                        VStack(alignment: .leading, spacing: 0) {
                            LineChartView(weeklyChartInformation: viewModel.weeklyChartInformation)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.leading, 30)
                                .padding(.top, 16)
                                .padding(.bottom, 70)
                                .opacity(graphOpacity)
                                .background {
                                    Color.black.opacity(0.2)
                                }
                                .cornerRadius(14)
                                .onAppear {
                                    withAnimation(.easeOut(duration: 0.4)) {
                                        graphOpacity = 1
                                    }
                                }
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 25)
                        .padding(.bottom, 65)
                    }
                }
                .loadingProgressLottie(isLoadingCompleted: viewModel.isAllLoaded, height: 400)
            }
            .padding(.top, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .weeklyWeatherViewBackground(
            isDayMode: currentLocationEO.currentLocationStore.state.isDayMode,
            skyType: currentLocationEO.currentLocationStore.state.skyType
        )
        .bottomNoticeFloater(
            isPresented: $viewModel.isNetworkFloaterPresented,
            view: BottomNoticeFloaterView(
                title: viewModel.networkFloaterMessage
            )
        )
        .onChange(of: currentLocationEO.currentLocationStore.state.isLocationUpdated) { newValue in
            if newValue {
                viewModel.refreshButtonOnTapGesture(locationInf: currentLocationEO.currentLocationStore.state.locationInf)
            }
        }
        .task(priority: .userInitiated) {
//            viewModel.currentLocationEODelegate = currentLocationEO
            viewModel.viewOnAppearAction(
                locationInf: currentLocationEO.currentLocationStore.state.locationInf
            )
        }
    }
}
