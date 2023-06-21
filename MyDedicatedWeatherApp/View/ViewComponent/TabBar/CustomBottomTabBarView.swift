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
            
            tabBarItemView(imageString: "calender_today", title: "현재 날씨") {
                currentTab = .current
            }
            
            Spacer()
            
            tabBarItemView(imageString: "calender_forecast", title: "주간 예보") {
                currentTab = .forecast
            }
            
            Spacer()
            
            tabBarItemView(imageString: "search", title: "검색") {
                currentTab = .search
            }
            
            Spacer()
            
            tabBarItemView(imageString: "gear", title: "설정") {
                currentTab = .setting
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 15)
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
    
    func tabBarItemView(imageString: String, title: String, onTapGesture: @escaping () -> Void) -> some View{
       return VStack(alignment: .center, spacing: 5) {
           Image(imageString)
               .resizable()
               .frame(width: 24, height: 24)
           
           Text(title)
               .font(.system(size: 10, weight: .medium))
               .foregroundColor(Color.black.opacity(0.6))
       }
       .onTapGesture {
           onTapGesture()
       }
   }
}
 
