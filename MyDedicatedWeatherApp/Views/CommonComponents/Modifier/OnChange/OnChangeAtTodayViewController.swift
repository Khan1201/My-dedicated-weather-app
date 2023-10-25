//
//  OnChangeAtTodayViewController.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/01.
//

import SwiftUI

struct OnChangeAtTodayViewController: ViewModifier {
    @Binding var disableTabBarTouch: Bool
    @EnvironmentObject var viewModel: CurrentWeatherVM
    @EnvironmentObject var locationDataManagerVM: LocationDataManagerVM
    @EnvironmentObject var contentVM: ContentVM
    
    func body(content: Content) -> some View {
        content
            .onChange(of: locationDataManagerVM.isLocationUpdated) { _ in
                viewModel.todayViewControllerLocationManagerUpdatedAction(
                    xy: locationDataManagerVM.convertLocationToXYForVeryShortForecast(),
                    longLati: locationDataManagerVM.longitudeAndLatitude
                )
            }
            .onChange(of: viewModel.isKakaoAddressLoadCompleted) { newValue in
                viewModel.todayViewControllerKakaoAddressUpdatedAction(
                    umdName: viewModel.subLocalityByKakaoAddress,
                    locality: locationDataManagerVM.currentLocation
                )
            }
            // 7 values..
            .onChange(of: viewModel.isCurrentWeatherInformationLoadCompleted &&
                      viewModel.isCurrentWeatherAnimationSetCompleted &&
                      viewModel.isFineDustLoadCompleted &&
                      viewModel.isKakaoAddressLoadCompleted &&
                      viewModel.isMinMaxTempLoadCompleted &&
                      viewModel.isSunriseSunsetLoadCompleted &&
                      viewModel.isTodayWeatherInformationLoadCompleted
            ) { newValue in
                viewModel.setIsAllLoadCompleted()
                disableTabBarTouch = false
            }
            .onChange(of: viewModel.isStartRefresh) { newValue in
                if newValue {
                    locationDataManagerVM.initializeStates()
                    viewModel.initializeStates()
                    locationDataManagerVM.startUpdaitingLocation()
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
