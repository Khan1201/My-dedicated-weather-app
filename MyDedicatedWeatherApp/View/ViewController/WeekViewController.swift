//
//  WeekViewController.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/24.
//

import SwiftUI

struct WeekViewController: View {
    @StateObject var viewModel: WeekViewModel = WeekViewModel(weeklyWeatherInformations: [])
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 15) {
                ForEach(viewModel.weeklyWeatherInformations, id: \.id) {
                    WeekWeatherItemView(item: $0)
                }
            }
        }
        .background {
            
        }
        .task {
            await viewModel.performWeekRequests()
        }
    }
}

struct WeekViewController_Previews: PreviewProvider {
    static var previews: some View {
        WeekViewController(viewModel: WeekViewModel(weeklyWeatherInformations: Dummy.shared.weeklyWeatherInformations()))
            .onAppear {
                
            }
    }
}
