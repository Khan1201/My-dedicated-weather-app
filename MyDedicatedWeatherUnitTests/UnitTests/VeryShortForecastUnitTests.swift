//
//  VeryShortForecastUnitTests.swift
//  MyDedicatedWeatherUnitTests
//
//  Created by 윤형석 on 3/20/24.
//

import XCTest
@testable import MyDedicatedWeatherApp

final class VeryShortForecastUnitTests: XCTestCase {
    var vm: CurrentWeatherVM!
    let baseDate: String = Date().toString(byAdding: -1, format: "yyyyMMdd")

    override func setUpWithError() throws {
        vm = CurrentWeatherVM()
    }

    override func tearDownWithError() throws {
        vm = nil
    }

    func test_초단기예보_목_데이터가_잘_반환되는지() async throws {
                
        // given
        let mockData = VeryShortForecastMockData.response
        let sut = VeryShortForecastServiceMock(result: mockData)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))
        
        // then
        switch result {
        case .success:
            XCTAssert(true)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_00시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "0030"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_1시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "0130"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_2시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "0230"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_3시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "0330"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_4시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "0430"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_5시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "0530"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_6시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "0630"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_7시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "0730"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_8시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "0830"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_9시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "0930"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_10시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "1030"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_11시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "1130"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_12시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "1230"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_13시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "1330"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_14시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "1430"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_15시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "1530"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_16시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "1630"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_17시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "1730"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_18시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "1830"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_19시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "1930"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_20시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "2030"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_21시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "2130"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_22시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "2230"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_23시_30분_요청이_되는지() async throws {
        // given
        let baseTime: String = "2330"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let sut = VeryShortForecastService(util: mockUtil)
        
        // when
        let result = await sut.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))

        // then
        switch result {
        case .success(let success):
            let isSuccess = success.item?.contains(where: { $0.baseTime == baseTime}) ?? false ||
            success.items?.contains(where: { $0.baseTime == baseTime}) ?? false
            XCTAssert(isSuccess)
        case .failure:
            XCTAssert(false)
        }
    }
    
    func test_초단기예보_api_호출후_currentWeatherAnimationImg_currentWeatherImage_세팅이_정상적으로_되는지_확인() async throws {
        // given
        let baseTime: String = "2330"
        let mockUtil = VeryShortForecastUtilMock(requestBaseTime: baseTime, requestBaseDate: baseDate)
        let service = VeryShortForecastService(util: mockUtil)
        vm = CurrentWeatherVM(veryShortForecastService: service)

        // when
        await vm.requestVeryShortForecastItems(xy: .init(lat: 0, lng: 0, x: 55, y: 127))
        let expectation = expectation(description: "대기")

        // then
        if vm.currentWeatherImage != "" && vm.currentWeatherAnimationImg != "" {
            expectation.fulfill()
            XCTAssert(true)
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func test_초단기예보_api_결과값이_맑음이고_일몰전일때_올바르게_변환되는지확인() async throws {
        // given
        let sut = CommonForecastUtil()
        
        let expectedImage = "weather_sunny"
        let expectedAnimation = "SunnyLottie"
        
        let resultImage = sut.veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
            ptyValue: "0",
            skyValue: "1",
            hhMMForDayOrNightImage: "1300",
            sunrise: "0700",
            sunset: "1800",
            isAnimationImage: false
        ).imageString
        
        let resultAnimation = sut.veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
            ptyValue: "0",
            skyValue: "1",
            hhMMForDayOrNightImage: "1300",
            sunrise: "0700",
            sunset: "1800",
            isAnimationImage: true
        ).imageString
        
        XCTAssertEqual(expectedImage, resultImage)
        XCTAssertEqual(expectedAnimation, resultAnimation)
    }
    
    func test_초단기예보_api_결과값이_맑음이고_일몰후일때_올바르게_변환되는지확인() async throws {
        // given
        let sut = CommonForecastUtil()
        
        let expectedImage = "weather_sunny_night"
        let expectedAnimation = "SunnyNightLottie"
        
        let resultImage = sut.veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
            ptyValue: "0",
            skyValue: "1",
            hhMMForDayOrNightImage: "2100",
            sunrise: "0700",
            sunset: "1800",
            isAnimationImage: false
        ).imageString
        
        let resultAnimation = sut.veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
            ptyValue: "0",
            skyValue: "1",
            hhMMForDayOrNightImage: "2100",
            sunrise: "0700",
            sunset: "1800",
            isAnimationImage: true
        ).imageString
        
        XCTAssertEqual(expectedImage, resultImage)
        XCTAssertEqual(expectedAnimation, resultAnimation)
    }
    
    func test_초단기예보_api_결과값이_구름많음이고_일몰전일때_올바르게_변환되는지확인() async throws {
        // given
        let sut = CommonForecastUtil()
        
        let currentHHmm: String = "1300"
        let ptyValue: String = "0" // 0 -> 강수량 없음
        let skyValue: String = "3"
        
        let expectedImage = "weather_cloud_many"
        let expectedAnimation = "CloudManyLottie"
        
        let resultImage = sut.veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
            ptyValue: ptyValue,
            skyValue: skyValue,
            hhMMForDayOrNightImage: currentHHmm,
            sunrise: "0700",
            sunset: "1800",
            isAnimationImage: false
        ).imageString
        
        let resultAnimation = sut.veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
            ptyValue: ptyValue,
            skyValue: skyValue,
            hhMMForDayOrNightImage: currentHHmm,
            sunrise: "0700",
            sunset: "1800",
            isAnimationImage: true
        ).imageString
        
        XCTAssertEqual(expectedImage, resultImage)
        XCTAssertEqual(expectedAnimation, resultAnimation)
    }
    
    func test_초단기예보_api_결과값이_구름많음이고_일몰후일때_올바르게_변환되는지확인() async throws {
        // given
        let sut = CommonForecastUtil()
        
        let currentHHmm: String = "2100"
        let ptyValue: String = "0" // 0 -> 강수량 없음
        let skyValue: String = "3"
        
        let expectedImage = "weather_cloud_many_night"
        let expectedAnimation = "CloudManyNightLottie"
        
        let resultImage = sut.veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
            ptyValue: ptyValue,
            skyValue: skyValue,
            hhMMForDayOrNightImage: currentHHmm,
            sunrise: "0700",
            sunset: "1800",
            isAnimationImage: false
        ).imageString
        
        let resultAnimation = sut.veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
            ptyValue: ptyValue,
            skyValue: skyValue,
            hhMMForDayOrNightImage: currentHHmm,
            sunrise: "0700",
            sunset: "1800",
            isAnimationImage: true
        ).imageString
        
        XCTAssertEqual(expectedImage, resultImage)
        XCTAssertEqual(expectedAnimation, resultAnimation)
    }
    
    func test_초단기예보_api_결과값이_흐림이고_일몰전일때_올바르게_변환되는지확인() async throws {
        // given
        let sut = CommonForecastUtil()
        
        let currentHHmm: String = "1300"
        let ptyValue: String = "0" // 0 -> 강수량 없음
        let skyValue: String = "4"
        
        let expectedImage = "weather_blur"
        let expectedAnimation = "BlurLottie"
        
        let resultImage = sut.veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
            ptyValue: ptyValue,
            skyValue: skyValue,
            hhMMForDayOrNightImage: currentHHmm,
            sunrise: "0700",
            sunset: "1800",
            isAnimationImage: false
        ).imageString
        
        let resultAnimation = sut.veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
            ptyValue: ptyValue,
            skyValue: skyValue,
            hhMMForDayOrNightImage: currentHHmm,
            sunrise: "0700",
            sunset: "1800",
            isAnimationImage: true
        ).imageString
        
        XCTAssertEqual(expectedImage, resultImage)
        XCTAssertEqual(expectedAnimation, resultAnimation)
    }
    
    func test_초단기예보_api_결과값이_흐림이고_일몰후일때_올바르게_변환되는지확인() async throws {
        // given
        let sut = CommonForecastUtil()
        
        let currentHHmm: String = "2100"
        let ptyValue: String = "0" // 0 -> 강수량 없음
        let skyValue: String = "4"
        
        let expectedImage = "weather_blur"
        let expectedAnimation = "BlurLottie"
        
        let resultImage = sut.veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
            ptyValue: ptyValue,
            skyValue: skyValue,
            hhMMForDayOrNightImage: currentHHmm,
            sunrise: "0700",
            sunset: "1800",
            isAnimationImage: false
        ).imageString
        
        let resultAnimation = sut.veryShortOrShortTermForecastWeatherDescriptionAndSkyTypeAndImageString(
            ptyValue: ptyValue,
            skyValue: skyValue,
            hhMMForDayOrNightImage: currentHHmm,
            sunrise: "0700",
            sunset: "1800",
            isAnimationImage: true
        ).imageString
        
        XCTAssertEqual(expectedImage, resultImage)
        XCTAssertEqual(expectedAnimation, resultAnimation)
    }
}
