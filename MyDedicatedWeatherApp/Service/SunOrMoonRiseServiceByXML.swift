//
//  SunOrMoonRiseServiceByXML.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/07/02.
//

import Foundation
import UIKit
import Combine
import Alamofire

final class SunAndMoonRiseByXMLService: NSObject {
    
    let queryItem: SunAndMoonriseReq

    var result = PassthroughSubject<SunAndMoonriseBase, Never>()
    
    var tempResult: SunAndMoonriseBase = .init()
    var isLock: Bool = false
    var tagType: SunAndMoonriseBase.TagType = .none
    
    init(queryItem: SunAndMoonriseReq) {
        
        self.queryItem = queryItem
        super.init()
        
        let url = URL(string: "https://apis.data.go.kr/B090041/openapi/service/RiseSetInfoService/getLCRiseSetInfo")

        AF.request(url!, method: .get, parameters: queryItem)
            .response { data in
                let parser = XMLParser(data: data.data!)
                parser.delegate = self
                parser.parse()
            }
    }
}

extension SunAndMoonRiseByXMLService: XMLParserDelegate {
    
    // XML 시작 태그 파싱 <>
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        let tagTypes: [SunAndMoonriseBase.TagType] = SunAndMoonriseBase.TagType.allCases
        
        if elementName == "item" {
            isLock = true
        }
        
        if isLock {
            for value in tagTypes {
                if elementName == value.rawValue {
                    tagType = .init(rawValue: elementName) ?? .none
                }
            }
        }
    }
    
    // XML 태그 안 값 파싱
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let parseString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isLock {
            
            switch tagType {
                
            case .sunrise:
                tempResult.sunrise = parseString
                tagType = .none
            case .sunset:
                tempResult.sunset = parseString
                tagType = .none
            case .moonrise:
                tempResult.moonrise = parseString
                tagType = .none
            case .moonset:
                tempResult.moonset = parseString
                tagType = .none
            case .none:
                break
            }
        }
    }
    
    // XML 끝 태그 파싱 </>
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            isLock = false
            result.send(tempResult)
        }
    }
}
