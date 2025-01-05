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
}
