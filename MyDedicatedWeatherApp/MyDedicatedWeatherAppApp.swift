//
//  MyDedicatedWeatherAppApp.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import SwiftUI
import Core

@main
struct MyDedicatedWeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(CurrentLocationVM.shared)
                .environmentObject(ContentVM.shared)
        }
    }
}
