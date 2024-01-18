//
//  OpenSourceListView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/15/23.
//

import SwiftUI

struct OpenSourceListView: View {
    @Binding var isPresented: Bool
    let titles: [String]
    let subTitles: [String]
    let descriptions: [String]
    let tapAvailableIndexes: [Int]
    
    @State private var selectedIndex: Int = 0
    @State private var isNextViewShown: Bool = false
    
    var body: some View {
        var descriptionIndex: Int = 0
        
        VStack(alignment: .leading, spacing: 30) {
            CustomNavigationBar(
                isPresented: $isPresented,
                isNavigationUsed: false,
                title: "오픈소스 라이센스")
            
            VStack(alignment: .leading, spacing: 15) {
                ForEach(titles.indices, id: \.self) { i in
                    VStack(alignment: .leading, spacing: 0) {
                        Text(titles[i])
                            .fontSpoqaHanSansNeo(size: 16, weight: .medium)
                            .foregroundStyle(Color.white)
                        
                        Text(subTitles[i])
                            .fontSpoqaHanSansNeo(size: 14, weight: .regular)
                            .foregroundStyle(Color.gray.opacity(0.7))
                            .padding(.top, 4)
                        
                        if i != titles.count - 1 {
                            Rectangle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(height: 1.3)
                                .padding(.top, 10)
                        }
                    }
                    .onTapGesture {
                        if tapAvailableIndexes.contains(i) {
                            descriptionIndex = i - (tapAvailableIndexes.first ?? 0)
                            selectedIndex = i
                            isNextViewShown = true
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
        .background(Color.black)
        .navToNextView(
            isPresented: $isNextViewShown,
            view: OpenSourceDetailView(
                title: titles[selectedIndex],
                description: descriptions[descriptionIndex]
            )
        )
    }
}

#Preview {
    OpenSourceListView(
        isPresented: .constant(true),
        titles: ["Alamofire", "lottie-ios", "PopupView", "SwiftUIPager"],
        subTitles: [
            "https://github.com/Alamofire/Alamofire",
            "https://github.com/airbnb/lottie-ios",
            "https://github.com/exyte/PopupView",
            "https://github.com/fermoya/SwiftUIPager"
        ],
        descriptions: [],
        tapAvailableIndexes: []
    )
}
