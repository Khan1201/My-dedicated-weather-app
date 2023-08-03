//
//  MidTermForecastUtil.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/04.
//

import Foundation

struct MidTermForecastUtil {
    /**
     Return 현재시간 -> baseDate (중기예보 Requst 타입)
     
     */
    func requestDate() -> String {
        
        var result: String = ""
        
        let dateFormatter0600: DateFormatter = DateFormatter()
        dateFormatter0600.dateFormat = "yyyyMMdd0600"
        
        let dateFormatter1800: DateFormatter = DateFormatter()
        dateFormatter1800.dateFormat = "yyyyMMdd1800"
        
        let dateFormatterCurrent: DateFormatter = DateFormatter()
        dateFormatterCurrent.dateFormat = "yyyyMMddHHmm"
        
        let currentDate: Date = Date()
        
        let currentDate0600ToString = dateFormatter0600.string(from: currentDate)
        let currentDate1800ToString = dateFormatter1800.string(from: currentDate)
        let yesterdayDate1800ToString = currentDate.toString(byAdding: -1, format: "yyyyMMddHHmm")
        let currentDateToString = dateFormatterCurrent.string(from: currentDate)
        
        
        if currentDateToString < currentDate0600ToString {
            result = yesterdayDate1800ToString
            
        } else if (currentDateToString > currentDate0600ToString) &&
                    (currentDateToString < currentDate1800ToString) {
            result = currentDate0600ToString
            
        } else if (currentDateToString > currentDate0600ToString) &&
                    (currentDateToString > currentDate1800ToString) {
            result = currentDate1800ToString
        }
        
        return result
    }
}
