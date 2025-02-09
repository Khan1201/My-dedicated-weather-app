//
//  UserDefaultsServiceImp.swift
//
//
//  Created by 윤형석 on 1/5/25.
//

import Foundation
import Domain

public struct UserDefaultsServiceImp: UserDefaultsService {
    public init() {} 
    
    public func getLocationInformations() -> [Domain.LocationInformation] {
        guard let savedData = UserDefaults.standard.data(forKey: UserDefaultsKeys.locationInformation) else { return [] }
        
        do {
            let locationInfs: [LocationInformation] = try JSONDecoder().decode([LocationInformation].self, from: savedData)
            return locationInfs
        } catch {
            print("Failed to decode locationInfs: \(error)")
            return []
        }
    }
    
    public func setLocationInformation(_ target: Domain.LocationInformation) {
        var savedLocationInfs: [LocationInformation] = getLocationInformations()
        guard !savedLocationInfs.contains(where: { $0.fullAddress == target.fullAddress }) else {
            print("이미 존재하는 LocationInf 입니다.")
            return
        }
        savedLocationInfs.append(target)
        
        do {
            let encodedData: Data = try JSONEncoder().encode(savedLocationInfs)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.locationInformation)
        } catch {
            print("Failed to incode locationInfs: \(error)")
        }
    }
    
    public func setLocationInformations(_ targets: [Domain.LocationInformation]) {
        var savedLocationInfs: [LocationInformation] = getLocationInformations()
        savedLocationInfs.append(contentsOf: targets)
        do {
            let encodedData: Data = try JSONEncoder().encode(savedLocationInfs)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.locationInformation)
        } catch {
            print("Failed to incode locationInfs: \(error)")
        }
    }
    
    public func removeLocationInformations(_ target: Domain.LocationInformation) {
        var savedLocationInfs: [LocationInformation] = getLocationInformations()
        savedLocationInfs.removeAll(where: { $0.fullAddress == target.fullAddress })
        setLocationInformations(savedLocationInfs)
    }
    
    public func getCurrentLocation() -> Domain.LocationInformation {
        .init(
            longitude: UserDefaults.shared.string(forKey: UserDefaultsKeys.longitude) ?? "",
            latitude: UserDefaults.shared.string(forKey: UserDefaultsKeys.latitude) ?? "",
            x: UserDefaults.shared.string(forKey: UserDefaultsKeys.x) ?? "",
            y: UserDefaults.shared.string(forKey: UserDefaultsKeys.y) ?? "",
            locality: UserDefaults.shared.string(forKey: UserDefaultsKeys.locality) ?? "",
            subLocality: UserDefaults.shared.string(forKey: UserDefaultsKeys.subLocality) ?? "",
            fullAddress: UserDefaults.shared.string(forKey: UserDefaultsKeys.fullAddress) ?? "",
            isGPSLocation: true
        )
    }
    
    public func getCurrentDustStationName() -> String {
        return UserDefaults.shared.string(forKey: UserDefaultsKeys.dustStationName) ?? ""
    }
    
    public func setCurrentLocationXY(x: String, y: String) {
        UserDefaults.shared.set(x, forKey: UserDefaultsKeys.x)
        UserDefaults.shared.set(y, forKey: UserDefaultsKeys.y)
    }
    
    public func setCurrentLocationLongitudeAndLatitude(longitude: String, latitude: String) {
        UserDefaults.shared.set(longitude, forKey: UserDefaultsKeys.longitude)
        UserDefaults.shared.set(latitude, forKey: UserDefaultsKeys.latitude)
    }
    
    public func setCurrentLocality(_ locality: String) {
        UserDefaults.shared.set(locality, forKey: UserDefaultsKeys.locality)
    }
    
    public func setCurrentSubLocality(_ subLocality: String) {
        UserDefaults.shared.set(subLocality, forKey: UserDefaultsKeys.subLocality)
    }
    
    public func setCurrentFullAddress(_ fullAddress: String) {
        UserDefaults.shared.set(fullAddress, forKey: UserDefaultsKeys.fullAddress)
    }
    
    public func setCurrentDustStationName(_ name: String) {
        UserDefaults.shared.set(name, forKey: UserDefaultsKeys.dustStationName)
    }
}
