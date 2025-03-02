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
                        isLoadCompleted: viewModel.isTodayWeatherInformationLoaded
                    )
                    .overlay(alignment: isFirstPage ? .topTrailing : .topLeading) {
                        LeftOrRightAnimationView(page: $page, pageIndex: $pageIndex)
                            .opacity(viewModel.isTodayWeatherInformationLoaded ? 1: 0)
                    }
                }
                
                LineDivider(height: 1, foregroudnColor: .white.opacity(0.3))
                    .padding(.vertical, 20)
                    .padding(.horizontal, 26)
                
                TodayWeatherItemScrollView(
                    todayWeatherInformations: viewModel.todayWeatherInformations,
                    isDayMode: contentEO.isDayMode
                )
                .padding(.horizontal, 26)
                .loadingProgressLottie(isLoadingCompleted: viewModel.isTodayWeatherInformationLoaded)
            }
            .padding(.top, 25)
            .frame(height: UIScreen.screenHeight, alignment: .center)
            .todayViewControllerBackground(
                isDayMode: contentEO.isDayMode,
                isSunriseSunsetLoadCompleted: viewModel.isSunriseSunsetLoaded,
                isAllLoadCompleted: viewModel.isAllLoaded,
                skyType: viewModel.currentWeatherInformation?.skyType
            )
            .onChange(of: currentLocationEO.isLocationUpdated) { _ in
                viewModel.fetchCurrentWeatherAllData(
                    locationInf: currentLocationEO.initialLocationInf
                )
            }
            .onChange(of: viewModel.isAllLoaded) { newValue in
                disableTabBarTouch = false
                contentEO.isLocationChanged = true
            }
            .bottomNoticeFloater(
                isPresented: $viewModel.isNoticeFloaterViewPresented,
                view: BottomNoticeFloaterView(
                    title: viewModel.noticeFloaterMessage
                ),
                duration: 3
            )
            .fullScreenCover(isPresented: $viewModel.isAdditionalLocationViewPresented) {
                RootNavigationView(
                    view: AdditionalLocationView(
                        isPresented: $viewModel.isAdditionalLocationViewPresented,
                        fetchNewLocation:
                            viewModel.fetchAdditionalLocationWeather(locationInf:isNewAdd:)
                    )
                )
            }
            .onAppear {
                viewModel.currentLocationEODelegate = currentLocationEO
                viewModel.contentEODelegate = contentEO
                currentLocationEO.startUpdaitingLocation()
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
                    location: currentLocationEO.locality,
                    subLocation: currentLocationEO.subLocality,
                    showRefreshButton: viewModel.isAllLoaded,
                    openAdditionalLocationView: $viewModel.isAdditionalLocationViewPresented,
                    refreshButtonOnTapGesture: viewModel.performRefresh(locationInf:)
                )
                .padding(.leading, 40)
                .loadingProgressLottie(isLoadingCompleted: viewModel.isKakaoAddressLoaded)
                                
                Spacer()
                
                if viewModel.isSunriseSunsetLoaded {
                    TodaySunriseSunsetView(
                        sunriseTime: viewModel.sunriseAndSunsetHHmm.0,
                        sunsetTime: viewModel.sunriseAndSunsetHHmm.1,
                        isDayMode: contentEO.isDayMode
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
                .loadingProgressLottie(isLoadingCompleted: viewModel.isCurrentWeatherInformationLoaded)
                
                CurrentTempAndMinMaxTempView(
                    temp: viewModel.currentWeatherInformation?.temperature,
                    minMaxTemp: viewModel.todayMinMaxTemperature,
                    isDayMode: contentEO.isDayMode
                )
                .loadingProgressLottie(
                    isLoadingCompleted: viewModel.isCurrentWeatherInformationLoaded && viewModel.isMinMaxTempLoaded
                )
            }
            .padding(.leading, 50)
            .padding(.trailing, 30)
        }
    }
}
