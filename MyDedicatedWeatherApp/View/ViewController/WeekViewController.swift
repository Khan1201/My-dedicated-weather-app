//
//  WeekViewController.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/24.
//

import SwiftUI

struct WeekViewController: View {
    @StateObject var viewModel: WeekViewModel = WeekViewModel(weeklyWeatherInformations: Dummy().weeklyWeatherInformations())
    @State private var graphOpacity: CGFloat = 0
    
    var body: some View {
        let currentDate: Date = Date()
        
        VStack(alignment: .leading, spacing: 0) {
            CurrentLocationAndDateView(
                location: UserDefaults.standard.string(forKey: "locality") ?? "",
                subLocation: UserDefaults.standard.string(forKey: "subLocality") ?? ""
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
                            LineChartView(temperatureChartInf: $viewModel.temperatureChartInformation)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.leading, 30)
                                .padding(.top, 16)
                                .padding(.bottom, 50)
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
                .loadingProgressLottie(isLoadingCompleted: viewModel.isWeeklyWeatherInformationsLoaded)
            }
            .padding(.top, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .weekViewControllerBackground(
            isDayMode: UserDefaults.standard.bool(forKey: "isDayMode"),
            skyKeyword: UserDefaults.standard.string(forKey: "skyKeyword") ?? ""
        )
        .task {
            await viewModel.performWeekRequests()
        }
    }
}

struct WeekViewController_Previews: PreviewProvider {
    static var previews: some View {
        WeekViewController(viewModel: WeekViewModel(weeklyWeatherInformations: Dummy.shared.weeklyWeatherInformations()))
    }
}
