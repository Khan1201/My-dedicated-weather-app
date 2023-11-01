//
//  SettingView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/1/23.
//

import SwiftUI

struct SettingView: View {
    
    let images: [String] = ["questionmark.circle", "square.and.pencil", "plus.bubble", "bolt.horizontal", "v.square"]
    let menus: [String] = ["도움말", "리뷰 등록하기", "오류 신고 및 기능 제안", "오픈소스 라이센스", "앱 버전"]
    let subTexts: [String] = ["사용법을 알려드려요!", "리뷰는 개발자에 큰 힘이 됩니다💪", "소중한 의견 반영하겠습니다 :)", "오픈소스", "1.0.0"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("설정")
                .fontSpoqaHanSansNeo(size: 30, weight: .bold)
                .foregroundStyle(Color.white)
            
            VStack(alignment: .leading, spacing: 15) {
                ForEach(menus.indices, id: \.self) { index in
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        HStack(alignment: .center, spacing: 20)  {
                            Image(systemName: images[index])
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(Color.white)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(menus[index])
                                    .fontSpoqaHanSansNeo(size: 15, weight: .medium)
                                    .foregroundStyle(Color.white)

                                Text(subTexts[index])
                                    .fontSpoqaHanSansNeo(size: 13, weight: .regular)
                                    .foregroundStyle(Color.white.opacity(0.5))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .resizable()
                                .frame(width: 8, height: 10)
                                .foregroundStyle(Color.white)
                        }
                        
                        if index != menus.count - 1 {
                            Rectangle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(height: 1.3)
                            
                        }
                    }
                }
            }
            .padding(.top, 50)
            
            Spacer()
        }
        .padding(.top, 35)
        .padding(.horizontal, 20)
        .background(Color.black)
    }
}

#Preview {
    SettingView()
}
