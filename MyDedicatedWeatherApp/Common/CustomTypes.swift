//
//  CustomTypes.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/18.
//

import Foundation
import SwiftUI

struct Weather {
    
    struct DescriptionAndImageString {
        let description: String
        let imageString: String
    }
    
    struct DescriptionAndColor {
        let description: String
        let color: Color
    }
}

enum TabBarType: CaseIterable {
    
    case current,
        forecast,
        search,
        setting
}
