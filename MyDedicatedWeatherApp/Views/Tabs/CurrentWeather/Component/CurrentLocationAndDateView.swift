//
//  CurrentLocationAndDateView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/28.
//

import SwiftUI

struct CurrentLocationAndDateView: View {
    
    let location: String
    let subLocation: String
    @Binding var showRefreshButton: Bool
    let refreshButtonOnTapGesture: () -> Void
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            Text(
            """
            \(location),
            \(subLocation)
            """
            )
            .fontSpoqaHanSansNeo(size: 26, weight: .bold)
            .foregroundColor(.white)
            .lineSpacing(2)
            .overlay(alignment: .topLeading) {
                Image(systemName: "plus.message")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.white)
                    .offset(y: -30)
                    .onTapGesture {
                        openAdditionalLocationView = true
                    }
            }
            
            HStack(alignment: .bottom, spacing: 4) {
                Text(
                    Date().toString(format: "EE요일, M월 d일")
                )
                .font(.system(size: 14))
                .foregroundColor(.white)
                
                Image("refresh.green")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .offset(x: 13)
                    .onTapGesture {
                        refreshButtonOnTapGesture()
                    }
                    .opacity(showRefreshButton ? 1 : 0)
            }
        }
    }
}

struct CurrentLocationAndDateView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLocationAndDateView(location: "", subLocation: "", showRefreshButton: .constant(true), refreshButtonOnTapGesture: {})
    }
}
