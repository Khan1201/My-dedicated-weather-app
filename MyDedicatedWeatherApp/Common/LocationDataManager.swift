//
//  LocationDataManager.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/05/07.
//

import Foundation
import CoreLocation

final class LocationDataManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
//    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var currentLocation: String = ""
    @Published var currentLocationSubLocality: String = ""
    @Published var isLocationPermissionAllow: Bool = false
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .authorizedAlways, .authorizedWhenInUse:
            
            locationManager.requestLocation()
            isLocationPermissionAllow = true
        case .restricted:
            currentLocation = "위치정보 권한이 필요합니다."
            isLocationPermissionAllow = false

        case .denied:
            currentLocation = "위치정보 권한이 필요합니다."
            isLocationPermissionAllow = false
        case .notDetermined:
            currentLocation = "위치정보 권한이 필요합니다."
            isLocationPermissionAllow = false
            manager.requestWhenInUseAuthorization()
        default:
            ()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let findLocation: CLLocation = CLLocation(
            latitude: locationManager.location?.coordinate.latitude ?? 0,
            longitude: locationManager.location?.coordinate.longitude ?? 0
        )
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-kr") // Korea
        
        geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { place, error in
            if let address: CLPlacemark = place?.last {
                self.currentLocation = "\(address.administrativeArea ?? "")  \(address.subLocality ?? "")"
                self.currentLocationSubLocality = address.subLocality ?? ""
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
