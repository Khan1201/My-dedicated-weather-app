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
    let showRefreshButton: Bool
    @Binding var openAdditionalLocationView: Bool
    var showLocationAddButton: Bool = true
    let refreshButtonOnTapGesture: () -> Void
    
    var body: some View {
        let isNotNocheDevice: Bool = CommonUtil.shared.isNotNocheDevice

        VStack(alignment: .leading, spacing: 6) {
            Text(
            """
            \(location),
            \(subLocation)
            """
            )
            .fontSpoqaHanSansNeo(size: isNotNocheDevice ? 23 : 26, weight: .bold)
            .foregroundColor(.white)
            .lineSpacing(2)
            .overlay(alignment: .topLeading) {
                HStack(alignment: .center, spacing: 5) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(Color.white)
                    
                    Text("지역 추가")
                        .fontSpoqaHanSansNeo(size: isNotNocheDevice ? 11 : 12, weight: .medium)
                        .foregroundStyle(Color.white)
                }
                .padding(.vertical, isNotNocheDevice ? 2 : 3)
                .padding(.horizontal, 10)
                .background(Color.blue.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .offset(y: -30)
                .onTapGesture {
                    openAdditionalLocationView = true
                }
                .opacity(showLocationAddButton ? 1 : 0)
            }
            
            HStack(alignment: .bottom, spacing: 4) {
                Text(
                    Date().toString(format: "EE요일, M월 d일")
                )
                .font(.system(size: 14))
                .foregroundColor(.white)
                
                Image("refresh.green")
                    .resizable()
                    .frame(width: isNotNocheDevice ? 22 : 25, height: isNotNocheDevice ? 22 : 25)
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
            showRefreshButton: true,
            openAdditionalLocationView: .constant(true),
            refreshButtonOnTapGesture: {}
        )
    }
}
