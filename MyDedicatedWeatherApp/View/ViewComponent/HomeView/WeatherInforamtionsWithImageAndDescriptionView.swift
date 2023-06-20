//
//  WeatherInforamtionsWithImageAndDescriptionView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/20.
//

import SwiftUI

struct WeatherInforamtionsWithImageAndDescriptionView: View {
    
    let imageString: String
    let description: String
    
    var imageSize: CGSize = CGSize(width: 25, height: 25)
    var fontSize: CGFloat = 12
    var fontWeight: Font.Weight = .medium
    var fontColor: Color = .white
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            
            Image(imageString)
                .resizable()
                .frame(width: imageSize.width, height: imageSize.height)
            
            Text(description)
                .font(.system(size: fontSize, weight: fontWeight))
                .foregroundColor(fontColor)
        }
    }
}

struct WeatherInforamtionsWithImageAndDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherInforamtionsWithImageAndDescriptionView(
            imageString: "wet", description: "90%"
        )
    }
}
