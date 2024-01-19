//
//  WeeklyWeatherVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/24.
//

import Foundation

final class WeeklyWeatherVM: ObservableObject {
    @Published var weeklyWeatherInformations: [Weather.WeeklyInformation] = []
    @Published var weeklyChartInformation: Weather.WeeklyChartInformation = .init(minTemps: [], maxTemps: [], xList: [], yList: [], imageAndRainPercents: [])
    @Published var errorMessage: String = ""
    
    @Published var isApiRequestProceeding: Bool = false
    @Published var isShortTermForecastLoaded: Bool = false
    @Published var isMidtermForecastSkyStateLoaded: Bool = false
    @Published var isMidtermForecastTempLoaded: Bool = false
    @Published var isWeeklyWeatherInformationsLoaded: Bool = false
    @Published var showLoadRetryButton: Bool = false
    @Published var showNoticeFloater: Bool = false
    
    var noticeMessage: String = ""

    var tommorowAndTwoDaysLaterInformations: [Weather.WeeklyInformation] = []
    var minMaxTemperaturesByThreeToTenDay: [(String, String)] = []
    var weatherImageAndRainfallPercentsByThreeToTenDay: [(String, String)] = []
    
    private let shortTermForecastUtil: ShortTermForecastUtil = ShortTermForecastUtil()
    private let commonForecastUtil: CommonForecastUtil = CommonForecastUtil()
    private let midTermForecastUtil: MidTermForecastUtil = MidTermForecastUtil()
    
    var timer: Timer?
    var timerNum: Int = 0
    var currentTask: Task<(), Never>?
    
    deinit {
        timer = nil
        currentTask = nil
    }
    
    init() {
        initWeeklyWeatherInformation()
        initWeeklyChartInformation()
    }
}

// MARK: - Request funcs..

extension WeeklyWeatherVM {
    /**
     Request 단기예보 Items
     
     - parameter xy: 공공데이터 값으로 변환된 X, Y
     */
    func requestShortForecastItems(xy: (String, String)) async {
        let reqStartTime = CFAbsoluteTimeGetCurrent()
        
        let parameters = VeryShortOrShortTermForecastReq(
            serviceKey: Env.shared.openDataApiResponseKey,
            numOfRows: "737",
            baseDate: shortTermForecastUtil.requestBaseDate(),
            baseTime: shortTermForecastUtil.requestBaseTime(),
            nx: xy.0,
            ny: xy.1
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
            
            DispatchQueue.main.async {
                if let item = result.item {
                    self.setWeeklyWeatherInformationsAndWeeklyChartInformation(one2twoDay: item)
                    self.isShortTermForecastLoaded = true
                    print("주간예보 - 단기 req 호출 소요시간: \(reqEndTime)")
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
     Request 중기예보 (3~ 10일) 최저, 최고 기온  Items
     */
    func requestMidTermForecastTempItems(fullAddress: String) async {
        let reqStartTime = CFAbsoluteTimeGetCurrent()
        
        let parameters: MidTermForecastReq = MidTermForecastReq(
            serviceKey: Env.shared.openDataApiResponseKey,
            regId: midTermForecastUtil.requestRegOrStnId(fullAddress: fullAddress, reqType: .temperature),
            stnId: nil,
            tmFc: midTermForecastUtil.requestTmFc()
        )
        
        do {
            let result = try await JsonRequest.shared.newRequest(
                url: Route.GET_WEATHER_MID_TERM_FORECAST_TEMP.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: PublicDataRes<MidTermForecastTemperatureBase>.self,
                requestName: "requestMidTermForecastTempItems()"
            )
            
            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            
            DispatchQueue.main.async {
                if let item = result.item?.first {
                    self.setWeeklyWeatherInformationsMinMaxTemp(three2tenDay: item)
                    self.setWeeklyChartInformationMinMaxTemp(three2tenDay: item)
                    self.isMidtermForecastTempLoaded = true
                    print("주간 예보 - 중기 예보(기온) req 호출 소요시간: \(reqEndTime)")
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
     Request 중기예보 (3~ 10일) 하늘 상태, 강수 확률 items
     */
    func requestMidTermForecastSkyStateItems(fullAddress: String) async {
        let reqStartTime = CFAbsoluteTimeGetCurrent()

        let parameters: MidTermForecastReq = MidTermForecastReq(
            serviceKey: Env.shared.openDataApiResponseKey,
            regId: midTermForecastUtil.requestRegOrStnId(fullAddress: fullAddress, reqType: .skystate),
            stnId: nil,
            tmFc: midTermForecastUtil.requestTmFc()
        )
        
        do {
            let result = try await JsonRequest.shared.newRequest(
                url: Route.GET_WEATHER_MID_TERM_FORECAST_SKYSTATE.val,
                method: .get,
                parameters: parameters,
                headers: nil,
                resultType: PublicDataRes<MidTermForecastSkyStateBase>.self,
                requestName: "requestMidTermForecastSkyStateItems()"
            )
            
            let reqEndTime = CFAbsoluteTimeGetCurrent() - reqStartTime
            
            DispatchQueue.main.async {
                if let item = result.item?.first {
                    self.setWeeklyWeatherInformationsImageAndRainPercent(three2tenDay: item)
                    self.setWeeklyChartInformationImageAndRainPercent(three2tenDay: item)
                    self.isMidtermForecastSkyStateLoaded = true
                    print("주간 예보 - 중기 예보(하늘상태) req 호출 소요시간: \(reqEndTime)")
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
    
    func performWeekRequests(xy: (String, String), fullAddress: String) {
        
        if !isWeeklyWeatherInformationsLoaded && !isApiRequestProceeding {
            DispatchQueue.main.async {
                self.isApiRequestProceeding = true
            }
            
            Task(priority: .userInitiated) {
                async let _ = requestShortForecastItems(xy: xy)
                async let _ = requestMidTermForecastTempItems(fullAddress: fullAddress)
                async let _ = requestMidTermForecastSkyStateItems(fullAddress: fullAddress)
            }
        }
    }
}

// MARK: - Set funcs..

extension WeeklyWeatherVM {
    
    /**
     Set `weeklyWeatherInformations`, `weeklyChartInformation` (오늘 ~ 내일까지의 최저, 최고 온도 및 하늘정보 image, 강수확률 데이터)
     - parameter items: requestShortForecastItems() 결과 데이터
     */
    func setWeeklyWeatherInformationsAndWeeklyChartInformation(one2twoDay items: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>]) {
        
        func minMaxItem(by filteredItems: [VeryShortOrShortTermForecastBase<ShortTermForecastCategory>]) -> (String, String) {
            var minMaxResult: (Int, Int) = (0, 0)
            
            for (index, item) in filteredItems.enumerated() {
                if index == 0 {
                    minMaxResult = (item.fcstValue.toInt, item.fcstValue.toInt)
                    
                } else {
                    if item.fcstValue.toInt > minMaxResult.1 {
                        minMaxResult.1 = item.fcstValue.toInt
                    } else if item.fcstValue.toInt < minMaxResult.0 {
                        minMaxResult.0 = item.fcstValue.toInt
                    }
                }
            }
            
            return (minMaxResult.0.toString, minMaxResult.1.toString)
        }
        
        let tommorrowDate: String = Date().toString(byAdding: 1, format: "yyyyMMdd")
        let twoDaysLaterDate: String = Date().toString(byAdding: 2, format: "yyyyMMdd")
        
        // 각 변수에는 오늘, 내일 데이터 포함 (count == 2)
        var precipitationPercentes: [String] = []
        var skyStateImageStrings: [String] = []
        var minMaxTemperatures: [(String, String)] = []
        
        let tommorowTempFilteredItems = items.filter { item in
            item.category == .TMP && item.fcstDate == tommorrowDate
        }
        
        let twoDaysLaterTempFilteredItems = items.filter { item in
            item.category == .TMP && item.fcstDate == twoDaysLaterDate
        }
        
        let skyStateFilteredItems = items.filter { item in
            item.category == .SKY && (item.fcstDate == tommorrowDate || item.fcstDate == twoDaysLaterDate) && item.fcstTime == "1200"
        }
        
        let percentFilteredItems = items.filter { item in
            item.category == .POP && (item.fcstDate == tommorrowDate || item.fcstDate == twoDaysLaterDate) && item.fcstTime == "1200"
        }
                        
        for i in 0..<skyStateFilteredItems.count {
            precipitationPercentes.append(percentFilteredItems[i].fcstValue)
            skyStateImageStrings.append(
                self.commonForecastUtil.remakeSkyStateValueByVeryShortTermOrShortTermForecast(
                    skyStateFilteredItems[i].fcstValue,
                    hhMMForDayOrNightImage: "1200",
                    sunrise: "0600",
                    sunset: "2000",
                    isAnimationImage: false
                ).imageString
            )
        }
        
        let tommorowMinMaxTemp: (String, String) = minMaxItem(by: tommorowTempFilteredItems)
        let twoDaysLaterMinMaxTemp: (String, String) = minMaxItem(by: twoDaysLaterTempFilteredItems)
        
        minMaxTemperatures.append(tommorowMinMaxTemp)
        minMaxTemperatures.append(twoDaysLaterMinMaxTemp)

        guard skyStateImageStrings.count >= 2 && precipitationPercentes.count >= 2 else {
            CommonUtil.shared.printError(funcTitle: "setTommorowAndTwoDaysLaterInformations()", description: """
                단기 예보 데이터 Response의 오늘 ~ 내일 데이터 filter가 제대로 되지 않았습니다.
                skyState array count == \(skyStateImageStrings.count),
                rainfallPercent array count = \(precipitationPercentes.count)
                """)
            return
        }
        guard weeklyWeatherInformations.count >= 2 else { return }
        guard weeklyChartInformation.maxTemps.count >= 2 && weeklyChartInformation.minTemps.count >= 2 && weeklyChartInformation.imageAndRainPercents.count >= 2 && weeklyChartInformation.yList.count >= 2 &&
            weeklyChartInformation.xList.count >= 2 else { return }

        for i in 0..<2 {
            weeklyWeatherInformations[i] = .init(
                weatherImage: skyStateImageStrings[i],
                rainfallPercent: precipitationPercentes[i],
                minTemperature: minMaxTemperatures[i].0,
                maxTemperature: minMaxTemperatures[i].1,
                date: tommorrowDate
            )
            
            weeklyChartInformation.minTemps[i] = CGFloat(minMaxTemperatures[i].0.toInt)
            weeklyChartInformation.maxTemps[i] = CGFloat(minMaxTemperatures[i].1.toInt)
            weeklyChartInformation.imageAndRainPercents[i] = (skyStateImageStrings[i], precipitationPercentes[i])
        }
    }
    
    /**
     Set `WeeklyWeatherInformations`(3일 ~ 10일 까지의 최소, 최고 온도 데이터)
     - parameter item: requestMidTermForecastTempItems() 결과 데이터
     */
    func setWeeklyWeatherInformationsMinMaxTemp(three2tenDay item: MidTermForecastTemperatureBase) {
        
        guard weeklyWeatherInformations.count >= 10 else { return }
        
        weeklyWeatherInformations[2].minTemperature = item.taMin3.toString
        weeklyWeatherInformations[2].maxTemperature = item.taMax3.toString
        
        weeklyWeatherInformations[3].minTemperature = item.taMin4.toString
        weeklyWeatherInformations[3].maxTemperature = item.taMax4.toString
        
        weeklyWeatherInformations[4].minTemperature = item.taMin5.toString
        weeklyWeatherInformations[4].maxTemperature = item.taMax5.toString
        
        weeklyWeatherInformations[5].minTemperature = item.taMin6.toString
        weeklyWeatherInformations[5].maxTemperature = item.taMax6.toString
        
        weeklyWeatherInformations[6].minTemperature = item.taMin7.toString
        weeklyWeatherInformations[6].maxTemperature = item.taMax7.toString
        
        weeklyWeatherInformations[7].minTemperature = item.taMin8.toString
        weeklyWeatherInformations[7].maxTemperature = item.taMax8.toString
        
        weeklyWeatherInformations[8].minTemperature = item.taMin9.toString
        weeklyWeatherInformations[8].maxTemperature = item.taMax9.toString
        
        weeklyWeatherInformations[9].minTemperature = item.taMin10.toString
        weeklyWeatherInformations[9].maxTemperature = item.taMax10.toString
    }
    
    /// +3 ~ +7 정보 set
    func setWeeklyChartInformationMinMaxTemp(three2tenDay item: MidTermForecastTemperatureBase) {
        
        guard weeklyChartInformation.maxTemps.count >= 7 && weeklyChartInformation.minTemps.count >= 7 else { return }
        
        weeklyChartInformation.minTemps[2] = CGFloat(item.taMin3)
        weeklyChartInformation.maxTemps[2] = CGFloat(item.taMax3)
        
        weeklyChartInformation.minTemps[3] = CGFloat(item.taMin4)
        weeklyChartInformation.maxTemps[3] = CGFloat(item.taMax4)
        
        weeklyChartInformation.minTemps[4] = CGFloat(item.taMin5)
        weeklyChartInformation.maxTemps[4] = CGFloat(item.taMax5)
        
        weeklyChartInformation.minTemps[5] = CGFloat(item.taMin6)
        weeklyChartInformation.maxTemps[5] = CGFloat(item.taMax6)
        
        weeklyChartInformation.minTemps[6] = CGFloat(item.taMin7)
        weeklyChartInformation.maxTemps[6] = CGFloat(item.taMax7)
    }
    
    /**
     Set `weeklyWeatherInformations`(3일 ~ 10일 까지의 하늘정보 image, 강수확률 데이터)
     - parameter item: requestMidTermForecastSkyStateItems() 결과 데이터
     */
    func setWeeklyWeatherInformationsImageAndRainPercent(three2tenDay item: MidTermForecastSkyStateBase) {
        
        func weatherImage(wf: String) -> String {
            let wfToImageString = midTermForecastUtil.remakeSkyStateValueToImageString(value: wf)
            return wfToImageString
        }
        
        guard weeklyWeatherInformations.count >= 10 else { return }
                
        weeklyWeatherInformations[2].weatherImage = weatherImage(wf: item.wf3Am)
        weeklyWeatherInformations[2].rainfallPercent = item.rnSt3Am.toString
        
        weeklyWeatherInformations[3].weatherImage = weatherImage(wf: item.wf4Am)
        weeklyWeatherInformations[3].rainfallPercent = item.rnSt4Am.toString
        
        weeklyWeatherInformations[4].weatherImage = weatherImage(wf: item.wf5Am)
        weeklyWeatherInformations[4].rainfallPercent = item.rnSt5Am.toString
        
        weeklyWeatherInformations[5].weatherImage = weatherImage(wf: item.wf6Am)
        weeklyWeatherInformations[5].rainfallPercent = item.rnSt6Am.toString
        
        weeklyWeatherInformations[6].weatherImage = weatherImage(wf: item.wf7Am)
        weeklyWeatherInformations[6].rainfallPercent = item.rnSt7Am.toString
        
        weeklyWeatherInformations[7].weatherImage = weatherImage(wf: item.wf8)
        weeklyWeatherInformations[7].rainfallPercent = item.rnSt8.toString
        
        weeklyWeatherInformations[8].weatherImage = weatherImage(wf: item.wf9)
        weeklyWeatherInformations[8].rainfallPercent = item.rnSt9.toString
        
        weeklyWeatherInformations[9].weatherImage = weatherImage(wf: item.wf10)
        weeklyWeatherInformations[9].rainfallPercent = item.rnSt10.toString
    }
    
    /// +3 ~ +10 set
    func setWeeklyChartInformationImageAndRainPercent(three2tenDay item: MidTermForecastSkyStateBase) {
        
        func weatherImageAndRainfallPercent(wf: String, rnSt: Int) -> (String, String) {
            let wfToImageString = midTermForecastUtil.remakeSkyStateValueToImageString(value: wf)
            return (wfToImageString, rnSt.toString)
        }
        
        guard weeklyChartInformation.imageAndRainPercents.count >= 7 else { return }
        
        weeklyChartInformation.imageAndRainPercents[2] = weatherImageAndRainfallPercent(wf: item.wf3Am, rnSt: item.rnSt3Am)
        weeklyChartInformation.imageAndRainPercents[3] = weatherImageAndRainfallPercent(wf: item.wf4Am, rnSt: item.rnSt4Am)
        weeklyChartInformation.imageAndRainPercents[4] = weatherImageAndRainfallPercent(wf: item.wf5Am, rnSt: item.rnSt5Am)
        weeklyChartInformation.imageAndRainPercents[5] = weatherImageAndRainfallPercent(wf: item.wf6Am, rnSt: item.rnSt6Am)
        weeklyChartInformation.imageAndRainPercents[6] = weatherImageAndRainfallPercent(wf: item.wf7Am, rnSt: item.rnSt7Am)
    }
    
    /// 차트 yList는 전체(+1 ~. +7) maxTemp가 필요하므로 전체 로드 된 후에 get
    func setWeeklyChartInformationYList() {
        
        guard isShortTermForecastLoaded && isMidtermForecastSkyStateLoaded && isMidtermForecastTempLoaded else { return }
        // completed 체크
        
        let maxTemps = weeklyChartInformation.maxTemps.max()
        weeklyChartInformation.yList = midTermForecastUtil.temperatureChartYList(maxTemp: Int(maxTemps ?? 0))
    }
}

// MARK: - On tap gestures..

extension WeeklyWeatherVM {
    
    func refreshButtonOnTapGesture(xy: (String, String), fullAddress: String) {
        initializeTaskAndTimer()
        initializeStates()
        
        currentTask = Task(priority: .userInitiated) {
            performWeekRequests(xy: xy, fullAddress: fullAddress)
        }
    }
    
    func retryButtonOnTapGesture(xy: (String, String), fullAddress: String) {
        showLoadRetryButton = false
        noticeMessage = """
                재시도 합니다.
                기상청 서버 네트워크에 따라 속도가 느려질 수 있습니다 :)
                """
        
        showNoticeFloater = false
        showNoticeFloater = true
        
        refreshButtonOnTapGesture(xy: xy, fullAddress: fullAddress)
    }
}

// MARK: - ETC funcs..

extension WeeklyWeatherVM {
    
    func initWeeklyWeatherInformation() {
        let currentDate: Date = Date()
        
        for i in 0..<10 {
            weeklyWeatherInformations.append(
                .init(weatherImage: "",
                      rainfallPercent: "",
                      minTemperature: "",
                      maxTemperature: "",
                      date: currentDate.toString(byAdding: 1 + i, format: "yyyyMMdd") // +1 ~ +10일까지 보여주기 위해
                     )
            )
        }
    }
    
    func initWeeklyChartInformation() {
        let currentDate: Date = Date()
        
        for i in 0..<7 {
            weeklyChartInformation.minTemps.append(0)
            weeklyChartInformation.maxTemps.append(0)
            weeklyChartInformation.xList.append(
                (
                    currentDate.toString(byAdding: 1 + i, format: "E"),
                    currentDate.toString(byAdding: 1 + i, format: "MM/dd")
                )
            )
            weeklyChartInformation.yList.append(0)
            weeklyChartInformation.imageAndRainPercents.append(("",""))
        }
    }
    
    func initializeStates() {
        initializeLoadedStates()
        isWeeklyWeatherInformationsLoaded = false
    }
    
    func initializeLoadedStates() {
        isShortTermForecastLoaded = false
        isMidtermForecastTempLoaded = false
        isMidtermForecastSkyStateLoaded = false
    }
    
    func initializeTaskAndTimer() {
        showLoadRetryButton = false
        
        initializeTask()
        initializeTimer()
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
    
    func timerStart() {
        initializeTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(askRetryIf7SecondsAfterNotLoaded(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc func askRetryIf7SecondsAfterNotLoaded(timer: Timer) {
        
        guard self.timer != nil else { return }
        self.timerNum += 1
        
        if timerNum == 3 {
            noticeMessage = """
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
}

// MARK: - On change funcs..

extension WeeklyWeatherVM {
    
    ///  ContentVM의 isRefreshed state 변수가 바뀔때
    func isRefreshedOnChangeAction(_ value: Bool) {
        
        if value {
            initializeStates()
        }
    }
    
    /// loaded 변수 (단기, 중기온도, 중기날씨) 전체 완료 시
    func loadedVariablesOnChangeAction(_ newValue: Bool) {
        
        if newValue {
            setWeeklyChartInformationYList()
            initializeTaskAndTimer()
            isWeeklyWeatherInformationsLoaded = true
            isApiRequestProceeding = false
            initializeLoadedStates()
        }
    }
}

// MARK: - Life cycle funcs..

extension WeeklyWeatherVM {
    
    func weeklyWeatherViewTaskAction(xy: (String, String), fullAddress: String) {
        
        if !isWeeklyWeatherInformationsLoaded {
            timerStart()
            initializeTask()
            
            currentTask = Task(priority: .userInitiated) {
                performWeekRequests(xy: xy, fullAddress: fullAddress)
            }
        }
    }
}
