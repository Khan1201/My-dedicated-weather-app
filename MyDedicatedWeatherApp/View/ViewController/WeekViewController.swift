//
//  WeekViewController.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/24.
//

import SwiftUI

struct WeekViewController: View {
    
    @StateObject var viewModel: WeekViewModel = WeekViewModel()
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            LottieView(jsonName: "BackgroundRainyLottie", loopMode: .loop)
                .frame(width: 375, height: 500, alignment: .center)
        }
        .background {
            Color.blue
        }
        .task {
            await viewModel.performWeekRequests()
        }
    }
}

struct WeekViewController_Previews: PreviewProvider {
    static var previews: some View {
        WeekViewController()
    }
}
