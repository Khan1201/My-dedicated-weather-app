//
//  HomeView.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeViewModel: HomeViewModel = HomeViewModel()
    @StateObject var locationDataManager = LocationDataManager()
    @State var test: String = ""
    
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
                    Text(locationDataManager.currentLocation)
                        .font(.system(size: 24, weight: .medium))
                        
                    if !locationDataManager.isLocationPermissionAllow {
                        ProgressView()
                    }
                }
                
                Text(Util().currntDateByCustomFormatter(
                    dateFormat: "yyyy, MM / dd")
                )
                    .font(.system(size: 20))
                    .foregroundColor(.gray.opacity(0.7))
                
                Image(homeViewModel.currentWeatherInformation.weatherImage)
                    .resizable()
                    .frame(width: 120, height: 120)
                
                Text(homeViewModel.currentWeatherInformation.temperature + "°")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(.gray)
                
                
                HStack(alignment: .top, spacing: 60) {
                    VStack(alignment: .center, spacing: 5) {
                        Image("precipitation")
                            .resizable()
                            .frame(width: 25, height: 25)
                        
                        Text(homeViewModel.currentWeatherInformation.oneHourPrecipitation)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .center, spacing: 5) {
                        Image("wind")
                            .resizable()
                            .frame(width: 25, height: 25)
                            
                        Text(homeViewModel.currentWeatherInformation.windSpeed)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .center, spacing: 5) {
                        
                        Image("wet")
                            .resizable()
                            .frame(width: 25, height: 25)
                        
                        Text(homeViewModel.currentWeatherInformation.wetPercent + "%")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 15)
                
                HStack(alignment: .center, spacing: 40) {
                    
                    VStack(alignment: .center, spacing: 5) {
                        Text("미세먼지")
                            .font(.system(size: 12))
                        
                        Text(homeViewModel.currentFineDustTuple.0)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(homeViewModel.currentFineDustTuple.1
                                .opacity(0.7))
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background {
                        homeViewModel.currentFineDustTuple.1.opacity(0.2)
                    }
                    .cornerRadius(8)
                    
                    VStack(alignment: .center, spacing: 5) {
                        Text("초미세먼지")
                            .font(.system(size: 12))
                        
                        Text(homeViewModel.currentUltraFindDustTuple.0)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(homeViewModel.currentUltraFindDustTuple.1
                                .opacity(0.7))
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background {
                        homeViewModel.currentUltraFindDustTuple.1.opacity(0.2)
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
        .task {
            let XY: Util.LatXLngY = Util().convertGPS2XY(
                mode: .toGPS,
                lat_X: locationDataManager.locationManager.location?.coordinate.latitude ?? 0,
                lng_Y: locationDataManager.locationManager.location?.coordinate.longitude ?? 0
            )
            await homeViewModel.requestVeryShortForecastItems(
                x: String(XY.x),
                y: String(XY.y)
            )
            locationDataManager.locationManager.requestLocation()
            await homeViewModel.requestRealTimeFindDustForecastItems(
                stationName: locationDataManager.currentLocationSubLocality
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
