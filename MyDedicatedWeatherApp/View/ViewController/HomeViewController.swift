//
//  HomeViewController.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import SwiftUI
import SwiftUIPager

struct HomeViewController: View {
    @StateObject var homeViewModel: HomeViewModel = HomeViewModel()
    @StateObject var locationDataManagerVM = LocationDataManagerVM()
    
    @State private var arrowRightOffset: CGFloat = -25
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
                    
                    Pager(page: page, data: homeViewModel.pageViewCount, id: \.self) { index in
                        
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
                        Image("arrow_\(isFirstPage ? "right" : "left")")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .offset(x: isFirstPage ? -18 : 18, y: arrowRightOffset)
                            .onTapGesture {
                                withAnimation {
                                    isFirstPage ? page.update(.next) : page.update(.previous)
                                }
                                pageIndex = page.index
                            }
                    }
                    .onAppear {
                        withAnimation(.linear(duration: 0.6).repeatForever()) {
                            arrowRightOffset = -15
                        }
                    }
                }
                
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.vertical, 20)
                    .padding(.horizontal, 26)
                
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(alignment: .center, spacing: 24) {
                        ForEach(homeViewModel.todayWeatherInformations, id: \.time) { item in
                            TodayWeatherItem(
                                time: item.time,
                                weatherImage: item.weatherImage,
                                percent: item.precipitation,
                                temperature: item.temperature,
                                isDayMode: homeViewModel.isDayMode
                            )
                            .padding(.leading, homeViewModel.todayWeatherInformations.first?.time == item.time ? 15 : 0)
                            .padding(.trailing, homeViewModel.todayWeatherInformations.last?.time == item.time ? 15 : 0)
                        }
                    }
                    .padding(.vertical, 10)
                }
                .background {
                    homeViewModel.isDayMode ? CustomColor.lightNavy.toColor.opacity(0.2) : Color.white.opacity(0.08)
                }
                .cornerRadius(16)
                .padding(.horizontal, 26)
            }
            .padding(.top, 25)
            .frame(height: UIScreen.screenHeight, alignment: .center)
            .background {
                if homeViewModel.isDayMode {
                    Image("background_sunny")
                        .overlay {
                            Color.black.opacity(0.1)
                        }
                    
                } else {
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.07, green: 0.1, blue: 0.14), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.17, green: 0.19, blue: 0.26), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0, y: 0),
                        endPoint: UnitPoint(x: 1, y: 1)
                    )
                    .ignoresSafeArea()
                    .overlay {
                        Image("background_star")
                            .resizable()
                            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                    }
                    .overlay(alignment: .topTrailing) {
                        Image("background_cloud")
                            .resizable()
                            .frame(width: 400, height: 400)
                    }
                }
            }
            .onChange(of: locationDataManagerVM.isLocationUpdated) { _ in
                homeViewModel.HomeViewControllerLocationManagerUpdatedAction(
                    xy: locationDataManagerVM.convertLocationToXYForVeryShortForecast(),
                    longLati: locationDataManagerVM.longitudeAndLatitude
                )
            }
            .onChange(of: homeViewModel.isKakaoAddressLoadCompleted) { newValue in
                homeViewModel.HomeViewControllerKakaoAddressUpdatedAction(
                    umdName: homeViewModel.subLocalityByKakaoAddress,
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

struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewController()
    }
}

// MARK: - Supporting Views..

extension HomeViewController {
    
    var currentWeatherWithImageAndTemperatureView: some View {
        
        let animationWidth: CGFloat = UIScreen.screenWidth / 2.5
        let animationHeight: CGFloat = UIScreen.screenHeight / 5.41
        
        return VStack(alignment: .leading, spacing: 8) {
            
            
            HStack(alignment: .center, spacing: 60) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(
                    """
                    \(locationDataManagerVM.currentLocation),
                    \(homeViewModel.subLocalityByKakaoAddress)
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
                        
                        Text("AM \(homeViewModel.sunRiseAndSetHHmm.0)")
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
                        
                        Text("PM \(homeViewModel.sunRiseAndSetHHmm.1)")
                            .fontSpoqaHanSansNeo(size: 14, weight: .medium)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 5)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Color.red.opacity(homeViewModel.isDayMode ? 0.3 : 0.2))
                .cornerRadius(14)
            }
            
            
            HStack(alignment: .center, spacing: 20) {
                LottieView(
                    jsonName: homeViewModel.currentWeatherAnimationImg,
                    loopMode: .loop
                )
                .frame(width: animationWidth, height: animationHeight)
                
                VStack(alignment: .center, spacing: 0) {
                    
                    HStack(alignment: .top, spacing: 2) {
                        Text(homeViewModel.currentWeatherInformation.temperature)
                            .fontSpoqaHanSansNeo(size: 55, weight: .bold)
                            .foregroundColor(.white)
                            .loadingProgress(isLoadCompleted: homeViewModel.isCurrentWeatherInformationLoadCompleted)
                            .padding(.top, 5)
                        
                        Text("° C")
                            .fontSpoqaHanSansNeo(size: 18, weight: .medium)
                            .foregroundColor(.white)
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        Image(systemName: "arrow.down")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.blue.opacity(homeViewModel.isDayMode ? 0.8 : 0.6))
                            .frame(width: 15, height: 15)
                        
                        Text(homeViewModel.todayMinMaxTemperature.0)
                            .fontSpoqaHanSansNeo(size: 16, weight: .regular)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.leading, 3)
                        
                        Image(systemName: "arrow.up")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color.red.opacity(homeViewModel.isDayMode ? 0.8 : 0.6))
                            .frame(width: 15, height: 15)
                            .padding(.leading, 10)
                        
                        Text(homeViewModel.todayMinMaxTemperature.1)
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

extension HomeViewController {
    
    var currentWeatherInfPagerFirstView: some View {
        
        return VStack(alignment: .leading, spacing: 10) {
            CurrentWeatherInformationItem(
                imageString: "precipitation2",
                imageColor: Color.blue,
                title: "강수량",
                value: homeViewModel.currentWeatherInformation.oneHourPrecipitation,
                isDayMode: homeViewModel.isDayMode
            )
            
            CurrentWeatherInformationItem(
                imageString: "wind2",
                imageColor: Color.red.opacity(0.7),
                title: "바람",
                value: homeViewModel.currentWeatherInformation.windSpeed,
                isDayMode: homeViewModel.isDayMode
            )
            
            CurrentWeatherInformationItem(
                imageString: "wet2",
                imageColor: Color.blue.opacity(0.7),
                title: "습도",
                value: homeViewModel.currentWeatherInformation.wetPercent,
                isDayMode: homeViewModel.isDayMode
            )
        }
        .padding(.horizontal, 26)
    }
}

extension HomeViewController {
    
    var currentWeatherInfPagerSecondView: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            CurrentWeatherInformationItem(
                imageString: "fine_dust",
                imageColor: Color.black.opacity(0.7),
                title: "미세먼지",
                value: (homeViewModel.currentFineDustTuple.description, ""),
                isDayMode: homeViewModel.isDayMode,
                backgroundColor: homeViewModel.currentFineDustTuple.color
            )
            
            CurrentWeatherInformationItem(
                imageString: "fine_dust",
                imageColor: Color.red.opacity(0.7),
                title: "초미세먼지",
                value: (homeViewModel.currentUltraFineDustTuple.description, ""),
                isDayMode: homeViewModel.isDayMode,
                backgroundColor: homeViewModel.currentUltraFineDustTuple.color
            )
        }
        .padding(.horizontal, 26)
    }
}
