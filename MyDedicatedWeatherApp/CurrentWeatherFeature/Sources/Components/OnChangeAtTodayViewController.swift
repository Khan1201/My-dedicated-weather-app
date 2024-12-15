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
    @EnvironmentObject var locationDataManagerEO: LocationDataManagerEO
    @EnvironmentObject var contentEO: ContentEO
    @EnvironmentObject var currentLocationEO: CurrentLocationEO
    
    func body(content: Content) -> some View {
        content
            .onChange(of: locationDataManagerEO.isLocationUpdated) { _ in
                viewModel.todayViewControllerLocationManagerUpdatedAction(
                    xy: locationDataManagerEO.convertLocationToXYForVeryShortForecast(),
                    longLati: locationDataManagerEO.longitudeAndLatitude,
                    locality: locationDataManagerEO.currentLocality
                )
            }
            .onChange(of: viewModel.isAllLoaded) { newValue in
                disableTabBarTouch = false
                contentEO.isLocationChanged = true
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
                    contentEO.setIsRefreshedActionWhenRefreshStart()
                }
            }
    }
}

extension View {
    func onChangeAtTodayViewController(disableTabBarTouch: Binding<Bool>) -> some View {
        modifier(OnChangeAtTodayViewController(disableTabBarTouch: disableTabBarTouch))
    }
}
