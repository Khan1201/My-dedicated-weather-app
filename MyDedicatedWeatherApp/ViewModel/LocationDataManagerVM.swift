//
//  LocationDataManagerVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/05/07.
//

import Foundation
import CoreLocation

final class LocationDataManagerVM: NSObject, ObservableObject {
    
    private var locationManager = CLLocationManager()
    @Published var currentLocation: String = "" // 서울특별시 성수동 1가
    @Published var currentLocationSubLocality: String = "" // 성수동 1가
    @Published var currentLocationLocality: String = "" // 서울특별시
    @Published var isLocationPermissionAllow: Bool = false
    @Published var isLocationUpdated: Bool = false
    
    private let util: Util = Util()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocationManager() {
        locationManager.requestLocation()
    }
    
    func convertLocationToXYForVeryShortForecast() -> Util.LatXLngY {
        let XY: Util.LatXLngY = util.convertGPS2XY(
            mode: .toGPS,
            lat_X: locationManager.location?.coordinate.latitude ?? 0,
            lng_Y:locationManager.location?.coordinate.longitude ?? 0
        )
        return XY
    }
}

extension LocationDataManagerVM: CLLocationManagerDelegate {
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
        
        geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { [weak self] place, error in
            if let address: CLPlacemark = place?.last {
                self?.currentLocation = "\(address.locality ?? "")  \(address.subLocality ?? "")"
                self?.currentLocationSubLocality = address.subLocality ?? ""
                self?.currentLocationLocality = address.administrativeArea ?? ""
                self?.isLocationUpdated = true
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
