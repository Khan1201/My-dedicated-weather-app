//
//  Extensions.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/22.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
