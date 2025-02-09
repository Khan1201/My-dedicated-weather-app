//
//  UserDefaultsService.swift
//
//
//  Created by 윤형석 on 1/5/25.
//

import Foundation

public protocol UserDefaultsService {
    func getLocationInformations() -> [LocationInformation]
    func setLocationInformation(_ target: LocationInformation)
    func setLocationInformations(_ targets: [LocationInformation])
    func removeLocationInformations(_ target: LocationInformation)
    
    func getCurrentLocation() -> LocationInformation
    func getCurrentDustStationName() -> String
    func setCurrentLocationXY(x: String, y: String)
    func setCurrentLocationLongitudeAndLatitude(longitude: String, latitude: String)
    func setCurrentLocality(_ locality: String)
    func setCurrentSubLocality(_ subLocality: String)
    func setCurrentFullAddress(_ fullAddress: String)
    func setCurrentDustStationName(_ name: String)
}
