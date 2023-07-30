//
//  CurrentLocationAndDateView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/28.
//

import SwiftUI

struct CurrentLocationAndDateView: View {
    
    let location: String
    let subLocation: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text(
            """
            \(location),
            \(subLocation)
            """
            )
            .fontSpoqaHanSansNeo(size: 24, weight: .medium)
            .foregroundColor(.white)
            .lineSpacing(2)
            
            Text(Util().currentDateByCustomFormatter(
                dateFormat: "E요일, M월 d일")
            )
            .font(.system(size: 13))
            .foregroundColor(.white)
        }
    }
}

struct CurrentLocationAndDateView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLocationAndDateView(location: "", subLocation: "")
    }
}
