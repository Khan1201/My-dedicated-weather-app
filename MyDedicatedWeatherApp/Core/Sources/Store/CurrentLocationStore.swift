//
//  CurrentLocationStore.swift
//  Core
//
//  Created by 윤형석 on 8/9/25.
//

import Foundation
import Domain

public enum CurrentLocationStoreAction {
    case setLocality(_ value: String)
    case setSubLocality(_ value: String)
    case setFullAddress(_ value: String)
    case setFullAddressByGPS
    case setXY(x: String, y: String)
    case setLongitudeAndLatitude(longitude: String, latitude: String)
    case setGPSLocality(_ value: String)
    case setGPSSubLocality(_ value: String)
    case setCoordinateAndAllLocality(locationInf: LocationInformation)
    case setSkyType(_ value: WeatherAPIValue)
    case setIsDayMode(sunriseHHmm: String, sunsetHHmm: String)
    case setIsLocationUpdate
}

public class CurrentLocationStoreState: ObservableObject {
    @Published public var isLocationUpdated: Bool = false
    
    @Published public var latitude: String = ""
    @Published public var longitude: String = ""
    @Published public var xy: (String, String) = ("", "")
    @Published public var locality: String = "" /// 서울특별시
    @Published public var subLocality: String = "" /// 성수동 1가
    @Published public var fullAddress: String = ""
    @Published public var gpsLocality: String = ""
    @Published public var gpsSubLocality: String = ""
    @Published public var skyType: WeatherAPIValue?
    @Published public var isDayMode: Bool = false
    
    public var gpsFullAddress: String {
        return gpsLocality + " " + gpsSubLocality
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
}

public final class DefaultCurrentLocationStore: CurrentLocationStore {
    public static let shared: DefaultCurrentLocationStore = .init()
    @Published public private(set) var state: CurrentLocationStoreState = .init()
    
    private init() {}
    
    public func send(_ action: CurrentLocationStoreAction) {
        Task {
            await reduce(state: state, action: action)
        }
    }
    
    @MainActor
    private func reduce(state: CurrentLocationStoreState, action: CurrentLocationStoreAction) {
        switch action {
        case .setLocality(let value):
            state.locality = value
            
        case .setSubLocality(let value):
            state.subLocality = value
            
        case .setFullAddress(let value):
            state.fullAddress = value

        case .setFullAddressByGPS:
            state.fullAddress = state.gpsFullAddress

        case .setXY(let x, let y):
            state.xy = (x, y)
            
        case .setLongitudeAndLatitude(let longitude, let latitude):
            state.longitude = longitude
            state.latitude = latitude
            
        case .setGPSLocality(let value):
            state.gpsLocality = value
            
        case .setGPSSubLocality(let value):
            state.gpsSubLocality = value
            
        case .setCoordinateAndAllLocality(let locationInf):
            state.xy = (locationInf.x, locationInf.y)
            state.longitude = locationInf.longitude
            state.latitude = locationInf.latitude
            state.fullAddress = locationInf.fullAddress
            state.locality = locationInf.locality
            state.subLocality = locationInf.subLocality
            
        case .setSkyType(let value):
            state.skyType = value
            
        case .setIsDayMode(let sunriseHHmm, let sunsetHHmm):
            let currentHHmm = Date().toString(format: "HHmm")
            let sunTime: SunTime = .init(
                currentHHmm: currentHHmm,
                sunriseHHmm: sunriseHHmm,
                sunsetHHmm: sunsetHHmm
            )
            state.isDayMode = sunTime.isDayMode
            
        case .setIsLocationUpdate:
            state.isLocationUpdated = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                state.isLocationUpdated = true
            }
        }
    }
}
