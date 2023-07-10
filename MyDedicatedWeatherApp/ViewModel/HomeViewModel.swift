//
//  HomeViewModel.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation
import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published private(set) var threeToTenDaysTemperature: [temperatureMinMax] = [] // day 3 ~ 10 temperature
    @Published private(set) var errorMessage: String = ""
    @Published private(set) var currentWeatherWithDescriptionAndImgString: Weather.DescriptionAndImageString = .init(description: "", imageString: "")
    @Published private(set) var currentTemperature: String = ""
    @Published private(set) var currentWeatherInformation: Weather.CurrentWeatherInformation = Dummy().currentWeatherInformation()
    @Published private(set) var currentFineDustTuple: Weather.DescriptionAndColor = .init(description: "", color: .clear)
    @Published private(set) var currentUltraFineDustTuple: Weather.DescriptionAndColor = .init(description: "", color: .clear)
    @Published private(set) var todayWeatherInformations: [Weather.TodayWeatherInformation] = []
    
    @Published var subLocalityByKakaoAddress: String = ""
    
    @Published private(set) var isDayMode: Bool = false
    @Published private(set) var sunRiseAndSetHHmm: (String, String) = ("","")
    
    /// Load Completed Variables..
    @Published private(set) var isCurrentWeatherInformationLoadCompleted: Bool = false
    @Published private(set) var isFineDustLoadCompleted: Bool = false
    @Published private(set) var isKakaoAddressLoadCompleted: Bool = false
    
    private enum ForDustStationRequest {
        static var tmXAndtmY: (String, String) = ("","")
        static var stationName: String = ""
    }
    
    private let util = Util()
    private let env = Env()
    private let jsonRequest = JsonRequest()
    private var subscriptions: Set<AnyCancellable> = []
    
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
                resultType: OpenDataRes<MidTermForecastBase>.self,
                requestName: "requestMidTermForecastItems()"
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
                resultType: OpenDataRes<VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>>.self,
                requestName: "requestVeryShortForecastItems(xy:)"
            )
            DispatchQueue.main.async {
                
                if let items = result.item {
                    self.setCurrentTemperature(items: items)
                    self.setCurrentWeatherInformations(items: items)
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
    
    
    /// 단기예보  Items request
    func requestShortForecastItems(xy: Util.LatXLngY) async {
        
        let parameters = VeryShortOrShortTermForecastReq(
            serviceKey: env.openDataApiResponseKey,
            baseDate: util.shortTermForcastBaseDate(),
//            baseDate: "20230705",
            baseTime: util.shortTermForecastBaseTime(),
//            baseTime: "0500",
            nx: String(xy.x),
            ny: String(xy.y)
        )
        
        do {
            let result = try await jsonRequest.newRequest(
                url: Route.GET_WEATHER_SHORT_TERM_FORECAST.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: OpenDataRes<VeryShortOrShortTermForecastBase<ShortTermForecastCategory>>.self,
                requestName: "requestShortForecastItems(xy:)"
            )
            
            DispatchQueue.main.async {
                if let items = result.item {
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
                resultType: OpenDataRes<RealTimeFindDustForecastBase>.self,
                requestName: "requestRealTimeFindDustForecastItems()"
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
    func requestDustForecastStationXY(subLocality: String, locality: String) async {
        
        let param: DustForecastStationXYReq = DustForecastStationXYReq(
            serviceKey: env.openDataApiResponseKey,
            umdName: subLocality
        )
        
        do {
            let result = try await jsonRequest.newRequest(
                url: Route.GET_DUST_FORECAST_STATION_XY.val,
                method: .get,
                parameters: param,
                headers: nil,
                resultType: OpenDataRes<DustForecastStationXYBase>.self,
                requestName: "requestDustForecastStationXY(umdName:, locality:)"
            )
            
            if let filteredResult = result.items?.first(where: { item in
                item.sidoName.contains(locality)
            }) {
                ForDustStationRequest.tmXAndtmY = (filteredResult.tmX, filteredResult.tmY)
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
                resultType: OpenDataRes<DustForecastStationBase>.self,
                requestName: "requestDustForecastStation()"
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
    
    // 'SubLocality'(성수동 1가) request by kakao address
    func requestKaKaoAddressBy(longitude: String, latitude: String) async {
        
        let param = KakaoAddressBase.Req(x: longitude, y: latitude)
        let header = Validate().kakaoHeader()
        
        do {
            let result = try await jsonRequest.newRequest(
                url: Route.GET_KAKAO_ADDRESS.val,
                method: .get,
                parameters: param,
                headers: header,
                resultType: KakaoAddressBase.DocumentsBase.self,
                requestName: "requestKaKaoAddressBy(x:, y:)"
            )
            
            DispatchQueue.main.async {
                self.subLocalityByKakaoAddress = result.documents[0].address.subLocality
                self.isKakaoAddressLoadCompleted = true
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
     Request 일출 및 일몰 시간 item by longitude(경도), latitude(위도)
     !!! Must first called when location manager updated !!!
     
     - parameter long: longitude(경도),
     - parameter lat: latitude(위도)
     */
    func requestSunAndMoonrise(long: String, lat: String) async {
        
        SunAndMoonRiseByXMLService(
            queryItem: .init(
                serviceKey: env.openDataApiResponseKey,
                locdate: util.currentDateByCustomFormatter(dateFormat: "yyyyMMdd"),
                longitude: long,
                latitude: lat
            )
        ).result
            .sink { [weak self] value in
                guard let self = self else { return }
                self.sunRiseAndSetHHmm = (value.sunrise, value.sunset)
                self.setIsDayMode(riseItem: value)
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Set Actions..
    
    /**
     초 단기예보 Items ->`currentWeatherWithDescriptionAndImgString`(날씨 String, 이미지 String)에 해당하는 값들 Extract
     
     - parameter items: [초단기예보 Model]
     */
    func setCurrentWeatherWithDescriptionAndImgString(items: [VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>]) -> Weather.DescriptionAndImageString {
        
        let firstPTYItem = items.first { item in // 강수 형태
            item.category == .PTY
        }
        
        let firstSKYItem = items.first { item in // 하늘 상태
            item.category == .SKY
        }
        
        return util.veryShortOrShortTermForecastWeatherDescriptionWithImageString(
            ptyValue: firstPTYItem?.fcstValue ?? "",
            skyValue: firstSKYItem?.fcstValue ?? "",
            hhMMForDayOrNightImage: firstPTYItem?.fcstTime ?? "",
            sunrise: sunRiseAndSetHHmm.0,
            sunset: sunRiseAndSetHHmm.1,
            isAnimationImage: true
        )
    }
    
    /**
     초 단기예보 Items -> `currentTemperature` 추출
     
     - parameter items: [초단기예보 Model]
     */
    func setCurrentTemperature(items: [VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>]) {
        
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
    func setCurrentWeatherInformations(items: [VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>]) {
        
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
        
        currentWeatherInformation = Weather.CurrentWeatherInformation(
            temperature: currentTemperature?.fcstValue ?? "",
            windSpeed: util.remakeWindSpeedValueByVeryShortTermOrShortTermForecast(
                value: currentWindSpeed?.fcstValue ?? ""
            ),
            wetPercent: ("\(currentWetPercent?.fcstValue ?? "")%", ""),
            oneHourPrecipitation: util.remakeOneHourPrecipitationValueByVeryShortTermOrShortTermForecast(
                value: currentOneHourPrecipitation?.fcstValue ?? ""
            ),
            weatherImage: setCurrentWeatherWithDescriptionAndImgString(items: items).imageString
        )
        
        isCurrentWeatherInformationLoadCompleted = true
    }
    
    /**
     단기예보 Items ->` todayWeathers`(시간 String, 날씨 이미지 String, 강수확률 String, 온도 String)에 해당하는 값들 Extract
     
     - parameter items: [초단기예보 Model]
     */
    func setTodayWeathers(items: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>]) {
        
        let currentDate = util.currentDateByCustomFormatter(dateFormat: "yyyyMMdd")
//        let currentHour = util.currentDateByCustomFormatter(dateFormat: "HH")
        let currentHour = "05"

        
        //
        let temperatureItems = items.filter { item in
            item.category == .TMP
        }
        
        let todayTemperatureStartIndex = temperatureItems.firstIndex { item in
            let fcstTimeHHIndex = item.fcstTime.index(item.fcstTime.startIndex, offsetBy: 1)
            return item.fcstDate == currentDate && item.fcstTime[...fcstTimeHHIndex] == currentHour
        } ?? 0
        
        var todayTemperatureItems: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>] = []
        
        //
        let precipitationItems = items.filter { item in
            item.category == .PTY
        }
        
        let todayPrecipitationStartIndex = precipitationItems.firstIndex { item in
            let fcstTimeHHIndex = item.fcstTime.index(item.fcstTime.startIndex, offsetBy: 1)
            return item.fcstDate == currentDate && item.fcstTime[...fcstTimeHHIndex] == currentHour
        } ?? 0
        
        var todayPrecipitationItems: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>] = []
        
        //
        let precipitationPercentItems = items.filter { item in
            item.category == .POP
        }
        
        let todayPrecipitationPercentStartIndex = precipitationPercentItems.firstIndex { item in
            let fcstTimeHHIndex = item.fcstTime.index(item.fcstTime.startIndex, offsetBy: 1)
            return item.fcstDate == currentDate && item.fcstTime[...fcstTimeHHIndex] == currentHour
        } ?? 0
        
        var todayPrecipitationPercentItems: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>] = []
        
        //
        let skyStateItems = items.filter { item in
            item.category == .SKY
        }
        
        let todaySkyStateStartIndex = skyStateItems.firstIndex { item in
            let fcstTimeHHIndex = item.fcstTime.index(item.fcstTime.startIndex, offsetBy: 1)
            return item.fcstDate == currentDate && item.fcstTime[...fcstTimeHHIndex] == currentHour
        } ?? 0
        
        var todaySkyStateItems: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>] = []
        
        //
        for i in 0...23 {
            todayTemperatureItems.append(temperatureItems[todayTemperatureStartIndex + i])
            todayPrecipitationItems.append(precipitationItems[todayPrecipitationStartIndex + i])
            todaySkyStateItems.append(skyStateItems[todaySkyStateStartIndex + i])
            todayPrecipitationPercentItems.append(precipitationPercentItems[todayPrecipitationPercentStartIndex + i])
        }
        
        for index in todayTemperatureItems.indices {
            
            let weather: Weather.DescriptionAndImageString = util.veryShortOrShortTermForecastWeatherDescriptionWithImageString(
                ptyValue: todayPrecipitationItems[index].fcstValue,
                skyValue: todaySkyStateItems[index].fcstValue,
                hhMMForDayOrNightImage: todayTemperatureItems[index].fcstTime,
                sunrise: self.sunRiseAndSetHHmm.0,
                sunset: self.sunRiseAndSetHHmm.1,
                isAnimationImage: false
            )
            
            let hourEndIndex = todayTemperatureItems[index].fcstTime.index(
                todayTemperatureItems[index].fcstTime.startIndex, offsetBy: 1
            )
            
            let hour = String(todayTemperatureItems[index].fcstTime[...hourEndIndex])
            
            let todayWeather = Weather.TodayWeatherInformation(
                time: util.convertAMOrPM(hour),
                weatherImage: weather.imageString,
                precipitation: todayPrecipitationPercentItems[index].fcstValue,
                temperature: todayTemperatureItems[index].fcstValue
            )
            
            todayWeatherInformations.append(todayWeather)
        }
    }
    
    /**
     중기예보 Items->` threeToTenDaysTemperature`( (최저온도 String, 최고온도 String), day String )에 해당하는 값들 Extract
     
     - parameter item: 중기예보 Model
     */
    func setThreeToTenDaysTemperature(item: MidTermForecastBase) {
        
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
    
    func setIsDayMode(riseItem: SunAndMoonriseBase) {
        
        let currentHHmm = util.currentDateByCustomFormatter(dateFormat: "HHmm")
        isDayMode = util.isDayMode(hhMM: currentHHmm, sunrise: riseItem.sunrise, sunset: riseItem.sunset)
    }
    
    // MARK: - View On Appear, Task Actions..
    
    func HomeViewControllerLocationManagerUpdatedAction(
        xy: Util.LatXLngY,
        longLati: (String, String)
    ) {
        Task {
            await requestSunAndMoonrise(long: longLati.0, lat: longLati.1) // Must first called
            await requestVeryShortForecastItems(xy: xy)
            await requestShortForecastItems(xy: xy)
            await requestKaKaoAddressBy(longitude: longLati.0, latitude: longLati.1)
        }
    }
    
    func HomeViewControllerKakaoAddressUpdatedAction(umdName: String, locality: String) {
        Task {
            await requestDustForecastStationXY(
                subLocality: umdName,
                locality: locality
            )
            await requestDustForecastStation()
            await requestRealTimeFindDustForecastItems()
        }
    }
}
