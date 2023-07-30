//
//  TodayViewController.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import SwiftUI
import SwiftUIPager

struct TodayViewController: View {
    @StateObject var viewModel: TodayViewModel = TodayViewModel()
    @StateObject var locationDataManagerVM = LocationDataManagerVM()
    
    @State private var pagerHeight: CGFloat = 0
    @State private var page: Page = .first()
    @State private var pageIndex: Int = 0
    
    var body: some View {
        
        let isFirstPage: Bool = pageIndex == 0
        
        switch locationDataManagerVM.locationPermissonType {
            
        case .allow:
            
            VStack(alignment: .leading, spacing: 0) {
                
                VStack(alignment: .leading, spacing: 15) {
                    topView
                    
                    CurrentWeatherInfItemPagerView(
                        viewModel: viewModel,
                        pageIndex: $pageIndex,
                        page: page
                    )
                    .overlay(alignment: isFirstPage ? .topTrailing : .topLeading) {
                        LeftOrRightAnimationView(page: $page, pageIndex: $pageIndex)
                    }
                }
                
                LineDivider(height: 1, foregroudnColor: .white.opacity(0.3))
                    .padding(.vertical, 20)
                    .padding(.horizontal, 26)
                
                TodayWeatherItemScrollView(
                    todayWeatherInformations: viewModel.todayWeatherInformations,
                    isDayMode: viewModel.isDayMode
                )
                .padding(.horizontal, 26)
            }
            .padding(.top, 25)
            .frame(height: UIScreen.screenHeight, alignment: .center)
            .todayViewControllerBackground(isDayMode: viewModel.isDayMode)
            .onChange(of: locationDataManagerVM.isLocationUpdated) { _ in
                viewModel.TodayViewControllerLocationManagerUpdatedAction(
                    xy: locationDataManagerVM.convertLocationToXYForVeryShortForecast(),
                    longLati: locationDataManagerVM.longitudeAndLatitude
                )
            }
            .onChange(of: viewModel.isKakaoAddressLoadCompleted) { newValue in
                viewModel.TodayViewControllerKakaoAddressUpdatedAction(
                    umdName: viewModel.subLocalityByKakaoAddress,
                    locality: locationDataManagerVM.currentLocationLocality
                )
            }
            
        case .notAllow:
            
            VStack(alignment: .center, spacing: 20) {
                
                LottieView(jsonName: "Location", loopMode: .loop)
                    .frame(width: 100, height: 100, alignment: .center)
                
                Text("위치정보 권한이 필요합니다.")
                    .font(.system(size: 18, weight: .bold))
                
                Text("설정하기")
                    .font(.system(size: 16, weight: .medium))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(12)
                    .onTapGesture {
                        locationDataManagerVM.openAppSetting()
                    }
            }
        }
    }
}

struct TodayViewController_Previews: PreviewProvider {
    static var previews: some View {
        TodayViewController()
    }
}

// MARK: - Supporting Views..

extension TodayViewController {
    
    var topView: some View {
        
        let animationWidth: CGFloat = UIScreen.screenWidth / 2.5
        let animationHeight: CGFloat = UIScreen.screenHeight / 5.41
        
        return VStack(alignment: .leading, spacing: 8) {
            
            HStack(alignment: .center, spacing: 60) {
                CurrentLocationAndDateView(
                    location: locationDataManagerVM.currentLocation,
                    subLocation: viewModel.subLocalityByKakaoAddress,
                    isLocationUpdated: locationDataManagerVM.isLocationUpdated
                )
                .padding(.leading, 40)
                
                TodaySunriseSunsetView(
                    sunriseTime: viewModel.sunRiseAndSetHHmm.0,
                    sunsetTime: viewModel.sunRiseAndSetHHmm.1,
                    isDayMode: viewModel.isDayMode
                )
            }
            
            HStack(alignment: .center, spacing: 20) {
                LottieView(
                    jsonName: viewModel.currentWeatherAnimationImg,
                    loopMode: .loop
                )
                .frame(width: animationWidth, height: animationHeight)
                .loadingProgressLottie(isLoadingCompleted: viewModel.isCurrentWeatherAnimationSetCompleted)
                
                CurrentTempAndMinMaxTempView(
                    temp: viewModel.currentWeatherInformation.temperature,
                    minMaxTemp: viewModel.todayMinMaxTemperature,
                    isDayMode: viewModel.isDayMode,
                    tempLoadCompleted: viewModel.isCurrentWeatherInformationLoadCompleted
                )
                .loadingProgressLottie(isLoadingCompleted: viewModel.loadingTest)
            }
            .padding(.leading, 50)
            .padding(.trailing, 30)
        }
    }
}
