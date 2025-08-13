//
//  CurrentLocationVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/5/23.
//

import Foundation
import CoreLocation
import Combine
import Domain

public final class CurrentLocationEO: NSObject, ObservableObject {
    @Published public private(set) var locationPermissonType: PermissionType = .notAllow
    @Published public private(set) var currentLocationStoreState: CurrentLocationStoreState = .init()
    private let currentLocationStore: any CurrentLocationStore
    
    private var locationManager = CLLocationManager()
    private let commonUtil: CommonUtil = .shared
    private let userDefaultsService: UserDefaultsService
    private var bag: Set<AnyCancellable> = []
    
    public init(userDefaultsService: UserDefaultsService, currentLocationStore: any CurrentLocationStore) {
        self.userDefaultsService = userDefaultsService
        self.currentLocationStore = currentLocationStore
        super.init()
        locationManager.delegate = self
        currentLocationStore.state.objectWillChange
            .sink { [weak self] _ in
                guard let self = self else { return }
                currentLocationStoreState = currentLocationStore.state
            }
            .store(in: &bag)
    }
}

// MARK: - Funcs
extension CurrentLocationEO {
    public func convertLocationToXY() -> Gps2XY.LatXLngY {
        let xy: Gps2XY.LatXLngY = commonUtil.convertGPS2XY(
            mode: .toXY,
            lat_X: locationManager.location?.coordinate.latitude ?? 0,
            lng_Y:locationManager.location?.coordinate.longitude ?? 0
        )
        return xy
    }
    
    public func startUpdaitingLocation() {
        locationManager.startUpdatingLocation()
    }
}

// MARK: - Fetch Funcs
extension CurrentLocationEO {
    private func fetchLocality(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
       LocationProvider.getLocality(
            latitude: latitude,
            longitude: longitude) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let success):
                    Task {
                        self.currentLocationStore.send(.setLongitudeAndLatitude(longitude: String(longitude), latitude: String(latitude)))
                        self.currentLocationStore.send(.setLocality(success))
                        self.currentLocationStore.send(.setGPSLocality(success))
                        self.currentLocationStore.send(.setIsLocationUpdate)
                        
                        self.userDefaultsService.setCurrentLocality(success)
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
            DispatchQueue.main.async {
                self.locationPermissonType = .allow
            }
            
        case .restricted, .denied, .notDetermined:
            manager.requestWhenInUseAuthorization()
            
        default:
            ()
        }
    }
        
    @MainActor public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()

        currentLocationStore.send(.setXY(
            x: convertLocationToXY().x.toString,
            y: convertLocationToXY().y.toString)
        )
        currentLocationStore.send(.setLongitudeAndLatitude(
            longitude: String(locationManager.location?.coordinate.longitude ?? 0),
            latitude: String(locationManager.location?.coordinate.latitude ?? 0))
        )
        
        fetchLocality(
            latitude: locationManager.location?.coordinate.latitude ?? 0,
            longitude: locationManager.location?.coordinate.longitude ?? 0
        )
        
        userDefaultsService.setCurrentLocationLongitudeAndLatitude(
            longitude: String(locationManager.location?.coordinate.longitude ?? 0),
            latitude: String(locationManager.location?.coordinate.latitude ?? 0)
        )
        userDefaultsService.setCurrentLocationXY(
            x: convertLocationToXY().x.toString,
            y: convertLocationToXY().y.toString
        )
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
}
