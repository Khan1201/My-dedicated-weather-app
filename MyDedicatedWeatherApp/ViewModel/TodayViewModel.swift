//
//  TodayViewModel.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation
import Combine

final class TodayViewModel: ObservableObject {
    
    @Published private(set) var threeToTenDaysTemperature: [temperatureMinMax] = [] // day 3 ~ 10 temperature
    @Published private(set) var errorMessage: String = ""
    @Published private(set) var currentTemperature: String = ""
    @Published private(set) var currentWeatherAnimationImg: String = ""
    @Published private(set) var currentWeatherInformation: Weather.CurrentWeatherInformation = Dummy().currentWeatherInformation()
    @Published private(set) var currentFineDustTuple: Weather.DescriptionAndColor = .init(description: "", color: .clear)
    @Published private(set) var currentUltraFineDustTuple: Weather.DescriptionAndColor = .init(description: "", color: .clear)
    @Published private(set) var todayMinMaxTemperature: (String, String) = ("__", "__")
    @Published private(set) var todayWeatherInformations: [Weather.TodayWeatherInformation] = []
    
    @Published var subLocalityByKakaoAddress: String = ""
    
    static private(set) var xy: Util.LatXLngY = .init(lat: 0, lng: 0, x: 0, y: 0)
    
    @Published private(set) var isDayMode: Bool = false
    @Published private(set) var sunRiseAndSetHHmm: (String, String) = ("----", "----")
    
    /// Load Completed Variables..
    @Published private(set) var isCurrentWeatherInformationLoadCompleted: Bool = false
    @Published private(set) var isCurrentWeatherAnimationSetCompleted: Bool = false
    @Published private(set) var isFineDustLoadCompleted: Bool = false
    @Published private(set) var isKakaoAddressLoadCompleted: Bool = false
    @Published private(set) var loadingTest: Bool = false
    
    private enum ForDustStationRequest {
        static var tmXAndtmY: (String, String) = ("","")
        static var stationName: String = ""
    }
    
    private let util = Util()
    private let env = Env()
    private let jsonRequest = JsonRequest()
    private var subscriptions: Set<AnyCancellable> = []
}

// MARK: - Request HTTP..

extension TodayViewModel {
    
    /**
     Request 중기예보 Items
     */
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
    
    /**
     Request 초 단기예보 Items
     - parameter xy: 공공데이터 값으로 변환된 X, Y
     
     */
    func requestVeryShortForecastItems(xy: Util.LatXLngY) async {
        
        TodayViewModel.xy = xy
        let baseTime = util.veryShortTermForecastBaseTime()
        let baseDate = util.veryShortTermForecastBaseDate(baseTime: baseTime)
        
        let parameters: VeryShortOrShortTermForecastReq = VeryShortOrShortTermForecastReq(
            serviceKey: env.openDataApiResponseKey,
            baseDate: baseDate,
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
                    self.setCurrentWeatherAnimationImg(items: items)
                    self.setCurrentTemperature(items: items)
                    self.setCurrentWeatherInformation(items: items)
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
    
    
    /**
     Request 단기예보 Items
     
     - parameter xy: 공공데이터 값으로 변환된 X, Y
     - parameter baseTime: Request param 의 `baseTime`
     
     `baseTime` == nil -> 앱 첫 진입 시 자동 계산되어 호출
     `baseTime` != nil -> 앱 첫 진입 시 호출이 아닌, 수동 호출
     */
    func requestShortForecastItems(xy: Util.LatXLngY, baseTime: String? = nil) async {
        
        let parameters = VeryShortOrShortTermForecastReq(
            serviceKey: env.openDataApiResponseKey,
            baseDate: util.shortTermForcastBaseDate(),
            baseTime: baseTime != nil ? baseTime! : util.shortTermForecastBaseTime(),
            /// baseTime != nil -> 앱 구동 시 호출이 아닌, 수동 호출
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
            
            if let items = result.item {
                
                if baseTime == nil { // baseTime == nil -> 앱 구동 시 처음 호출 (자동 baseTime set)
                    DispatchQueue.main.async {
                        self.setTodayWeatherInformations(items: items)
                        self.setTodayMinMaxTemperature(
                            items: items,
                            baseTime: self.util.shortTermForecastBaseTime()
                        )
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.setTodayMinMaxTemperature(items: items, baseTime: baseTime ?? "")
                    }
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
    
    /**
     Request 실시간 미세먼지, 초미세먼지 Items request
     */
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
    
    /**
     Request 미세먼지 측정소가 위치한 X, Y 좌표
     
     - parameter subLocality: ex) 성수동 1가
     - parameter locality: ex) 서울특별시
     */
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
    
    /**
     Request 미세먼지 측정소 이름
     - parameter tmxAndtmY: 미세먼지 측정소 X, Y 좌표
     
     */
    func requestDustForecastStation(tmXAndtmY: (String, String)) async {
        
        let param: DustForecastStationReq = DustForecastStationReq(
            serviceKey: env.openDataApiResponseKey,
            tmX: tmXAndtmY.0,
            tmY: tmXAndtmY.1
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
    
    /**
     Request sublocality(성수동 1가) by kakao address
     - parameter longitude: 경도
     - parameter latitude: 위도
     
     Apple이 제공하는.reverseGeocodeLocation 에서 특정 기기에서 sublocality가 nil로 할당되므로
     kakao address request 에서 가져오도록 결정함.
     */
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
     Request 일출 및 일몰 시간 item
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
}

// MARK: - Set Variables..

extension TodayViewModel {
    
    /**
     Set 초 단기예보 Items -> `currentTemperature`(현재 기온) varialbe
     
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
    func setCurrentWeatherInformation(items: [VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>]) {
        
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
        
        let firstPTYItem = items.first { item in // 강수 형태
            item.category == .PTY
        }
        
        let firstSKYItem = items.first { item in // 하늘 상태
            item.category == .SKY
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
            weatherImage: util.veryShortOrShortTermForecastWeatherDescriptionWithImageString(
                ptyValue: firstPTYItem?.fcstValue ?? "",
                skyValue: firstSKYItem?.fcstValue ?? "",
                hhMMForDayOrNightImage: firstPTYItem?.fcstTime ?? "",
                sunrise: sunRiseAndSetHHmm.0,
                sunset: sunRiseAndSetHHmm.1,
                isAnimationImage: false
            ).imageString
        )
        
        isCurrentWeatherInformationLoadCompleted = true
    }
    
    /**
     Set 단기예보 Items ->` todayWeatherInformations`variable
     
     - parameter items: [초단기예보 Model]
     */
    func setTodayWeatherInformations(items: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>]) {
        
        let currentDate = util.currentDateByCustomFormatter(dateFormat: "yyyyMMdd")
        let currentHour = util.currentDateByCustomFormatter(dateFormat: "HH")
        
        // 온도 filter
        let temperatureItems = items.filter { item in
            item.category == .TMP
        }
        
        let todayTemperatureStartIndex = temperatureItems.firstIndex { item in
            let fcstTimeHHIndex = item.fcstTime.index(item.fcstTime.startIndex, offsetBy: 1)
            return item.fcstDate == currentDate && item.fcstTime[...fcstTimeHHIndex] == currentHour
        } ?? 0
        
        var todayTemperatureItems: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>] = []
        
        // 강수형태 filter
        let precipitationItems = items.filter { item in
            item.category == .PTY
        }
        
        let todayPrecipitationStartIndex = precipitationItems.firstIndex { item in
            let fcstTimeHHIndex = item.fcstTime.index(item.fcstTime.startIndex, offsetBy: 1)
            return item.fcstDate == currentDate && item.fcstTime[...fcstTimeHHIndex] == currentHour
        } ?? 0
        
        var todayPrecipitationItems: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>] = []
        
        // 강수확률 filter
        let precipitationPercentItems = items.filter { item in
            item.category == .POP
        }
        
        let todayPrecipitationPercentStartIndex = precipitationPercentItems.firstIndex { item in
            let fcstTimeHHIndex = item.fcstTime.index(item.fcstTime.startIndex, offsetBy: 1)
            return item.fcstDate == currentDate && item.fcstTime[...fcstTimeHHIndex] == currentHour
        } ?? 0
        
        var todayPrecipitationPercentItems: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>] = []
        
        // 하늘상태 filter
        let skyStateItems = items.filter { item in
            item.category == .SKY
        }
        
        let todaySkyStateStartIndex = skyStateItems.firstIndex { item in
            let fcstTimeHHIndex = item.fcstTime.index(item.fcstTime.startIndex, offsetBy: 1)
            return item.fcstDate == currentDate && item.fcstTime[...fcstTimeHHIndex] == currentHour
        } ?? 0
        
        var todaySkyStateItems: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>] = []
        
        // 각 index 해당하는 값(시간에 해당하는 값) append
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
     Set 단기예보 Items -> `todayMinMaxTemperature` variable
     
     - parameter items: [단기예보 Model]
     */
    func setTodayMinMaxTemperature(
        items: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>],
        baseTime: String
    ) {
        switch baseTime {
            
        case "0200":
            setTodayMinMaxTemperature(items: items, isMinTemp: true)
            setTodayMinMaxTemperature(items: items, isMinTemp: false)
            
        case "0500":
            requestMinTemp()
            setTodayMinMaxTemperature(items: items, isMinTemp: false)
            
        case "0800":
            requestMinTemp()
            setTodayMinMaxTemperature(items: items, isMinTemp: false)
            
        case "1100":
            requestMinTemp()
            setTodayMinMaxTemperature(items: items, isMinTemp: false)
            
        default:
            requestMinMaxTemp()
        }
        loadingTest = true
        
        func setTodayMinMaxTemperature(items: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>], isMinTemp: Bool) {
            guard let minOrMaxTemp = items.filter(
                { item in
                    item.category == (isMinTemp ? .TMN : .TMX)
                }
            ).first?.fcstValue else { return }
            
            guard let minOrMaxTempToDouble = Double(minOrMaxTemp) else { return }
            let toString = String(Int(minOrMaxTempToDouble))

            if isMinTemp {
                todayMinMaxTemperature.0 = toString
                
            } else {
                todayMinMaxTemperature.1 = toString
            }
        }
        
        func requestMinTemp() {
            Task {
                await requestShortForecastItems(xy: TodayViewModel.xy, baseTime: "0200")
            }
        }
        
        func requestMinMaxTemp() {
            Task {
                await requestShortForecastItems(xy: TodayViewModel.xy, baseTime: "1100")
            }
        }
    }
    
    /**
     Set 중기예보 Items->` threeToTenDaysTemperature` (최저온도 String, 최고온도 String, 현재Date Int ) varialbe
     
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
    
    /**
     Set 초 단기예보 Items ->`currentWeatherAnimationImg`(현재 날씨 animation lottie)
     
     - parameter items: [초단기예보 Model]
     */
    func setCurrentWeatherAnimationImg(items: [VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>]) {
        
        let firstPTYItem = items.first { item in // 강수 형태
            item.category == .PTY
        }
        
        let firstSKYItem = items.first { item in // 하늘 상태
            item.category == .SKY
        }
        
        currentWeatherAnimationImg = util.veryShortOrShortTermForecastWeatherDescriptionWithImageString(
            ptyValue: firstPTYItem?.fcstValue ?? "",
            skyValue: firstSKYItem?.fcstValue ?? "",
            hhMMForDayOrNightImage: firstPTYItem?.fcstTime ?? "",
            sunrise: sunRiseAndSetHHmm.0,
            sunset: sunRiseAndSetHHmm.1,
            isAnimationImage: true
        ).imageString
        
        isCurrentWeatherAnimationSetCompleted = true
    }
    
    /**
     Set riseItem -> `isDayMode`variable
     
     - parameter riseItem: 일출, 일몰 Item
     */
    func setIsDayMode(riseItem: SunAndMoonriseBase) {
        
        let currentHHmm = util.currentDateByCustomFormatter(dateFormat: "HHmm")
        isDayMode = util.isDayMode(hhMM: currentHHmm, sunrise: riseItem.sunrise, sunset: riseItem.sunset)
    }
}

// MARK: - View On Appear, Task Actions..

extension TodayViewModel {
    
    func TodayViewControllerLocationManagerUpdatedAction(
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
    
    func TodayViewControllerKakaoAddressUpdatedAction(umdName: String, locality: String) {
        Task {
            await requestDustForecastStationXY(
                subLocality: umdName,
                locality: locality
            )
            await requestDustForecastStation(tmXAndtmY: ForDustStationRequest.tmXAndtmY)
            await requestRealTimeFindDustForecastItems()
        }
    }
}
