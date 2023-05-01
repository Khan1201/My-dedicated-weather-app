//
//  HomeView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel: HomeViewModel = HomeViewModel()
    @State var test: String = ""
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 10) {
                
                ForEach(homeViewModel.threeToTenDaysTemperature, id: \.id) {
                    HomeViewMinMaxTemperatureVC(
                        day: $0.day,
                        min: $0.minMax.0,
                        max: $0.minMax.1
                    )
                }
            }
        }
        .task {
            await homeViewModel.requestMidTermForecastItems()
        }
            
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
