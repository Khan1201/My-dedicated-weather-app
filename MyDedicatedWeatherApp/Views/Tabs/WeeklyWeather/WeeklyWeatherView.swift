//
//  WeeklyWeatherView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/24.
//

import SwiftUI

struct WeeklyWeatherView: View {
    
    @StateObject var viewModel: WeeklyWeatherVM = WeeklyWeatherVM(weeklyWeatherInformations: Dummy().weeklyWeatherInformations())
    @EnvironmentObject var contentVM: ContentVM
    @EnvironmentObject var currentLocationVM: CurrentLocationVM
    
    @State private var graphOpacity: CGFloat = 0
    
    var body: some View {
        let currentDate: Date = Date()
        
        VStack(alignment: .leading, spacing: 0) {
            CurrentLocationAndDateView(
                location: currentLocationVM.locality,
                subLocation: currentLocationVM.subLocality,
                showRefreshButton: viewModel.isWeeklyWeatherInformationsLoaded,
                openAdditionalLocationView: .constant(false),
                showLocationAddButton: false,
                refreshButtonOnTapGesture: {
                    viewModel.refreshButtonOnTapGesture(
                        xy: currentLocationVM.xy,
                        fullAddress: currentLocationVM.fullAddress
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
                .overlay(alignment: .bottom) {
                    Text("재시도")
                        .fontSpoqaHanSansNeo(size: 20, weight: .bold)
                        .foregroundStyle(Color.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(Color.blue.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .onTapGesture {
                            viewModel.retryButtonOnTapGesture(
                                xy: currentLocationVM.xy,
                                fullAddress: currentLocationVM.fullAddress
                            )
                        }
                        .opacity(viewModel.showLoadRetryButton ? 1 : 0)
                }
            }
            .padding(.top, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .weekViewControllerBackground(
            isDayMode: contentVM.isDayMode,
            skyKeyword: contentVM.skyKeyword
        )
        .bottomNoticeFloater(
            isPresented: $viewModel.showRetryFloaterAlert,
            view: BottomNoticeFloaterView(
                title: """
                재시도 합니다.
                기상청 서버 네트워크에 따라 속도가 느려질 수 있습니다 :)
                """
            )
        )
        .onChange(of: contentVM.isRefreshed) { newValue in
            viewModel.isRefreshedOnChangeAction(newValue)
        }
        .onChange(of: contentVM.isLocationChanged) { newValue in
            contentVM.isLocationChanged = false
            if newValue {
                viewModel.isWeeklyWeatherInformationsLoaded = false
            }
        }
        .task(priority: .userInitiated) {
            viewModel.weeklyWeatherViewTaskAction(
                xy: currentLocationVM.xy,
                fullAddress: currentLocationVM.fullAddress
            )
        }
    }
}

struct WeekViewController_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyWeatherView(viewModel: WeeklyWeatherVM(weeklyWeatherInformations: Dummy.shared.weeklyWeatherInformations()))
    }
}
