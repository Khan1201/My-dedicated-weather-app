//
//  LaunchScreen.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/23/23.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        let logoWidth: CGFloat = UIScreen.screenWidth / 1.345
        
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                Image("launch_screen_logo")
                    .resizable()
                    .frame(width: logoWidth, height: logoWidth)
                    .padding(.trailing, 30)
            }
        }
    }
}

#Preview {
    LaunchScreen()
}
