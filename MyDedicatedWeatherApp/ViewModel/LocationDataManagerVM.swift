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
    @Published var currentLocation: String = "" // 서울특별시 성수동 1가
    @Published var currentLocationLocality: String = "" // 서울특별시
    @Published var locationPermissonType: PermissionType = .notAllow
    
    var longitudeAndLatitude: (String, String) {
        
        return (
            String(locationManager.location?.coordinate.longitude ?? 0),
            String(locationManager.location?.coordinate.latitude ?? 0)
        )
    }
    
    /// Load Completed Variables..
    @Published var isLocationUpdated: Bool = false
    
    private let util: Util = Util()
    
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
    
    func convertLocationToXYForVeryShortForecast() -> Util.LatXLngY {
        let XY: Util.LatXLngY = util.convertGPS2XY(
            mode: .toGPS,
            lat_X: locationManager.location?.coordinate.latitude ?? 0,
            lng_Y:locationManager.location?.coordinate.longitude ?? 0
        )
        return XY
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
            manager.requestLocation()
            locationPermissonType = .allow
        case .restricted:
            ()
        case .denied:
            ()
        case .notDetermined:
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
                self?.currentLocation = "\(address.locality ?? "")"
                self?.currentLocationLocality = address.administrativeArea ?? ""
                self?.isLocationUpdated = true
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
