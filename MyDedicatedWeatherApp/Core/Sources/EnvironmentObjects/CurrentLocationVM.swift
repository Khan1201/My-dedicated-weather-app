//
//  CurrentLocationVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/5/23.
//

import Foundation
import Domain

public final class CurrentLocationVM: ObservableObject {
    
    public static let shared = CurrentLocationVM()
    
    @Published public private(set) var latitude: String = ""
    @Published public private(set) var longitude: String = ""
    @Published public private(set) var xy: (String, String) = ("", "")
    @Published public private(set) var locality: String = ""
    @Published public private(set) var subLocality: String = ""
    @Published public private(set) var fullAddress: String = ""
    
    @Published public private(set) var gpsLocality: String = ""
    @Published public private(set) var gpsSubLocality: String = ""
    public var gpsFullAddress: String {
        return gpsLocality + " " + gpsSubLocality
    }
    
    private init() {}
}

// MARK: - Set funcs..

extension CurrentLocationVM {
    
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
    public func setXY(_ value: (String, String)) {
        self.xy = value
    }
    
    @MainActor
    public func setLatitude(_ value: String) {
        self.latitude = value
    }
    
    @MainActor
    public func setLongitude(_ value: String) {
        self.longitude = value
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
    public func setCoordinateAndAllLocality(xy: Gps2XY.LatXLngY, latitude: Double, longitude: Double, allLocality: AllLocality) {
        setXY((String(xy.x), String(xy.y)))
        setLatitude(String(latitude))
        setLongitude(String(longitude))
        setFullAddress(allLocality.fullAddress)
        setLocality(allLocality.locality)
        setSubLocality(allLocality.subLocality)
    }
}
