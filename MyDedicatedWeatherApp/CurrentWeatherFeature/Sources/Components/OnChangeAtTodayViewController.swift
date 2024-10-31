//
//  OnChangeAtTodayViewController.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/01.
//

import SwiftUI
import Core

struct OnChangeAtTodayViewController: ViewModifier {
    @Binding var disableTabBarTouch: Bool
    @EnvironmentObject var viewModel: CurrentWeatherVM
    @EnvironmentObject var locationDataManagerVM: LocationDataManagerVM
    @EnvironmentObject var contentVM: ContentVM
    @EnvironmentObject var currentLocationVM: CurrentLocationVM
    
    func body(content: Content) -> some View {
        content
            .onChange(of: locationDataManagerVM.isLocationUpdated) { _ in
                viewModel.todayViewControllerLocationManagerUpdatedAction(
                    xy: locationDataManagerVM.convertLocationToXYForVeryShortForecast(),
                    longLati: locationDataManagerVM.longitudeAndLatitude,
                    locality: locationDataManagerVM.currentLocality
                )
            }
            .onChange(of: viewModel.isAllLoaded) { newValue in
                disableTabBarTouch = false
                contentVM.isLocationChanged = true
            }
            .onChange(of: viewModel.isStartRefresh) { newValue in
                viewModel.isStartRefreshOnChangeAction(
                    newValue: newValue,
                    longitude: currentLocationVM.longitude,
                    latitude: currentLocationVM.latitude,
                    xy: currentLocationVM.xy,
                    locality: currentLocationVM.locality,
                    subLocality: currentLocationVM.subLocality
                )
                
                if newValue {
                    contentVM.setIsRefreshedActionWhenRefreshStart()
                }
            }
    }
}

extension View {
    func onChangeAtTodayViewController(disableTabBarTouch: Binding<Bool>) -> some View {
        modifier(OnChangeAtTodayViewController(disableTabBarTouch: disableTabBarTouch))
    }
}
