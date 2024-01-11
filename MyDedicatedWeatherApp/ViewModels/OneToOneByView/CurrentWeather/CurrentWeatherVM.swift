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
    @Published var isLaunchScreenEnded: Bool = false
    
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
    @Published var showLoadRetryButton: Bool = false
    @Published var showNoticeFloater: Bool = false
    
    var noticeFloaterMessage: String = ""
    var timer: Timer?
    var timerNum: Int = 0
    var currentTask: Task<(), Never>?
    
    private enum DustStationRequestParam {
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
            
            guard let items = result.item else { return }
            await self.setCurrentWeatherImgAndAnimationImg(items: items)
            await self.setCurrentTemperature(items: items)
            await self.setCurrentWeatherInformation(items: items)
            
            let durationTime = CFAbsoluteTimeGetCurrent() - startTime
            print("초단기 req 소요시간: \(durationTime)")
            
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
            
            guard let items = result.item else { return }
            await setTodayWeatherInformations(items: items)
            
            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            print("단기 req 호출 소요시간: \(reqEndTime)")
            
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
            
            guard let items = result.item else { return }
            await setTodayMinMaxTemperature(items)
            
            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            print("단기 req(최소, 최대 온도 값) 호출 소요시간: \(reqEndTime)")

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
        let reqStartTime = CFAbsoluteTimeGetCurrent()

        let parameters: RealTimeFindDustForecastReq = RealTimeFindDustForecastReq(
            serviceKey: Env.shared.openDataApiResponseKey,
            stationName: DustStationRequestParam.stationName
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
            
            guard let item = result.items?.first else { return }
            await setCurrentFineDustAndUltraFineDustTuple(item)
            
            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            print("미세먼지 item 호출 소요시간: \(reqEndTime)")
            
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
        let reqStartTime = CFAbsoluteTimeGetCurrent()

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
            
            setDustStationRequestParamXY(items: result.items, locality: locality)
                
            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            print("미세먼지 측정소 xy좌표 get 호출 소요시간: \(reqEndTime)")
            
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
        let reqStartTime = CFAbsoluteTimeGetCurrent()

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
            
            setDustStationRequestParamStationName(result.items)
            
            guard let items = result.items, let item = items.first else { return }
            UserDefaults.setWidgetShared(item.stationName, to: .dustStationName)

            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            print("미세먼지 측정소 get 호출 소요시간: \(reqEndTime)")
            
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
            
            await setSubLocalityByKakaoAddress(result.documents)
            
            guard result.documents.count > 0 else { return }
            await currentLocationVM.setSubLocality(result.documents[0].address.subLocality)
            
            /// For Widget
            if isCurrentLocationRequested {
                await self.currentLocationVM.setGPSSubLocality(result.documents[0].address.subLocality)
                await self.currentLocationVM.setFullAddress(self.currentLocationVM.gpsFullAddress)
                UserDefaults.setWidgetShared(self.subLocalityByKakaoAddress, to: .subLocality)
                UserDefaults.setWidgetShared(result.documents[0].address.fullAddress, to: .fullAddress)
            }

            let durationTime = CFAbsoluteTimeGetCurrent() - startTime
            print("카카오 주소 req 소요시간: \(durationTime)")
            
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
            
            await setSunRiseAndSetHHmm(parser.result)
            await contentVM.setIsDayMode(
                sunrise: parser.result.sunrise,
                sunset: parser.result.sunset
            )
            
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
    @MainActor
    func setCurrentTemperature(items: [VeryShortOrShortTermForecastBase<VeryShortTermForecastCategory>]) {
        currentTemperature = items[24].fcstValue
    }
    
    /**
     초 단기예보 Items -> `currentWeatherInformations`(온도 String, 바람속도 String, 습도 String, 1시간 강수량 String, 날씨 이미지 String)에 해당하는 값들 Extract
     
     - parameter items: [초단기예보 Model]
     */
    @MainActor
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
    @MainActor
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
    @MainActor
    func setTodayMinMaxTemperature(_ items: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>]) {
        let todayDate = Date().toString(format: "yyyyMMdd")
        
        let filteredItems = items.filter( {$0.category == .TMP && $0.fcstDate == todayDate} )
        var filteredTemps = filteredItems.map({ $0.fcstValue.toInt })
        filteredTemps.append(currentTemperature.toInt)
        
        let min = filteredTemps.min() ?? 0
        let max = filteredTemps.max() ?? 0
        
        todayMinMaxTemperature = (min.toString, max.toString)
        isMinMaxTempLoadCompleted = true
    }
    
    /**
     Set 초 단기예보 Items ->`currentWeatherAnimationImg`(현재 날씨 animation lottie)
     
     - parameter items: [초단기예보 Model]
     */
    @MainActor
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
    
    /// Set 미세먼지, 초미세먼지
    /// - parameter item: 미세먼지 요청 response
    @MainActor
    func setCurrentFineDustAndUltraFineDustTuple(_ item: RealTimeFindDustForecastBase) {
        currentFineDustTuple = fineDustLookUpUtil.remakeFindDustValue(value: item.pm10Value)
        currentUltraFineDustTuple = fineDustLookUpUtil.remakeUltraFindDustValue(value: item.pm25Value)
        isFineDustLoadCompleted = true
    }
    
    /// Set 세부주소
    /// - parameter items: 카카오 주소 요청 response
    @MainActor
    func setSubLocalityByKakaoAddress(_ items: [KakaoAddressBase.AddressBase]) {
        guard items.count > 0 else { return }
        subLocalityByKakaoAddress = items[0].address.subLocality
        isKakaoAddressLoadCompleted = true
    }
    
    /// Set 일출, 일몰 시간
    /// - parameter item: 일출 일몰 요청 response
    @MainActor
    func setSunRiseAndSetHHmm(_ item: SunAndMoonriseBase) {
        sunRiseAndSetHHmm = (item.sunrise, item.sunset)
        isSunriseSunsetLoadCompleted = true
    }
    
    /// Set XY좌표(미세먼지 측정소 이름 get 요청에 필요)
    /// - parameter items: 측정소 xy 좌표 요청 response
    /// - parameter locality: 측정소 xy좌표 요청 response에서 필터하기 위한것
    func setDustStationRequestParamXY(items: [DustForecastStationXYBase]?, locality: String) {
        guard let items = items else { return }
        guard let item = items.first( where: { $0.sidoName.contains(locality) } ) else { return }
        DustStationRequestParam.tmXAndtmY = (item.tmX, item.tmY)
    }
    
    /// Set 미세먼지 측정소 이름  (미세먼지 아이템 get 요청에 필요)
    /// - parameter items: 측정소 측정소 이름 요청 response
    func setDustStationRequestParamStationName(_ items: [DustForecastStationBase]?) {
        guard let items = items, let item = items.first else { return }
        DustStationRequestParam.stationName = item.stationName
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
        
        if isAllLoadCompleted {
            initializeTaskAndTimer()
        }
    }
}

// MARK: - View On Appear, Task Actions..

extension CurrentWeatherVM {
    
    func todayViewControllerLocationManagerUpdatedAction(
        xy: Gps2XY.LatXLngY,
        longLati: (String, String),
        locality: String
    ) {
        
        // 런치 스크린때문에 2.5초 후에 타이머 시작
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.timerStart()
        }
        
        initializeTask()
        currentTask = Task(priority: .userInitiated) {
            await requestSunAndMoonrise(long: longLati.0, lat: longLati.1) // Must first called
            
            Task(priority: .userInitiated) {
                async let _ = requestVeryShortForecastItems(xy: xy)
                async let _ = requestShortForecastItems(xy: xy)
                async let _ = requestTodayMinMaxTemp(xy: xy)
            }
            
            Task(priority: .userInitiated) {
                await requestKaKaoAddressBy(longitude: longLati.0, latitude: longLati.1, isCurrentLocationRequested: true)
                await requestDustForecastStationXY(
                    subLocality: subLocalityByKakaoAddress,
                    locality: locality
                )
                await requestDustForecastStation(tmXAndtmY: DustStationRequestParam.tmXAndtmY, isCurrentLocationRequested: true)
                await requestRealTimeFindDustForecastItems()
            }
        }
    }
}

// MARK: - On tap gestures..

extension CurrentWeatherVM {
    
    func refreshButtonOnTapGesture() {
        isStartRefresh = true
        showLoadRetryButton = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isStartRefresh = false
        }
    }
        
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
                
                timerStart()
                initializeTask()
                
                currentTask = Task(priority: .userInitiated) {
                    await self.requestSunAndMoonrise(long: String(longitude), lat: String(latitude)) // Must first called
                    
                    Task(priority: .userInitiated) {
                        async let _ = self.requestVeryShortForecastItems(xy: xy)
                        async let _ = self.requestShortForecastItems(xy: xy)
                        async let _ = self.requestTodayMinMaxTemp(xy: xy)
                    }
                    
                    Task(priority: .userInitiated) {
                        await self.requestKaKaoAddressBy(longitude: String(longitude), latitude: String(latitude), isCurrentLocationRequested: false)
                        await self.requestDustForecastStationXY(
                            subLocality: subLocality,
                            locality: locality
                        )
                        await self.requestDustForecastStation(tmXAndtmY: DustStationRequestParam.tmXAndtmY, isCurrentLocationRequested: false)
                        await self.requestRealTimeFindDustForecastItems()
                    }
                    
                    await self.currentLocationVM.setXY((String(xy.x), String(xy.y)))
                    await self.currentLocationVM.setLatitude(String(latitude))
                    await self.currentLocationVM.setLongitude(String(longitude))
                    await self.currentLocationVM.setLocality(locality)
                    await self.currentLocationVM.setSubLocality(subLocality)
                    await self.currentLocationVM.setFullAddress(fullAddress)
                    
                    DispatchQueue.main.async {
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
    
    func retryButtonOnTapGesture(longitude: String, latitude: String, xy: (String, String), locality: String, subLocality: String) {
        showLoadRetryButton = false

        noticeFloaterMessage = """
        재시도 합니다.
        기상청 서버 네트워크에 따라 속도가 느려질 수 있습니다 :)
        """
        showNoticeFloater = false
        showNoticeFloater = true

        performRefresh(longitude: longitude, latitude: latitude, xy: xy, locality: locality, subLocality: subLocality)
    }
}

// MARK: - On change funcs..

extension CurrentWeatherVM {
    
    func isStartRefreshOnChangeAction(newValue: Bool, longitude: String, latitude: String, xy: (String, String), locality: String, subLocality: String) {
        
        if newValue {
            initLoadCompletedVariables()
            
            performRefresh(
                longitude: longitude,
                latitude: latitude,
                xy: xy,
                locality: locality,
                subLocality: subLocality
            )
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
    
    func initializeTask() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    func initializeTimer() {
        timer?.invalidate()
        timer = nil
        timerNum = 0
    }
    
    func initializeTaskAndTimer() {
        showLoadRetryButton = false
        
        initializeTask()
        initializeTimer()
    }
    
    func timerStart() {
        initializeTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(askRetryIf7SecondsAfterNotLoaded(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc func askRetryIf7SecondsAfterNotLoaded(timer: Timer) {
        
        guard self.timer != nil else { return }
        self.timerNum += 1
        
        if timerNum == 3 {
            noticeFloaterMessage = """
            조금만 기다려주세요.
            기상청 서버 네트워크에 따라 속도가 느려질 수 있습니다 :)
            """
            showNoticeFloater = false
            showNoticeFloater = true
            
        } else if timerNum == 8 {
            initializeTimer()
            showLoadRetryButton = true
        }
    }
    
    func performRefresh(longitude: String, latitude: String, xy: (String, String), locality: String, subLocality: String) {
        let convertedXY: Gps2XY.LatXLngY = .init(lat: 0, lng: 0, x: xy.0.toInt, y: xy.1.toInt)
        
        timerStart()
        initializeTask()
        
        currentTask = Task(priority: .userInitiated) {
            await requestSunAndMoonrise(long: longitude, lat: latitude) // Must first called
            
            Task(priority: .userInitiated) {
                async let _ = requestVeryShortForecastItems(xy: convertedXY)
                async let _ = requestShortForecastItems(xy: convertedXY)
                async let _ = requestTodayMinMaxTemp(xy: convertedXY)
            }
            
            Task(priority: .userInitiated) {
                await requestKaKaoAddressBy(longitude: longitude, latitude: latitude, isCurrentLocationRequested: false)
                await requestDustForecastStationXY(
                    subLocality: subLocality,
                    locality: locality
                )
                await requestDustForecastStation(tmXAndtmY: DustStationRequestParam.tmXAndtmY, isCurrentLocationRequested: false)
                await requestRealTimeFindDustForecastItems()
            }
        }
    }
}

