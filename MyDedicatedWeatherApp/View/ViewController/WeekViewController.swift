//
//  WeekViewController.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/24.
//

import SwiftUI

struct WeekViewController: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            LottieView(jsonName: "BackgroundRainyLottie", loopMode: .loop)
                .frame(width: 375, height: 500, alignment: .center)
        }
        .background {
            Color.blue
        }
    }
}

struct WeekViewController_Previews: PreviewProvider {
    static var previews: some View {
        WeekViewController()
    }
}