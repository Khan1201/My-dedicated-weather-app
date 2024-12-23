//
//  CurrentLocationVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/5/23.
//

import Foundation
import CoreLocation
import Domain

public protocol CurrentLocationEODelegate: AnyObject {
    @MainActor
    func setSubLocality(_ value: String)
    @MainActor
    func setFullAddressByGPS()
    @MainActor
    func setGPSSubLocality(_ value: String)
    @MainActor
    func setCoordinateAndAllLocality(locationInf: LocationInformation)
    var locationInf: LocationInformation { get }
}

// MARK: -

public final class CurrentLocationEO: NSObject, ObservableObject, CurrentLocationEODelegate {
    @Published public var locationPermissonType: PermissionType = .notAllow
    @Published public var isLocationUpdated: Bool = false
    
    @Published public private(set) var latitude: String = ""
    @Published public private(set) var longitude: String = ""
    @Published public private(set) var xy: (String, String) = ("", "")
    @Published public private(set) var locality: String = "" /// 서울특별시
    @Published public private(set) var subLocality: String = "" /// 성수동 1가
    @Published public private(set) var fullAddress: String = ""
    
    @Published public private(set) var gpsLocality: String = ""
    @Published public private(set) var gpsSubLocality: String = ""
    public var gpsFullAddress: String {
        return gpsLocality + " " + gpsSubLocality
    }
    public var longitudeAndLatitude: (String, String) {
        return (
            String(locationManager.location?.coordinate.longitude ?? 0),
            String(locationManager.location?.coordinate.latitude ?? 0)
        )
    }
    public var locationInf: LocationInformation {
        .init(longitude: longitude, latitude: latitude, xy: xy, locality: locality, subLocality: subLocality, fullAddress: fullAddress)
    }
    
    public var initialLocationInf: LocationInformation {
        .init(longitude: longitude, latitude: latitude, xy: xy, locality: locality, subLocality: subLocality, fullAddress: fullAddress, isGPSLocation: true)
    }
    
    public var gpsLocationInf: LocationInformation {
        .init(longitude: longitude, latitude: latitude, xy: xy, locality: gpsLocality, subLocality: gpsSubLocality, fullAddress: gpsFullAddress)
    }
    
    private let commonForecastUtil: CommonForecastUtil = CommonForecastUtil()
    private var locationManager = CLLocationManager()
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    @MainActor
    public func setLocality(_ value: String) {
        self.locality = value
    }
    
    @MainActor
    public func setSubLocality(_ value: String) {
        self.subLocality = value
    }
    
    @MainActor
    public func setFullAddress(_ value: String) {
        self.fullAddress = value
    }
    
    @MainActor
    public func setFullAddressByGPS() {
        self.fullAddress = gpsFullAddress
    }
    
    @MainActor
    public func setXY(_ value: (String, String)) {
        self.xy = value
    }
    
    @MainActor
    public func setXYWithWidget(xy: Gps2XY.LatXLngY) {
        self.xy = (xy.x.toString, xy.y.toString)
        UserDefaults.setWidgetShared(xy.x.toString, to: .x)
        UserDefaults.setWidgetShared(xy.y.toString, to: .y)
    }
    
    @MainActor
    public func setLatitude(_ value: String) {
        self.latitude = value
        UserDefaults.setWidgetShared(value, to: .latitude)
    }
    
    @MainActor
    public func setLatitudeWithWidget(_ value: String) {
        self.latitude = value
    }
    
    @MainActor
    public func setLongitude(_ value: String) {
        self.longitude = value
    }
    
    @MainActor
    public func setLongitudeWithWidget(_ value: String) {
        self.longitude = value
        UserDefaults.setWidgetShared(value, to: .longitude)
    }
    
    @MainActor
    public func setGPSLocality(_ value: String) {
        self.gpsLocality = value
    }
    
    @MainActor
    public func setGPSSubLocality(_ value: String) {
        self.gpsSubLocality = value
    }
    
    @MainActor
    public func setCoordinateAndAllLocality(locationInf: LocationInformation) {
        setXY(locationInf.xy)
        setLatitude(locationInf.latitude)
        setLongitude(locationInf.longitude)
        setFullAddress(locationInf.fullAddress)
        setLocality(locationInf.locality)
        setSubLocality(locationInf.subLocality)
    }
    
    public func convertLocationToXY() -> Gps2XY.LatXLngY {
        let xy: Gps2XY.LatXLngY = commonForecastUtil.convertGPS2XY(
            mode: .toXY,
            lat_X: locationManager.location?.coordinate.latitude ?? 0,
            lng_Y:locationManager.location?.coordinate.longitude ?? 0
        )
        return xy
    }
    
    public  func startUpdaitingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    private func fetchLocality(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
       LocationProvider.getLocality(
            latitude: latitude,
            longitude: longitude) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success):
                    locality = success
                    
                    Task {
                        await self.setLatitude(String(latitude))
                        await self.setLongitude(String(longitude))
                        await self.setLocality(self.locality)
                        await self.setGPSLocality(self.locality)
                    }
                    UserDefaults.setWidgetShared(locality, to: .locality)
                    self.isLocationUpdated = true
                case .failure(_):
                    self.locationManager.startUpdatingLocation()
                }
            }
    }
}

// MARK: - Location Manager Delegate

extension CurrentLocationEO: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .authorizedAlways, .authorizedWhenInUse:
            locationPermissonType = .allow
            
        case .restricted, .denied, .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        default:
            ()
        }
    }
        
    @MainActor public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        
        setXYWithWidget(xy: convertLocationToXY())
        setLongitudeWithWidget(String(locationManager.location?.coordinate.longitude ?? 0))
        setLatitudeWithWidget(String(locationManager.location?.coordinate.latitude ?? 0))
        fetchLocality(
            latitude: locationManager.location?.coordinate.latitude ?? 0,
            longitude: locationManager.location?.coordinate.longitude ?? 0
        )
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
