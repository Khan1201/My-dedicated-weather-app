//
//  AdditionalLocationSavedItemView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/7/23.
//

import SwiftUI
import Domain

struct AdditionalLocationSavedItemView: View {
    let locationInf: LocationInformation
    let tempItem: Weather.WeatherImageAndMinMax?
    let onTapGesture: (LocationInformation, Bool) -> Void
    let deleteAction: (LocationInformation) -> Void
    
    @State private var isDeleteMode: Bool = false
    @State private var tempSize: CGSize = CGSize()
    
    var body: some View {
        let isWeatherLoaded: Bool = tempItem != nil
        
        HStack(alignment: .center, spacing: 0) {
            Text(locationInf.fullAddress)
                .fontSpoqaHanSansNeo(size: 15, weight: .medium)
                .foregroundStyle(Color.white)
            
            Spacer()
            
            HStack(alignment: .center, spacing: 0) {
                Image(tempItem?.weatherImage ?? "")
                    .resizable()
                    .frame(width: 34, height: 34)
                
                VStack(alignment: .center, spacing: 2) {
                    Text(" \(tempItem?.currentTemp ?? "")°")
                        .fontSpoqaHanSansNeo(size: 18, weight: .medium)
                        .foregroundStyle(Color.white)
                    
                    Text("\(tempItem?.minMaxTemp.0 ?? "")°/\(tempItem?.minMaxTemp.1 ?? "")°")
                        .fontSpoqaHanSansNeo(size: 12, weight: .regular)
                        .foregroundStyle(Color.white.opacity(0.7))
                }
                .frame(maxWidth: tempSize.width)
            }
            .padding(.vertical, 12)
            .padding(.leading, 5)
            .padding(.trailing, 8)
            .loadingProgressLottie(
                isLoadingCompleted: isWeatherLoaded,
                width: 65,
                height: 65
            )
            
            if isDeleteMode {
                VStack(alignment: .leading, spacing: 0) {
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 70)
                        .overlay {
                            Text("삭제")
                                .fontSpoqaHanSansNeo(size: 14, weight: .medium)
                                .foregroundStyle(Color.white)
                        }
                }
                .transition(.move(edge: .trailing))
                .onTapGesture {
                    withAnimation {
                        deleteAction(locationInf)
                        isDeleteMode = false
                    }
                }
            }
        }
        .padding(.leading, 15)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            VStack(alignment: .leading, spacing: 2) {
                Text(" -00°")
                    .fontSpoqaHanSansNeo(size: 18, weight: .medium)
                    .foregroundStyle(Color.white)
                
                Text("-00°/-0°")
                    .fontSpoqaHanSansNeo(size: 12, weight: .regular)
                    .foregroundStyle(Color.white.opacity(0.7))
            }
            .getSize(size: $tempSize)
            .opacity(0)
        }
        .onTapGesture {
            if isDeleteMode {
                withAnimation(.easeIn(duration: 0.15)) {
                    isDeleteMode = false
                }
                
            } else {
                onTapGesture(locationInf, false)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.width < 0 {
                        withAnimation(.easeIn(duration: 0.15)) {
                            isDeleteMode = true
                        }
                        
                    } else {
                        withAnimation(.easeIn(duration: 0.15)) {
                            isDeleteMode = false
                        }
                    }
                }
        )
    }
}
