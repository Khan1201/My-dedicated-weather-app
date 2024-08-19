//
//  MyDedicatedWeatherAppApp.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import SwiftUI
import Domain

@main
struct MyDedicatedWeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(CurrentLocationVM.shared)
                .environmentObject(ContentVM.shared)
        }
    }
}
