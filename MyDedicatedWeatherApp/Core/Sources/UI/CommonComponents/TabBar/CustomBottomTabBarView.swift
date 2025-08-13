//
//  CustomBottomTabBarView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/21.
//

import SwiftUI
import Domain

public struct CustomBottomTabBarView: View {
    let currentTab: TabBarType
    let itemOnTapGesture: ((TabBarType) -> Void)
    
    @State private var tabBarItemSize: CGSize = CGSize()
    
    public init(currentTab: TabBarType, itemOnTapGesture: @escaping (TabBarType) -> Void) {
        self.currentTab = currentTab
        self.itemOnTapGesture = itemOnTapGesture
    }
    
    public var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            tabBarItemView(
                imageString: "calender_today",
                title: "현재 날씨",
                currentTab: currentTab,
                tabValue: .current, 
                onTapGesture: itemOnTapGesture
            )
            .getSize(size: $tabBarItemSize)
            
            Spacer()
            
            tabBarItemView(
                imageString: "calender_forecast",
                title: "주간 예보",
                currentTab: currentTab,
                tabValue: .week,
                onTapGesture: itemOnTapGesture
            )
            .frame(maxWidth: tabBarItemSize.width)
            
            Spacer()
            
            tabBarItemView(
                imageString: "gear",
                title: "설정",
                currentTab: currentTab,
                tabValue: .setting, 
                onTapGesture: itemOnTapGesture
            )
            .frame(maxWidth: tabBarItemSize.width)
        }
        .padding(.horizontal, 35)
        .padding(.top, 15)
        .padding(.bottom, 20)
        .background(.white)
        .cornerRadius(25, corners: [.topLeft, .topRight])
    }
}

// MARK: - Supporting View

extension CustomBottomTabBarView {
    
    func tabBarItemView(
        imageString: String,
        title: String,
        currentTab: TabBarType,
        tabValue: TabBarType,
        onTapGesture: @escaping ((TabBarType) -> Void)
    ) -> some View{
        let isNotNocheDevice: Bool = CommonUtil.shared.isNotNocheDevice
        
        return VStack(alignment: .center, spacing: 5) {
            
            Image(imageString)
                .resizable()
                .frame(width: isNotNocheDevice ? 21 : 24, height: isNotNocheDevice ? 21 : 24)
            
            Text(title)
                .font(.system(size: isNotNocheDevice ? 9 : 10, weight: .medium))
                .foregroundColor(Color.black.opacity(0.6))
        }
        .overlay(alignment: .top) {
            Image("check_blue")
                .resizable()
                .frame(width: isNotNocheDevice ? 18 : 20, height: isNotNocheDevice ? 18 : 20)
                .opacity(currentTab == tabValue ? 1 : 0)
                .offset(y: -5)
        }
        .onTapGesture {
            onTapGesture(tabValue)
        }
    }
}

