//
//  AdditionalLocationVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/2/23.
//

import Foundation
import Domain
import Data

final class AdditionalLocationVM: ObservableObject {
    
    @Published var gpsTempItem: Weather.WeatherImageAndMinMax = .init(weatherImage: "", currentTemp: "", minMaxTemp: ("", ""))
    @Published var tempItems: [Weather.WeatherImageAndMinMax] = Dummy.weatherImageAndMinMax()
    @Published var allLocalities: [AllLocality] = []
        
    private let commonForecastUtil: CommonForecastUtil = CommonForecastUtil()
    private let veryShortTermForecastUtil: VeryShortTermForecastUtil = VeryShortTermForecastUtil()
    private let shortTermForecastUtil: ShortTermForecastUtil = ShortTermForecastUtil()
    
    private let veryShortForecastService: VeryShortForecastRequestable
    private let shortForecastService: ShortForecastRequestable
    
    private let publicApiKey: String = Bundle.main.object(forInfoDictionaryKey: "public_api_key") as? String ?? ""
    var currentTask: Task<(), Never>?
    
    init(
        veryShortForecastService: VeryShortForecastRequestable = VeryShortForecastService(),
        shortForecastService: ShortForecastRequestable = ShortForecastService()
    ) {
        self.veryShortForecastService = veryShortForecastService
        self.shortForecastService = shortForecastService
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
     Request 일출 및 일몰 시간 item
     !!! Must first called when location manager updated !!!
     
     - parameter long: longitude(경도),
     - parameter lat: latitude(위도)
     */
//    func requestSunRiseAndSunSetHHmm(long: String, lat: String) async -> (String, String) {
//
//        do {
//            let parser = try await SunAndMoonRiseByXMLService(
//                queryItem: .init(
//                    serviceKey: Env.shared.openDataApiResponseKey,
//                    locdate: Date().toString(format: "yyyyMMdd"),
//                    longitude: long,
//                    latitude: lat
//                )
//            )
//            CommonUtil.shared.printSuccess(
//                funcTitle: "requestSunRiseAndSunSetHHmm",
//                value: parser.result
//            )
//            
//            return (parser.result.sunrise, parser.result.sunset)
//            
//        } catch APIError.transportError {
//            DispatchQueue.main.async {
////                self.errorMessage = "API 통신 에러"
//            }
//            return ("", "")
//
//        } catch {
//            DispatchQueue.main.async {
////                self.errorMessage = "알 수 없는 오류"
//            }
//            return ("", "")
//        }
//    }
    
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
    func requestCurrentWeatherImageAndTemp(xy: Gps2XY.LatXLngY, sunriseAndsunsetHHmm: (String, String)) async -> (String, String) {
        let result = await veryShortForecastService.requestVeryShortForecastItems(serviceKey: publicApiKey, xy: xy)
        
        switch result {
        case .success(let success):
            CommonUtil.shared.printSuccess(
                funcTitle: "requestCurrentWeatherImageAndTemp",
                value: result
            )
            
            guard let items = success.item else { return ("", "") }
            guard items.count >= 25 else { return ("", "")}
            
            let firstPTYItem = items[6]
            let firstSKYItem = items[18]
            
            let weatherImage = commonForecastUtil.veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
                ptyValue: firstPTYItem.fcstValue,
                skyValue: firstSKYItem.fcstValue,
                hhMMForDayOrNightImage: firstPTYItem.fcstTime,
                sunrise: sunriseAndsunsetHHmm.0,
                sunset: sunriseAndsunsetHHmm.1,
                isAnimationImage: false
            ).imageString
            
            let temp = items[24].fcstValue
                        
            return (weatherImage, temp)
        case .failure:
            return ("", "")
        }
    }
    
    /// - parameter xy: 공공데이터 값으로 변환된 X, Y
    /// '단기예보' 에서의 최소, 최대 온도 값 요청 위해 및
    /// 02:00 or 23:00 으로 호출해야 하므로, 따로 다시 요청한다.
    func requestTodayMinMaxTemp(xy: Gps2XY.LatXLngY, currentTemp: String) async -> (String, String) {
        func filteredMinMax(_ items: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>], currentTemp: String) -> (String, String) {
            let todayDate = Date().toString(format: "yyyyMMdd")
            
            let filteredItems = items.filter( {$0.category == .TMP && $0.fcstDate == todayDate} )
            var filteredTemps = filteredItems.map({ $0.fcstValue.toInt })
            filteredTemps.append(currentTemp.toInt)
            
            let min = filteredTemps.min() ?? 0
            let max = filteredTemps.max() ?? 0
            
            return (min.toString, max.toString)
        }
        
        let result = await shortForecastService.requestTodayMinMaxTemp(serviceKey: publicApiKey,xy: xy)

        switch result {
        case .success(let success):
            guard let items = success.item else { return ("", "") }
            return filteredMinMax(items, currentTemp: currentTemp)
        case .failure(let failure):
            return ("", "")
        }
    }
}

// MARK: - Set funcs..

extension AdditionalLocationVM {
    
    @MainActor
    func setTempItems(currentWeatherImageAndTemp: (String, String), minMaxTemp: (String, String), index: Int) {
        guard currentWeatherImageAndTemp != ("", "") && minMaxTemp != ("", "") else {
            CommonUtil.shared.printError(
                funcTitle: "setTempItems()",
                description: "currentWeatherImageAndTemp 또는 minMaxTemp 값이 없습니다.",
                value: """
                currentWeatherImageAndTemp = \(currentWeatherImageAndTemp)
                minMaxTemp = \(minMaxTemp)
                """
            )
            
            return
        }
        tempItems.insert(
            .init(
                weatherImage: currentWeatherImageAndTemp.0,
                currentTemp: currentWeatherImageAndTemp.1,
                minMaxTemp: minMaxTemp
            ),
            at: index
        )
        tempItems.remove(at: index + 1)
        
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
    
    func itemDeleteAction(allLocality: AllLocality) {
        
        guard let fullAddresses = UserDefaults.standard.array(forKey: UserDefaultsKeys.additionalFullAddresses) as? [String] else {
            return
        }
        
        guard let localities = UserDefaults.standard.array(forKey: UserDefaultsKeys.additionalLocalities) as? [String] else {
            return
        }
        
        guard let subLocalities = UserDefaults.standard.array(forKey: UserDefaultsKeys.additionalSubLocalities) as? [String] else {
            return
        }
        
        guard fullAddresses.count == localities.count && fullAddresses.count == subLocalities.count else {
            CommonUtil.shared.printError(
                funcTitle: "itemDeleteAction",
                description: "fullAddress.count != localities.count != subLocalities.count"
            )
            return
        }
        
        guard let index = fullAddresses.firstIndex(of: allLocality.fullAddress) else {
            CommonUtil.shared.printError(
                funcTitle: "itemDeleteAction", 
                description: "Index를 찾을 수 없습니다."
            )
            return
        }
        
        UserDefaults.standard.removeStringElementInArray(index: index, key: UserDefaultsKeys.additionalFullAddresses)
        UserDefaults.standard.removeStringElementInArray(index: index, key: UserDefaultsKeys.additionalLocalities)
        UserDefaults.standard.removeStringElementInArray(index: index, key: UserDefaultsKeys.additionalSubLocalities)
        
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
        
        var addresses = allLocalities.map { $0.fullAddress }
        addresses.append(gpsFullAddress)
        
        for (index, address) in addresses.enumerated() {
            LocationDataManagerVM.getLatitudeAndLongitude(address: address) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                    
                case .success(let success):
                    let latitude: Double = success.0
                    let longitude: Double = success.1
                    let xy: Gps2XY.LatXLngY = self.commonForecastUtil.convertGPS2XY(mode: .toXY, lat_X: latitude, lng_Y: longitude)
                    let sunRiseAndSunSetHHmm = sunriseSunsetHHmm(longLati: (String(longitude), String(latitude)))
                    
                    currentTask = Task(priority: .userInitiated) {
                        let currentWeatherImageAndTemp = await self.requestCurrentWeatherImageAndTemp(
                            xy: xy,
                            sunriseAndsunsetHHmm: sunRiseAndSunSetHHmm
                        )
                        let minMaxTemp = await self.requestTodayMinMaxTemp(
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
                    
                case .failure(_):
                    CommonUtil.shared.printError(
                        funcTitle: "performRequestSavedLocationWeather()",
                        description: "위치를 찾을 수 없습니다."
                    )
                }
            }
        }
    }
    
    func initAllLocalities() {
        allLocalities = []
        
        let fullAddresses: [String] = UserDefaults.standard.array(forKey: UserDefaultsKeys.additionalFullAddresses) as? [String] ?? []
        let localities: [String] = UserDefaults.standard.array(forKey: UserDefaultsKeys.additionalLocalities) as? [String] ?? []
        let subLocalities: [String] = UserDefaults.standard.array(forKey: UserDefaultsKeys.additionalSubLocalities) as? [String] ?? []
        
        guard fullAddresses.count == localities.count && fullAddresses.count == subLocalities.count else { return }
        
        for i in fullAddresses.indices {
            allLocalities.append(
                .init(
                    fullAddress: fullAddresses[i],
                    locality: localities[i],
                    subLocality: subLocalities[i]
                )
            )
        }
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
