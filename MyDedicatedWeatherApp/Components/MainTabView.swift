//
//  ContentView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import SwiftUI
import Core
import Domain
import CurrentWeatherFeature
import WeeklyWeatherFeature
import SettingFeature

struct MainTabView: View {
    
    @EnvironmentObject var vm: ContentEO
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            ZStack(alignment: .center) {
                if vm.isLaunchScreenPresented {
                    LaunchScreen()
                        .onAppear {
                            vm.hideLaunchScreenAfterFewSeconds()
                        }
                }
                
                TabView(selection: $vm.currentTab) {
                    CurrentWeatherView()
                        .tag(TabBarType.current)
                    
                    if vm.currentTab == .week {
                        WeeklyWeatherView()
                            .tag(TabBarType.week)
                    }
                    
                    if vm.currentTab == .setting {
                        RootNavigationView(
                            view: SettingView()
                        )
                        .tag(TabBarType.setting)
                    }
                }
                .overlay(alignment: .bottom) {
                    CustomBottomTabBarView(
                        currentTab: vm.currentTab,
                        itemOnTapGesture: vm.tabBarItemOnTapGesture(_:)
                    )
                }
                .opacity(vm.isLaunchScreenPresented ? 0 : 1)
                .bottomNoticeFloater(
                    isPresented: $vm.isTabBarTouchNoticeFloaterPresented,
                    view: BottomNoticeFloaterView(
                        title: "현재 날씨 로딩후에 접근 가능합니다."
                    )
                )
                .onAppear {
                    UITabBar.appearance().backgroundImage = UIImage()
                    UITabBar.appearance().shadowImage = UIImage()
                    UITabBar.appearance().clipsToBounds = true
                }
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
