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
        
        switch locationDataManager.locationManager.authorizationStatus {
            
        case .authorizedAlways, .authorizedWhenInUse:
            
            VStack(alignment: .leading, spacing: 5) {
                
                VStack(alignment: .center, spacing: 8) {
                    Text("서울특별시")
                        .font(.system(size: 24, weight: .medium))
                    
                    Text(Util().currntDateByCustomFormatter(dateFormat: "yyyy, MM / dd"))
                        .font(.system(size: 20))
                        .foregroundColor(.gray.opacity(0.7))
                    
                    Image(homeViewModel.currentWeatherInformation.weatherImage)
                        .resizable()
                        .frame(width: 120, height: 120)
                    
                    Text(homeViewModel.currentWeatherInformation.temperature + "°")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(.gray)
                    
                    HStack(alignment: .top, spacing: 50) {
                        VStack(alignment: .leading, spacing: 5) {
                            Image("wind")
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                            Text(homeViewModel.currentWeatherInformation.windSpeed)
                                .font(.system(size: 26, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Image("precipitation")
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                            Text(homeViewModel.currentWeatherInformation.oneHourPrecipitation)
                                .font(.system(size: 26, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            
                            Image("wet")
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                            Text(homeViewModel.currentWeatherInformation.wetPercent)
                                .font(.system(size: 26, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
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
            }
            
        case .restricted:
            Text("위치 정보 제한됨")
            
        case .notDetermined:
            Text("위치 정보 찾는중..")
            ProgressView()
            
        default:
            ProgressView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
