//
//  ContentView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import SwiftUI

struct ContentView: View {
    @State private var currentTab: TabBarType = .current
    @State private var isLoading: Bool = true
    @State private var disableTabBarTouch: Bool = true
    @State private var showNoticePopup: Bool = false
    
    func tabBarItemOnTapGesture(_ type: TabBarType) {
        
        if disableTabBarTouch {
            showNoticePopup = true
            
        } else {
            currentTab = type
        }
    }
    
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
                    CurrentWeatherView(disableTabBarTouch: $disableTabBarTouch)
                        .tag(TabBarType.current)
                    
                    WeeklyWeatherView()
                        .tag(TabBarType.forecast)

                }
                .overlay(alignment: .bottom) {
                    CustomBottomTabBarView(currentTab: $currentTab, disableTabBarTouch: $disableTabBarTouch, itemOnTapGesture: tabBarItemOnTapGesture(_:))
                }
                .opacity(isLoading ? 0 : 1)
                .bottomNoticeFloater(
                    isPresented: $showNoticePopup,
                    view: BottomNoticeFloaterView(
                        title: "현재 날씨 로딩후에 접근 가능합니다."
                    )
                )
                .onAppear {
                    UITabBar.appearance().barTintColor = .clear
                }
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
