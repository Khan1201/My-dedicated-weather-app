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
        .init(longitude: longitude, latitude: latitude, x: xy.0, y: xy.1, locality: locality, subLocality: subLocality, fullAddress: fullAddress)
    }
    
    public var initialLocationInf: LocationInformation {
        .init(longitude: longitude, latitude: latitude, x: xy.0, y: xy.1, locality: locality, subLocality: subLocality, fullAddress: fullAddress, isGPSLocation: true)
    }
    
    public var gpsLocationInf: LocationInformation {
        .init(longitude: longitude, latitude: latitude, x: xy.0, y: xy.1, locality: gpsLocality, subLocality: gpsSubLocality, fullAddress: gpsFullAddress)
    }
    
    private let commonUtil: CommonUtil = .shared
    private let userDefaultsService: UserDefaultsService
    
    private var locationManager = CLLocationManager()
    
    public init(userDefaultsService: UserDefaultsService) {
        self.userDefaultsService = userDefaultsService
        super.init()
        locationManager.delegate = self
    }
    
    @MainActor
    public func setLocality(_ value: String) {
        self.locality = value
    }
    
    @MainActor
    public func setLocalityWithWidget(_ value: String) {
        setLocality(value)
        userDefaultsService.setCurrentLocality(value)
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
    public func setXY(x: String, y: String) {
        self.xy = (x, y)
    }
    
    @MainActor
    public func setXYWithWidget(xy: Gps2XY.LatXLngY) {
        setXY(x: xy.x.toString, y: xy.y.toString)
        userDefaultsService.setCurrentLocationXY(x: xy.x.toString, y: xy.y.toString)
    }
    
    @MainActor
    public func setLongitudeAndLatitude(longitude: String, latitude: String) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    @MainActor
    public func setLongitudeAndLatitudeWithWidget(longitude: String, latitude: String) {
        setLongitudeAndLatitude(longitude: longitude, latitude: latitude)
        userDefaultsService.setCurrentLocationLongitudeAndLatitude(longitude: longitude, latitude: latitude)
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
        setXY(x:locationInf.x, y:locationInf.y)
        setLongitudeAndLatitude(longitude: locationInf.longitude, latitude: locationInf.latitude)
        setFullAddress(locationInf.fullAddress)
        setLocality(locationInf.locality)
        setSubLocality(locationInf.subLocality)
    }
    
    public func convertLocationToXY() -> Gps2XY.LatXLngY {
        let xy: Gps2XY.LatXLngY = commonUtil.convertGPS2XY(
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
                    Task {
                        await self.setLongitudeAndLatitude(longitude: String(longitude), latitude: String(latitude))
                        await self.setLocalityWithWidget(success)
                        await self.setGPSLocality(success)
                        self.isLocationUpdated = true
                    }
                    
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
        setLongitudeAndLatitudeWithWidget(
            longitude: String(locationManager.location?.coordinate.longitude ?? 0),
            latitude: String(locationManager.location?.coordinate.latitude ?? 0)
        )
        fetchLocality(
            latitude: locationManager.location?.coordinate.latitude ?? 0,
            longitude: locationManager.location?.coordinate.longitude ?? 0
        )
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
