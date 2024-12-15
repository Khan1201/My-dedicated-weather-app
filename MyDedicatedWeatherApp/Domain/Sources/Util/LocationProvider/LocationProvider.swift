//
//  LocationProvider.swift
//
//
//  Created by 윤형석 on 12/15/24.
//

import Foundation
import CoreLocation

public struct LocationProvider {
    public static func getLatitudeAndLongitude(address: String, completion: @escaping (Result<(Double, Double), Error>) -> Void) {
        let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                guard let placemarks = placemarks,
                let location = placemarks.first?.location?.coordinate else {
                    return completion(.failure(LocationError.notFound))
                }
                completion(.success((location.latitude, location.longitude)))
            }
    }
    
    public static func getLocality(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Result<String, Error>) -> Void) {
        let geoCoder: CLGeocoder = CLGeocoder()
        let locale: Locale = Locale(identifier: "Ko-KR") // Korea
        let location: CLLocation = CLLocation(
            latitude: latitude,
            longitude: longitude
        )
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { places, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let address = places?.last else { return }
            completion(.success(address.administrativeArea ?? ""))
        }
    }
}
