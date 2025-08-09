//
//  CurrentLocationAndDateView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/28.
//

import SwiftUI
import Domain

public struct CurrentLocationAndDateView: View {
    
    public let location: String
    public let subLocation: String
    public let showRefreshButton: Bool
    @Binding public var openAdditionalLocationView: Bool
    public var showLocationAddButton: Bool
    public let refreshButtonOnTapGesture: (LocationInformation) -> Void
    
    @EnvironmentObject var currentLocationEO: CurrentLocationEO
    
    public init(location: String, subLocation: String, showRefreshButton: Bool, openAdditionalLocationView: Binding<Bool>, showLocationAddButton: Bool = true, refreshButtonOnTapGesture: @escaping (LocationInformation) -> Void) {
        self.location = location
        self.subLocation = subLocation
        self.showRefreshButton = showRefreshButton
        self._openAdditionalLocationView = openAdditionalLocationView
        self.showLocationAddButton = showLocationAddButton
        self.refreshButtonOnTapGesture = refreshButtonOnTapGesture
    }
    
    public var body: some View {
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
                        refreshButtonOnTapGesture(currentLocationEO.currentLocationStore.state.initialLocationInf)
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
            refreshButtonOnTapGesture: {_ in }
        )
    }
}
