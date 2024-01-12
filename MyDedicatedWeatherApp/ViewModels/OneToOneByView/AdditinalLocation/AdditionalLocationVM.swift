//
//  AdditionalLocationVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 12/2/23.
//

import Foundation

final class AdditionalLocationVM: ObservableObject {
    
    @Published var gpsTempItem: Weather.WeatherImageAndMinMax = .init(weatherImage: "", currentTemp: "", minMaxTemp: ("", ""))
    @Published var tempItems: [Weather.WeatherImageAndMinMax] = Dummy.weatherImageAndMinMax()
    @Published var fullAddresses: [String] = UserDefaults.standard.array(forKey: UserDefaultsKeys.additionalFullAddresses) as? [String] ?? []
    @Published var localities: [String] = UserDefaults.standard.array(forKey: UserDefaultsKeys.additionalLocalities) as? [String] ?? []
    @Published var subLocalities: [String] = UserDefaults.standard.array(forKey: UserDefaultsKeys.additionalSubLocalities) as? [String] ?? []
        
    private let commonForecastUtil: CommonForecastUtil = CommonForecastUtil()
    private let veryShortTermForecastUtil: VeryShortTermForecastUtil = VeryShortTermForecastUtil()
    private let shortTermForecastUtil: ShortTermForecastUtil = ShortTermForecastUtil()
    
    var currentTask: Task<(), Never>?
    
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
    func requestSunRiseAndSunSetHHmm(long: String, lat: String) async -> (String, String) {

        do {
            let parser = try await SunAndMoonRiseByXMLService(
                queryItem: .init(
                    serviceKey: Env.shared.openDataApiResponseKey,
                    locdate: Date().toString(format: "yyyyMMdd"),
                    longitude: long,
                    latitude: lat
                )
            )
            CommonUtil.shared.printSuccess(
                funcTitle: "requestSunRiseAndSunSetHHmm",
                value: parser.result
            )
            
            return (parser.result.sunrise, parser.result.sunset)
            
        } catch APIError.transportError {
            DispatchQueue.main.async {
//                self.errorMessage = "API 통신 에러"
            }
            return ("", "")

        } catch {
            DispatchQueue.main.async {
//                self.errorMessage = "알 수 없는 오류"
            }
            return ("", "")
        }
    }
    
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
        let baseTime = veryShortTermForecastUtil.requestBaseTime()
        let baseDate = veryShortTermForecastUtil.requestBaseDate()
        
        let parameters: VeryShortOrShortTermForecastReq = VeryShortOrShortTermForecastReq(
            serviceKey: Env.shared.openDataApiResponseKey,
            numOfRows: "300",
            baseDate: baseDate,
            baseTime: baseTime,
            nx: String(xy.x),
            ny: String(xy.y)
        )
        
        do {
            let result = try await JsonRequest.shared.newRequest(
                url: Route.GET_WEATHER_VERY_SHORT_TERM_FORECAST.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: PublicDataRes<VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>>.self,
                requestName: "requestVeryShortForecastItems(xy:)"
            )
            
            CommonUtil.shared.printSuccess(
                funcTitle: "requestCurrentWeatherImageAndTemp",
                value: result
            )
            
            guard let items = result.item else { return ("", "") }
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
            
        } catch APIError.transportError {
            
            DispatchQueue.main.async {
//                self.errorMessage = "API 통신 에러"
            }
            return ("", "")
            
        } catch {
            DispatchQueue.main.async {
//                self.errorMessage = "알 수 없는 오류"
            }
            return ("", "")
        }
    }
    
    /// - parameter xy: 공공데이터 값으로 변환된 X, Y
    /// '단기예보' 에서의 최소, 최대 온도 값 요청 위해 및
    /// 02:00 or 23:00 으로 호출해야 하므로, 따로 다시 요청한다.
    func requestTodayMinMaxTemp(xy: Gps2XY.LatXLngY, currentTemp: String) async -> (String, String) {

        let parameters = VeryShortOrShortTermForecastReq(
            serviceKey: Env.shared.openDataApiResponseKey,
            numOfRows: "300",
            baseDate: shortTermForecastUtil.baseDateForTodayMinMaxReq,
            baseTime: shortTermForecastUtil.baseTimeForTodayMinMaxReq,
            nx: String(xy.x),
            ny: String(xy.y)
        )
        
        do {
            func filteredMinMax(_ items: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>], currentTemp: String) -> (String, String) {
                let todayDate = Date().toString(format: "yyyyMMdd")
                
                let filteredItems = items.filter( {$0.category == .TMP && $0.fcstDate == todayDate} )
                var filteredTemps = filteredItems.map({ $0.fcstValue.toInt })
                filteredTemps.append(currentTemp.toInt)
                
                let min = filteredTemps.min() ?? 0
                let max = filteredTemps.max() ?? 0
                
                return (min.toString, max.toString)
            }
            
            let result = try await JsonRequest.shared.newRequest(
                url: Route.GET_WEATHER_SHORT_TERM_FORECAST.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: PublicDataRes<VeryShortOrShortTermForecastBase<ShortTermForecastCategory>>.self,
                requestName: "requestShortForecastItems(xy:)"
            )
            
            guard let items = result.item else { return ("", "") }
            return filteredMinMax(items, currentTemp: currentTemp)
            
        } catch APIError.transportError {
            
            DispatchQueue.main.async {
//                self.errorMessage = "API 통신 에러"
            }
            return ("", "")
        } catch {
            DispatchQueue.main.async {
//                self.errorMessage = "알 수 없는 오류"
            }
            return ("", "")
        }
    }
    
    /**
     Request 단기예보 Items
     
     - parameter xy: 공공데이터 값으로 변환된 X, Y
     - parameter baseTime: Request param 의 `baseTime`
     
     `baseTime` == nil -> 앱 첫 진입 시 자동 계산되어 호출
     `baseTime` != nil -> 앱 첫 진입 시 호출이 아닌, 수동 호출
     
     Response:
     - 1시간 별 데이터 12개 (13:00 -> 12개, 14:00 -> 12개)
     - 요청 basetime 별 response 값이 다름
     
     시간 별 Index:
     - 0: TMP (온도)
     - 1: UUU (풍속 동서성분)
     - 2: VVV (풍속 남북성분)
     - 3: VEC (풍향)
     - 4: WSD (풍속)
     - 5: SKY (하늘 상태)
     - 6: PTY (강수 형태)
     - 7: POP (강수 확률)
     - 8: WAV (파고)
     - 9: PCP (1시간 강수량)
     - 10: REH (습도)
     - 11: SNO (1시간 신적설)
     
     요청 basetime 별 데이터 크기:
     - 0200: '+1시간' ~ '+70시간'
     - 0500: '+1시간' ~ '+67시간'
     - 0800: '+1시간' ~ '+64시간'
     - 1100: '+1시간' ~ '+61시간'
     - 1400: '+1시간' ~ '+58시간' (0200 ~ 1400 : 오늘 ~ 모레까지)
     - 1700: '+1시간' ~ '+79시간'
     - 2000: '+1시간' ~ '+76시간'
     - 2300: '+1시간' ~ '+73시간' (17:00 ~ 2300: 오늘 ~ 모레+1일 까지)
     */
//    func requestMinMaxTemp(xy: Gps2XY.LatXLngY) async -> (String, String) {
//        let currentDateString = Date().toString(format: "yyyyMMdd")
//        let tomorrowDateString = Date().toString(byAdding: 1, format: "yyyyMMdd")
//        let baseTime = shortTermForecastUtil.requestBaseTime()
//        let isBaseTime2300: Bool = baseTime == "2300"
//        
//        let parameters = VeryShortOrShortTermForecastReq(
//            serviceKey: Env.shared.openDataApiResponseKey,
//            numOfRows: "300",
//            baseDate: shortTermForecastUtil.requestBaseDate(),
//            /// baseTime != nil -> 앱 구동 시 호출이 아닌, 수동 호출
//            baseTime: baseTime,
//            nx: String(xy.x),
//            ny: String(xy.y)
//        )
//        
//        do {
//            let result = try await JsonRequest.shared.newRequest(
//                url: Route.GET_WEATHER_SHORT_TERM_FORECAST.val,
//                method: .get,
//                parameters: parameters,
//                headers: nil,
//                resultType: PublicDataRes<VeryShortOrShortTermForecastBase<ShortTermForecastCategory>>.self,
//                requestName: "requestShortForecastItems(xy:)"
//            )
//            
//            CommonUtil.shared.printSuccess(
//                funcTitle: "requestMinMaxTemp",
//                value: result
//            )
//            
//            guard let items = result.item else { return ("", "") }
//            let filteredTempItems = items.filter({ $0.fcstDate == (isBaseTime2300 ? tomorrowDateString : currentDateString) && $0.category == .TMP })
//            let filteredTemps = filteredTempItems.map({ $0.fcstValue })
//            let minTemp = filteredTemps.min() ?? ""
//            let maxTemp = filteredTemps.max() ?? ""
//
//            return (minTemp, maxTemp)
//            
//        } catch APIError.transportError {
//            
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
    
    func itemDeleteAction(fullAddress: String, locality: String, subLocality: String) {
        
        guard let fullAddresses = UserDefaults.standard.array(forKey: UserDefaultsKeys.additionalFullAddresses) as? [String] else {
            return
        }
        
        guard let localities = UserDefaults.standard.array(forKey: UserDefaultsKeys.additionalLocalities) as? [String] else {
            return
        }
        
        guard let subLocalities = UserDefaults.standard.array(forKey: UserDefaultsKeys.additionalSubLocalities) as? [String] else {
            return
        }
        
        guard let fullAddressIndex = fullAddresses.firstIndex(of: fullAddress), let localityIndex = localities.firstIndex(of: locality),
              let subLocalityIndex = subLocalities.firstIndex(of: subLocality) else { 
            CommonUtil.shared.printError(
                funcTitle: "itemDeleteAction", 
                description: "Index를 찾을 수 없습니다."
            )
            return
        }
        
        guard fullAddressIndex == localityIndex && fullAddressIndex == subLocalityIndex else {
            CommonUtil.shared.printError(
                funcTitle: "itemDeleteAction",
                description: "ullAddressIndex == localityIndex == subLocalityIndex 이 아닙니다."
            )
            return
        }
        
        UserDefaults.standard.removeStringElementInArray(index: fullAddressIndex, key: UserDefaultsKeys.additionalFullAddresses)
        UserDefaults.standard.removeStringElementInArray(index: localityIndex, key: UserDefaultsKeys.additionalLocalities)
        UserDefaults.standard.removeStringElementInArray(index: subLocalityIndex, key: UserDefaultsKeys.additionalSubLocalities)
        
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
        
        var addresses = fullAddresses
        addresses.append(gpsFullAddress)
        
        for (index, address) in addresses.enumerated() {
            LocationDataManagerVM.getLatitudeAndLongitude(address: address) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                    
                case .success(let success):
                    let latitude: Double = success.0
                    let longitude: Double = success.1
                    let xy: Gps2XY.LatXLngY = self.commonForecastUtil.convertGPS2XY(mode: .toXY, lat_X: latitude, lng_Y: longitude)
                    
                    currentTask = Task(priority: .userInitiated) {
                        let sunRiseAndSunSetHHmm = await self.requestSunRiseAndSunSetHHmm(long: String(longitude), lat: String(latitude))
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
    
    func reloadItems() {
        let fullAddresses: [String] = UserDefaults.standard.array(forKey: UserDefaultsKeys.additionalFullAddresses) as? [String] ?? []
        let localities: [String] = UserDefaults.standard.array(forKey: UserDefaultsKeys.additionalLocalities) as? [String] ?? []
        let subLocalities: [String] = UserDefaults.standard.array(forKey: UserDefaultsKeys.additionalSubLocalities) as? [String] ?? []
        
        self.fullAddresses = fullAddresses
        self.localities = localities
        self.subLocalities = subLocalities
    }
}
