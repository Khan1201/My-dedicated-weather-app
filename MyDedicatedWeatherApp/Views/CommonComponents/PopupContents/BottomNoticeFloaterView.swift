//
//  BottomNoticeFloaterView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 10/19/23.
//

import SwiftUI

struct BottomNoticeFloaterView: View {
    let title: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Image("exclamation.mark.circle.yellow.24x24")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.leading, 16)
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
                .padding(.vertical, 12)
                .padding(.leading, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.init(53, 53, 53).opacity(0.8))
        .cornerRadius(8)
        
    }
}

#Preview {
    BottomNoticeFloaterView(title: "예시입니다")
}
