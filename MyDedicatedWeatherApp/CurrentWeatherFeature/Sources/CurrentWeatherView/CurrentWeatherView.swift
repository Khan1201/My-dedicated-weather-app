//
//  CurrentWeatherView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import SwiftUI
import SwiftUIPager

struct CurrentWeatherView: View {
    @Binding var disableTabBarTouch: Bool
    
    @StateObject var viewModel: CurrentWeatherVM = CurrentWeatherVM()
    @StateObject var locationDataManagerVM = LocationDataManagerVM()
    @EnvironmentObject var contentVM: ContentVM
    @EnvironmentObject var currentLocationVM: CurrentLocationVM
    
    @State private var pagerHeight: CGFloat = 0
    @State private var page: Page = .first()
    @State private var pageIndex: Int = 0
    
    var body: some View {
        
        let isFirstPage: Bool = pageIndex == 0
        
        switch locationDataManagerVM.locationPermissonType {
            
        case .allow:
            
            VStack(alignment: .leading, spacing: 0) {
                
                VStack(alignment: .leading, spacing: 15) {
                    currentWeatherTopView
                    
                    CurrentWeatherInfItemPagerView(
                        viewModel: viewModel,
                        pageIndex: $pageIndex,
                        page: page,
                        isLoadCompleted: viewModel.isTodayWeatherInformationLoadCompleted
                    )
                    .overlay(alignment: isFirstPage ? .topTrailing : .topLeading) {
                        LeftOrRightAnimationView(page: $page, pageIndex: $pageIndex)
                            .opacity(viewModel.isTodayWeatherInformationLoadCompleted ? 1: 0)
                    }
                }
                
                LineDivider(height: 1, foregroudnColor: .white.opacity(0.3))
                    .padding(.vertical, 20)
                    .padding(.horizontal, 26)
                
                TodayWeatherItemScrollView(
                    todayWeatherInformations: viewModel.todayWeatherInformations,
                    isDayMode: contentVM.isDayMode
                )
                .padding(.horizontal, 26)
                .loadingProgressLottie(isLoadingCompleted: viewModel.isTodayWeatherInformationLoadCompleted)
            }
            .padding(.top, 25)
            .frame(height: UIScreen.screenHeight, alignment: .center)
            .overlay(alignment: .center) {
                Text("재시도")
                    .fontSpoqaHanSansNeo(size: 20, weight: .bold)
                    .foregroundStyle(Color.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.blue.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onTapGesture {
                        viewModel.retryButtonOnTapGesture(
                            longitude: currentLocationVM.longitude,
                            latitude: currentLocationVM.latitude,
                            xy: currentLocationVM.xy,
                            locality: currentLocationVM.locality,
                            subLocality: currentLocationVM.subLocality
                        )
                    }
                    .opacity(viewModel.showLoadRetryButton ? 1 : 0)
            }
            .todayViewControllerBackground(
                isDayMode: contentVM.isDayMode,
                isSunriseSunsetLoadCompleted: viewModel.isSunriseSunsetLoadCompleted,
                isAllLoadCompleted: viewModel.isAllLoadCompleted,
                skyType: viewModel.currentWeatherInformation.skyType
            )
            .onChangeAtTodayViewController(disableTabBarTouch: $disableTabBarTouch)
            .bottomNoticeFloater(
                isPresented: $viewModel.showNoticeFloater,
                view: BottomNoticeFloaterView(
                    title: viewModel.noticeFloaterMessage
                ),
                duration: 3
            )
            .fullScreenCover(isPresented: $viewModel.openAdditionalLocationView) {
                RootNavigationView(
                    view: AdditionalLocationView(
                        isPresented: $viewModel.openAdditionalLocationView,
                        progress: $viewModel.additionalLocationProgress,
                        finalLocationOnTapGesture:
                            viewModel.additionalAddressFinalLocationOnTapGesture(allLocality:isNewAdd:)
                    )
                )
            }
            .environmentObject(viewModel)
            .environmentObject(locationDataManagerVM)
            
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
                        locationDataManagerVM.openAppSetting()
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
                    location: currentLocationVM.locality,
                    subLocation: currentLocationVM.subLocality,
                    showRefreshButton: viewModel.isAllLoadCompleted,
                    openAdditionalLocationView: $viewModel.openAdditionalLocationView,
                    refreshButtonOnTapGesture: viewModel.refreshButtonOnTapGesture
                )
                .padding(.leading, 40)
                .loadingProgressLottie(isLoadingCompleted: viewModel.isKakaoAddressLoadCompleted)
                                
                Spacer()
                
                if viewModel.isSunriseSunsetLoadCompleted {
                    TodaySunriseSunsetView(
                        sunriseTime: viewModel.sunriseAndSunsetHHmm.0,
                        sunsetTime: viewModel.sunriseAndSunsetHHmm.1,
                        isDayMode: contentVM.isDayMode
                    )
                    .padding(.trailing, 40)
                }
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
                    isDayMode: contentVM.isDayMode
                )
                .loadingProgressLottie(
                    isLoadingCompleted: viewModel.isCurrentWeatherInformationLoadCompleted && viewModel.isMinMaxTempLoadCompleted
                )
            }
            .padding(.leading, 50)
            .padding(.trailing, 30)
        }
    }
}
