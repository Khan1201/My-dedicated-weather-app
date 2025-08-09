//
//  CurrentWeatherView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import SwiftUI
import SwiftUIPager
import Core
import Domain
import AdditionalLocationFeature

public struct CurrentWeatherView: View {
    @Binding var disableTabBarTouch: Bool
    
    @StateObject var viewModel: CurrentWeatherVM = DI.currentWeatherVM()
    @EnvironmentObject var contentEO: ContentEO
    @EnvironmentObject var currentLocationEO: CurrentLocationEO
    
    @State private var pagerHeight: CGFloat = 0
    @State private var page: Page = .first()
    @State private var pageIndex: Int = 0
    @State private var isOnceAppeared: Bool = false
    
    public init(disableTabBarTouch: Binding<Bool>) {
        self._disableTabBarTouch = disableTabBarTouch
    }
    
    public var body: some View {
        let isFirstPage: Bool = pageIndex == 0
        
        switch currentLocationEO.locationPermissonType {
        case .allow:
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 15) {
                    currentWeatherTopView
                    
                    CurrentWeatherInfItemPagerView(
                        viewModel: viewModel,
                        pageIndex: $pageIndex,
                        page: page,
                        isLoadCompleted: viewModel.loadedVariables[.todayWeatherInformationsLoaded] ?? false
                    )
                    .overlay(alignment: isFirstPage ? .topTrailing : .topLeading) {
                        LeftOrRightAnimationView(page: $page, pageIndex: $pageIndex)
                            .opacity(viewModel.loadedVariables[.todayWeatherInformationsLoaded] ?? false ? 1 : 0)
                    }
                }
                
                LineDivider(height: 1, foregroudnColor: .white.opacity(0.3))
                    .padding(.vertical, 20)
                    .padding(.horizontal, 26)
                
                TodayWeatherItemScrollView(
                    todayWeatherInformations: viewModel.todayWeatherInformations,
                    isDayMode: currentLocationEO.currentLocationStore.state.isDayMode
                )
                .padding(.horizontal, 26)
                .loadingProgressLottie(isLoadingCompleted: viewModel.loadedVariables[.todayWeatherInformationsLoaded] ?? false)
            }
            .padding(.top, 25)
            .frame(height: UIScreen.screenHeight, alignment: .center)
            .currentWeatherViewBackground(
                isDayMode: currentLocationEO.currentLocationStore.state.isDayMode,
                isSunriseSunsetLoadCompleted: viewModel.loadedVariables[.sunriseSunsetLoaded] ?? false,
                isAllLoadCompleted: viewModel.isAllLoaded,
                isLocationUpdated: currentLocationEO.currentLocationStore.state.isLocationUpdated,
                skyType: viewModel.currentWeatherInformation?.skyType
            )
            .onChange(of: currentLocationEO.currentLocationStore.state.isLocationUpdated) { newValue in
                if newValue {
                    viewModel.loadCurrentWeatherAllData(
                        locationInf: currentLocationEO.currentLocationStore.state.initialLocationInf
                    )
                }
            }
            .onChange(of: viewModel.isAllLoaded) { newValue in
                disableTabBarTouch = false
            }
            .bottomNoticeFloater(
                isPresented: $viewModel.isNetworkFloaterPresented,
                view: BottomNoticeFloaterView(
                    title: viewModel.networkFloaterMessage
                )
            )
            .fullScreenCover(isPresented: $viewModel.isAdditionalLocationViewPresented) {
                RootNavigationView(
                    view: AdditionalLocationView(
                        isPresented: $viewModel.isAdditionalLocationViewPresented,
                        fetchNewLocation:
                            viewModel.loadAdditionalLocationWeather(locationInf:isNewAdd:)
                    )
                )
            }
            .onAppear {
                if !isOnceAppeared {
//                    viewModel.currentLocationEODelegate = currentLocationEO
                    currentLocationEO.startUpdaitingLocation()
                    isOnceAppeared = true
                }
            }
            
        case .notAllow:
            VStack(alignment: .center, spacing: 20) {
                LottieView(jsonName: "LocationLottie", loopMode: .loop)
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
                        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
                        guard UIApplication.shared.canOpenURL(settingURL) else { return }
                        UIApplication.shared.open(settingURL)
                    }
            }
        }
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView(disableTabBarTouch: .constant(false))
    }
}

// MARK: - Supporting Views..

extension CurrentWeatherView {
    var currentWeatherTopView: some View {
        let animationWidth: CGFloat = UIScreen.screenWidth / 2.5
        let animationHeight: CGFloat = UIScreen.screenHeight / 5.41
        
        return VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 0) {
                CurrentLocationAndDateView(
                    location: currentLocationEO.currentLocationStore.state.locality,
                    subLocation: currentLocationEO.currentLocationStore.state.subLocality,
                    showRefreshButton: viewModel.isAllLoaded,
                    openAdditionalLocationView: $viewModel.isAdditionalLocationViewPresented,
                    refreshButtonOnTapGesture: viewModel.performRefresh(locationInf:)
                )
                .padding(.leading, 40)
                .loadingProgressLottie(isLoadingCompleted: viewModel.loadedVariables[.kakaoAddressLoaded] ?? false)
                
                Spacer()
                
                if viewModel.loadedVariables[.sunriseSunsetLoaded] ?? false {
                    TodaySunriseSunsetView(
                        sunriseTime: viewModel.sunriseAndSunsetHHmm.0,
                        sunsetTime: viewModel.sunriseAndSunsetHHmm.1,
                        isDayMode: currentLocationEO.currentLocationStore.state.isDayMode
                    )
                    .padding(.trailing, 40)
                }
            }
            
            HStack(alignment: .center, spacing: 20) {
                LottieView(
                    jsonName: viewModel.currentWeatherInformation?.weatherAnimation ?? "",
                    loopMode: .loop
                )
                .frame(width: animationWidth, height: animationHeight)
                .loadingProgressLottie(isLoadingCompleted: viewModel.loadedVariables[.currentWeatherInformationLoaded] ?? false)
                
                CurrentTempAndMinMaxTempView(
                    temp: viewModel.currentWeatherInformation?.temperature,
                    minMaxTemp: viewModel.todayMinMaxTemperature,
                    isDayMode: currentLocationEO.currentLocationStore.state.isDayMode
                )
                .loadingProgressLottie(
                    isLoadingCompleted: viewModel.loadedVariables[.currentWeatherInformationLoaded] ?? false && viewModel.loadedVariables[.minMaxTempLoaded] ?? false
                )
            }
            .padding(.leading, 50)
            .padding(.trailing, 30)
        }
    }
}
