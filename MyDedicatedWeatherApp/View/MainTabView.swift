//
//  MainTabView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/21.
//

import SwiftUI

struct MainTabView: View {
    
    @State var currentTab: TabBarType = .current
    
    var body: some View {
                
        VStack(alignment: .leading, spacing: 0) {
            TabView(selection: $currentTab) {
                HomeViewController()
                    .tag(TabBarType.current)
                
                Text("gdgd")
                    .tag(TabBarType.forecast)
            }
            .overlay(alignment: .bottom) {
                CustomBottomTabBarView(currentTab: $currentTab)
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
