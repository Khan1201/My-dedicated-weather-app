//
//  CornerRadiusStyle.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/06/21.
//

import SwiftUI

public struct CornerRadiusByCorner: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    public init(radius: CGFloat, corners: UIRectCorner) {
        self.radius = radius
        self.corners = corners
    }
    
    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    public func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusByCorner(radius: radius, corners: corners))
    }
}
