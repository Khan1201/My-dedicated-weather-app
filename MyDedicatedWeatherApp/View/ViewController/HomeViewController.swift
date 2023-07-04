//
//  HomeViewController.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import SwiftUI

struct HomeViewController: View {
    @StateObject var homeViewModel: HomeViewModel = HomeViewModel()
    @StateObject var locationDataManagerVM = LocationDataManagerVM()
    
    var body: some View {
        
        switch locationDataManagerVM.locationPermissonType {
            
        case .allow:
            
            VStack(alignment: .leading, spacing: 0) {
                
                VStack(alignment: .leading, spacing: 15) {
                    currentWeatherWithImageAndTemperatureView
                    currentWeatherWithAdditionalInformationsView
                }
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(.white)
                    .padding(.vertical, 25)
                    .padding(.horizontal, 26)
                
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(alignment: .center, spacing: 24) {
                        ForEach(homeViewModel.todayWeatherInformations, id: \.time) { item in
                            TodayWeatherItem(
                                time: homeViewModel.todayWeatherInformations.first?.time == item.time ? "Now" : item.time,
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
                    homeViewModel.isDayMode ? Color.black.opacity(0.03) : Color.white.opacity(0.03)
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
                            Color.black.opacity(0.15)
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
        
        return VStack(alignment: .leading, spacing: 8) {
            
            
            VStack(alignment: .leading, spacing: 10) {
                Text(
                """
                \(locationDataManagerVM.currentLocation),
                \(homeViewModel.subLocalityByKakaoAddress)
                """
                )
                .fontSpoqaHanSansNeo(size: 24, weight: .medium)
                .foregroundColor(homeViewModel.isDayMode ? CustomColor.black.toColor : .white)
                .lineSpacing(2)
                .loadingProgress(isLoadCompleted: locationDataManagerVM.isLocationUpdated)
                
                
                Text(Util().currentDateByCustomFormatter(
                    dateFormat: "E요일, M월 d일")
                )
                .font(.system(size: 13))
                .foregroundColor(homeViewModel.isDayMode ? CustomColor.black.toColor.opacity(0.7) : .white.opacity(0.7))
            }
            .padding(.leading, 40)
            
            HStack(alignment: .center, spacing: 10) {
                LottieView(
                    jsonName: homeViewModel.currentWeatherWithDescriptionAndImgString.imageString,
                    loopMode: .loop
                )
                .frame(width: 150, height: 150)
                
                HStack(alignment: .top, spacing: 2) {
                    Text(homeViewModel.currentWeatherInformation.temperature)
                        .fontSpoqaHanSansNeo(size: 45, weight: .bold)
                        .foregroundColor(homeViewModel.isDayMode ? CustomColor.black.toColor : .white)
                        .loadingProgress(isLoadCompleted: homeViewModel.isCurrentWeatherInformationLoadCompleted)
                        .padding(.top, 5)
                    
                    Text("° C")
                        .fontSpoqaHanSansNeo(size: 14, weight: .light)
                        .foregroundColor(homeViewModel.isDayMode ? CustomColor.black.toColor : .white)
                }
            }
            .padding(.leading, 50)
            .padding(.trailing, 30)
                        
        }
    }
}

extension HomeViewController {
    
    var currentWeatherWithAdditionalInformationsView: some View {
        
        return VStack(alignment: .center, spacing: 25) {
            
            
            VStack(alignment: .leading, spacing: 10) {
                CurrentWeatherInformationItem(
                    imageString: "precipitation2", imageColor: Color.blue,
                    title: "강수량", value: homeViewModel.currentWeatherInformation.oneHourPrecipitation,
                    isDayMode: homeViewModel.isDayMode
                )
                
                CurrentWeatherInformationItem(
                    imageString: "wind2", imageColor: Color.red.opacity(0.7),
                    title: "바람", value: homeViewModel.currentWeatherInformation.windSpeed,
                    isDayMode: homeViewModel.isDayMode
                )
                
                CurrentWeatherInformationItem(
                    imageString: "wet2", imageColor: Color.blue.opacity(0.7),
                    title: "습도", value: homeViewModel.currentWeatherInformation.wetPercent,
                    isDayMode: homeViewModel.isDayMode
                )
                
                //                CurrentWeatherInformationItem(
                //                    imageString: "fine_dust", imageColor: Color.black.opacity(0.7),
                //                    title: "미세먼지", value: homeViewModel.currentFineDustTuple.description,
                //                    isDayMode: homeViewModel.isDayMode,
                //                    backgroundColor: homeViewModel.currentFineDustTuple.color
                //                )
                //
                //                CurrentWeatherInformationItem(
                //                    imageString: "fine_dust", imageColor: Color.red.opacity(0.7),
                //                    title: "초미세먼지", value: homeViewModel.currentUltraFineDustTuple.description,
                //                    isDayMode: homeViewModel.isDayMode,
                //                    backgroundColor: homeViewModel.currentUltraFineDustTuple.color
                //                )
            }
            .padding(.horizontal, 26)
            
            //            HStack(alignment: .top, spacing: 60) {
            //
            //                WeatherInforamtionsWithImageAndDescriptionView(
            //                    imageString: "precipitation",
            //                    description: homeViewModel.currentWeatherInformation.oneHourPrecipitation
            //                )
            //                .loadingProgress(isLoadCompleted: $homeViewModel.isCurrentWeatherInformationLoadCompleted)
            //
            //                WeatherInforamtionsWithImageAndDescriptionView(
            //                    imageString: "wind",
            //                    description: homeViewModel.currentWeatherInformation.windSpeed
            //                )
            //                .loadingProgress(isLoadCompleted: $homeViewModel.isCurrentWeatherInformationLoadCompleted)
            //
            //                WeatherInforamtionsWithImageAndDescriptionView(
            //                    imageString: "wet",
            //                    description: homeViewModel.currentWeatherInformation.wetPercent + "%"
            //                )
            //                .loadingProgress(isLoadCompleted: $homeViewModel.isCurrentWeatherInformationLoadCompleted)
            //            }
            
            //            HStack(alignment: .center, spacing: 40) {
            //
            //                FineDustWithDescriptionAndBackgroundColorView(
            //                    title: "미세먼지",
            //                    description: homeViewModel.currentFineDustTuple.description,
            //                    descriptionFontColor: homeViewModel.currentFineDustTuple.color
            //                        .opacity(0.8),
            //                    backgroundColor:  homeViewModel.currentFineDustTuple.color.opacity(0.4)
            //                )
            //                .loadingProgress(isLoadCompleted: $homeViewModel.isFineDustLoadCompleted)
            //
            //                FineDustWithDescriptionAndBackgroundColorView(
            //                    title: "초미세먼지",
            //                    description: homeViewModel.currentUltraFineDustTuple.description,
            //                    descriptionFontColor: homeViewModel.currentUltraFineDustTuple.color
            //                        .opacity(0.8),
            //                    backgroundColor:  homeViewModel.currentUltraFineDustTuple.color.opacity(0.4)
            //                )
            //                .loadingProgress(isLoadCompleted: $homeViewModel.isFineDustLoadCompleted)
            //            }
        }
    }
}
