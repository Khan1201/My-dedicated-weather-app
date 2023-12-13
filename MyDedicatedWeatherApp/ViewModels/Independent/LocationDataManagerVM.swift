//
//  LocationDataManagerVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/05/07.
//

import Foundation
import CoreLocation
import UIKit

final class LocationDataManagerVM: NSObject, ObservableObject {
    
    @Published var currentLocality: String = "" // 서울특별시, 대구광역시
    @Published var locationPermissonType: PermissionType = .notAllow
    @Published var isLocationUpdated: Bool = false
    
    private let currentLocationVM: CurrentLocationVM
    private let commonForecastUtil: CommonForecastUtil = CommonForecastUtil()

    private var locationManager = CLLocationManager()
    var longitudeAndLatitude: (String, String) {
        
        return (
            String(locationManager.location?.coordinate.longitude ?? 0),
            String(locationManager.location?.coordinate.latitude ?? 0)
        )
    }
    
    enum PermissionType {
        
        case allow
        case notAllow
    }
    
    init(currentLocationVM: CurrentLocationVM = CurrentLocationVM.shared) {
        self.currentLocationVM = currentLocationVM
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocationManager() {
        locationManager.requestLocation()
    }
    
    func startUpdaitingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func initializeStates() {
        isLocationUpdated = false
    }
    
    func convertLocationToXYForVeryShortForecast() -> Gps2XY.LatXLngY {
        let xy: Gps2XY.LatXLngY = commonForecastUtil.convertGPS2XY(
            mode: .toXY,
            lat_X: locationManager.location?.coordinate.latitude ?? 0,
            lng_Y:locationManager.location?.coordinate.longitude ?? 0
        )
        return xy
    }
    
    func openAppSetting() {
        
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingURL) {
            UIApplication.shared.open(settingURL)
        }
    }

    static func getLatitudeAndLongitude(address: String, completion: @escaping (Result<(Double, Double), Error>) -> Void) {
        let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                guard let placemarks = placemarks,
                let location = placemarks.first?.location?.coordinate else {
                    return completion(.failure(LocationError.notFound))
                }
                completion(.success((location.latitude, location.longitude)))
            }
    }
}

extension LocationDataManagerVM: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
            locationPermissonType = .allow
            
        case .restricted, .denied, .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        default:
            ()
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()

        let location: CLLocation = CLLocation(
            latitude: locationManager.location?.coordinate.latitude ?? 0,
            longitude: locationManager.location?.coordinate.longitude ?? 0
        )
        let xy: Gps2XY.LatXLngY = convertLocationToXYForVeryShortForecast()
        let latitude: String = String(locationManager.location?.coordinate.latitude ?? 0)
        let longitude: String = String(locationManager.location?.coordinate.longitude ?? 0)
        
        // Widget에 공유 위해
        UserDefaults.setWidgetShared(latitude, to: .latitude)
        UserDefaults.setWidgetShared(longitude, to: .longitude)
        UserDefaults.setWidgetShared(String(xy.x), to: .x)
        UserDefaults.setWidgetShared(String(xy.y), to: .y)
        
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-KR") // Korea
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale: local) { [weak self] place, error in
            guard let self = self else { return }
            if let address: CLPlacemark = place?.last {
                self.currentLocality = address.administrativeArea ?? ""
                
                Task {
                    await self.currentLocationVM.setXY((String(xy.x), String(xy.y)))
                    await self.currentLocationVM.setLatitude(latitude)
                    await self.currentLocationVM.setLongitude(longitude)
                    await self.currentLocationVM.setLocality(self.currentLocality)
                    await self.currentLocationVM.setGPSLocality(self.currentLocality)
                }
                
                self.isLocationUpdated = true
                
                // Widget에 공유 위해
                UserDefaults.setWidgetShared(self.currentLocality, to: .locality)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
