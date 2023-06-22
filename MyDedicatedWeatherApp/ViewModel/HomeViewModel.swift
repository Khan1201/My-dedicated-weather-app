//
//  HomeViewModel.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    
    @Published var threeToTenDaysTemperature: [temperatureMinMax] = [] // day 3 ~ 10 temperature
    @Published var errorMessage: String = ""
    @Published var currentWeatherWithDescriptionAndImgString: Weather.DescriptionAndImageString = .init(description: "", imageString: "")
    @Published var currentTemperature: String = ""
    @Published var currentWeatherInformation: CurrentWeatherInformationModel = Dummy().currentWeatherInformation()
    @Published var currentFineDustTuple: Weather.DescriptionAndColor = .init(description: "", color: .clear)
    @Published var currentUltraFineDustTuple: Weather.DescriptionAndColor = .init(description: "", color: .clear)
    @Published var todayWeatherInformations: [TodayWeatherInformationModel] = []
    
    @Published var isFineDustLoadCompleted: Bool = false
    
    private enum ForDustStationRequest {
        static var tmXAndtmY: (String, String) = ("","")
        static var stationName: String = ""
    }
    
    private let util = Util()
    private let env = Env()
    private let jsonRequest = JsonRequest()
    
    // MARK: - Request..
    
    /// 중기예보 Items request
    func requestMidTermForecastItems() async {
        
        let parameters: MidTermForecastReq = MidTermForecastReq(
            serviceKey: env.openDataApiResponseKey,
            regId: MidTermLocationID.daegu.val,
            tmFc: util.midTermForecastRequestDate()
        )
        do {
            let result = try await jsonRequest.newRequest(
                url: Route.GET_WEATHER_MID_TERM_FORECAST.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: OpenDataRes<MidTermForecastModel>.self
            )
            DispatchQueue.main.async {
                if let item = result.item?.first {
                    self.setThreeToTenDaysTemperature(item: item)
                }
                
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
    
    /// 초 단기예보  Items request
    func requestVeryShortForecastItems(xy: Util.LatXLngY) async {
        
        let baseTime = util.veryShortTermForecastBaseTime()
        
        let parameters: VeryShortOrShortTermForecastReq = VeryShortOrShortTermForecastReq(
            serviceKey: env.openDataApiResponseKey,
            baseDate: util.veryShortTermForecastBaseDate(baseTime: baseTime),
            baseTime: baseTime,
            nx: String(xy.x),
            ny: String(xy.y)
        )
        
        do {
            let result = try await jsonRequest.newRequest(
                url: Route.GET_WEATHER_VERY_SHORT_TERM_FORECAST.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: OpenDataRes<VeryShortOrShortTermForecastModel<VeryShortTermForecastCategory>>.self
            )
            DispatchQueue.main.async {
                
                if let items = result.item {
                    self.setCurrentTemperature(items: items)
                    self.setCurrentWeatherInformations(items: items)
                    self.setTodayWeathers(items: items)
                }
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
    
    /// 실시간 미세먼지, 초미세먼지 Items request
    func requestRealTimeFindDustForecastItems() async {
        
        let parameters: RealTimeFindDustForecastReq = RealTimeFindDustForecastReq(
            serviceKey: env.openDataApiResponseKey,
            stationName: ForDustStationRequest.stationName
        )
        
        do {
            let result = try await jsonRequest.newRequest(
                url: Route.GET_REAL_TIME_FIND_DUST_FORECAST.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: OpenDataRes<RealTimeFindDustForecastModel>.self
            )
            
            if let item = result.items?.first {
                
                DispatchQueue.main.async {
                    self.currentFineDustTuple = self.util.remakeFindDustValue(value: item.pm10Value)
                    self.currentUltraFineDustTuple = self.util.remakeUltraFindDustValue(value: item.pm25Value)
                    self.isFineDustLoadCompleted = true
                }
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
    
    /// 미세먼지 주변 측정소 X, Y 좌표. request
    func requestDustForecastStationXY(umdName: String, locality: String) async {
        
        let param: DustForecastStationXYReq = DustForecastStationXYReq(
            serviceKey: env.openDataApiResponseKey,
            umdName: umdName
        )
        
        do {
            let result = try await jsonRequest.newRequest(
                url: Route.GET_DUST_FORECAST_STATION_XY.val,
                method: .get,
                parameters: param,
                headers: nil,
                resultType: OpenDataRes<DustForecastStationXYModel>.self
            )
            
            if let filteredResult = result.items?.first(where: { item in
                item.sidoName == locality
            }) {
                DispatchQueue.main.async {
                    ForDustStationRequest.tmXAndtmY = (filteredResult.tmX, filteredResult.tmY)
                }
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
    
    /// 미세먼지 주변 측정소 name request
    func requestDustForecastStation() async {
        
        let param: DustForecastStationReq = DustForecastStationReq(
            serviceKey: env.openDataApiResponseKey,
            tmX: ForDustStationRequest.tmXAndtmY.0,
            tmY: ForDustStationRequest.tmXAndtmY.1
        )
        
        do {
            let result = try await jsonRequest.newRequest(
                url: Route.GET_DUST_FORECAST_STATION.val,
                method: .get,
                parameters: param,
                headers: nil,
                resultType: OpenDataRes<DustForecastStationModel>.self
            )
            
            if let filteredResult = result.items?.first {
                ForDustStationRequest.stationName = filteredResult.stationName
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
    
    /**
      초 단기예보 Items ->`currentWeatherWithDescriptionAndImgString`(날씨 String, 이미지 String)에 해당하는 값들 Extract
     
        - parameter items: [초단기예보 Model]
     */
    func setCurrentWeatherWithDescriptionAndImgString(items: [VeryShortOrShortTermForecastModel<VeryShortTermForecastCategory>]) -> Weather.DescriptionAndImageString {
        
        let firstPTYItem = items.first { item in // 강수 형태
            item.category == .PTY
        }
        
        let firstSKYItem = items.first { item in // 하늘 상태
            item.category == .SKY
        }
        
        return util.veryShortTermForecastWeatherDescriptionWithImageString(
            ptyValue: firstPTYItem?.fcstValue ?? "",
            skyValue: firstSKYItem?.fcstValue ?? "",
            isAnimationImage: true
        )
    }
    
    /**
      초 단기예보 Items -> `currentTemperature` 추출
     
        - parameter items: [초단기예보 Model]
     */
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
    
    /**
     초 단기예보 Items -> `currentWeatherInformations`(온도 String, 바람속도 String, 습도 String, 1시간 강수량 String, 날씨 이미지 String)에 해당하는 값들 Extract

        - parameter items: [초단기예보 Model]
     */
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
                
        currentWeatherInformation = CurrentWeatherInformationModel(
            temperature: currentTemperature?.fcstValue ?? "",
            windSpeed: util.remakeWindSpeedValueByVeryShortTermOrShortTermForecast(
                value: currentWindSpeed?.fcstValue ?? "")
            ,
            wetPercent: currentWetPercent?.fcstValue ?? "",
            oneHourPrecipitation: util.remakeOneHourPrecipitationValueByVeryShortTermOrShortTermForecast(
                value: currentOneHourPrecipitation?.fcstValue ?? ""
            ),
            weatherImage: setCurrentWeatherWithDescriptionAndImgString(items: items).imageString
        )
        
    }
    
    /**
     초 단기예보 Items ->` todayWeathers`(날씨 이미지 String, 시간 String, 온도 String)에 해당하는 값들 Extract

        - parameter items: [초단기예보 Model]
     */
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
            
            let weather: Weather.DescriptionAndImageString = util.veryShortTermForecastWeatherDescriptionWithImageString(
                ptyValue: filteredPrecipitationItems[index].fcstValue,
                skyValue: filteredSkyStateItems[index].fcstValue,
                isAnimationImage: false
            )
            
            let todayWeather = TodayWeatherInformationModel(
                weatherImage: weather.imageString,
                time: util.convertHHmmToHHColonmm(
                    HHmm: filteredTemperatureItems[index].fcstTime
                ),
                temperature: filteredTemperatureItems[index].fcstValue
            )
            
            todayWeatherInformations.append(todayWeather)
        }
    }
    
    /**
     중기예보 Items->` threeToTenDaysTemperature`( (최저온도 String, 최고온도 String), day String )에 해당하는 값들 Extract

        - parameter item: 중기예보 Model
     */
    func setThreeToTenDaysTemperature(item: MidTermForecastModel) {
        
        let minMaxItems: [(Int, Int)] = [
            (item.taMin3, item.taMax3),
            (item.taMin4, item.taMax4),
            (item.taMin5, item.taMax5),
            (item.taMin6, item.taMax6),
            (item.taMin7, item.taMax7),
            (item.taMin8, item.taMax8),
            (item.taMin9, item.taMax9),
            (item.taMin10, item.taMax10)
        ]
        
        for index in 0...7 { // day 3 ~ 10
            threeToTenDaysTemperature.append(temperatureMinMax.init(
                minMax:(minMaxItems[index].0, minMaxItems[index].1),
                day: index + 3)
            )
        }
    }
}
