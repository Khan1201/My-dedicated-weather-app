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
                    currentWeatherWithImageAndTemperatureView
                    
                    Pager(page: page, data: viewModel.pageViewCount, id: \.self) { index in
                        
                        switch index {
                            
                        case 0:
                            currentWeatherInfPagerFirstView
                                .getHeight(height: $pagerHeight)
                            
                        case 1:
                            currentWeatherInfPagerSecondView
                            
                        default:
                            EmptyView()
                            
                        }
                    }
                    .onPageChanged { index in
                        pageIndex = index
                    }
                    .frame(height: pagerHeight != 0 ? pagerHeight : nil)
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
    
    var currentWeatherWithImageAndTemperatureView: some View {
        
        let animationWidth: CGFloat = UIScreen.screenWidth / 2.5
        let animationHeight: CGFloat = UIScreen.screenHeight / 5.41
        
        return VStack(alignment: .leading, spacing: 8) {
            
            
            HStack(alignment: .center, spacing: 60) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(
                    """
                    \(locationDataManagerVM.currentLocation),
                    \(viewModel.subLocalityByKakaoAddress)
                    """
                    )
                    .fontSpoqaHanSansNeo(size: 24, weight: .medium)
                    .foregroundColor(.white)
                    .lineSpacing(2)
                    .loadingProgress(isLoadCompleted: locationDataManagerVM.isLocationUpdated)
                    
                    
                    Text(Util().currentDateByCustomFormatter(
                        dateFormat: "E요일, M월 d일")
                    )
                    .font(.system(size: 13))
                    .foregroundColor(.white)
                }
                .padding(.leading, 40)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center, spacing: 4) {
                        Image("sunrise")
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        Text("AM \(viewModel.sunRiseAndSetHHmm.0)")
                            .fontSpoqaHanSansNeo(size: 14, weight: .regular)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 5)
                    .overlay(alignment: .bottom) {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.white.opacity(0.3))  // Day
                    }
                    
                    HStack(alignment: .center, spacing: 4) {
                        Image("sunset")
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        Text("PM \(viewModel.sunRiseAndSetHHmm.1)")
                            .fontSpoqaHanSansNeo(size: 14, weight: .medium)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 5)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color.red.opacity(viewModel.isDayMode ? 0.3 : 0.2))
                .cornerRadius(14)
            }
            
            
            HStack(alignment: .center, spacing: 20) {
                LottieView(
                    jsonName: viewModel.currentWeatherAnimationImg,
                    loopMode: .loop
                )
                .frame(width: animationWidth, height: animationHeight)
                
                VStack(alignment: .center, spacing: 0) {
                    
                    HStack(alignment: .top, spacing: 2) {
                        Text(viewModel.currentWeatherInformation.temperature)
                            .fontSpoqaHanSansNeo(size: 55, weight: .bold)
                            .foregroundColor(.white)
                            .loadingProgress(isLoadCompleted: viewModel.isCurrentWeatherInformationLoadCompleted)
                            .padding(.top, 5)
                        
                        Text("° C")
                            .fontSpoqaHanSansNeo(size: 18, weight: .medium)
                            .foregroundColor(.white)
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        Image(systemName: "arrow.down")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.blue.opacity(viewModel.isDayMode ? 0.8 : 0.6))
                            .frame(width: 15, height: 15)
                        
                        Text(viewModel.todayMinMaxTemperature.0)
                            .fontSpoqaHanSansNeo(size: 16, weight: .regular)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.leading, 3)
                        
                        Image(systemName: "arrow.up")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.red.opacity(viewModel.isDayMode ? 0.8 : 0.6))
                            .frame(width: 15, height: 15)
                            .padding(.leading, 10)
                        
                        Text(viewModel.todayMinMaxTemperature.1)
                            .fontSpoqaHanSansNeo(size: 16, weight: .regular)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.leading, 3)
                    }
                    .padding(.top, 10)
                }
                
            }
            .padding(.leading, 50)
            .padding(.trailing, 30)
        }
    }
}

extension TodayViewController {
    
    var currentWeatherInfPagerFirstView: some View {
        
        return VStack(alignment: .leading, spacing: 10) {
            CurrentWeatherInformationItemView(
                imageString: "precipitation2",
                imageColor: Color.blue,
                title: "강수량",
                value: viewModel.currentWeatherInformation.oneHourPrecipitation,
                isDayMode: viewModel.isDayMode
            )
            
            CurrentWeatherInformationItemView(
                imageString: "wind2",
                imageColor: Color.red.opacity(0.7),
                title: "바람",
                value: viewModel.currentWeatherInformation.windSpeed,
                isDayMode: viewModel.isDayMode
            )
            
            CurrentWeatherInformationItemView(
                imageString: "wet2",
                imageColor: Color.blue.opacity(0.7),
                title: "습도",
                value: viewModel.currentWeatherInformation.wetPercent,
                isDayMode: viewModel.isDayMode
            )
        }
        .padding(.horizontal, 26)
    }
}

extension TodayViewController {
    
    var currentWeatherInfPagerSecondView: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            CurrentWeatherInformationItemView(
                imageString: "fine_dust",
                imageColor: Color.black.opacity(0.7),
                title: "미세먼지",
                value: (viewModel.currentFineDustTuple.description, ""),
                isDayMode: viewModel.isDayMode,
                backgroundColor: viewModel.currentFineDustTuple.color
            )
            
            CurrentWeatherInformationItemView(
                imageString: "fine_dust",
                imageColor: Color.red.opacity(0.7),
                title: "초미세먼지",
                value: (viewModel.currentUltraFineDustTuple.description, ""),
                isDayMode: viewModel.isDayMode,
                backgroundColor: viewModel.currentUltraFineDustTuple.color
            )
        }
        .padding(.horizontal, 26)
    }
}
