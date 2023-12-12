//
//  CurrentWeatherVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation
import Combine

final class CurrentWeatherVM: ObservableObject {
    @Published private(set) var errorMessage: String = ""
    @Published private(set) var currentTemperature: String = "00"
    @Published private(set) var currentWeatherAnimationImg: String = ""
    @Published private(set) var currentWeatherImage: String = ""
    @Published private(set) var currentWeatherInformation: Weather.CurrentInformation = Dummy.shared.currentWeatherInformation()
    @Published private(set) var currentFineDustTuple: Weather.DescriptionAndColor = .init(description: "", color: .defaultAreaColor)
    @Published private(set) var currentUltraFineDustTuple: Weather.DescriptionAndColor = .init(description: "", color: .defaultAreaColor)
    @Published private(set) var todayMinMaxTemperature: (String, String) = ("__", "__")
    @Published private(set) var todayWeatherInformations: [Weather.TodayInformation] = Dummy.shared.todayWeatherInformations()
    @Published var isStartRefresh: Bool = false
    @Published var openAdditionalLocationView: Bool = false
    @Published var additionalLocationProgress: AdditionalLocationProgress = .none
    @Published var locality: String = ""
    @Published var subLocalityByKakaoAddress: String = ""
    
    static private(set) var xy: Gps2XY.LatXLngY = .init(lat: 0, lng: 0, x: 0, y: 0)
    
    @Published private(set) var sunRiseAndSetHHmm: (String, String) = ("0000", "0000")
    
    /// Load Completed Variables..(7 values)
    @Published private(set) var isCurrentWeatherInformationLoadCompleted: Bool = false
    @Published private(set) var isCurrentWeatherAnimationSetCompleted: Bool = false
    @Published private(set) var isFineDustLoadCompleted: Bool = false
    @Published private(set) var isKakaoAddressLoadCompleted: Bool = false
    @Published private(set) var isMinMaxTempLoadCompleted: Bool = false
    @Published private(set) var isSunriseSunsetLoadCompleted: Bool = false
    @Published private(set) var isTodayWeatherInformationLoadCompleted: Bool = false
    
    @Published private(set) var isAllLoadCompleted: Bool = false
    
    private enum ForDustStationRequest {
        static var tmXAndtmY: (String, String) = ("","")
        static var stationName: String = ""
    }
    
    private let contentVM: ContentVM
    private let currentLocationVM: CurrentLocationVM
    
    private let commonForecastUtil: CommonForecastUtil = CommonForecastUtil()
    private let veryShortTermForecastUtil: VeryShortTermForecastUtil = VeryShortTermForecastUtil()
    private let shortTermForecastUtil: ShortTermForecastUtil = ShortTermForecastUtil()
    private let midTermForecastUtil: MidTermForecastUtil = MidTermForecastUtil()
    private let fineDustLookUpUtil: FineDustLookUpUtil = FineDustLookUpUtil()
    private var subscriptions: Set<AnyCancellable> = []
    
    init(contentVM: ContentVM = ContentVM.shared, currentLocationVM: CurrentLocationVM = CurrentLocationVM.shared) {
        self.contentVM = contentVM
        self.currentLocationVM = currentLocationVM
    }
}

// MARK: - Request HTTP..

extension CurrentWeatherVM {
    
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
    func requestVeryShortForecastItems(xy: Gps2XY.LatXLngY) async {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let baseTime = veryShortTermForecastUtil.requestBaseTime()
        let baseDate = veryShortTermForecastUtil.requestBaseDate(baseTime: baseTime)
        
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
            DispatchQueue.main.async {
                
                if let items = result.item {
                    self.setCurrentWeatherImgAndAnimationImg(items: items)
                    self.setCurrentTemperature(items: items)
                    self.setCurrentWeatherInformation(items: items)
                    let durationTime = CFAbsoluteTimeGetCurrent() - startTime
                    print("초단기 req 소요시간: \(durationTime)")
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
    func requestShortForecastItems(xy: Gps2XY.LatXLngY, baseTime: String? = nil) async {
        let reqStartTime = CFAbsoluteTimeGetCurrent()

        let parameters = VeryShortOrShortTermForecastReq(
            serviceKey: Env.shared.openDataApiResponseKey,
            numOfRows: "300",
            baseDate: shortTermForecastUtil.requestBaseDate(),
            /// baseTime != nil -> 앱 구동 시 호출이 아닌, 수동 호출
            baseTime: baseTime != nil ? baseTime! : shortTermForecastUtil.requestBaseTime(),
            nx: String(xy.x),
            ny: String(xy.y)
        )
        
        do {
            let result = try await JsonRequest.shared.newRequest(
                url: Route.GET_WEATHER_SHORT_TERM_FORECAST.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: PublicDataRes<VeryShortOrShortTermForecastBase<ShortTermForecastCategory>>.self,
                requestName: "requestShortForecastItems(xy:)"
            )
            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            let logicStartTime = CFAbsoluteTimeGetCurrent()
            
            guard let items = result.item else { return }
            
            DispatchQueue.main.async {
                self.setTodayWeatherInformations(items: items)
                let logicEndTime = CFAbsoluteTimeGetCurrent() - logicStartTime
                print("단기 req 호출 소요시간: \(reqEndTime)")
                print("단기 req 로직 소요시간: \(logicEndTime)")
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
    
    /// - parameter xy: 공공데이터 값으로 변환된 X, Y
    /// '단기예보' 에서의 최소, 최대 온도 값 요청 위해 및
    /// 02:00 or 23:00 으로 호출해야 하므로, 따로 다시 요청한다.
    func requestTodayMinMaxTemp(xy: Gps2XY.LatXLngY) async {
        let reqStartTime = CFAbsoluteTimeGetCurrent()

        let parameters = VeryShortOrShortTermForecastReq(
            serviceKey: Env.shared.openDataApiResponseKey,
            numOfRows: "300",
            baseDate: shortTermForecastUtil.baseDateForTodayMinMaxReq,
            baseTime: shortTermForecastUtil.baseTimeForTodayMinMaxReq,
            nx: String(xy.x),
            ny: String(xy.y)
        )
        
        do {
            let result = try await JsonRequest.shared.newRequest(
                url: Route.GET_WEATHER_SHORT_TERM_FORECAST.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: PublicDataRes<VeryShortOrShortTermForecastBase<ShortTermForecastCategory>>.self,
                requestName: "requestShortForecastItems(xy:)"
            )
            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            let logicStartTime = CFAbsoluteTimeGetCurrent()
            
            guard let items = result.item else { return }
            
            DispatchQueue.main.async {
                self.setTodayMinMaxTemperature(items)
                let logicEndTime = CFAbsoluteTimeGetCurrent() - logicStartTime
                print("단기 req(최소, 최대 온도 값) 호출 소요시간: \(reqEndTime)")
                print("단기 req(최소, 최대 온도 값) 로직 소요시간: \(logicEndTime)")
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
            serviceKey: Env.shared.openDataApiResponseKey,
            stationName: ForDustStationRequest.stationName
        )
        
        do {
            let result = try await JsonRequest.shared.newRequest(
                url: Route.GET_REAL_TIME_FIND_DUST_FORECAST.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: PublicDataRes<RealTimeFindDustForecastBase>.self,
                requestName: "requestRealTimeFindDustForecastItems()"
            )
            
            if let item = result.items?.first {
                
                DispatchQueue.main.async {
                    self.currentFineDustTuple = self.fineDustLookUpUtil.remakeFindDustValue(value: item.pm10Value)
                    self.currentUltraFineDustTuple = self.fineDustLookUpUtil.remakeUltraFindDustValue(value: item.pm25Value)
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
            serviceKey: Env.shared.openDataApiResponseKey,
            umdName: subLocality
        )
        
        do {
            let result = try await JsonRequest.shared.newRequest(
                url: Route.GET_DUST_FORECAST_STATION_XY.val,
                method: .get,
                parameters: param,
                headers: nil,
                resultType: PublicDataRes<DustForecastStationXYBase>.self,
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
    func requestDustForecastStation(tmXAndtmY: (String, String), isCurrentLocationRequested: Bool) async {
        
        let param: DustForecastStationReq = DustForecastStationReq(
            serviceKey: Env.shared.openDataApiResponseKey,
            tmX: tmXAndtmY.0,
            tmY: tmXAndtmY.1
        )
        
        do {
            let result = try await JsonRequest.shared.newRequest(
                url: Route.GET_DUST_FORECAST_STATION.val,
                method: .get,
                parameters: param,
                headers: nil,
                resultType: PublicDataRes<DustForecastStationBase>.self,
                requestName: "requestDustForecastStation()"
            )
            
            if let filteredResult = result.items?.first {
                ForDustStationRequest.stationName = filteredResult.stationName
                
                if isCurrentLocationRequested {
                    UserDefaults.setWidgetShared(filteredResult.stationName, to: .dustStationName)
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
     Request sublocality(성수동 1가) by kakao address
     - parameter longitude: 경도
     - parameter latitude: 위도
     
     Apple이 제공하는.reverseGeocodeLocation 에서 특정 기기에서 sublocality가 nil로 할당되므로
     kakao address request 에서 가져오도록 결정함.
     */
    func requestKaKaoAddressBy(longitude: String, latitude: String, isCurrentLocationRequested: Bool) async {
        let startTime = CFAbsoluteTimeGetCurrent()

        let param = KakaoAddressReq(x: longitude, y: latitude)
        let header = Validate().kakaoHeader()
        
        do {
            let result = try await JsonRequest.shared.newRequest(
                url: Route.GET_KAKAO_ADDRESS.val,
                method: .get,
                parameters: param,
                headers: header,
                resultType: KakaoAddressBase.DocumentsBase.self,
                requestName: "requestKaKaoAddressBy(x:, y:)"
            )
            
            DispatchQueue.main.async {
                self.subLocalityByKakaoAddress = result.documents[0].address.subLocality
                self.currentLocationVM.setSubLocality(result.documents[0].address.subLocality)
                self.isKakaoAddressLoadCompleted = true
                
                /// For Widget
                if isCurrentLocationRequested {
                    self.currentLocationVM.setGPSSubLocality(result.documents[0].address.subLocality)
                    self.currentLocationVM.setFullAddress(self.currentLocationVM.gpsFullAddress)
                    UserDefaults.setWidgetShared(self.subLocalityByKakaoAddress, to: .subLocality)
                    UserDefaults.setWidgetShared(result.documents[0].address.fullAddress, to: .fullAddress)
                }

                let durationTime = CFAbsoluteTimeGetCurrent() - startTime
                print("카카오 주소 req 소요시간: \(durationTime)")
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
        let startTime = CFAbsoluteTimeGetCurrent()

        do {
            let parser = try await SunAndMoonRiseByXMLService(
                queryItem: .init(
                    serviceKey: Env.shared.openDataApiResponseKey,
                    locdate: Date().toString(format: "yyyyMMdd"),
                    longitude: long,
                    latitude: lat
                )
            )
            
            DispatchQueue.main.async {
                self.sunRiseAndSetHHmm = (parser.result.sunrise, parser.result.sunset)
                
                let currentHHmm = Date().toString(format: "HHmm")
                let isDayMode = self.commonForecastUtil.isDayMode(hhMM: currentHHmm, sunrise: parser.result.sunrise, sunset: parser.result.sunset)
                self.contentVM.setIsDayMode(isDayMode)
                
                self.isSunriseSunsetLoadCompleted = true
            }
            
            let durationTime = CFAbsoluteTimeGetCurrent() - startTime
            print("일출 일몰 req 소요시간: \(durationTime)")
            
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
}

// MARK: - Set Variables..

extension CurrentWeatherVM {
    
    /**
     Set 초 단기예보 Items -> `currentTemperature`(현재 기온) varialbe
     
     - parameter items: [초단기예보 Model]
     */
    func setCurrentTemperature(items: [VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>]) {
        currentTemperature = items[24].fcstValue
    }
    
    /**
     초 단기예보 Items -> `currentWeatherInformations`(온도 String, 바람속도 String, 습도 String, 1시간 강수량 String, 날씨 이미지 String)에 해당하는 값들 Extract
     
     - parameter items: [초단기예보 Model]
     */
    func setCurrentWeatherInformation(items: [VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>]) {
        let currentTemperature = items[24]
        let currentWindSpeed = items[54]
        let currentWetPercent = items[30]
        let currentOneHourPrecipitation = items[12]
        let firstPTYItem = items[6]
        let firstSKYItem = items[18]
        
        let veryShortTermForecastWeatherInf = commonForecastUtil.veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
            ptyValue: firstPTYItem.fcstValue,
            skyValue: firstSKYItem.fcstValue,
            hhMMForDayOrNightImage: firstPTYItem.fcstTime,
            sunrise: sunRiseAndSetHHmm.0,
            sunset: sunRiseAndSetHHmm.1,
            isAnimationImage: false
        )
        
        currentWeatherInformation = Weather.CurrentInformation(
            temperature: currentTemperature.fcstValue,
            windSpeed: commonForecastUtil.remakeWindSpeedValueByVeryShortTermOrShortTermForecast(
                value: currentWindSpeed.fcstValue
            ),
            wetPercent: ("\(currentWetPercent.fcstValue)%", ""),
            oneHourPrecipitation: commonForecastUtil.remakeOneHourPrecipitationValueByVeryShortTermOrShortTermForecast(
                value: currentOneHourPrecipitation.fcstValue
            ),
            weatherImage: veryShortTermForecastWeatherInf.imageString,
            skyType: veryShortTermForecastWeatherInf.skyType
        )
        
        contentVM.setSkyKeyword(veryShortTermForecastWeatherInf.skyType.backgroundImageKeyword)
        isCurrentWeatherInformationLoadCompleted = true
    }
    
    /**
     Set 단기예보 Items ->` todayWeatherInformations`variable
     
     - parameter items: [초단기예보 Model]
     */
    func setTodayWeatherInformations(items: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>]) {
        todayWeatherInformations = []
        
        let skipValue = shortTermForecastUtil.todayWeatherIndexSkipValue()
        
        var tempIndex = 0 + skipValue
        var skyIndex = 5 + skipValue
        var ptyIndex = 6 + skipValue
        var popIndex = 7 + skipValue
        var step = 12
        let loopCount = shortTermForecastUtil.todayWeatherLoopCount()
        
        // 각 index 해당하는 값(시간에 해당하는 값) append
        for _ in 0..<loopCount {
            
            // 1시간 별 데이터 중 TMX(최고온도), TMN(최저온도) 가 있는지
            // 존재하면 1시간 별 데이터 기존 12개 -> 13이 됨
            let isExistTmxOrTmn = items[tempIndex + 12].category == .TMX ||
            items[tempIndex + 12].category == .TMN
            
            step = isExistTmxOrTmn ? 13 : 12

            let weatherImage: Weather.DescriptionAndSkyTypeAndImageString = commonForecastUtil.veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
                ptyValue: items[ptyIndex].fcstValue,
                skyValue: items[skyIndex].fcstValue,
                hhMMForDayOrNightImage: items[tempIndex].fcstTime,
                sunrise: self.sunRiseAndSetHHmm.0,
                sunset: self.sunRiseAndSetHHmm.1,
                isAnimationImage: false
            )
            
            let todayWeather = Weather.TodayInformation(
                time: CommonUtil.shared.convertAMOrPMFromHHmm(items[tempIndex].fcstTime),
                weatherImage: weatherImage.imageString,
                precipitation: items[popIndex].fcstValue,
                temperature: items[tempIndex].fcstValue
            )
            todayWeatherInformations.append(todayWeather)
            
            tempIndex += step
            skyIndex += step
            ptyIndex += step
            popIndex += step
        }
        isTodayWeatherInformationLoadCompleted = true
    }
    
    /// Set `todayMinMaxTemperature` variable
    /// - parameter items: 단기예보 response items
    func setTodayMinMaxTemperature(_ items: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>]) {
        
        guard let filteredMinTempItem = items.first(where: { $0.category == .TMN }) else {
            CommonUtil.shared.printError(
                funcTitle: "setTodayMinMaxTemperature",
                description: "category == .TMN 에 해당하는 item이 없습니다."
            )
            return
        }
        guard let filteredMaxTempItem = items.first(where: { $0.category == .TMX }) else {
            CommonUtil.shared.printError(
                funcTitle: "setTodayMinMaxTemperature",
                description: "category == .TMX 에 해당하는 item이 없습니다."
            )
            return
        }
        
        todayMinMaxTemperature = (filteredMinTempItem.fcstValue.toDouble.toInt.toString,
                                  filteredMaxTempItem.fcstValue.toDouble.toInt.toString
        )
        isMinMaxTempLoadCompleted = true
    }
    
    /**
     Set 초 단기예보 Items ->`currentWeatherAnimationImg`(현재 날씨 animation lottie)
     
     - parameter items: [초단기예보 Model]
     */
    func setCurrentWeatherImgAndAnimationImg(items: [VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>]) {
        let firstPTYItem = items[6] // 강수 형태 first
        let firstSKYItem = items[18] // 하늘 상태 first
        
        currentWeatherAnimationImg = commonForecastUtil.veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
            ptyValue: firstPTYItem.fcstValue,
            skyValue: firstSKYItem.fcstValue,
            hhMMForDayOrNightImage: firstPTYItem.fcstTime,
            sunrise: sunRiseAndSetHHmm.0,
            sunset: sunRiseAndSetHHmm.1,
            isAnimationImage: true
        ).imageString
        
        currentWeatherImage = commonForecastUtil.veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
            ptyValue: firstPTYItem.fcstValue,
            skyValue: firstSKYItem.fcstValue,
            hhMMForDayOrNightImage: firstPTYItem.fcstTime,
            sunrise: sunRiseAndSetHHmm.0,
            sunset: sunRiseAndSetHHmm.1,
            isAnimationImage: false
        ).imageString
        
        isCurrentWeatherAnimationSetCompleted = true
    }
    
    /**
     Set `isAllLoadCompleted` variable
     
     */
    func setIsAllLoadCompleted() {
        
        isAllLoadCompleted = // 7 values
        (isCurrentWeatherInformationLoadCompleted &&
         isCurrentWeatherAnimationSetCompleted && isFineDustLoadCompleted &&
         isKakaoAddressLoadCompleted && isMinMaxTempLoadCompleted &&
         isSunriseSunsetLoadCompleted && isTodayWeatherInformationLoadCompleted)
    }
}

// MARK: - View On Appear, Task Actions..

extension CurrentWeatherVM {
    
    func todayViewControllerLocationManagerUpdatedAction(
        xy: Gps2XY.LatXLngY,
        longLati: (String, String)
    ) {
        Task(priority: .userInitiated) {
            await requestSunAndMoonrise(long: longLati.0, lat: longLati.1) // Must first called
            async let _ = requestVeryShortForecastItems(xy: xy)
            async let _ = requestShortForecastItems(xy: xy)
            async let _ = requestTodayMinMaxTemp(xy: xy)
            async let _ = requestKaKaoAddressBy(longitude: longLati.0, latitude: longLati.1, isCurrentLocationRequested: true)
        }
    }
    
    func todayViewControllerKakaoAddressUpdatedAction(umdName: String, locality: String) {
        Task(priority: .userInitiated) {
            await requestDustForecastStationXY(
                subLocality: umdName,
                locality: locality
            )
            await requestDustForecastStation(tmXAndtmY: ForDustStationRequest.tmXAndtmY, isCurrentLocationRequested: true)
            await requestRealTimeFindDustForecastItems()
        }
    }
}

// MARK: - On tap gestures..

extension CurrentWeatherVM {
    
    func refreshButtonOnTapGesture() {
        isStartRefresh = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isStartRefresh = false
        }
    }
    
//    func additinalAddressSavedItemOnTapGesture(fullAddress)
    
    func additionalAddressFinalLocationOnTapGesture(fullAddress: String, locality: String, subLocality: String, isNewAdd: Bool) {
        
        LocationDataManagerVM.getLatitudeAndLongitude(address: fullAddress) { [weak self] result in
            guard let self = self else { return }
            self.locality = locality
            
            switch result {
                
            case .success(let success):
                let latitude: Double = success.0
                let longitude: Double = success.1
                let xy: Gps2XY.LatXLngY = self.commonForecastUtil.convertGPS2XY(mode: .toXY, lat_X: latitude, lng_Y: longitude)
                
                additionalLocationProgress = .loading
                initLoadCompletedVariables()
                
                Task(priority: .userInitiated) {
                    await self.requestSunAndMoonrise(long: String(longitude), lat: String(latitude)) // Must first called
                    async let _ = self.requestVeryShortForecastItems(xy: xy)
                    async let _ = self.requestShortForecastItems(xy: xy)
                    async let _ = self.requestTodayMinMaxTemp(xy: xy)
                    async let _ = self.requestKaKaoAddressBy(longitude: String(longitude), latitude: String(latitude), isCurrentLocationRequested: false)
                    await self.requestDustForecastStationXY(
                        subLocality: subLocality,
                        locality: locality
                    )
                    await self.requestDustForecastStation(tmXAndtmY: ForDustStationRequest.tmXAndtmY, isCurrentLocationRequested: false)
                    await self.requestRealTimeFindDustForecastItems()
                    
                    DispatchQueue.main.async {
                        self.currentLocationVM.setXY((String(xy.x), String(xy.y)))
                        self.currentLocationVM.setLatitude(String(latitude))
                        self.currentLocationVM.setLongitude(String(longitude))
                        self.currentLocationVM.setLocality(locality)
                        self.currentLocationVM.setSubLocality(subLocality)
                        self.currentLocationVM.setFullAddress(fullAddress)
                        
                        self.additionalLocationProgress = .completed
                        self.openAdditionalLocationView = false
                    }
                                        
                    if isNewAdd {
                        UserDefaults.standard.setUserDefaultsStringArray(value: fullAddress, key: UserDefaultsKeys.additionalFullAddresses)
                        UserDefaults.standard.setUserDefaultsStringArray(value: locality, key: UserDefaultsKeys.additionalLocalities)
                        UserDefaults.standard.setUserDefaultsStringArray(value: subLocality, key: UserDefaultsKeys.additionalSubLocalities)
                    }
                }
                
            case .failure(_):
                DispatchQueue.main.async {
                    self.additionalLocationProgress = .notFound
                }
            }
        }
    }
}

// MARK: - On change funcs..

extension CurrentWeatherVM {
    
    func isStartRefreshOnChangeAction(newValue: Bool, longitude: String, latitude: String, xy: (String, String), locality: String, subLocality: String) {
        
        if newValue {
            initLoadCompletedVariables()
            
            Task(priority: .userInitiated) {
                performRefresh(
                    longitude: longitude,
                    latitude: latitude,
                    xy: xy,
                    locality: locality,
                    subLocality: subLocality
                )
            }
        }
    }
    
    func loadCompletedVariablesOnChangeAction() {
        setIsAllLoadCompleted()
    }
}

// MARK: - ETC funcs..

extension CurrentWeatherVM {
    
    func initLoadCompletedVariables() {
        isCurrentWeatherInformationLoadCompleted = false
        isCurrentWeatherAnimationSetCompleted = false
        isFineDustLoadCompleted = false
        isKakaoAddressLoadCompleted = false
        isMinMaxTempLoadCompleted = false
        isSunriseSunsetLoadCompleted = false
        isTodayWeatherInformationLoadCompleted = false
    }
    
    func performRefresh(longitude: String, latitude: String, xy: (String, String), locality: String, subLocality: String) {
        let convertedXY: Gps2XY.LatXLngY = .init(lat: 0, lng: 0, x: xy.0.toInt, y: xy.1.toInt)
        
        Task(priority: .userInitiated) {
            await requestSunAndMoonrise(long: longitude, lat: latitude) // Must first called
            async let _ = requestVeryShortForecastItems(xy: convertedXY)
            async let _ = requestShortForecastItems(xy: convertedXY)
            async let _ = requestTodayMinMaxTemp(xy: convertedXY)
            async let _ = requestKaKaoAddressBy(longitude: longitude, latitude: latitude, isCurrentLocationRequested: false)
            await requestDustForecastStationXY(
                subLocality: subLocality,
                locality: locality
            )
            await requestDustForecastStation(tmXAndtmY: ForDustStationRequest.tmXAndtmY, isCurrentLocationRequested: false)
            await requestRealTimeFindDustForecastItems()
        }
    }
}

