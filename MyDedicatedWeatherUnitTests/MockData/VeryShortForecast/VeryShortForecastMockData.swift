//
//  VeryShortForecastMockData.swift
//  MyDedicatedWeatherUnitTests
//
//  Created by 윤형석 on 3/20/24.
//

import Foundation

struct VeryShortForecastMockData {
    
    static let response: Data = """
    {
      "response": {
        "header": {
          "resultCode": "00",
          "resultMsg": "NORMAL_SERVICE"
        },
        "body": {
          "dataType": "JSON",
          "items": {
            "item": [
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "LGT",
                "fcstDate": "20240320",
                "fcstTime": "2200",
                "fcstValue": "0",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "LGT",
                "fcstDate": "20240320",
                "fcstTime": "2300",
                "fcstValue": "0",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "LGT",
                "fcstDate": "20240321",
                "fcstTime": "0000",
                "fcstValue": "0",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "LGT",
                "fcstDate": "20240321",
                "fcstTime": "0100",
                "fcstValue": "0",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "LGT",
                "fcstDate": "20240321",
                "fcstTime": "0200",
                "fcstValue": "0",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "LGT",
                "fcstDate": "20240321",
                "fcstTime": "0300",
                "fcstValue": "0",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "PTY",
                "fcstDate": "20240320",
                "fcstTime": "2200",
                "fcstValue": "0",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "PTY",
                "fcstDate": "20240320",
                "fcstTime": "2300",
                "fcstValue": "0",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "PTY",
                "fcstDate": "20240321",
                "fcstTime": "0000",
                "fcstValue": "0",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "PTY",
                "fcstDate": "20240321",
                "fcstTime": "0100",
                "fcstValue": "0",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "PTY",
                "fcstDate": "20240321",
                "fcstTime": "0200",
                "fcstValue": "0",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "PTY",
                "fcstDate": "20240321",
                "fcstTime": "0300",
                "fcstValue": "0",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "RN1",
                "fcstDate": "20240320",
                "fcstTime": "2200",
                "fcstValue": "강수없음",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "RN1",
                "fcstDate": "20240320",
                "fcstTime": "2300",
                "fcstValue": "강수없음",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "RN1",
                "fcstDate": "20240321",
                "fcstTime": "0000",
                "fcstValue": "강수없음",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "RN1",
                "fcstDate": "20240321",
                "fcstTime": "0100",
                "fcstValue": "강수없음",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "RN1",
                "fcstDate": "20240321",
                "fcstTime": "0200",
                "fcstValue": "강수없음",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "RN1",
                "fcstDate": "20240321",
                "fcstTime": "0300",
                "fcstValue": "강수없음",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "SKY",
                "fcstDate": "20240320",
                "fcstTime": "2200",
                "fcstValue": "1",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "SKY",
                "fcstDate": "20240320",
                "fcstTime": "2300",
                "fcstValue": "1",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "SKY",
                "fcstDate": "20240321",
                "fcstTime": "0000",
                "fcstValue": "1",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "SKY",
                "fcstDate": "20240321",
                "fcstTime": "0100",
                "fcstValue": "1",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "SKY",
                "fcstDate": "20240321",
                "fcstTime": "0200",
                "fcstValue": "1",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "SKY",
                "fcstDate": "20240321",
                "fcstTime": "0300",
                "fcstValue": "1",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "T1H",
                "fcstDate": "20240320",
                "fcstTime": "2200",
                "fcstValue": "3",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "T1H",
                "fcstDate": "20240320",
                "fcstTime": "2300",
                "fcstValue": "2",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "T1H",
                "fcstDate": "20240321",
                "fcstTime": "0000",
                "fcstValue": "2",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "T1H",
                "fcstDate": "20240321",
                "fcstTime": "0100",
                "fcstValue": "0",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "T1H",
                "fcstDate": "20240321",
                "fcstTime": "0200",
                "fcstValue": "0",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "T1H",
                "fcstDate": "20240321",
                "fcstTime": "0300",
                "fcstValue": "-1",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "REH",
                "fcstDate": "20240320",
                "fcstTime": "2200",
                "fcstValue": "45",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "REH",
                "fcstDate": "20240320",
                "fcstTime": "2300",
                "fcstValue": "50",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "REH",
                "fcstDate": "20240321",
                "fcstTime": "0000",
                "fcstValue": "55",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "REH",
                "fcstDate": "20240321",
                "fcstTime": "0100",
                "fcstValue": "65",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "REH",
                "fcstDate": "20240321",
                "fcstTime": "0200",
                "fcstValue": "70",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "REH",
                "fcstDate": "20240321",
                "fcstTime": "0300",
                "fcstValue": "75",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "UUU",
                "fcstDate": "20240320",
                "fcstTime": "2200",
                "fcstValue": "1.6",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "UUU",
                "fcstDate": "20240320",
                "fcstTime": "2300",
                "fcstValue": "1.2",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "UUU",
                "fcstDate": "20240321",
                "fcstTime": "0000",
                "fcstValue": "1.2",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "UUU",
                "fcstDate": "20240321",
                "fcstTime": "0100",
                "fcstValue": "1.2",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "UUU",
                "fcstDate": "20240321",
                "fcstTime": "0200",
                "fcstValue": "1.3",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "UUU",
                "fcstDate": "20240321",
                "fcstTime": "0300",
                "fcstValue": "1.2",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "VVV",
                "fcstDate": "20240320",
                "fcstTime": "2200",
                "fcstValue": "-0.3",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "VVV",
                "fcstDate": "20240320",
                "fcstTime": "2300",
                "fcstValue": "-0.1",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "VVV",
                "fcstDate": "20240321",
                "fcstTime": "0000",
                "fcstValue": "-0.2",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "VVV",
                "fcstDate": "20240321",
                "fcstTime": "0100",
                "fcstValue": "-0.5",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "VVV",
                "fcstDate": "20240321",
                "fcstTime": "0200",
                "fcstValue": "-0.5",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "VVV",
                "fcstDate": "20240321",
                "fcstTime": "0300",
                "fcstValue": "-0.5",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "VEC",
                "fcstDate": "20240320",
                "fcstTime": "2200",
                "fcstValue": "284",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "VEC",
                "fcstDate": "20240320",
                "fcstTime": "2300",
                "fcstValue": "277",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "VEC",
                "fcstDate": "20240321",
                "fcstTime": "0000",
                "fcstValue": "284",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "VEC",
                "fcstDate": "20240321",
                "fcstTime": "0100",
                "fcstValue": "295",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "VEC",
                "fcstDate": "20240321",
                "fcstTime": "0200",
                "fcstValue": "297",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "VEC",
                "fcstDate": "20240321",
                "fcstTime": "0300",
                "fcstValue": "297",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "WSD",
                "fcstDate": "20240320",
                "fcstTime": "2200",
                "fcstValue": "2",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "WSD",
                "fcstDate": "20240320",
                "fcstTime": "2300",
                "fcstValue": "1",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "WSD",
                "fcstDate": "20240321",
                "fcstTime": "0000",
                "fcstValue": "1",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "WSD",
                "fcstDate": "20240321",
                "fcstTime": "0100",
                "fcstValue": "1",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "WSD",
                "fcstDate": "20240321",
                "fcstTime": "0200",
                "fcstValue": "1",
                "nx": 55,
                "ny": 127
              },
              {
                "baseDate": "20240320",
                "baseTime": "2130",
                "category": "WSD",
                "fcstDate": "20240321",
                "fcstTime": "0300",
                "fcstValue": "1",
                "nx": 55,
                "ny": 127
              }
            ]
          },
          "pageNo": 1,
          "numOfRows": 1000,
          "totalCount": 60
        }
      }
    }
    """.data(using: .utf8)!
}

