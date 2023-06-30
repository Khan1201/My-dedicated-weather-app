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
                
                //                listAfterCurrentTimeView
                //                    .padding(.top, 25)
                //                    .padding(.leading, 20)
                
                Spacer()
            }
            .padding(.top, 35)
            //            .background(Color.blue.opacity(0.3))
            .background {
                
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.07, green: 0.1, blue: 0.14), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.17, green: 0.19, blue: 0.26), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
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
                //                            Image(
                //                                Util().decideImageWhetherDayOrNight(
                //                                    dayImageString: "sunny_background",
                //                                    nightImgString: "night_background"
                //                                )
                //                            )
                //                            .overlay {
                //                                Color.black.opacity(0.2)
                //                            }
            }
            .task {
                await homeViewModel.HomeViewControllerTaskAction(
                    xy: locationDataManagerVM.convertLocationToXYForVeryShortForecast(),
                    longLati: locationDataManagerVM.longitudeAndLatitude
                )
            }
            .onChange(of: locationDataManagerVM.isLocationUpdated &&
                      homeViewModel.isKakaoAddressLoadCompleted) { _ in
                homeViewModel.HomeViewControllerLocationUpdatedAction(
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
                .foregroundColor(homeViewModel.isNightMode ? .white : CustomColor.black.toColor)
                .lineSpacing(2)
                .loadingProgress(isLoadCompleted: $locationDataManagerVM.isLocationUpdated)
                
                
                Text(Util().currentDateByCustomFormatter(
                    dateFormat: "E요일, M월 d일")
                )
                .font(.system(size: 13))
                .foregroundColor(homeViewModel.isNightMode ? .white.opacity(0.7) : CustomColor.black.toColor.opacity(0.7))
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
                        .foregroundColor(homeViewModel.isNightMode ? .white : CustomColor.black.toColor)
                        .loadingProgress(isLoadCompleted: $homeViewModel.isCurrentWeatherInformationLoadCompleted)
                        .padding(.top, 5)
                    
                    Text("° C")
                        .fontSpoqaHanSansNeo(size: 14, weight: .light)
                        .foregroundColor(homeViewModel.isNightMode ? .white : CustomColor.black.toColor)
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
                    title: "강수량", value: homeViewModel.currentWeatherInformation.oneHourPrecipitation, isNightMode: true
                )
                
                CurrentWeatherInformationItem(
                    imageString: "wind2", imageColor: Color.red.opacity(0.7),
                    title: "바람", value: homeViewModel.currentWeatherInformation.windSpeed, isNightMode: true
                )
                
                CurrentWeatherInformationItem(
                    imageString: "wet2", imageColor: Color.blue.opacity(0.7),
                    title: "습도", value: homeViewModel.currentWeatherInformation.wetPercent, isNightMode: true
                )
                
                CurrentWeatherInformationItem(
                    imageString: "fine_dust", imageColor: Color.black.opacity(0.7),
                    title: "미세먼지", value: homeViewModel.currentFineDustTuple.description, isNightMode: true, backgroundColor: homeViewModel.currentFineDustTuple.color
                )
                
                CurrentWeatherInformationItem(
                    imageString: "fine_dust", imageColor: Color.red.opacity(0.7),
                    title: "초미세먼지", value: homeViewModel.currentUltraFineDustTuple.description, isNightMode: true,
                    backgroundColor: homeViewModel.currentUltraFineDustTuple.color
                )
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

extension HomeViewController {
    
    var listAfterCurrentTimeView: some View {
        
        return VStack(alignment: .leading, spacing: 20) {
            Text("Today")
                .font(.system(size: 20, weight: .bold))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 10) {
                    ForEach(
                        homeViewModel.todayWeatherInformations,
                        id: \.time
                    ) {
                        WeatherInformationsWithImgAndTimeAndTemperature(
                            imageString: $0.weatherImage,
                            time: $0.time,
                            temperature: $0.temperature
                        )
                    }
                }
            }
        }
    }
}
