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
    @Published private(set) var sunriseAndSunsetHHmm: (String, String) = ("", "")
    @Published private(set) var currentWeatherInformation: Weather.CurrentInformation?
    @Published private(set) var currentDust: Weather.CurrentDust?
    @Published private(set) var todayMinMaxTemperature: (String, String) = ("", "")
    @Published private(set) var todayWeatherInformations: [Weather.TodayInformation] = []
    @Published private(set) var subLocalityByKakaoAddress: String = ""
    @Published private(set) var dustStationXY: (String, String) = ("", "")
    @Published private(set) var dustStationName: String = ""
    
    /// Load Completed Variables..(7 values)
    @Published private(set) var isCurrentWeatherInformationLoaded: Bool = false
    @Published private(set) var isFineDustLoaded: Bool = false
    @Published private(set) var isKakaoAddressLoaded: Bool = false
    @Published private(set) var isMinMaxTempLoaded: Bool = false
    @Published private(set) var isSunriseSunsetLoaded: Bool = false
    @Published private(set) var isTodayWeatherInformationLoaded: Bool = false
    @Published private(set) var isAllLoaded: Bool = false
    
    @Published var isNoticeFloaterViewPresented: Bool = false
    @Published var isAdditionalLocationViewPresented: Bool = false

    var noticeFloaterMessage: String = ""
    var timer: Timer?
    var timerNum: Int = 0
    var currentTask: Task<(), Never>?
    
    private var bag: Set<AnyCancellable> = .init()
    
    weak var currentLocationEODelegate: CurrentLocationEODelegate?
    weak var contentEODelegate: ContentEODelegate?
    
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
        userDefaultsService: UserDefaultsService
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
        sinkIsAllLoaded()
    }
}

// MARK: - Sink Funcs..

extension CurrentWeatherVM {
    private func sinkIsAllLoaded() {
        let zipFirst = Publishers.Zip3($isCurrentWeatherInformationLoaded, $isFineDustLoaded, $isKakaoAddressLoaded)
        let zipSecond = Publishers.Zip3($isMinMaxTempLoaded, $isSunriseSunsetLoaded, $isTodayWeatherInformationLoaded)
        
        Publishers.Zip(zipFirst, zipSecond)
            .sink { [weak self] results in
                guard let self = self else { return }
                let isZipFirstAllLoaded: Bool = results.0.0 && results.0.1 && results.0.2
                let isZipSecondAllLoaded: Bool = results.1.0 && results.1.1 && results.1.2
                guard isZipFirstAllLoaded && isZipSecondAllLoaded else { return }
                isAllLoaded = true
                CustomHapticGenerator.impact(style: .soft)
                initializeTaskAndTimer()
            }
            .store(in: &bag)
    }
}

// MARK: - Fetch..

extension CurrentWeatherVM {
    func fetchCurrentWeatherInformations(xy: Gps2XY.LatXLngY) async {
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let result = await veryShortForecastService.getCurrentItems(xy: xy)
        
        switch result {
        case .success(let items):
            await self.setCurrentWeatherInformation(items: items)
            
            let durationTime = CFAbsoluteTimeGetCurrent() - startTime
            print("초단기 req 소요시간: \(durationTime)")
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
    
    func fetchTodayWeatherInformations(xy: Gps2XY.LatXLngY) async {
        let reqStartTime = CFAbsoluteTimeGetCurrent()
        
        let result = await shortForecastService.getTodayItems(xy: xy, reqRow: "300")
        
        switch result {
        case .success(let items):
            await setTodayWeatherInformations(items: items)
            
            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            print("단기 req 호출 소요시간: \(reqEndTime)")
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }

    func fetchTodayMinMaxTemperature(xy: Gps2XY.LatXLngY) async {
        let reqStartTime = CFAbsoluteTimeGetCurrent()
        
        let result = await shortForecastService.getTodayMinMaxItems(xy: xy)
        
        switch result {
        case .success(let items):
            await setTodayMinMaxTemperature(items)
            
            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            print("단기 req(최소, 최대 온도 값) 호출 소요시간: \(reqEndTime)")
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
    
    func fetchCurrentDust() async {
        let reqStartTime = CFAbsoluteTimeGetCurrent()
        
        let result = await dustForecastService.getRealTimeDustItems(stationName: dustStationName)
        
        switch result {
        case .success(let items):
            guard let item = items.first else { return }
            await setCurrentDust(item)
            
            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            print("미세먼지 item 호출 소요시간: \(reqEndTime)")
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }

    func fetchDustStationXY(subLocality: String, locality: String) async {
        let reqStartTime = CFAbsoluteTimeGetCurrent()
        
        let result = await dustForecastService.getXYOfStation(subLocality: subLocality)
        
        switch result {
        case .success(let items):
            setDustStationXY(items: items, locality: locality)
            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            print("미세먼지 측정소 xy좌표 get 호출 소요시간: \(reqEndTime)")
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
    
    func fetchDustStationName(tmXAndtmY: (String, String)) async {
        let reqStartTime = CFAbsoluteTimeGetCurrent()
        
        let result = await dustForecastService.getStationInfo(tmXAndtmY: tmXAndtmY)
        
        switch result {
        case .success(let items):
            setDustStationName(items)
            guard let firstItem = items.first else { return }
            userDefaultsService.setCurrentDustStationName(firstItem.stationName)
            
            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            print("미세먼지 측정소 get 호출 소요시간: \(reqEndTime)")
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
    
    func fetchSubLocalityByKakaoAddress(longitude: String, latitude: String, isCurrentLocationRequested: Bool) async {
        let startTime = CFAbsoluteTimeGetCurrent()
        
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
            
            let durationTime = CFAbsoluteTimeGetCurrent() - startTime
            print("카카오 주소 req 소요시간: \(durationTime)")
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
    
    func fetchAdditionalLocationWeather(locationInf: LocationInformation, isNewAdd: Bool) {
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
                        self.initLoadCompletedVariables()
                        self.isAdditionalLocationViewPresented = false
                    }
                    self.fetchCurrentWeatherAllData(locationInf: locationInf)
                    await self.currentLocationEODelegate?.setCoordinateAndAllLocality(locationInf: locationInf)
                    
                    if isNewAdd {
                        self.userDefaultsService.setLocationInformation(locationInf)
                    }
                }
                
            case .failure(_):
                return
            }
        }
    }
    
    func fetchCurrentWeatherAllData(locationInf: LocationInformation) {
        let convertedXY: Gps2XY.LatXLngY = .init(lat: 0, lng: 0, x: locationInf.x.toInt, y: locationInf.y.toInt)
        
        initializeTask()
        timerStart()
        calculateAndSetSunriseSunset(longLati: (locationInf.longitude, locationInf.latitude))
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
}

// MARK: - Set Variables..

extension CurrentWeatherVM {
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
        isTodayWeatherInformationLoaded = true
    }
    
    /// Set `todayMinMaxTemperature` variable
    /// - parameter items: 단기예보 response items
    @MainActor
    func setTodayMinMaxTemperature(_ items: [VeryShortOrShortTermForecast<ShortTermForecastCategory>]) {
        let todayDate = Date().toString(format: "yyyyMMdd")
        
        let filteredItems = items.filter( {$0.category == .TMP && $0.fcstDate == todayDate} )
        var filteredTemps = filteredItems.map({ $0.fcstValue.toInt })
        filteredTemps.append(currentWeatherInformation?.temperature.toInt ?? 0)
        
        let min = filteredTemps.min() ?? 0
        let max = filteredTemps.max() ?? 0
        
        todayMinMaxTemperature = (min.toString, max.toString)
        isMinMaxTempLoaded = true
    }
    
    /// Set 미세먼지, 초미세먼지
    /// - parameter item: 미세먼지 요청 response
    @MainActor
    func setCurrentDust(_ item: RealTimeFindDustForecast) {
        let convertedFineDust: WeatherAPIValue = fineDustLookUpUtil.convertFineDust(rawValue: item.pm10Value)
        let convertedUltraFineDust: WeatherAPIValue = fineDustLookUpUtil.convertUltraFineDust(rawValue: item.pm25Value)
        currentDust = .init(
            fineDust: FineDust(description: convertedFineDust.toDescription, backgroundColor: convertedFineDust.color),
            ultraFineDust: UltraFineDust(description: convertedUltraFineDust.toDescription, backgroundColor: convertedUltraFineDust.color)
        )
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
    
    func setDustStationXY(items: [DustForecastStationXY]?, locality: String) {
        guard let items = items else { return }
        guard let item = items.first( where: { $0.sidoName.contains(locality) } ) else { return }
        dustStationXY = (item.tmX, item.tmY)
    }

    func setDustStationName(_ items: [DustForecastStation]?) {
        guard let items = items, let item = items.first else { return }
        dustStationName = item.stationName
    }
}

// MARK: - ETC funcs..

extension CurrentWeatherVM {
    func initLoadCompletedVariables() {
        isCurrentWeatherInformationLoaded = false
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
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(askRetryIfFewSecondsAfterNotLoaded(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc func askRetryIfFewSecondsAfterNotLoaded(timer: Timer) {
        guard self.timer != nil else { return }
        self.timerNum += 1
        
        if timerNum == 3 {
            noticeFloaterMessage = """
            조금만 기다려주세요.
            기상청 서버 네트워크에 따라 속도가 느려질 수 있습니다 :)
            """
            isNoticeFloaterViewPresented = false
            isNoticeFloaterViewPresented = true
            
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
        initLoadCompletedVariables()
        fetchCurrentWeatherAllData(locationInf: locationInf)
    }
    
    func retryAndShowNoticeFloater(locationInf: LocationInformation) {
        noticeFloaterMessage = """
        재시도 합니다.
        기상청 서버 네트워크에 따라 속도가 느려질 수 있습니다 :)
        """
        isNoticeFloaterViewPresented = false
        isNoticeFloaterViewPresented = true
        
        performRefresh(locationInf: locationInf)
    }
}

