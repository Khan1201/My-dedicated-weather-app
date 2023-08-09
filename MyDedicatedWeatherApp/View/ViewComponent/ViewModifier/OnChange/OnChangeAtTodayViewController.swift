//
//  OnChangeAtTodayViewController.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/01.
//

import SwiftUI

struct OnChangeAtTodayViewController: ViewModifier {
    
    @EnvironmentObject var viewModel: TodayViewModel
    @EnvironmentObject var locationDataManagerVM: LocationDataManagerVM
    
    func body(content: Content) -> some View {
        content
            .onChange(of: locationDataManagerVM.isLocationUpdated) { _ in
                viewModel.TodayViewControllerLocationManagerUpdatedAction(
                    xy: locationDataManagerVM.convertLocationToXYForVeryShortForecast(),
                    longLati: locationDataManagerVM.longitudeAndLatitude
                )
            }
            .onChange(of: viewModel.isKakaoAddressLoadCompleted) { newValue in
                viewModel.TodayViewControllerKakaoAddressUpdatedAction(
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
            }
    }
}

extension View {
    func onChangeAtTodayViewController() -> some View {
        modifier(OnChangeAtTodayViewController())
    }
}
