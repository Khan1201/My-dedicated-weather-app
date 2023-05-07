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
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 10) {
                
                ForEach(homeViewModel.threeToTenDaysTemperature, id: \.id) {
                    HomeViewMinMaxTemperatureVC(
                        day: $0.day,
                        min: $0.minMax.0,
                        max: $0.minMax.1
                    )
                }
            }
            
            switch locationDataManager.locationManager.authorizationStatus {
                
            case .authorizedAlways, .authorizedWhenInUse:
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("위치 정보 권한 얻음")
                        .onTapGesture {
                            locationDataManager.locationManager.requestLocation()
                        }
                    Text("버튼")
                        .onTapGesture {
                            
                            let XY: Util.LatXLngY = Util().convertGPS2XY(
                                mode: .toGPS,
                                lat_X: locationDataManager.locationManager.location?.coordinate.latitude ?? 0,
                                lng_Y: locationDataManager.locationManager.location?.coordinate.longitude ?? 0
                            )
                            
                            Task {
                                
                                await homeViewModel.requestVeryShortForecastItems(
                                    x: String(XY.x),
                                    y: String(XY.y))
                            }
                        }
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
        .task {
            await homeViewModel.requestMidTermForecastItems()
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
