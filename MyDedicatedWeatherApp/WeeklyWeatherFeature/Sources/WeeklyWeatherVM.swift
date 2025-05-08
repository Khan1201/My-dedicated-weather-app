//
//  WeeklyWeatherVM.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/24.
//

import Foundation
import Combine
import Domain
import Core

final class WeeklyWeatherVM: ObservableObject {
    @Published private(set) var weeklyWeatherInformations: [Weather.WeeklyInformation] = []
    @Published private(set) var weeklyChartInformation: Weather.WeeklyChartInformation = .init(minTemps: [], maxTemps: [], xList: [], yList: [], imageAndRainPercents: [])
    
    @Published private(set) var isShortTermForecastLoaded: Bool = false
    @Published private(set) var isMidtermForecastSkyStateLoaded: Bool = false
    @Published private(set) var isMidtermForecastTempLoaded: Bool = false
    @Published private(set) var isAllLoaded: Bool = false
    
    @Published var showNoticeFloater: Bool = false
    @Published private(set) var noticeFloaterMessage: String = ""
    private let waitNoticeFloaterMessage: String = """
    조금만 기다려주세요.
    기상청 서버 네트워크에 따라 속도가 느려질 수 있습니다 :)
    """
    private let retryNoticeFloaterMessage: String = """
    조금만 기다려주세요.
    기상청 서버 네트워크에 따라 속도가 느려질 수 있습니다 :)
    """
    private let waitNoticeFloaterTriggerTime: Int = 3
    private let retryTriggerTime: Int = 8

    private var tommorowToThreeDaysLaterInformations: [Weather.WeeklyInformation] = []
    private var minMaxTemperaturesByThreeToTenDay: [(String, String)] = []
    private var weatherImageAndRainfallPercentsByThreeToTenDay: [(String, String)] = []
    
    private let shortForecastUtil: ShortForecastUtil
    private let commonForecastUtil: CommonForecastUtil
    private let midForecastUtil: MidForecastUtil
    
    private let shortForecastService: ShortForecastService
    private let midtermForecastService: MidtermForecastService
    
    public var currentLocationEODelegate: CurrentLocationEODelegate?
        
    private var timer: Timer?
    private var timerNum: Int = 0
    private var currentTask: Task<(), Never>?
    private var bag: Set<AnyCancellable> = []
    
    deinit {
        timer = nil
        currentTask = nil
    }
    
    init(
        shortForecastUtil: ShortForecastUtil,
        commonForecastUtil: CommonForecastUtil,
        midForecastUtil: MidForecastUtil,
        shortForecastService: ShortForecastService,
        midtermForecastService: MidtermForecastService
    ) {
        self.shortForecastUtil = shortForecastUtil
        self.commonForecastUtil = commonForecastUtil
        self.midForecastUtil = midForecastUtil
        self.shortForecastService = shortForecastService
        self.midtermForecastService = midtermForecastService
        initWeeklyWeatherInformation()
        initWeeklyChartInformation()
        sinkIsAllLoaded()
    }
}

// MARK: - View Communication Funcs
extension WeeklyWeatherVM {
    func getWeeklyItems(locationInf: LocationInformation) {
        if !isAllLoaded {
            Task(priority: .high) {
                await getTodayToThreeDaysLaterItems(xy: (locationInf.x, locationInf.y))
                await getFourToTenDaysLaterTempItems(fullAddress: locationInf.fullAddress)
                await getFourToTenDaysLaterSkyStateItems(fullAddress: locationInf.fullAddress)
            }
        }
    }
    
    func refreshButtonOnTapGesture(locationInf: LocationInformation) {
        initializeTaskAndTimer()
        initializeStates()
        
        timerStart()
        currentTask = Task(priority: .high) {
            getWeeklyItems(locationInf: locationInf)
        }
    }
    
    func retryAndShowNoticeFloater(locationInf: LocationInformation) {
        noticeFloaterMessage = retryNoticeFloaterMessage
        showNoticeFloater = false
        showNoticeFloater = true
        getWeeklyItems(locationInf: locationInf)
    }
    
    func viewOnAppearAction(locationInf: LocationInformation) {
        if !isAllLoaded {
            initializeTask()
            
            timerStart()
            currentTask = Task(priority: .high) {
                getWeeklyItems(locationInf: locationInf)
            }
        }
    }
}

// MARK: - Get Funcs
extension WeeklyWeatherVM {
    /// 단기예보  온도, 하늘 상태, 강수 확률 Items
    private func getTodayToThreeDaysLaterItems(xy: (String, String)) async {
        let result = await shortForecastService.getTodayItems(
            xy: .init(lat: 0, lng: 0, x: xy.0.toInt, y: xy.1.toInt),
            reqRow: "1000"
        )
        
        switch result {
        case .success(let items):
            DispatchQueue.main.async {
                self.setWeeklyWeatherInformationsAndWeeklyChartInformation(one2threeDay: items)
                self.isShortTermForecastLoaded = true
            }
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
    
    /// 중기예보 온도 Items
    private func getFourToTenDaysLaterTempItems(fullAddress: String) async {
        let result = await midtermForecastService.getTempItems(
            fullAddress: fullAddress
        )
        
        switch result {
        case .success(let items):
            DispatchQueue.main.async {
                if let item = items.first {
                    self.setWeeklyWeatherInformationsMinMaxTemp(four2tenDay: item)
                    self.setWeeklyChartInformationMinMaxTemp(four2tenDay: item)
                    self.isMidtermForecastTempLoaded = true
                }
                
            }
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
    
    /// 중기예보 하늘 상태 및 강수 확률 Items
    private func getFourToTenDaysLaterSkyStateItems(fullAddress: String) async {
        let result = await midtermForecastService.getSkyStateItems(
            fullAddress: fullAddress
        )
        
        switch result {
        case .success(let items):
            DispatchQueue.main.async {
                if let item = items.first {
                    self.setWeeklyWeatherInformationsImageAndRainPercent(four2tenDay: item)
                    self.setWeeklyChartInformationImageAndRainPercent(four2tenDay: item)
                    self.isMidtermForecastSkyStateLoaded = true
                }
            }
        case .failure(let error):
            CustomLogger.error("\(error)")
        }
    }
}

// MARK: - Set Funcs
extension WeeklyWeatherVM {
    /// 최저 및 최고 온도, 하늘정보 image, 강수확률 데이터 Set
    private func setWeeklyWeatherInformationsAndWeeklyChartInformation(one2threeDay items: [VeryShortOrShortTermForecast<ShortTermForecastCategory>]) {
        let tommorrowDate: String = Date().toString(byAdding: 1, format: "yyyyMMdd")
        let twoDaysLaterDate: String = Date().toString(byAdding: 2, format: "yyyyMMdd")
        let threeDaysLaterDate: String = Date().toString(byAdding: 3, format: "yyyyMMdd")
        let sunTime: SunTime = .init(
            currentHHmm: "1200",
            sunriseHHmm: "0600",
            sunsetHHmm: "2000"
        )
        
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
        
        let threeDaysLaterTempFilteredItems = items.filter { item in
            item.category == .TMP && item.fcstDate == threeDaysLaterDate
        }
        
        let skyStateFilteredItems = items.filter { item in
            item.category == .SKY && (item.fcstDate == tommorrowDate || item.fcstDate == twoDaysLaterDate || item.fcstDate == threeDaysLaterDate) && item.fcstTime == "1200"
        }
        
        let percentFilteredItems = items.filter { item in
            item.category == .POP && (item.fcstDate == tommorrowDate || item.fcstDate == twoDaysLaterDate || item.fcstDate == threeDaysLaterDate) && item.fcstTime == "1200"
        }
                        
        for i in 0..<skyStateFilteredItems.count {
            precipitationPercentes.append(percentFilteredItems[i].fcstValue)
            skyStateImageStrings.append(
                self.commonForecastUtil.convertSkyState(rawValue: skyStateFilteredItems[i].fcstValue).image(isDayMode: sunTime.isDayMode)
            )
        }
        
        let tommorowMinMaxTemp: (String, String) = minMaxItem(by: tommorowTempFilteredItems)
        let twoDaysLaterMinMaxTemp: (String, String) = minMaxItem(by: twoDaysLaterTempFilteredItems)
        let threeDaysLaterMinMaxTemp: (String, String) = minMaxItem(by: threeDaysLaterTempFilteredItems)
        
        minMaxTemperatures.append(tommorowMinMaxTemp)
        minMaxTemperatures.append(twoDaysLaterMinMaxTemp)
        minMaxTemperatures.append(threeDaysLaterMinMaxTemp)

        guard skyStateImageStrings.count >= 3 && precipitationPercentes.count >= 3 else {
            CustomLogger.error("단기 예보 데이터 Response의 +0 ~ +2일 데이터 filter가 제대로 되지 않았습니다.")
            return
        }
        guard weeklyWeatherInformations.count >= 3 else { return }
        guard weeklyChartInformation.maxTemps.count >= 3 && weeklyChartInformation.minTemps.count >= 3 && weeklyChartInformation.imageAndRainPercents.count >= 3 && weeklyChartInformation.yList.count >= 3 &&
            weeklyChartInformation.xList.count >= 3 else { return }

        for i in 0..<3 {
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
        
        func minMaxItem(by filteredItems: [VeryShortOrShortTermForecast<ShortTermForecastCategory>]) -> (String, String) {
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
    }
    
    /// 아이템 리스트의 최저 및 최고 온도 Set
    private func setWeeklyWeatherInformationsMinMaxTemp(four2tenDay item: MidTermForecastTemperature) {
        guard weeklyWeatherInformations.count >= 10 else { return }
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
    
    /// 차트의 최저 및 최고 온도 Set
    private func setWeeklyChartInformationMinMaxTemp(four2tenDay item: MidTermForecastTemperature) {
        guard weeklyChartInformation.maxTemps.count >= 7 && weeklyChartInformation.minTemps.count >= 7 else { return }
        weeklyChartInformation.minTemps[3] = CGFloat(item.taMin4)
        weeklyChartInformation.maxTemps[3] = CGFloat(item.taMax4)
        
        weeklyChartInformation.minTemps[4] = CGFloat(item.taMin5)
        weeklyChartInformation.maxTemps[4] = CGFloat(item.taMax5)
        
        weeklyChartInformation.minTemps[5] = CGFloat(item.taMin6)
        weeklyChartInformation.maxTemps[5] = CGFloat(item.taMax6)
        
        weeklyChartInformation.minTemps[6] = CGFloat(item.taMin7)
        weeklyChartInformation.maxTemps[6] = CGFloat(item.taMax7)
    }
    
    /// 아이템 리스트의 하늘정보 image, 강수확률 데이터 Set
    private func setWeeklyWeatherInformationsImageAndRainPercent(four2tenDay item: MidTermForecastSkyState) {
        guard weeklyWeatherInformations.count >= 10 else { return }
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
        
        func weatherImage(wf: String) -> String {
            let wfToImageString = midForecastUtil.convertSkyState(rawValue: wf)
            return wfToImageString.image(isDayMode: false)
        }
    }
    
    /// 차트의 하늘정보 image, 강수확률 데이터 Set
    private func setWeeklyChartInformationImageAndRainPercent(four2tenDay item: MidTermForecastSkyState) {
        guard weeklyChartInformation.imageAndRainPercents.count >= 7 else { return }
        weeklyChartInformation.imageAndRainPercents[3] = weatherImageAndRainfallPercent(wf: item.wf4Am, rnSt: item.rnSt4Am)
        weeklyChartInformation.imageAndRainPercents[4] = weatherImageAndRainfallPercent(wf: item.wf5Am, rnSt: item.rnSt5Am)
        weeklyChartInformation.imageAndRainPercents[5] = weatherImageAndRainfallPercent(wf: item.wf6Am, rnSt: item.rnSt6Am)
        weeklyChartInformation.imageAndRainPercents[6] = weatherImageAndRainfallPercent(wf: item.wf7Am, rnSt: item.rnSt7Am)
        
        func weatherImageAndRainfallPercent(wf: String, rnSt: Int) -> (String, String) {
            let wfToImageString = midForecastUtil.convertSkyState(rawValue: wf).image(isDayMode: false)
            return (wfToImageString, rnSt.toString)
        }
    }
    
    /// 차트 yList는 전체(+1 ~. +7) maxTemp가 필요하므로 전체 로드 된 후에 get
    private func setWeeklyChartInformationYList() {
        guard isAllLoaded else { return }
        let maxTemps = weeklyChartInformation.maxTemps.max()
        weeklyChartInformation.yList = temperatureChartYList(maxTemp: Int(maxTemps ?? 0))
        
        func temperatureChartYList(maxTemp: Int) -> [Int] {
            switch maxTemp {
            case 31...35:
                return fiveUnitRange(maxOfRange: 35)
            case 26...30:
                return fiveUnitRange(maxOfRange: 30)
            case 21...25:
                return fiveUnitRange(maxOfRange: 25)
            case 16...20:
                return fiveUnitRange(maxOfRange: 20)
            case 11...15:
                return fiveUnitRange(maxOfRange: 15)
            case 6...10:
                return fiveUnitRange(maxOfRange: 10)
            case 1...5:
                return fiveUnitRange(maxOfRange: 5)
            case -4...0:
                return fiveUnitRange(maxOfRange: 0)
            case -9 ... -5:
                return fiveUnitRange(maxOfRange: -5)
            case -14 ... -10:
                return fiveUnitRange(maxOfRange: -10)
            case -19 ... -15:
                return fiveUnitRange(maxOfRange: -15)
            default:
                CustomLogger.error("yList 범위를 지정할 수 없습니다.")
                return []
            }
            
            func fiveUnitRange(maxOfRange: Int) -> [Int] {
                var max: Int = maxOfRange
                var yList: [Int] = []
                
                for i in 0..<5 {
                    if i == 0 {
                        yList.append(max)
                        
                    } else {
                        max -= 5
                        yList.append(max)
                    }
                }
                
                return yList
            }
        }
    }
}

// MARK: - ETC Funcs
extension WeeklyWeatherVM {
    private func initWeeklyWeatherInformation() {
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
    
    private func initWeeklyChartInformation() {
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
    
    private func initializeStates() {
        initializeApiLoadedStates()
        isAllLoaded = false
    }
    
    private func initializeApiLoadedStates() {
        isShortTermForecastLoaded = false
        isMidtermForecastTempLoaded = false
        isMidtermForecastSkyStateLoaded = false
    }
    
    private func initializeTaskAndTimer() {
        initializeTask()
        initializeTimer()
    }
    
    private func initializeTask() {
        currentTask?.cancel()
        currentTask = nil
    }
    
    private func initializeTimer() {
        timer?.invalidate()
        timer = nil
        timerNum = 0
    }
    
    private func timerStart() {
        initializeTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(askRetryIf7SecondsAfterNotLoaded(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc private func askRetryIf7SecondsAfterNotLoaded(timer: Timer) {
        guard self.timer != nil else { return }
        self.timerNum += 1
        
        if timerNum == waitNoticeFloaterTriggerTime {
            noticeFloaterMessage = waitNoticeFloaterMessage
            showNoticeFloater = false
            showNoticeFloater = true
            
        } else if timerNum == retryTriggerTime {
            initializeTimer()
            guard let currentLocationEODelegate = currentLocationEODelegate else { return }
            retryAndShowNoticeFloater(locationInf: currentLocationEODelegate.locationInf)
        }
    }
    
    private func sinkIsAllLoaded() {
        Publishers.Zip3($isShortTermForecastLoaded, $isMidtermForecastTempLoaded, $isMidtermForecastSkyStateLoaded)
            .sink { [weak self] results in
                guard let self = self else { return }
                guard results.0 && results.1 && results.2 else { return }
                weeklyItemAllLoadedAction()
            }
            .store(in: &bag)
    }
    
    private func weeklyItemAllLoadedAction() {
        isAllLoaded = true
        setWeeklyChartInformationYList()
        initializeTaskAndTimer()
        initializeApiLoadedStates()
        CustomHapticGenerator.impact(style: .soft)
    }
}
