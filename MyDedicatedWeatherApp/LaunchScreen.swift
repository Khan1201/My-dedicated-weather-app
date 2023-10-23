//
//  LaunchScreen.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/23/23.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                Image("launch_screen_logo")
                    .resizable()
                    .frame(width: 220, height: 260)
            }
        }
    }
}

#Preview {
    LaunchScreen()
}
