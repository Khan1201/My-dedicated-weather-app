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
    
    func setLocality(_ value: String) {
        self.locality = value
    }
    
    func setSubLocality(_ value: String) {
        self.subLocality = value
    }
    
    func setFullAddress(_ value: String) {
        self.fullAddress = value
    }
    
    func setXY(_ value: (String, String)) {
        self.xy = value
    }
    
    func setLatitude(_ value: String) {
        self.latitude = value
    }
    
    func setLongitude(_ value: String) {
        self.longitude = value
    }
    
    func setGPSLocality(_ value: String) {
        self.gpsLocality = value
    }
    
    func setGPSSubLocality(_ value: String) {
        self.gpsSubLocality = value
    }
}
