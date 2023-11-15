//
//  OpenSourceDetailView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/15/23.
//

import SwiftUI

struct OpenSourceDetailView: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            CustomNavigationBar(
                isPresented: .constant(false),
                isNavigationUsed: true,
                title: title
            )
            
            ScrollView(.vertical) {
                Text(description)
                    .fontSpoqaHanSansNeo(size: 14, weight: .regular)
                    .foregroundStyle(Color.white)
                    .lineSpacing(3)
                    .padding(.horizontal, 24)
            }
        }
        .background(Color.black)
    }
}

#Preview {
    OpenSourceDetailView(
        title: "Alamofire",
        description: Dummy.shared.openSourceDescriptions()[0]
    )
}
