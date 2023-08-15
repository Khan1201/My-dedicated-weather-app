//
//  MainTabView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/21.
//

import SwiftUI

struct MainTabView: View {
    @State var currentTab: TabBarType = .current
    @State var isLoading: Bool = true
    
    var body: some View {
                
        VStack(alignment: .leading, spacing: 0) {
            
            ZStack(alignment: .center) {
                if isLoading {
                    Text("로딩중 입니다.")
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                isLoading = false
                            }
                        }
                }
                
                TabView(selection: $currentTab) {
                    TodayViewController()
                        .tag(TabBarType.current)
                    
                    WeekViewController()
                        .tag(TabBarType.forecast)

                }
                .overlay(alignment: .bottom) {
                    CustomBottomTabBarView(currentTab: $currentTab)
                }
                .opacity(isLoading ? 0 : 1)
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
