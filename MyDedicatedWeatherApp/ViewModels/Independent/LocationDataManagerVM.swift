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
    
    private var locationManager = CLLocationManager()
    @Published var currentLocation: String = "" // 서울특별시, 대구광역시
    @Published var locationPermissonType: PermissionType = .notAllow
    
    var longitudeAndLatitude: (String, String) {
        
        return (
            String(locationManager.location?.coordinate.longitude ?? 0),
            String(locationManager.location?.coordinate.latitude ?? 0)
        )
    }
    
    /// Load Completed Variables..
    @Published var isLocationUpdated: Bool = false
    
    private let commonForecastUtil: CommonForecastUtil = CommonForecastUtil()
    
    enum PermissionType {
        
        case allow
        case notAllow
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocationManager() {
        locationManager.requestLocation()
    }
    
    func convertLocationToXYForVeryShortForecast() -> Gps2XY.LatXLngY {
        let xy: Gps2XY.LatXLngY = commonForecastUtil.convertGPS2XY(
            mode: .toXY,
            lat_X: locationManager.location?.coordinate.latitude ?? 0,
            lng_Y:locationManager.location?.coordinate.longitude ?? 0
        )
        UserDefaults.standard.set(xy.x, forKey: "x")
        UserDefaults.standard.set(xy.y, forKey: "y")
        return xy
    }
    
    func openAppSetting() {
        
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingURL) {
            UIApplication.shared.open(settingURL)
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
        // Widget에 공유 위해
        UserDefaults.shared.set(locationManager.location?.coordinate.latitude ?? 0, forKey: "latitude")
        UserDefaults.shared.set(locationManager.location?.coordinate.longitude ?? 0, forKey: "longitude")
        
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-KR") // Korea
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale: local) { [weak self] place, error in
            guard let self = self else { return }
            if let address: CLPlacemark = place?.last {
                self.currentLocation = address.administrativeArea ?? ""
                self.isLocationUpdated = true
                UserDefaults.standard.set(self.currentLocation, forKey: "locality")
                UserDefaults.shared.set(self.currentLocation, forKey: "locality")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
