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
        
        //        ScrollView(.horizontal, showsIndicators: false) {
        //            HStack(alignment: .center, spacing: 10) {
        //
        //                ForEach(homeViewModel.threeToTenDaysTemperature, id: \.id) {
        //                    HomeViewMinMaxTemperatureVC(
        //                        day: $0.day,
        //                        min: $0.minMax.0,
        //                        max: $0.minMax.1
        //                    )
        //                }
        //            }
        //        }
        //        .task {
        //            await homeViewModel.requestMidTermForecastItems()
        //        }
        VStack(alignment: .leading, spacing: 0) {
            
            VStack(alignment: .center, spacing: 15) {
                
                currentWeatherWithImageAndTemperatureView
                
                currentWeatherWithAdditionalInformationsView
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            listAfterCurrentTimeView
                .padding(.top, 15)
            
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
            locationDataManagerVM.requestLocationManager()
            await homeViewModel.requestVeryShortForecastItems(
                xy:locationDataManagerVM.convertLocationToXYForVeryShortForecast()
            )
        }
        .onChange(of: locationDataManagerVM.isLocationUpdated) { _ in
            Task {
                await homeViewModel.requestDustForecastStationXY(
                    umdName: locationDataManagerVM.currentLocationSubLocality,
                    locality: locationDataManagerVM.currentLocationLocality
                )
                await homeViewModel.requestDustForecastStation()
                await homeViewModel.requestRealTimeFindDustForecastItems()
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
                
                if !locationDataManagerVM.isLocationPermissionAllow {
                    ProgressView()
                }
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
                
                WeatherInforamtionsWithImageAndDescriptionView(
                    imageString: "wind",
                    description: homeViewModel.currentWeatherInformation.windSpeed
                )
                
                WeatherInforamtionsWithImageAndDescriptionView(
                    imageString: "wet",
                    description: homeViewModel.currentWeatherInformation.wetPercent + "%"
                )
            }
            
            HStack(alignment: .center, spacing: 40) {
                
                FineDustWithDescriptionAndBackgroundColorView(
                    title: "미세먼지",
                    description: homeViewModel.currentFineDustTuple.description,
                    descriptionFontColor: homeViewModel.currentFineDustTuple.color
                        .opacity(0.8),
                    backgroundColor:  homeViewModel.currentFineDustTuple.color.opacity(0.4)
                )
                
                FineDustWithDescriptionAndBackgroundColorView(
                    title: "초미세먼지",
                    description: homeViewModel.currentUltraFindDustTuple.description,
                    descriptionFontColor: homeViewModel.currentUltraFindDustTuple.color
                        .opacity(0.8),
                    backgroundColor:  homeViewModel.currentUltraFindDustTuple.color.opacity(0.4)
                )
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
