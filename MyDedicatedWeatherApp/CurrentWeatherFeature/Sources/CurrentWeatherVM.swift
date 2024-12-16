//
//  CurrentWeatherVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation
import Combine
import Domain
import Data
import Core

final class CurrentWeatherVM: ObservableObject {
    @Published private(set) var currentTemperature: String = "00"
    @Published private(set) var currentWeatherAnimationImg: String = ""
    @Published private(set) var currentWeatherImage: String = ""
    @Published private(set) var currentWeatherInformation: Weather.CurrentInformation = Dummy.shared.currentWeatherInformation()
    @Published private(set) var currentFineDustTuple: Weather.DescriptionAndColor = .init(description: "", color: .defaultAreaColor)
    @Published private(set) var currentUltraFineDustTuple: Weather.DescriptionAndColor = .init(description: "", color: .defaultAreaColor)
    @Published private(set) var todayMinMaxTemperature: (String, String) = ("__", "__")
    @Published private(set) var todayWeatherInformations: [Weather.TodayInformation] = Dummy.shared.todayWeatherInformations()
    @Published var openAdditionalLocationView: Bool = false
    @Published var additionalLocationProgress: AdditionalLocationProgress = .none
    @Published var subLocalityByKakaoAddress: String = ""
    @Published var isLaunchScreenEnded: Bool = false
    
    static private(set) var xy: Gps2XY.LatXLngY = .init(lat: 0, lng: 0, x: 0, y: 0)
    
    @Published private(set) var sunriseAndSunsetHHmm: (String, String) = ("0000", "0000")
    
    /// Load Completed Variables..(7 values)
    @Published private(set) var isCurrentWeatherInformationLoaded: Bool = false
    @Published private(set) var isCurrentWeatherAnimationSetCompleted: Bool = false
    @Published private(set) var isFineDustLoaded: Bool = false
    @Published private(set) var isKakaoAddressLoaded: Bool = false
    @Published private(set) var isMinMaxTempLoaded: Bool = false
    @Published private(set) var isSunriseSunsetLoaded: Bool = false
    @Published private(set) var isTodayWeatherInformationLoaded: Bool = false
    
    @Published private(set) var isAllLoaded: Bool = false
    @Published var showNoticeFloater: Bool = false
    
    private let publicApiKey: String = Bundle.main.object(forInfoDictionaryKey: "public_api_key") as? String ?? ""
    private let kakaoApiKey: String = Bundle.main.object(forInfoDictionaryKey: "kakao_api_key") as? String ?? ""
    
    var noticeFloaterMessage: String = ""
    var timer: Timer?
    var timerNum: Int = 0
    var currentTask: Task<(), Never>?
    
    private var bag: Set<AnyCancellable> = .init()
    
    private enum DustStationRequestParam {
        static var tmXAndtmY: (String, String) = ("","")
        static var stationName: String = ""
    }
    
    weak var currentLocationEODelegate: CurrentLocationEODelegate?
    weak var contentEODelegate: ContentEODelegate?
    
    private let commonForecastUtil: CommonForecastUtil
    private let veryShortTermForecastUtil: VeryShortTermForecastUtil
    private let shortTermForecastUtil: ShortTermForecastUtil
    private let midTermForecastUtil: MidTermForecastUtil
    private let fineDustLookUpUtil: FineDustLookUpUtil
    
    private let veryShortForecastService: VeryShortForecastService
    private let shortForecastService: ShortForecastService
    private let dustForecastService: DustForecastService
    private let kakaoAddressService: KakaoAddressService
    
    init(
        commonForecastUtil: CommonForecastUtil,
        veryShortTermForecastUtil: VeryShortTermForecastUtil,
        shortTermForecastUtil: ShortTermForecastUtil,
        midTermForecastUtil: MidTermForecastUtil,
        fineDustLookUpUtil: FineDustLookUpUtil,
        veryShortForecastService: VeryShortForecastService,
        shortForecastService: ShortForecastService,
        dustForecastService: DustForecastService,
        kakaoAddressService: KakaoAddressService
    ) {
        self.commonForecastUtil = commonForecastUtil
        self.veryShortTermForecastUtil = veryShortTermForecastUtil
        self.shortTermForecastUtil = shortTermForecastUtil
        self.midTermForecastUtil = midTermForecastUtil
        self.fineDustLookUpUtil = fineDustLookUpUtil
        self.veryShortForecastService = veryShortForecastService
        self.shortForecastService = shortForecastService
        self.dustForecastService = dustForecastService
        self.kakaoAddressService = kakaoAddressService
        
        sinkIsAllLoaded()
    }
}

// MARK: - Sink Funcs..

extension CurrentWeatherVM {
    private func sinkIsAllLoaded() {
        let zipFirst = Publishers.Zip4($isCurrentWeatherInformationLoaded, $isCurrentWeatherAnimationSetCompleted, $isFineDustLoaded, $isKakaoAddressLoaded)
        let zipSecond = Publishers.Zip3($isMinMaxTempLoaded, $isSunriseSunsetLoaded, $isTodayWeatherInformationLoaded)
        
        Publishers.Zip(zipFirst, zipSecond)
            .sink { [weak self] results in
                guard let self = self else { return }
                let isZipFirstAllLoaded: Bool = results.0.0 && results.0.1 && results.0.2 && results.0.3
                let isZipSecondAllLoaded: Bool = results.1.0 && results.1.1 && results.1.2
                guard isZipFirstAllLoaded && isZipSecondAllLoaded else { return }
                isAllLoaded = true
                CustomHapticGenerator.impact(style: .soft)
                initializeTaskAndTimer()
            }
            .store(in: &bag)
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
    func getCurrentItems(xy: Gps2XY.LatXLngY) async {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let result = await veryShortForecastService.getCurrentItems(serviceKey: publicApiKey, xy: xy)
        
        switch result {
        case .success(let items):
            await self.setCurrentWeatherImgAndAnimationImg(items: items)
            await self.setCurrentTemperature(items: items)
            await self.setCurrentWeatherInformation(items: items)
            
            let durationTime = CFAbsoluteTimeGetCurrent() - startTime
            print("초단기 req 소요시간: \(durationTime)")
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
    
    /**
     Request 단기예보 Items
     - parameter xy: 공공데이터 값으로 변환된 X, Y
     
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
    func getTodayItems(xy: Gps2XY.LatXLngY) async {
        let reqStartTime = CFAbsoluteTimeGetCurrent()

        let result = await shortForecastService.getTodayItems(serviceKey: publicApiKey, xy: xy, reqRow: "300")
        
        switch result {
        case .success(let items):
            await setTodayWeatherInformations(items: items)
            
            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            print("단기 req 호출 소요시간: \(reqEndTime)")
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
    
    /// - parameter xy: 공공데이터 값으로 변환된 X, Y
    /// '단기예보' 에서의 최소, 최대 온도 값 요청 위해 및
    /// 02:00 or 23:00 으로 호출해야 하므로, 따로 다시 요청한다.
    func getTodayMinMaxItems(xy: Gps2XY.LatXLngY) async {
        let reqStartTime = CFAbsoluteTimeGetCurrent()

        let result = await shortForecastService.getTodayMinMaxItems(serviceKey: publicApiKey, xy: xy)
        
        switch result {
        case .success(let items):
            await setTodayMinMaxTemperature(items)
            
            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            print("단기 req(최소, 최대 온도 값) 호출 소요시간: \(reqEndTime)")
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
    
    /**
     Request 실시간 미세먼지, 초미세먼지 Items request
     */
    func getRealTimeDustItems() async {
        let reqStartTime = CFAbsoluteTimeGetCurrent()

        let result = await dustForecastService.getRealTimeDustItems(serviceKey: publicApiKey, stationName: DustStationRequestParam.stationName)
        
        switch result {
        case .success(let items):
            guard let item = items.first else { return }
            await setCurrentFineDustAndUltraFineDustTuple(item)
            
            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            print("미세먼지 item 호출 소요시간: \(reqEndTime)")
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
    
    /**
     Request 미세먼지 측정소가 위치한 X, Y 좌표
     
     - parameter subLocality: ex) 성수동 1가
     - parameter locality: ex) 서울특별시
     */
    func getXYOfDustStation(subLocality: String, locality: String) async {
        let reqStartTime = CFAbsoluteTimeGetCurrent()
        
        let result = await dustForecastService.getXYOfStation(serviceKey: publicApiKey, subLocality: subLocality)
        
        switch result {
        case .success(let items):
            setDustStationRequestParamXY(items: items, locality: locality)
                
            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            print("미세먼지 측정소 xy좌표 get 호출 소요시간: \(reqEndTime)")
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
    
    /**
     Request 미세먼지 측정소 이름
     - parameter tmxAndtmY: 미세먼지 측정소 X, Y 좌표
     
     */
    func getDustStationInfo(tmXAndtmY: (String, String), isCurrentLocationRequested: Bool) async {
        let reqStartTime = CFAbsoluteTimeGetCurrent()
        
        let result = await dustForecastService.getStationInfo(serviceKey: publicApiKey, tmXAndtmY: tmXAndtmY)
        
        switch result {
        case .success(let items):
            setDustStationRequestParamStationName(items)
            
            guard let firstItem = items.first else { return }
            UserDefaults.setWidgetShared(firstItem.stationName, to: .dustStationName)

            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            print("미세먼지 측정소 get 호출 소요시간: \(reqEndTime)")
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
    
    /**
     Request sublocality(성수동 1가) by kakao address
     - parameter longitude: 경도
     - parameter latitude: 위도
     
     Apple이 제공하는.reverseGeocodeLocation 에서 특정 기기에서 sublocality가 nil로 할당되므로
     kakao address request 에서 가져오도록 결정함.
     */
    func getKaKaoAddressBy(longitude: String, latitude: String, isCurrentLocationRequested: Bool) async {
        let startTime = CFAbsoluteTimeGetCurrent()

        let result = await kakaoAddressService.getKaKaoAddressBy(
            apiKey: kakaoApiKey,
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
                UserDefaults.setWidgetShared(self.subLocalityByKakaoAddress, to: .subLocality)
                UserDefaults.setWidgetShared(item.documents[0].address.fullAddress, to: .fullAddress)
            }

            let durationTime = CFAbsoluteTimeGetCurrent() - startTime
            print("카카오 주소 req 소요시간: \(durationTime)")
        case .failure(let error):
            CustomLogger.error("\(error)")
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
    func setCurrentTemperature(items: [VeryShortOrShortTermForecast<VeryShortTermForecastCategory>]) {
        currentTemperature = items[24].fcstValue
    }
    
    /**
     초 단기예보 Items -> `currentWeatherInformations`(온도 String, 바람속도 String, 습도 String, 1시간 강수량 String, 날씨 이미지 String)에 해당하는 값들 Extract
     
     - parameter items: [초단기예보 Model]
     */
    @MainActor
    func setCurrentWeatherInformation(items: [VeryShortOrShortTermForecast<VeryShortTermForecastCategory>]) {
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
            windSpeed: (commonForecastUtil.convertWindSpeed(rawValue: currentWindSpeed.fcstValue).toDescription, "\(currentWindSpeed.fcstValue)ms"),
            wetPercent: ("\(currentWetPercent.fcstValue)%", ""),
            oneHourPrecipitation: (
                commonForecastUtil.convertPrecipitationAmount(
                    rawValue: currentOneHourPrecipitation.fcstValue
                ),
                commonForecastUtil.precipitationValueToShort(rawValue: currentOneHourPrecipitation.fcstValue)
            ),
            weatherImage: skyType.image(isDayMode: sunTime.isDayMode),
            skyType: skyType
        )
        contentEODelegate?.setSkyType(skyType)
        isCurrentWeatherInformationLoaded = true
    }
    
    /**
     Set 단기예보 Items ->` todayWeatherInformations`variable
     
     - parameter items: [초단기예보 Model]
     */
    @MainActor
    func setTodayWeatherInformations(items: [VeryShortOrShortTermForecast<ShortTermForecastCategory>]) {
        todayWeatherInformations = []
        
        let skipValue = shortTermForecastUtil.todayWeatherIndexSkipValue
        
        var tempIndex = 0 + skipValue
        var skyIndex = 5 + skipValue
        var ptyIndex = 6 + skipValue
        var popIndex = 7 + skipValue
        var step = 12
        let loopCount = shortTermForecastUtil.todayWeatherLoopCount
        let sunTime: SunTime = .init(
            currentHHmm: items[tempIndex].fcstTime,
            sunriseHHmm: self.sunriseAndSunsetHHmm.0,
            sunsetHHmm: self.sunriseAndSunsetHHmm.1
        )
        
        // 각 index 해당하는 값(시간에 해당하는 값) append
        for _ in 0..<loopCount {
            
            // 1시간 별 데이터 중 TMX(최고온도), TMN(최저온도) 가 있는지
            // 존재하면 1시간 별 데이터 기존 12개 -> 13이 됨
            let isExistTmxOrTmn = items[tempIndex + 12].category == .TMX ||
            items[tempIndex + 12].category == .TMN
            
            step = isExistTmxOrTmn ? 13 : 12

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
        isTodayWeatherInformationLoaded = true
    }
    
    /// Set `todayMinMaxTemperature` variable
    /// - parameter items: 단기예보 response items
    @MainActor
    func setTodayMinMaxTemperature(_ items: [VeryShortOrShortTermForecast<ShortTermForecastCategory>]) {
        let todayDate = Date().toString(format: "yyyyMMdd")
        
        let filteredItems = items.filter( {$0.category == .TMP && $0.fcstDate == todayDate} )
        var filteredTemps = filteredItems.map({ $0.fcstValue.toInt })
        filteredTemps.append(currentTemperature.toInt)
        
        let min = filteredTemps.min() ?? 0
        let max = filteredTemps.max() ?? 0
        
        todayMinMaxTemperature = (min.toString, max.toString)
        isMinMaxTempLoaded = true
    }
    
    /**
     Set 초 단기예보 Items ->`currentWeatherAnimationImg`(현재 날씨 animation lottie)
     
     - parameter items: [초단기예보 Model]
     */
    @MainActor
    func setCurrentWeatherImgAndAnimationImg(items: [VeryShortOrShortTermForecast<VeryShortTermForecastCategory>]) {
        let firstPTYItem = items[6] // 강수 형태 first
        let firstSKYItem = items[18] // 하늘 상태 first
        let sunTime: SunTime = .init(
            currentHHmm: firstPTYItem.fcstTime,
            sunriseHHmm: sunriseAndSunsetHHmm.0,
            sunsetHHmm: sunriseAndSunsetHHmm.1
        )
        
        currentWeatherAnimationImg = commonForecastUtil.convertPrecipitationSkyStateOrSkyState(
            ptyValue: firstPTYItem.fcstValue,
            skyValue: firstSKYItem.fcstValue
        ).lottie(isDayMode: sunTime.isDayMode)
        
        currentWeatherImage = commonForecastUtil.convertPrecipitationSkyStateOrSkyState(
            ptyValue: firstPTYItem.fcstValue,
            skyValue: firstSKYItem.fcstValue
        ).image(isDayMode: sunTime.isDayMode)
        
        isCurrentWeatherAnimationSetCompleted = true
    }
    
    /// Set 미세먼지, 초미세먼지
    /// - parameter item: 미세먼지 요청 response
    @MainActor
    func setCurrentFineDustAndUltraFineDustTuple(_ item: RealTimeFindDustForecast) {
        currentFineDustTuple = fineDustLookUpUtil.remakeFindDustValue(value: item.pm10Value)
        currentUltraFineDustTuple = fineDustLookUpUtil.remakeUltraFindDustValue(value: item.pm25Value)
        isFineDustLoaded = true
    }
    
    /// Set 세부주소
    /// - parameter items: 카카오 주소 요청 response
    @MainActor
    func setSubLocalityByKakaoAddress(_ items: [KakaoAddress.AddressBase]) {
        guard items.count > 0 else { return }
        subLocalityByKakaoAddress = items[0].address.subLocality
        isKakaoAddressLoaded = true
    }
    
    /// Set 일출, 일몰 시간
    /// - parameter item: 일출 일몰 요청 response
    func setSunriseAndSunsetHHmm(sunrise: String, sunset: String) {
        sunriseAndSunsetHHmm = (sunrise, sunset)
        isSunriseSunsetLoaded = true
    }
    
    /// Set XY좌표(미세먼지 측정소 이름 get 요청에 필요)
    /// - parameter items: 측정소 xy 좌표 요청 response
    /// - parameter locality: 측정소 xy좌표 요청 response에서 필터하기 위한것
    func setDustStationRequestParamXY(items: [DustForecastStationXY]?, locality: String) {
        guard let items = items else { return }
        guard let item = items.first( where: { $0.sidoName.contains(locality) } ) else { return }
        DustStationRequestParam.tmXAndtmY = (item.tmX, item.tmY)
    }
    
    /// Set 미세먼지 측정소 이름  (미세먼지 아이템 get 요청에 필요)
    /// - parameter items: 측정소 측정소 이름 요청 response
    func setDustStationRequestParamStationName(_ items: [DustForecastStation]?) {
        guard let items = items, let item = items.first else { return }
        DustStationRequestParam.stationName = item.stationName
    }
}

// MARK: - View On Appear, Task Actions..

extension CurrentWeatherVM {
    
    func todayViewControllerLocationManagerUpdatedAction(
        xy: Gps2XY.LatXLngY,
        longLati: (String, String),
        locality: String
    ) {
        
        // 런치 스크린때문에 0.5초 후에 타이머 시작
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.timerStart()
        }
        
        initializeTask()
        calculateAndSetSunriseSunset(longLati: longLati)
        
        currentTask = Task(priority: .high) {
                        
            Task(priority: .high) {
                await getCurrentItems(xy: xy)
                await getTodayItems(xy: xy)
                await getTodayMinMaxItems(xy: xy)
            }
            
            Task(priority: .low) {
                await getKaKaoAddressBy(longitude: longLati.0, latitude: longLati.1, isCurrentLocationRequested: true)
                await getXYOfDustStation(
                    subLocality: subLocalityByKakaoAddress,
                    locality: locality
                )
                await getDustStationInfo(tmXAndtmY: DustStationRequestParam.tmXAndtmY, isCurrentLocationRequested: true)
                await getRealTimeDustItems()
            }
        }
    }
}

// MARK: - On tap gestures..

extension CurrentWeatherVM {
    
    func refreshButtonOnTapGesture(locationInf: LocationInformation) {
        initLoadCompletedVariables()
        performRefresh(locationInf: locationInf)
    }
    
    func additionalAddressFinalLocationOnTapGesture(allLocality: AllLocality, isNewAdd: Bool) {
            
            LocationProvider.getLatitudeAndLongitude(address: allLocality.fullAddress) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                    
                case .success(let success):
                    let latitude: Double = success.0
                    let longitude: Double = success.1
                    let xy: Gps2XY.LatXLngY = self.commonForecastUtil.convertGPS2XY(mode: .toXY, lat_X: latitude, lng_Y: longitude)
                    
                    additionalLocationProgress = .loading
                    initLoadCompletedVariables()
                    
                    timerStart()
                    initializeTask()
                    calculateAndSetSunriseSunset(longLati: (String(longitude), String(latitude)))
                    
                    currentTask = Task(priority: .high) {
                        
                        Task(priority: .high) {
                            await self.getCurrentItems(xy: xy)
                            await self.getTodayItems(xy: xy)
                            await self.getTodayMinMaxItems(xy: xy)
                        }
                        
                        Task(priority: .low) {
                            await self.getKaKaoAddressBy(longitude: String(longitude), latitude: String(latitude), isCurrentLocationRequested: false)
                            await self.getXYOfDustStation(
                                subLocality: allLocality.subLocality,
                                locality: allLocality.locality
                            )
                            await self.getDustStationInfo(tmXAndtmY: DustStationRequestParam.tmXAndtmY, isCurrentLocationRequested: false)
                            await self.getRealTimeDustItems()
                        }
                        
                        await self.currentLocationEODelegate?.setCoordinateAndAllLocality(
                            xy: xy,
                            latitude: latitude,
                            longitude: longitude,
                            allLocality: allLocality
                        )
                        
                        DispatchQueue.main.async {
                            self.additionalLocationProgress = .completed
                            self.openAdditionalLocationView = false
                        }
                        
                        if isNewAdd {
                            UserDefaults.standard.appendAdditionalAllLocality(allLocality)
                        }
                    }
                    
                case .failure(_):
                    DispatchQueue.main.async {
                        self.additionalLocationProgress = .notFound
                    }
                }
            }
        }
    
    func retryAndShowNoticeFloater(locationInf: LocationInformation) {
        noticeFloaterMessage = """
        재시도 합니다.
        기상청 서버 네트워크에 따라 속도가 느려질 수 있습니다 :)
        """
        showNoticeFloater = false
        showNoticeFloater = true

        performRefresh(locationInf: locationInf)
    }
}

// MARK: - ETC funcs..

extension CurrentWeatherVM {
    
    func initLoadCompletedVariables() {
        isCurrentWeatherInformationLoaded = false
        isCurrentWeatherAnimationSetCompleted = false
        isFineDustLoaded = false
        isKakaoAddressLoaded = false
        isMinMaxTempLoaded = false
        isSunriseSunsetLoaded = false
        isTodayWeatherInformationLoaded = false
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
            guard let currentLocationEODelegate = currentLocationEODelegate else { return }
            retryAndShowNoticeFloater(locationInf: currentLocationEODelegate.locationInf)
        }
    }
    
    func calculateAndSetSunriseSunset(longLati: (String, String)) {
        let currentDate: Date = Date()
        let sunrise = currentDate.sunrise(.init(latitude: longLati.1.toDouble, longitude: longLati.0.toDouble))
        let sunset = currentDate.sunset(.init(latitude: longLati.1.toDouble, longitude: longLati.0.toDouble))
        
        if let sunrise = sunrise, let sunset = sunset {
            let sunriseHHmm = sunrise.toString(format: "HHmm", timeZone: TimeZone(identifier: "UTC"))
            let sunsetHHmm = sunset.toString(format: "HHmm", timeZone: TimeZone(identifier: "UTC"))
            
            contentEODelegate?.setIsDayMode(sunriseHHmm: sunriseHHmm, sunsetHHmm: sunsetHHmm)
            setSunriseAndSunsetHHmm(sunrise: sunriseHHmm, sunset: sunsetHHmm)
            print("일출: \(sunriseHHmm), 일몰: \(sunsetHHmm)")
        }
    }
    
    func performRefresh(locationInf: LocationInformation) {
        let convertedXY: Gps2XY.LatXLngY = .init(lat: 0, lng: 0, x: locationInf.xy.0.toInt, y: locationInf.xy.1.toInt)
        
        timerStart()
        initializeTask()
        calculateAndSetSunriseSunset(longLati: (locationInf.longitude, locationInf.latitude))

        currentTask = Task(priority: .high) {
            
            Task(priority: .high) {
                await getCurrentItems(xy: convertedXY)
                await getTodayItems(xy: convertedXY)
                await getTodayMinMaxItems(xy: convertedXY)
            }
            
            Task(priority: .low) {
                await getKaKaoAddressBy(longitude: locationInf.longitude, latitude: locationInf.latitude, isCurrentLocationRequested: false)
                await getXYOfDustStation(
                    subLocality: locationInf.subLocality,
                    locality: locationInf.locality
                )
                await getDustStationInfo(tmXAndtmY: DustStationRequestParam.tmXAndtmY, isCurrentLocationRequested: false)
                await getRealTimeDustItems()
            }
        }
    }
}

