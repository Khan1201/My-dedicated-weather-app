//
//  VeryShortForecastUnitTests.swift
//  MyDedicatedWeatherUnitTests
//
//  Created by 윤형석 on 3/20/24.
//

import XCTest
@testable import MyDedicatedWeatherApp

final class VeryShortForecastUnitTests: XCTestCase {
    let baseDate: String = Date().toString(byAdding: -1, format: "yyyyMMdd")

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
}
