//
//  HomeViewModel.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation
import CoreLocation

final class HomeViewModel: ObservableObject {
    
    @Published var threeToTenDaysTemperature: [temperatureMinMax] = []
    @Published var errorMessage: String = ""
    @Published var currentWeatherTuple: (String, String) = ("","") // (description, imageName)
    @Published var currentTemperature: String = ""
    @Published var currentWeatherInformation: CurrentWeatherInformationModel = Dummy().currentWeatherInformation()
    @Published var todayWeatherInformations: [TodayWeatherInformationModel] = []
    @Published var currentPlace: String = ""
    
    private let util = Util()
    
    func requestMidTermForecastItems() async {
        
        let parameters: MidTermForecastReq = MidTermForecastReq(
            serviceKey: Env().midTermForecastApiResponseKey,
            regId: MidTermLocationID.daegu.val,
            tmFc: Util().midTermForecastRequestDate()
        )
        do {
            let result = try await JsonRequest().newRequest(
                url: Route.GET_WEATHER_MID_TERM_FORECAST.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: OpenDataRes<MidTermForecastModel>.self
            )
            DispatchQueue.main.async {
                self.setMidTermForecastItemToArray(item: result.item.first ?? Dummy().midTermForecastModel())
            }
        } catch APIError.transportError {
            
            DispatchQueue.main.async {
                self.errorMessage = "API 통신 에러"
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "알 수 없는 오류"
            }
        }
    }
    
    func requestVeryShortForecastItems(x: String, y: String) async {
        
        let baseTime = Util().veryShortTermForecastBaseTime()
        
        let parameters: VeryShortOrShortTermForecastReq = VeryShortOrShortTermForecastReq(
            serviceKey: Env().midTermForecastApiResponseKey,
            baseDate: util.veryShortTermForecastBaseDate(baseTime: baseTime),
            baseTime: baseTime,
            nx: x,
            ny: y
        )
        
        do {
            let result = try await JsonRequest().newRequest(
                url: Route.GET_WEATHER_VERY_SHORT_TERM_FORECAST.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: OpenDataRes<VeryShortOrShortTermForecastModel<VeryShortTermForecastCategory>>.self
            )
            DispatchQueue.main.async {
                self.setCurrentTemperature(items: result.item)
                self.setCurrentWeatherInformations(items: result.item)
                self.setTodayWeathers(items: result.item)
            }
            
        } catch APIError.transportError {
            
            DispatchQueue.main.async {
                self.errorMessage = "API 통신 에러"
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "알 수 없는 오류"
            }
        }
    }
    
    func currentWeatherTuple(items: [VeryShortOrShortTermForecastModel<VeryShortTermForecastCategory>]) -> (String, String) {
        
        let firstPTYItem = items.first { item in // 강수 형태
            item.category == .PTY
        }
        
        let firstSKYItem = items.first { item in // 하늘 상태
            item.category == .SKY
        }
        
        return util.veryShortTermForecastWeatherTuple(
            ptyValue: firstPTYItem?.fcstValue ?? "",
            skyValue: firstSKYItem?.fcstValue ?? ""
        )
    }
    
    func setCurrentTemperature(items: [VeryShortOrShortTermForecastModel<VeryShortTermForecastCategory>]) {
        
        let currenTemperatureItem = items.first { item in
            item.category == .T1H
        }
        
        if let currenTemperatureItem = currenTemperatureItem {
            currentTemperature = currenTemperatureItem.fcstValue
        } else {
            print ("currenTemperatureItem == null..")
        }
    }
    
    func setCurrentLocation(latitude: CGFloat, longitude: CGFloat) {
        let findLocation: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-kr") // Korea
        
        geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { place, error in
            if let address: [CLPlacemark] = place {
                self.currentPlace = (address.last?.administrativeArea ?? "") + (address.last?.locality ?? "")
            }
        }
    }
    
    func setCurrentWeatherInformations(items: [VeryShortOrShortTermForecastModel<VeryShortTermForecastCategory>]) {
        
        let currentTemperature = items.first { item in
            item.category == .T1H
        }
        
        let currentWindSpeed = items.first { item in
            item.category == .WSD
        }
        
        let currentWetPercent = items.first { item in
            item.category == .REH
        }
        
        let currentOneHourPrecipitation = items.first { item in
            item.category == .RN1
        }
        
        let currentWeatherTuple = currentWeatherTuple(items: items)
        
        currentWeatherInformation = CurrentWeatherInformationModel(
            temperature: currentTemperature?.fcstValue ?? "",
            windSpeed: util.remakeWindSpeedValue(value: currentWindSpeed?.fcstValue ?? ""),
            wetPercent: currentWetPercent?.fcstValue ?? "",
            oneHourPrecipitation: util.remakeOneHourPrecipitationValue(
                value: currentOneHourPrecipitation?.fcstValue ?? ""),
            weatherImage: currentWeatherTuple.1
        )
        
    }
    
    func setTodayWeathers(items: [VeryShortOrShortTermForecastModel<VeryShortTermForecastCategory>]) {
        
       let filteredTemperatureItems = items.filter { item in
            item.category == .T1H
        }
        
        let filteredPrecipitationItems = items.filter { item in
            item.category == .PTY
        }
        
        let filteredSkyStateItems = items.filter { item in
            item.category == .SKY
        }
        
        for index in filteredTemperatureItems.indices {
            
            let weatherTuple = util.veryShortTermForecastWeatherTuple(
                ptyValue: filteredPrecipitationItems[index].fcstValue,
                skyValue: filteredSkyStateItems[index].fcstValue
            )
                
            let todayWeather = TodayWeatherInformationModel(
                weatherImage: weatherTuple.1,
                time: util.convertHHmmToHHColonmm(
                    HHmm: filteredTemperatureItems[index].fcstTime
                ),
                temperature: filteredTemperatureItems[index].fcstValue
            )
            
            todayWeatherInformations.append(todayWeather)
        }
    }
    
    
    func setMidTermForecastItemToArray(item: MidTermForecastModel) {
        
        threeToTenDaysTemperature.append(temperatureMinMax.init(minMax:(item.taMin3, item.taMax3), day: 3))
        threeToTenDaysTemperature.append(temperatureMinMax.init(minMax:(item.taMin4, item.taMax4), day: 4))
        threeToTenDaysTemperature.append(temperatureMinMax.init(minMax:(item.taMin5, item.taMax5), day: 5))
        threeToTenDaysTemperature.append(temperatureMinMax.init(minMax:(item.taMin6, item.taMax6), day: 6))
        threeToTenDaysTemperature.append(temperatureMinMax.init(minMax:(item.taMin7, item.taMax7), day: 7))
        threeToTenDaysTemperature.append(temperatureMinMax.init(minMax:(item.taMin8, item.taMax8), day: 8))
        threeToTenDaysTemperature.append(temperatureMinMax.init(minMax:(item.taMin9, item.taMax9), day: 9))
        threeToTenDaysTemperature.append(temperatureMinMax.init(minMax:(item.taMin10, item.taMax10), day: 10))
    }
}
