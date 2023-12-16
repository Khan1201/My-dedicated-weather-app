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
    @Binding var openAdditionalLocationView: Bool
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
                HStack(alignment: .center, spacing: 5) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(Color.white)
                    
                    Text("지역 추가")
                        .fontSpoqaHanSansNeo(size: 12, weight: .medium)
                        .foregroundStyle(Color.white)
                }
                .padding(.vertical, 3)
                .padding(.horizontal, 10)
                .background(Color.blue.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 14))
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
        CurrentLocationAndDateView(
            location: "",
            subLocation: "",
            showRefreshButton: .constant(true),
            openAdditionalLocationView: .constant(true),
            refreshButtonOnTapGesture: {}
        )
    }
}
