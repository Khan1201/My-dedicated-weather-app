//
//  CustomBottomTabBarView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/21.
//

import SwiftUI

struct CustomBottomTabBarView: View {
    
    @Binding var currentTab: TabBarType
    
    var body: some View {
        
        HStack(alignment: .bottom, spacing: 0) {
            
            tabBarItemView(
                imageString: "calender_today",
                title: "현재 날씨",
                currentTab: $currentTab,
                tabValue: .current
            )
            
            Spacer()
            
            tabBarItemView(
                imageString: "calender_forecast",
                title: "주간 예보",
                currentTab: $currentTab,
                tabValue: .forecast
            )
            
            Spacer()
            
            tabBarItemView(
                imageString: "search",
                title: "검색",
                currentTab: $currentTab,
                tabValue: .search
            )
            
            Spacer()
            
            tabBarItemView(
                imageString: "gear",
                title: "설정",
                currentTab: $currentTab,
                tabValue: .setting
            )
        }
        .padding(.horizontal, 24)
        .padding(.top, 15)
        .padding(.bottom, 27)
        .background(.white)
        .cornerRadius(25, corners: [.topLeft, .topRight])
    }
}

struct CustomBottomTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        CustomBottomTabBarView(currentTab: .constant(.current))
    }
}

// MARK: - Supporting View

extension CustomBottomTabBarView {
    
    func tabBarItemView(
        imageString: String,
        title: String,
        currentTab: Binding<TabBarType>,
        tabValue: TabBarType
    ) -> some View{
        
        return VStack(alignment: .center, spacing: 5) {
            
            Image(imageString)
                .resizable()
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Color.black.opacity(0.6))
        }
        .overlay(alignment: .top) {
            Image("check_blue")
                .resizable()
                .frame(width: 20, height: 20)
                .opacity(currentTab.wrappedValue == tabValue ? 1 : 0)
                .offset(y: -5)
        }
        .onTapGesture {
            currentTab.wrappedValue = tabValue
        }
    }
}

