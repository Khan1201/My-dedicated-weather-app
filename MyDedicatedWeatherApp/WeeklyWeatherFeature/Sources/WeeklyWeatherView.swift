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
    
    @StateObject var viewModel: WeeklyWeatherVM = WeeklyWeatherVM()
    @EnvironmentObject var contentVM: ContentVM
    @EnvironmentObject var currentLocationEO: CurrentLocationEO
    
    @State private var graphOpacity: CGFloat = 0
    
    public init() {}
    
    public var body: some View {
        let currentDate: Date = Date()
        
        VStack(alignment: .leading, spacing: 0) {
            CurrentLocationAndDateView(
                location: currentLocationEO.locality,
                subLocation: currentLocationEO.subLocality,
                showRefreshButton: viewModel.isWeeklyWeatherInformationsLoaded,
                openAdditionalLocationView: .constant(false),
                showLocationAddButton: false,
                refreshButtonOnTapGesture: {
                    viewModel.refreshButtonOnTapGesture(
                        xy: currentLocationEO.xy,
                        fullAddress: currentLocationEO.fullAddress
                    )
                }
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
                    
                    if viewModel.isWeeklyWeatherInformationsLoaded {
                        VStack(alignment: .leading, spacing: 0) {
                            LineChartView(weeklyChartInformation: $viewModel.weeklyChartInformation)
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
                .loadingProgressLottie(isLoadingCompleted: viewModel.isWeeklyWeatherInformationsLoaded, height: 400)
            }
            .padding(.top, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .weekViewControllerBackground(
            isDayMode: contentVM.isDayMode,
            skyType: contentVM.skyType
        )
        .bottomNoticeFloater(
            isPresented: $viewModel.showNoticeFloater,
            view: BottomNoticeFloaterView(
                title: viewModel.noticeMessage
            ),
            duration: 3
        )
        .onChange(of: viewModel.retryInitialReq) { newValue in
            if newValue {
                viewModel.retryAndShowNoticeFloater(
                    xy: currentLocationEO.xy,
                    fullAddress: currentLocationEO.fullAddress
                )
            }
        }
        .onChange(of: contentVM.isRefreshed) { newValue in
            viewModel.isRefreshedOnChangeAction(newValue)
        }
        .onChange(of: contentVM.isLocationChanged) { newValue in
            contentVM.isLocationChanged = false
            if newValue {
                viewModel.isWeeklyWeatherInformationsLoaded = false
            }
        }
        .onChange(of: viewModel.isShortTermForecastLoaded && viewModel.isMidtermForecastTempLoaded && viewModel.isMidtermForecastSkyStateLoaded) { newValue in
            viewModel.loadedVariablesOnChangeAction(newValue)
        }
        .task(priority: .userInitiated) {
            viewModel.weeklyWeatherViewTaskAction(
                xy: currentLocationEO.xy,
                fullAddress: currentLocationEO.fullAddress
            )
        }
    }
}
