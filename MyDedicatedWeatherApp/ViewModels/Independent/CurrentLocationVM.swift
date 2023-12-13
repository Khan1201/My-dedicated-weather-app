//
//  CurrentLocationVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/5/23.
//

import Foundation

final class CurrentLocationVM: ObservableObject {
    
    static let shared = CurrentLocationVM()
    
    @Published private(set) var latitude: String = ""
    @Published private(set) var longitude: String = ""
    @Published private(set) var xy: (String, String) = ("", "")
    @Published private(set) var locality: String = ""
    @Published private(set) var subLocality: String = ""
    @Published private(set) var fullAddress: String = ""
    
    @Published private(set) var gpsLocality: String = ""
    @Published private(set) var gpsSubLocality: String = ""
    var gpsFullAddress: String {
        return gpsLocality + " " + gpsSubLocality
    }
    
    private init() {}
}

// MARK: - Set funcs..

extension CurrentLocationVM {
    
    @MainActor
    func setLocality(_ value: String) {
        self.locality = value
    }
    
    @MainActor
    func setSubLocality(_ value: String) {
        self.subLocality = value
    }
    
    @MainActor
    func setFullAddress(_ value: String) {
        self.fullAddress = value
    }
    
    @MainActor
    func setXY(_ value: (String, String)) {
        self.xy = value
    }
    
    @MainActor
    func setLatitude(_ value: String) {
        self.latitude = value
    }
    
    @MainActor
    func setLongitude(_ value: String) {
        self.longitude = value
    }
    
    @MainActor
    func setGPSLocality(_ value: String) {
        self.gpsLocality = value
    }
    
    @MainActor
    func setGPSSubLocality(_ value: String) {
        self.gpsSubLocality = value
    }
}
