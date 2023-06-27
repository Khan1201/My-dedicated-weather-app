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
                
                VStack(alignment: .center, spacing: 15) {
                    currentWeatherWithImageAndTemperatureView
                    currentWeatherWithAdditionalInformationsView
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                listAfterCurrentTimeView
                    .padding(.top, 25)
                    .padding(.leading, 20)
                
                Spacer()
            }
            .padding(.top, 35)
            .background {
                Image(
                    Util().decideImageWhetherDayOrNight(
                        dayImageString: "sunny_background",
                        nightImgString: "night_background"
                    )
                )
                .overlay {
                    Color.black.opacity(0.4)
                }
            }
            .task {
                await homeViewModel.HomeViewControllerTaskAction(
                    xy: locationDataManagerVM.convertLocationToXYForVeryShortForecast()
                )
//                await homeViewModel.requestVeryShortForecastItems(
//                    xy:locationDataManagerVM.convertLocationToXYForVeryShortForecast()
//                )
            }
            .onChange(of: locationDataManagerVM.isLocationUpdated) { _ in
                homeViewModel.HomeViewControllerLocationUpdatedAction(
                    umdName: locationDataManagerVM.currentLocationSubLocality,
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
        
        return VStack(alignment: .center, spacing: 8) {
            
            HStack(alignment: .center, spacing: 5) {
                Text(locationDataManagerVM.currentLocation)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .loadingProgress(isLoadCompleted: $locationDataManagerVM.isLocationUpdated)
            }
            
            Text(Util().currentDateByCustomFormatter(
                dateFormat: "yyyy, MM / dd")
            )
            .font(.system(size: 20))
            .foregroundColor(.white)
            
            LottieView(
                jsonName: homeViewModel.currentWeatherWithDescriptionAndImgString.imageString,
                loopMode: .loop
            )
            .frame(width: 150, height: 150)
            
            Text(homeViewModel.currentWeatherInformation.temperature + "°")
                .font(.system(size: 40, weight: .medium))
                .foregroundColor(.white)
                .loadingProgress(isLoadCompleted: $homeViewModel.isCurrentWeatherInformationLoadCompleted)
        }
    }
}

extension HomeViewController {
    
    var currentWeatherWithAdditionalInformationsView: some View {
        
        return VStack(alignment: .center, spacing: 25) {
            HStack(alignment: .top, spacing: 60) {
                
                WeatherInforamtionsWithImageAndDescriptionView(
                    imageString: "precipitation",
                    description: homeViewModel.currentWeatherInformation.oneHourPrecipitation
                )
                .loadingProgress(isLoadCompleted: $homeViewModel.isCurrentWeatherInformationLoadCompleted)
                
                WeatherInforamtionsWithImageAndDescriptionView(
                    imageString: "wind",
                    description: homeViewModel.currentWeatherInformation.windSpeed
                )
                .loadingProgress(isLoadCompleted: $homeViewModel.isCurrentWeatherInformationLoadCompleted)
                
                WeatherInforamtionsWithImageAndDescriptionView(
                    imageString: "wet",
                    description: homeViewModel.currentWeatherInformation.wetPercent + "%"
                )
                .loadingProgress(isLoadCompleted: $homeViewModel.isCurrentWeatherInformationLoadCompleted)
            }
            
            HStack(alignment: .center, spacing: 40) {
                
                FineDustWithDescriptionAndBackgroundColorView(
                    title: "미세먼지",
                    description: homeViewModel.currentFineDustTuple.description,
                    descriptionFontColor: homeViewModel.currentFineDustTuple.color
                        .opacity(0.8),
                    backgroundColor:  homeViewModel.currentFineDustTuple.color.opacity(0.4)
                )
                .loadingProgress(isLoadCompleted: $homeViewModel.isFineDustLoadCompleted)
                
                FineDustWithDescriptionAndBackgroundColorView(
                    title: "초미세먼지",
                    description: homeViewModel.currentUltraFineDustTuple.description,
                    descriptionFontColor: homeViewModel.currentUltraFineDustTuple.color
                        .opacity(0.8),
                    backgroundColor:  homeViewModel.currentUltraFineDustTuple.color.opacity(0.4)
                )
                .loadingProgress(isLoadCompleted: $homeViewModel.isFineDustLoadCompleted)
            }
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
