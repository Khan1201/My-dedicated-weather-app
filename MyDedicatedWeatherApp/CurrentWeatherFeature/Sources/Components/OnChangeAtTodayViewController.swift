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
    @EnvironmentObject var currentLocationEO: CurrentLocationEO
    
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
                    longitude: currentLocationEO.longitude,
                    latitude: currentLocationEO.latitude,
                    xy: currentLocationEO.xy,
                    locality: currentLocationEO.locality,
                    subLocality: currentLocationEO.subLocality
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
