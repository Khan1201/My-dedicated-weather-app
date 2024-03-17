//
//  SunriseAndSunsetCarculate.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 1/18/24.
//

import Foundation
import Foundation
import CoreLocation


let SOLAR_DEGREES_PER_HOUR = 15.0

private enum Event {
    case sunrise
    case sunset
}

private extension TimeZone {
    var hoursfromGMT: Double {
        return Double(self.secondsFromGMT()) / (60 * 60)
    }
}

func longitudinalHour(_ longitude: CLLocationDegrees) -> Double {
    return longitude / SOLAR_DEGREES_PER_HOUR
}

extension Date {
    
    fileprivate func timeOfEvent(_ event: Event, location: CLLocation, zenith: Zenith) -> Date? {
        let cal = Calendar.current
        
        let dayOfYear = Double(cal.ordinality(of: .day, in: .year, for: self) ?? 0)
        
        let sun = Sun(dayOfYear: dayOfYear)
        
        //guess for rise or set
        let guess = (event == .sunrise) ? 6.0 : 18.0
        let approxT = ((guess - longitudinalHour(location.coordinate.longitude)) / 24.0) + dayOfYear
        
        //7a.
        let cosHour = sun.localHourAngleCosine(zenith, latitude: location.coordinate.latitude)
        
        guard (cosHour < 1) && (cosHour > -1) else {
            return nil
        }
        
        //7b
        let multiplier = (event == .sunrise) ? -1.0 : 1.0
        let hour = (acos(cosHour).degrees * multiplier) / 15
        
        //8
        let T = (hour + sun.rightAscension - (0.06571 * approxT) - 6.622)
        
        //9 -- coerce into UTC
        var UTC = (T - longitudinalHour(location.coordinate.longitude)) + 9
        if UTC < 0 {
            UTC += 24
        }
        
        //coerce into NSDate
        var dateComponents = cal.dateComponents([.day, .month, .year], from: self)
        dateComponents.hour   = Int(UTC)
        dateComponents.minute = Int((UTC * 60).truncatingRemainder(dividingBy: 60))
        dateComponents.second = Int((UTC * 3600).truncatingRemainder(dividingBy: 60))
        dateComponents.timeZone = TimeZone(identifier: "UTC")
        
        return cal.date(from: dateComponents)
    }
    
    func sunrise(_ location: CLLocation, zenith: Zenith) -> Date? {
        return timeOfEvent(.sunrise, location: location, zenith: zenith)
    }
    
    func sunset(_ location: CLLocation, zenith: Zenith) -> Date? {
        return timeOfEvent(.sunset, location: location, zenith: zenith)
    }
    
    func sunrise(_ location: CLLocation) -> Date? {
        return sunrise(location, zenith: .official)
    }
    
    func sunset(_ location: CLLocation) -> Date? {
        return sunset(location, zenith: .official)
    }
}

struct Sun {
    let dayOfYear: Double
    
    var longitude: Double {
        let solarMeanAnomaly = (0.9856 * dayOfYear) - 3.289
        
        let solarLongitudeApprox = solarMeanAnomaly + (1.916 * sin(solarMeanAnomaly.radians)) +
            (0.020 * sin(2 * solarMeanAnomaly.radians)) + 282.634
        
        return solarLongitudeApprox.truncatingRemainder(dividingBy: 360)
    }
    
    var rightAscension: Double {
        let x = 0.91764 * tan(longitude.radians)
        var solarRightAscensionApprox = atan(x).degrees
        
        let LQuadrant  = (floor(longitude                 / 90.0)) * 90
        let RAQuadrant = (floor(solarRightAscensionApprox / 90.0)) * 90
        
        solarRightAscensionApprox = solarRightAscensionApprox + (LQuadrant - RAQuadrant)
        
        return solarRightAscensionApprox / SOLAR_DEGREES_PER_HOUR
    }
    
    var declination: (sin: Double, cos: Double) {
        let s = 0.39782 * sin(longitude.radians)
        let c = cos(asin(s))
        
        return (s, c)
    }
    
    func localHourAngleCosine(_ zenith: Zenith, latitude: Double) -> Double {
        let zenithCosine = cos(zenith.rawValue.radians)
        
        return (zenithCosine -
            (declination.sin * sin(latitude.radians))) /
            (declination.cos * cos(latitude.radians))
    }
}

// The usual one is 'Official'.

enum Zenith: Double {
    case official     = 90.8333333333
    case civil        = 96.0
    case nautical     = 102.0
    case astronomical = 108.0
}

//helpful maths functions
extension Double {
    public var radians: Double { return self * Double.pi / 180 }
    public var degrees: Double { return self * 180 / Double.pi }
}
