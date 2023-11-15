//
//  CustomNavigationBar.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/15/23.
//

import SwiftUI

struct CustomNavigationBar: View {
    @Binding var isPresented: Bool
    let isNavigationUsed: Bool
    var title: String?
    var onTapGesture: (() -> Void)?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack(alignment: .center, spacing: 13) {
            Image(systemName: "arrow.backward")
                .resizable()
                .foregroundStyle(Color.white)
                .frame(width: 18, height: 15)
                .onTapGesture {
                    if let onTapGesture = onTapGesture {
                        onTapGesture()
                        
                    } else {
                        if isNavigationUsed {
                            dismiss()
                            
                        } else {
                            isPresented = false
                        }
                    }
                }
            
            if let title = title {
                Text(title)
                    .fontSpoqaHanSansNeo(size: 18, weight: .medium)
                    .foregroundStyle(Color.white)
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 22)
    }
}

#Preview {
    CustomNavigationBar(isPresented: .constant(true), isNavigationUsed: false, title: "오픈소스")
}
