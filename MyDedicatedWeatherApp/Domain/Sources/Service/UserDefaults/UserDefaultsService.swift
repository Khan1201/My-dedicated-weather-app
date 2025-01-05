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
}
