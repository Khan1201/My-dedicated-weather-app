//
//  Util.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation

struct Util {
    
    func midTermForecastRequestDate() -> String {
        
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
        let yesterdayDate1800ToString = dateToStringByAddingDay(currentDate: currentDate, day: -1)
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

func dateToStringByAddingDay(currentDate: Date, day: Int) -> String {
    
    let calender: Calendar = Calendar.current
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyyMMddHHmm"
    
    let dateComponent: DateComponents = DateComponents(day: day)

    let yesterdayDate: Date = calender.date(byAdding: dateComponent, to: currentDate) ?? Date()
    let yesterdayDateToString = dateFormatter.string(from: yesterdayDate)
    return yesterdayDateToString
}
