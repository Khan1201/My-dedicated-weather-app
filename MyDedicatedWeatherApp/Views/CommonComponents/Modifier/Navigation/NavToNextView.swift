//
//  NavToNextView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/15/23.
//

import SwiftUI

struct NavToNextView<T: View>: ViewModifier {
    @Binding var isPresented: Bool
    let view: T
    
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .navigationDestination(isPresented: $isPresented) {
                    view
                        .navigationBarBackButtonHidden()
                }
            
        } else {
            VStack(alignment: .leading, spacing: 0) {
                content
                
                NavigationLink(isActive: $isPresented) {
                    view
                        .navigationBarHidden(true)
                } label: {
                    EmptyView()
                }
            }
        }
    }
}

extension View {
    
    func navToNextView<T: View>(isPresented: Binding<Bool>, view: T) -> some View {
        modifier(NavToNextView(isPresented: isPresented, view: view))
    }
}
