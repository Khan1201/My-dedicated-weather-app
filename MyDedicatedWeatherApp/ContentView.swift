//
//  ContentView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import SwiftUI

struct ContentView: View {
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
                    CurrentWeatherView()
                        .tag(TabBarType.current)
                    
                    WeeklyWeatherView()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
