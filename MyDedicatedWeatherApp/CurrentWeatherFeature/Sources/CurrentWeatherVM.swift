//
//  CurrentWeatherVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation
import Combine
import Domain
import Core

final class CurrentWeatherVM: ObservableObject {
    
    enum Loading: CaseIterable {
        case currentWeatherInformationLoaded, fineDustLoaded, todayWeatherInformationsLoaded, kakaoAddressLoaded, minMaxTempLoaded, sunriseSunsetLoaded
    }
    
    @Published private(set) public var sunriseAndSunsetHHmm: (String, String) = ("", "")
    @Published private(set) public var currentWeatherInformation: Weather.CurrentInformation?
    @Published private(set) public var currentDust: Weather.CurrentDust?
    @Published private(set) public var todayMinMaxTemperature: (String, String) = ("", "")
    @Published private(set) public var todayWeatherInformations: [Weather.TodayInformation] = []
    @Published private(set) public var subLocalityByKakaoAddress: String = ""
    @Published private(set) public var dustStationXY: (String, String) = ("", "")
    @Published private(set) public var dustStationName: String = ""
    
    @Published public var isAdditionalLocationViewPresented: Bool = false
    
    @Published public private(set) var loadedVariables: [Loading : Bool] = {
        var result: [Loading: Bool] = [:]
        let _ = Loading.allCases.map { value in
            result[value] = false
        }
        return result
    }()
    @Published private(set) public var isAllLoaded: Bool = false
    @Published private var reloadActions: [Loading : () -> Void] = [:]
    @Published public var isNetworkFloaterPresented: Bool = false
    @Published public var networkFloaterMessage: String = ""
    
    private var noticeAndRetryTimer: NoticeAndRetryTimer = NoticeAndRetryTimer()
    private var currentTask: Task<(), Never>?
    
    private var bag: Set<AnyCancellable> = .init()
    
    weak var currentLocationEODelegate: CurrentLocationEODelegate?
    
    private let commonUtil: CommonUtil
    private let commonForecastUtil: CommonForecastUtil
    private let veryShortForecastUtil: VeryShortForecastUtil
    private let shortForecastUtil: ShortForecastUtil
    private let midForecastUtil: MidForecastUtil
    private let fineDustLookUpUtil: FineDustLookUpUtil
    
    private let veryShortForecastService: VeryShortForecastService
    private let shortForecastService: ShortForecastService
    private let dustForecastService: DustForecastService
    private let kakaoAddressService: KakaoAddressService
    private let userDefaultsService: UserDefaultsService
    private let networkFloaterStore: any NetworkFloaterStore

    init(
        commonUtil: CommonUtil,
        commonForecastUtil: CommonForecastUtil,
        veryShortForecastUtil: VeryShortForecastUtil,
        shortForecastUtil: ShortForecastUtil,
        midForecastUtil: MidForecastUtil,
        fineDustLookUpUtil: FineDustLookUpUtil,
        veryShortForecastService: VeryShortForecastService,
        shortForecastService: ShortForecastService,
        dustForecastService: DustForecastService,
        kakaoAddressService: KakaoAddressService,
        userDefaultsService: UserDefaultsService,
        networkFloaterStore: any NetworkFloaterStore

    ) {
        self.commonUtil = commonUtil
        self.commonForecastUtil = commonForecastUtil
        self.veryShortForecastUtil = veryShortForecastUtil
        self.shortForecastUtil = shortForecastUtil
        self.midForecastUtil = midForecastUtil
        self.fineDustLookUpUtil = fineDustLookUpUtil
        self.veryShortForecastService = veryShortForecastService
        self.shortForecastService = shortForecastService
        self.dustForecastService = dustForecastService
        self.kakaoAddressService = kakaoAddressService
        self.userDefaultsService = userDefaultsService
        self.networkFloaterStore = networkFloaterStore
        sinkIsAllLoaded()
        
        networkFloaterStore.state.presenter.$isPresented
            .assign(to: &$isNetworkFloaterPresented)
        
        networkFloaterStore.state.presenter.$floaterMessage
            .assign(to: &$networkFloaterMessage)
    }
}

// MARK: - View Communication Funcs
extension CurrentWeatherVM {
    @MainActor public func loadCurrentWeatherAllData(locationInf: LocationInformation) {
        let convertedXY: Gps2XY.LatXLngY = .init(lat: 0, lng: 0, x: locationInf.x.toInt, y: locationInf.y.toInt)
        
        initializeTask()
        startNetworkFloaterTimer()
        calculateAndSetSunriseSunset(longLati: (locationInf.longitude, locationInf.latitude))
        setReloadActions(locationInf: locationInf)
        currentTask = Task(priority: .high) {
            Task(priority: .high) {
                await fetchCurrentWeatherInformations(xy: convertedXY)
                await fetchTodayWeatherInformations(xy: convertedXY)
                await fetchTodayMinMaxTemperature(xy: convertedXY)
            }
            
            Task(priority: .low) {
                await fetchSubLocalityByKakaoAddress(longitude: locationInf.longitude, latitude: locationInf.latitude, isCurrentLocationRequested: locationInf.isGPSLocation)
                await fetchDustStationXY(
                    subLocality: locationInf.isGPSLocation ? subLocalityByKakaoAddress : locationInf.subLocality,
                    locality: locationInf.locality
                )
                await fetchDustStationName(tmXAndtmY: dustStationXY)
                await fetchCurrentDust()
            }
        }
    }
    
    public func loadAdditionalLocationWeather(locationInf: LocationInformation, isNewAdd: Bool) {
        LocationProvider.getLatitudeAndLongitude(address: locationInf.fullAddress) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                
            case .success(let success):
                Task {
                    let xy: Gps2XY.LatXLngY = self.commonUtil.convertGPS2XY(mode: .toXY, lat_X: success.0, lng_Y: success.1)
                    let locationInf: LocationInformation = .init(
                        longitude: String(success.1),
                        latitude: String(success.0),
                        x: String(xy.x),
                        y: String(xy.y),
                        locality: locationInf.locality,
                        subLocality: locationInf.subLocality,
                        fullAddress: locationInf.fullAddress
                    )
                    
                    DispatchQueue.main.async { 
                        self.initLoadedVariables()
                        self.isAdditionalLocationViewPresented = false
                    }
                    await self.loadCurrentWeatherAllData(locationInf: locationInf)
                    await self.currentLocationEODelegate?.setCoordinateAndAllLocality(locationInf: locationInf)
                    await self.currentLocationEODelegate?.setIsLocationUpdated()
                    
                    if isNewAdd {
                        self.userDefaultsService.setLocationInformation(locationInf)
                    }
                }
                
            case .failure(_):
                return
            }
        }
    }
    
    @MainActor public func performRefresh(locationInf: LocationInformation) {
        initLoadedVariables()
        loadCurrentWeatherAllData(locationInf: locationInf)
    }
}

// MARK: - Fetch Funcs
extension CurrentWeatherVM {
    private func fetchCurrentWeatherInformations(xy: Gps2XY.LatXLngY) async {        
        let result = await veryShortForecastService.getCurrentItems(xy: xy)
        
        switch result {
        case .success(let items):
            await self.setCurrentWeatherInformation(items: items)
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
    
    private func fetchTodayWeatherInformations(xy: Gps2XY.LatXLngY) async {
        let result = await shortForecastService.getTodayItems(xy: xy, reqRow: "300")
        
        switch result {
        case .success(let items):
            await setTodayWeatherInformations(items: items)
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }

    private func fetchTodayMinMaxTemperature(xy: Gps2XY.LatXLngY) async {
        let result = await shortForecastService.getTodayMinMaxItems(xy: xy)
        
        switch result {
        case .success(let items):
            await setTodayMinMaxTemperature(items)
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
    
    private func fetchCurrentDust() async {
        let result = await dustForecastService.getRealTimeDustItems(stationName: dustStationName)
        
        switch result {
        case .success(let items):
            guard let item = items.first else { return }
            await setCurrentDust(item)
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }

    private func fetchDustStationXY(subLocality: String, locality: String) async {
        let result = await dustForecastService.getXYOfStation(subLocality: subLocality)
        
        switch result {
        case .success(let items):
            await setDustStationXY(items: items, locality: locality)
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
    
    private func fetchDustStationName(tmXAndtmY: (String, String)) async {
        let result = await dustForecastService.getStationInfo(tmXAndtmY: tmXAndtmY)
        
        switch result {
        case .success(let items):
            await setDustStationName(items)
            guard let firstItem = items.first else { return }
            userDefaultsService.setCurrentDustStationName(firstItem.stationName)
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
    
    private func fetchSubLocalityByKakaoAddress(longitude: String, latitude: String, isCurrentLocationRequested: Bool) async {
        let result = await kakaoAddressService.getKaKaoAddressBy(
            longitude: longitude,
            latitude: latitude
        )
        
        switch result {
        case .success(let item):
            await setSubLocalityByKakaoAddress(item.documents)
            
            guard item.documents.count > 0 else { return }
            await currentLocationEODelegate?.setSubLocality(item.documents[0].address.subLocality)
            
            /// For Widget
            if isCurrentLocationRequested {
                await self.currentLocationEODelegate?.setGPSSubLocality(item.documents[0].address.subLocality)
                await self.currentLocationEODelegate?.setFullAddressByGPS()
                userDefaultsService.setCurrentSubLocality(self.subLocalityByKakaoAddress)
                userDefaultsService.setCurrentFullAddress(item.documents[0].address.fullAddress)
            }
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
}

// MARK: - Sink Funcs..
extension CurrentWeatherVM {
    private func sinkIsAllLoaded() {
        $loadedVariables.sink { [weak self] dics in
            guard let self = self else { return }
            isAllLoaded = dics.values.allSatisfy { $0 }
            
            if isAllLoaded {
                initializeTaskAndTimer()
            }
        }
        .store(in: &bag)
    }
}

// MARK: - Set Funcs
extension CurrentWeatherVM {
    @MainActor
    private func setCurrentWeatherInformation(items: [VeryShortOrShortTermForecast<VeryShortTermForecastCategory>]) {
        let currentTemperature = items[24]
        let currentWindSpeed = items[54]
        let currentWetPercent = items[30]
        let currentOneHourPrecipitation = items[12]
        let firstPTYItem = items[6]
        let firstSKYItem = items[18]
        let sunTime: SunTime = .init(
            currentHHmm: firstPTYItem.fcstTime,
            sunriseHHmm: sunriseAndSunsetHHmm.0,
            sunsetHHmm: sunriseAndSunsetHHmm.1
        )
        
        let skyType = commonForecastUtil.convertPrecipitationSkyStateOrSkyState(
            ptyValue: firstPTYItem.fcstValue,
            skyValue: firstSKYItem.fcstValue
        )
        
        currentWeatherInformation = Weather.CurrentInformation(
            temperature: currentTemperature.fcstValue,
            windSpeed: (veryShortForecastUtil.convertWindSpeed(rawValue: currentWindSpeed.fcstValue).toDescription, "\(currentWindSpeed.fcstValue)ms"),
            wetPercent: ("\(currentWetPercent.fcstValue)%", ""),
            oneHourPrecipitation: (
                shortForecastUtil.convertPrecipitationAmount(
                    rawValue: currentOneHourPrecipitation.fcstValue
                ),
                shortForecastUtil.precipitationValueToShort(rawValue: currentOneHourPrecipitation.fcstValue)
            ),
            weatherImage: skyType.image(isDayMode: sunTime.isDayMode), 
            weatherAnimation: skyType.lottie(isDayMode: sunTime.isDayMode),
            skyType: skyType
        )
        currentLocationEODelegate?.setSkyType(skyType)
        loadedVariables[.currentWeatherInformationLoaded] = true
    }

    @MainActor
    private func setTodayWeatherInformations(items: [VeryShortOrShortTermForecast<ShortTermForecastCategory>]) {
        todayWeatherInformations = []
        
        let skipValue = shortForecastUtil.todayWeatherIndexSkipValue
        
        var tempIndex = 0 + skipValue
        var skyIndex = 5 + skipValue
        var ptyIndex = 6 + skipValue
        var popIndex = 7 + skipValue
        var step = 12
        let loopCount = shortForecastUtil.todayWeatherLoopCount
        
        // 각 index 해당하는 값(시간에 해당하는 값) append
        for _ in 0..<loopCount {
            
            // 1시간 별 데이터 중 TMX(최고온도), TMN(최저온도) 가 있는지
            // 존재하면 1시간 별 데이터 기존 12개 -> 13이 됨
            let isExistTmxOrTmn = items[tempIndex + 12].category == .TMX ||
            items[tempIndex + 12].category == .TMN
            
            step = isExistTmxOrTmn ? 13 : 12
            
            let sunTime: SunTime = .init(
                currentHHmm: items[tempIndex].fcstTime,
                sunriseHHmm: self.sunriseAndSunsetHHmm.0,
                sunsetHHmm: self.sunriseAndSunsetHHmm.1
            )
            
            let skyType = commonForecastUtil.convertPrecipitationSkyStateOrSkyState(
                ptyValue: items[ptyIndex].fcstValue,
                skyValue: items[skyIndex].fcstValue
            )
            
            let todayWeather = Weather.TodayInformation(
                time: CommonUtil.shared.convertAMOrPMFromHHmm(items[tempIndex].fcstTime),
                weatherImage: skyType.image(isDayMode: sunTime.isDayMode),
                precipitation: items[popIndex].fcstValue,
                temperature: items[tempIndex].fcstValue
            )
            todayWeatherInformations.append(todayWeather)
            
            tempIndex += step
            skyIndex += step
            ptyIndex += step
            popIndex += step
        }
        loadedVariables[.todayWeatherInformationsLoaded] = true
    }

    @MainActor
    private func setTodayMinMaxTemperature(_ items: [VeryShortOrShortTermForecast<ShortTermForecastCategory>]) {
        let todayDate = Date().toString(format: "yyyyMMdd")
        
        let filteredItems = items.filter( {$0.category == .TMP && $0.fcstDate == todayDate} )
        var filteredTemps = filteredItems.map({ $0.fcstValue.toInt })
        filteredTemps.append(currentWeatherInformation?.temperature.toInt ?? 0)
        
        let min = filteredTemps.min() ?? 0
        let max = filteredTemps.max() ?? 0
        
        todayMinMaxTemperature = (min.toString, max.toString)
        loadedVariables[.minMaxTempLoaded] = true
    }
    
    @MainActor
    private func setCurrentDust(_ item: RealTimeFindDustForecast) {
        let convertedFineDust: WeatherAPIValue = fineDustLookUpUtil.convertFineDust(rawValue: item.pm10Value)
        let convertedUltraFineDust: WeatherAPIValue = fineDustLookUpUtil.convertUltraFineDust(rawValue: item.pm25Value)
        currentDust = .init(
            fineDust: FineDust(description: convertedFineDust.toDescription, backgroundColor: convertedFineDust.color),
            ultraFineDust: UltraFineDust(description: convertedUltraFineDust.toDescription, backgroundColor: convertedUltraFineDust.color)
        )
        loadedVariables[.fineDustLoaded] = true
    }
    
    @MainActor
    private func setSubLocalityByKakaoAddress(_ items: [KakaoAddress.AddressBase]) {
        guard items.count > 0 else { return }
        subLocalityByKakaoAddress = items[0].address.subLocality
        loadedVariables[.kakaoAddressLoaded] = true
    }
    
    @MainActor
    private func setSunriseAndSunsetHHmm(sunrise: String, sunset: String) {
        sunriseAndSunsetHHmm = (sunrise, sunset)
        loadedVariables[.sunriseSunsetLoaded] = true
    }
    
    @MainActor
    private func setDustStationXY(items: [DustForecastStationXY]?, locality: String) {
        guard let items = items else { return }
        guard let item = items.first( where: { $0.sidoName.contains(locality) } ) else { return }
        dustStationXY = (item.tmX, item.tmY)
    }

    @MainActor
    private func setDustStationName(_ items: [DustForecastStation]?) {
        guard let items = items, let item = items.first else { return }
        dustStationName = item.stationName
    }
}

// MARK: - ETC Funcs
extension CurrentWeatherVM {
    private func initLoadedVariables() {
        let _ = Loading.allCases.map { value in
            loadedVariables[value] = false
        }
    }
    
    private func initializeTask() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    private func initializeTaskAndTimer() {
        initializeTask()
        networkFloaterStore.send(.stopTimer)
    }
    
    private func startNetworkFloaterTimer() {
        networkFloaterStore.send(
            .startTimerAndShowFloaterIfTimeOver(
                retryAction: reload
            )
        )
    }
    
    private func setReloadActions(locationInf: LocationInformation) {
        let convertedXY: Gps2XY.LatXLngY = .init(lat: 0, lng: 0, x: locationInf.x.toInt, y: locationInf.y.toInt)
        
        reloadActions[.currentWeatherInformationLoaded] = {
            Task {
                await self.fetchCurrentWeatherInformations(xy: convertedXY)
            }
        }
        
        reloadActions[.fineDustLoaded] = {
            Task {
                await self.fetchDustStationXY(
                    subLocality: locationInf.isGPSLocation ? self.subLocalityByKakaoAddress : locationInf.subLocality,
                    locality: locationInf.locality
                )
                await self.fetchDustStationName(tmXAndtmY: self.dustStationXY)
                await self.fetchCurrentDust()
            }
        }
        
        reloadActions[.kakaoAddressLoaded] = {
            Task {
                await self.fetchSubLocalityByKakaoAddress(longitude: locationInf.longitude, latitude: locationInf.latitude, isCurrentLocationRequested: locationInf.isGPSLocation)
            }
        }
        
        reloadActions[.minMaxTempLoaded] = {
            Task {
                await self.fetchTodayMinMaxTemperature(xy: convertedXY)
            }
        }
        
        reloadActions[.todayWeatherInformationsLoaded] = {
            Task {
                await self.fetchTodayWeatherInformations(xy: convertedXY)
            }
        }
    }
    
    private func reload() {
        initializeTask()
        currentTask = Task(priority: .high) {
            loadedVariables.keys.forEach {
                guard let isLoaded = loadedVariables[$0] else { return }
                
                if !isLoaded {
                    reloadActions[$0]?()
                }
            }
        }
    }
    
    @MainActor private func calculateAndSetSunriseSunset(longLati: (String, String)) {
        let currentDate: Date = Date()
        let sunrise = currentDate.sunrise(.init(latitude: longLati.1.toDouble, longitude: longLati.0.toDouble))
        let sunset = currentDate.sunset(.init(latitude: longLati.1.toDouble, longitude: longLati.0.toDouble))
        
        if let sunrise = sunrise, let sunset = sunset {
            let sunriseHHmm = sunrise.toString(format: "HHmm", timeZone: TimeZone(identifier: "UTC"))
            let sunsetHHmm = sunset.toString(format: "HHmm", timeZone: TimeZone(identifier: "UTC"))
            
            currentLocationEODelegate?.setIsDayMode(sunriseHHmm: sunriseHHmm, sunsetHHmm: sunsetHHmm)
            setSunriseAndSunsetHHmm(sunrise: sunriseHHmm, sunset: sunsetHHmm)
        }
    }
}
