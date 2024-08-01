//
//  LineDivider.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/27.
//

import SwiftUI

public struct LineDivider: View {
    
    let height: CGFloat
    let foregroudnColor: Color
    
    public init(height: CGFloat, foregroudnColor: Color) {
        self.height = height
        self.foregroudnColor = foregroudnColor
    }
    
    public var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity, maxHeight: height)
            .foregroundColor(foregroudnColor)
    }
}

struct LineDivider_Previews: PreviewProvider {
    static var previews: some View {
        LineDivider(height: 1, foregroudnColor: .blue)
    }
}
