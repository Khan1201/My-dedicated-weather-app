//
//  AdditionalLocationVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/2/23.
//

import Foundation
import Domain
import Core

final class AdditionalLocationVM: ObservableObject {
    
    @Published var gpsTempItem: Weather.WeatherImageAndMinMax = .init(weatherImage: "", currentTemp: "", minMaxTemp: ("", ""))
    @Published var tempItems: [Weather.WeatherImageAndMinMax] = []
    @Published var locationInfs: [LocationInformation] = []
    
    private let commonUtil: CommonUtil
    private let commonForecastUtil: CommonForecastUtil
    private let veryShortForecastUtil: VeryShortForecastUtil
    private let shortForecastUtil: ShortForecastUtil
    
    private let veryShortForecastService: VeryShortForecastService
    private let shortForecastService: ShortForecastService
    private let userDefaultsService: UserDefaultsService
    
    var currentTask: Task<(), Never>?
    
    init(
        commonUtil: CommonUtil,
        commonForecastUtil: CommonForecastUtil,
        veryShortForecastUtil: VeryShortForecastUtil,
        shortForecastUtil: ShortForecastUtil,
        veryShortForecastService: VeryShortForecastService,
        shortForecastService: ShortForecastService,
        userDefaultsService: UserDefaultsService
    ) {
        self.commonUtil = commonUtil
        self.commonForecastUtil = commonForecastUtil
        self.veryShortForecastUtil = veryShortForecastUtil
        self.shortForecastUtil = shortForecastUtil
        self.veryShortForecastService = veryShortForecastService
        self.shortForecastService = shortForecastService
        self.userDefaultsService = userDefaultsService
        self.initAllLocalities()
    }
    
    deinit {
        currentTask?.cancel()
        currentTask = nil
    }
}

// MARK: - Request funcs..

extension AdditionalLocationVM {
    /**
     Request 초 단기예보 Items
     - parameter xy: 공공데이터 값으로 변환된 X, Y
     
     Response:
     - 총 60개 데이터
     - 각 카테고리 별 데이터 6개
     
     Index:
     - 0 ~ 5: LGT (낙뢰)
     - 6 ~ 11: PTY (강수 형태)
     - 12 ~ 17: RN1 (1시간 강수량)
     - 18 ~ 23: SKY (하늘 상태)
     - 24 ~ 29: T1H (현재 기온)
     - 30 ~ 35: REH (습도)
     - 36 ~ 41: UUU (동서 바람성분)
     - 42 ~ 47: VVV (남북 바람성분)
     - 48 ~ 53: VEC (풍향)
     - 54 ~ 59: WSD(풍속)
     */
    func getCurrentItems(xy: Gps2XY.LatXLngY, sunriseAndsunsetHHmm: (String, String)) async -> (String, String) {
        let result = await veryShortForecastService.getCurrentItems(xy: xy)
        
        switch result {
        case .success(let items):
            guard items.count >= 25 else { return ("", "")}
            
            let firstPTYItem = items[6]
            let firstSKYItem = items[18]
            let sunTime: SunTime = .init(
                currentHHmm: firstPTYItem.fcstTime,
                sunriseHHmm: sunriseAndsunsetHHmm.0,
                sunsetHHmm: sunriseAndsunsetHHmm.1
            )
            
            let weatherImage = commonForecastUtil.convertPrecipitationSkyStateOrSkyState(
                ptyValue: firstPTYItem.fcstValue,
                skyValue: firstSKYItem.fcstValue
            ).image(isDayMode: sunTime.isDayMode)
            
            let temp = items[24].fcstValue
                        
            return (weatherImage, temp)
        case .failure:
            return ("", "")
        }
    }
    
    /// - parameter xy: 공공데이터 값으로 변환된 X, Y
    /// '단기예보' 에서의 최소, 최대 온도 값 요청 위해 및
    /// 02:00 or 23:00 으로 호출해야 하므로, 따로 다시 요청한다.
    func getTodayMinMaxItems(xy: Gps2XY.LatXLngY, currentTemp: String) async -> (String, String) {
        func filteredMinMax(_ items: [VeryShortOrShortTermForecast<ShortTermForecastCategory>], currentTemp: String) -> (String, String) {
            let todayDate = Date().toString(format: "yyyyMMdd")
            
            let filteredItems = items.filter( {$0.category == .TMP && $0.fcstDate == todayDate} )
            var filteredTemps = filteredItems.map({ $0.fcstValue.toInt })
            filteredTemps.append(currentTemp.toInt)
            
            let min = filteredTemps.min() ?? 0
            let max = filteredTemps.max() ?? 0
            
            return (min.toString, max.toString)
        }
        
        let result = await shortForecastService.getTodayMinMaxItems(xy: xy)

        switch result {
        case .success(let items):
            return filteredMinMax(items, currentTemp: currentTemp)
        case .failure:
            return ("", "")
        }
    }
}

// MARK: - Set funcs..

extension AdditionalLocationVM {
    
    @MainActor
    func setTempItems(currentWeatherImageAndTemp: (String, String), minMaxTemp: (String, String), index: Int) {
        guard currentWeatherImageAndTemp != ("", "") && minMaxTemp != ("", "") else {
            CustomLogger.error("currentWeatherImageAndTemp 또는 minMaxTemp 값이 없습니다.")
            return
        }
        tempItems.append(
            .init(
                weatherImage: currentWeatherImageAndTemp.0,
                currentTemp: currentWeatherImageAndTemp.1,
                minMaxTemp: minMaxTemp
            )
        )
    }
    
    @MainActor
    func setGPSTempItem(currentWeatherImageAndTemp: (String, String), minMaxTemp: (String, String)) {
        gpsTempItem = .init(
            weatherImage: currentWeatherImageAndTemp.0,
            currentTemp: currentWeatherImageAndTemp.1,
            minMaxTemp: minMaxTemp
        )
    }
}

// MARK: - 0n tap gestures..

extension AdditionalLocationVM {
    func deleteLocalLocationInf(locationInf: LocationInformation) {
        userDefaultsService.removeLocationInformations(locationInf)
        reloadItems()
    }
}

// MARK: - Life cycle funcs..

extension AdditionalLocationVM {
    
    func additinalLocationViewTaskAction(gpsFullAddress: String) {
        performRequestSavedLocationWeather(gpsFullAddress: gpsFullAddress)
    }
}

// MARK: - ETC funcs..

extension AdditionalLocationVM {
    
    func performRequestSavedLocationWeather(gpsFullAddress: String) {
        
        var addresses = locationInfs.map { $0.fullAddress }
        addresses.append(gpsFullAddress)
        
        for (index, address) in addresses.enumerated() {
            LocationProvider.getLatitudeAndLongitude(address: address) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                    
                case .success(let success):
                    let latitude: Double = success.0
                    let longitude: Double = success.1
                    let xy: Gps2XY.LatXLngY = self.commonUtil.convertGPS2XY(mode: .toXY, lat_X: latitude, lng_Y: longitude)
                    let sunRiseAndSunSetHHmm = sunriseSunsetHHmm(longLati: (String(longitude), String(latitude)))
                    
                    currentTask = Task(priority: .userInitiated) {
                        let currentWeatherImageAndTemp = await self.getCurrentItems(
                            xy: xy,
                            sunriseAndsunsetHHmm: sunRiseAndSunSetHHmm
                        )
                        let minMaxTemp = await self.getTodayMinMaxItems(
                            xy: xy,
                            currentTemp: currentWeatherImageAndTemp.1
                        )
                        
                        // gps item
                        if address == gpsFullAddress {
                            await self.setGPSTempItem(
                                currentWeatherImageAndTemp: currentWeatherImageAndTemp,
                                minMaxTemp: minMaxTemp
                            )
                            
                        } else {
                            await self.setTempItems(
                                currentWeatherImageAndTemp: currentWeatherImageAndTemp,
                                minMaxTemp: minMaxTemp,
                                index: index
                            )
                        }
                    }
                    
                case .failure(let error):
                    CustomLogger.error("\(error)")
                }
            }
        }
    }
    
    func initAllLocalities() {
        locationInfs = []
        locationInfs = userDefaultsService.getLocationInformations()
    }
    
    func reloadItems() {
        initAllLocalities()
    }
    
    func sunriseSunsetHHmm(longLati: (String, String)) -> (String, String) {
        let currentDate: Date = Date()
        let sunrise = currentDate.sunrise(.init(latitude: longLati.1.toDouble, longitude: longLati.0.toDouble))
        let sunset = currentDate.sunset(.init(latitude: longLati.1.toDouble, longitude: longLati.0.toDouble))
        
        if let sunrise = sunrise, let sunset = sunset {
            let sunriseHHmm = sunrise.toString(format: "HHmm", timeZone: TimeZone(identifier: "UTC"))
            let sunsetHHmm = sunset.toString(format: "HHmm", timeZone: TimeZone(identifier: "UTC"))
            
            return (sunriseHHmm, sunsetHHmm)
            
        } else {
            return ("", "")
        }
    }
}
