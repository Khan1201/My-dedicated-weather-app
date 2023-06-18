//
//  HomeView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import SwiftUI

struct HomeView: View {
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
        VStack(alignment: .leading, spacing: 5) {
            
            VStack(alignment: .center, spacing: 8) {
                
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
                
                
                HStack(alignment: .top, spacing: 60) {
                    VStack(alignment: .center, spacing: 5) {
                        Image("precipitation")
                            .resizable()
                            .frame(width: 25, height: 25)
                        
                        Text(homeViewModel.currentWeatherInformation.oneHourPrecipitation)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .center, spacing: 5) {
                        Image("wind")
                            .resizable()
                            .frame(width: 25, height: 25)
                            
                        Text(homeViewModel.currentWeatherInformation.windSpeed)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .center, spacing: 5) {
                        
                        Image("wet")
                            .resizable()
                            .frame(width: 25, height: 25)
                        
                        Text(homeViewModel.currentWeatherInformation.wetPercent + "%")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 15)
                
                HStack(alignment: .center, spacing: 40) {
                    
                    VStack(alignment: .center, spacing: 5) {
                        Text("미세먼지")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                        
                        Text(homeViewModel.currentFineDustTuple.0)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(homeViewModel.currentFineDustTuple.1
                                .opacity(0.8))
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background {
                        homeViewModel.currentFineDustTuple.1.opacity(0.4)
                    }
                    .cornerRadius(8)
                    
                    VStack(alignment: .center, spacing: 5) {
                        Text("초미세먼지")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                        
                        Text(homeViewModel.currentUltraFindDustTuple.0)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(homeViewModel.currentUltraFindDustTuple.1
                                .opacity(0.8))
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background {
                        homeViewModel.currentUltraFindDustTuple.1.opacity(0.4)
                    }
                    .cornerRadius(8)
                }
                .padding(.top, 15)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 30)
            
            Divider()
                .padding(.vertical, 10)
            Text("Today")
                .font(.system(size: 20, weight: .bold))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 5) {
                    ForEach(
                        homeViewModel.todayWeatherInformations,
                        id: \.time
                    ) {
                        TodayWeatherVC(
                            imageString: $0.weatherImage,
                            time: $0.time,
                            temperature: $0.temperature
                        )
                    }
                }
            }
            .padding(.top, 20)
        }
        .background(content: {
            Image("night_background")
                .overlay {
                    Color.black.opacity(0.5)
                }
                
        })
        .task {
            await locationDataManagerVM.requestLocationManager()
            await homeViewModel.requestVeryShortForecastItems(
                xy:locationDataManagerVM.convertLocationToXYForVeryShortForecast()
            )
            await homeViewModel.requestDustForecastStationXY(
                umdName: locationDataManagerVM.currentLocationSubLocality,
                locality: locationDataManagerVM.currentLocationLocality
            )
            await homeViewModel.requestDustForecastStation()
            await homeViewModel.requestRealTimeFindDustForecastItems()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
