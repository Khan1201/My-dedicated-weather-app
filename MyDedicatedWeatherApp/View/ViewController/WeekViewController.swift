//
//  WeekViewController.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/24.
//

import SwiftUI

struct WeekViewController: View {
    @StateObject var viewModel: WeekViewModel = WeekViewModel(weeklyWeatherInformations: Dummy().weeklyWeatherInformations())
    
    var body: some View {
        let currentDate: Date = Date()
        
        VStack(alignment: .leading, spacing: 0) {
            CurrentLocationAndDateView(
                location: UserDefaults.standard.string(forKey: "locality") ?? "",
                subLocation: UserDefaults.standard.string(forKey: "subLocality") ?? ""
            )
            .padding(.leading, 10)
            .padding(.top, 35)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(viewModel.weeklyWeatherInformations.indices, id: \.self) { index in
                        WeekWeatherItemView(
                            item: viewModel.weeklyWeatherInformations[index],
                            day: currentDate.toString(byAdding: index + 1, format: "EE요일")
                        )
                        .padding(.bottom, index == viewModel.weeklyWeatherInformations.count - 1 ? 45 : 0)
                    }
                }
                .loadingProgressLottie(isLoadingCompleted: viewModel.isWeeklyWeatherInformationsLoaded)
            }
            .padding(.top, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
