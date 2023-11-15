//
//  RootNavigationView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 11/15/23.
//

import SwiftUI

struct RootNavigationView<Content: View>: View {
    let view: Content
    
    var body: some View {
        
        if #available(iOS 16.0, *) {
            NavigationStack {
                view
                    .navigationBarBackButtonHidden()
            }
        } else {
            NavigationView {
                view
                    .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    RootNavigationView(view: EmptyView())
}
