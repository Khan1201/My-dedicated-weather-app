//
//  FineDustWithDescriptionAndBackgroundColorView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/20.
//

import SwiftUI

struct FineDustWithDescriptionAndBackgroundColorView: View {
    
    let title: String
    let description: String
    let descriptionFontColor: Color
    let backgroundColor: Color
    
    var titleFont: Font = .system(size: 12)
    var titleFontColor: Color = .white
    var descriptionFont: Font = .system(size: 12, weight: .bold)
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 5) {
            
            Text(title)
                .font(titleFont)
                .foregroundColor(titleFontColor)
            
            Text(description)
                .font(descriptionFont)
                .foregroundColor(descriptionFontColor)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background {
            backgroundColor
        }
        .cornerRadius(8)
    }
}

struct FineDustWithDescriptionAndBackgroundColorView_Previews: PreviewProvider {
    static var previews: some View {
        FineDustWithDescriptionAndBackgroundColorView(
            title: "미세먼지",
            description: "좋음",
            descriptionFontColor: .blue,
            backgroundColor: .blue
        )
    }
}
