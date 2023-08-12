//
//  CommonUtil.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation
import SwiftUI

final class CommonUtil {
    static let shared = CommonUtil()
    
    //MARK: - Common..

    /**
     ex) 현재시각 AM 10시
     1000 -> 10:00 변환
     
     - parameter HHmm: hour minute (HHmm) String
     */
    func convertHHmmToHHColonmm(HHmm: String) -> String {
        
        let lastIndex = HHmm.index(before: HHmm.endIndex)
        
        let hourIndex = HHmm.index(HHmm.startIndex, offsetBy: 1)
        let hour = HHmm[HHmm.startIndex...hourIndex]
        
        let minuteIndex = HHmm.index(HHmm.startIndex, offsetBy: 2)
        let minute = HHmm[minuteIndex...lastIndex]
        
        return hour + ":" + minute
    }
    
    /**
     Return AM or PM by 현재시간
     
     - parameter HH: Hour
     */
    func convertAMOrPMFromHHmm(_ HHmm: String) -> String {
        
        let hourEndIndex = HHmm.index(
            HHmm.startIndex, offsetBy: 1
        )
        let hour = String(HHmm[...hourEndIndex])
        let hourToInt = Int(hour) ?? 0
        
        if hourToInt - 12 > 0 {
            return "\(hourToInt - 12)PM"
            
        } else if hourToInt == 12 {
            return "12PM"
            
        } else if hourToInt == 00 {
            return "12AM"
            
        } else {
            
            if hourToInt < 10 { // 2 digit -> 1digit (remove 0)
                return "\(String(hourToInt).last ?? "0")AM"
                
            } else {
                return "\(hourToInt)AM"
            }
        }
    }
    
    func printError(funcTitle: String, description: String, value: Any? = nil, values: [Any]? = nil) {
        print("""
        ***********************************************************
        ⚠️ Error
        -----------------------------------------------------------
        ●Function Name: \(funcTitle)
        -----------------------------------------------------------
        ●Description:
        \(description)
        -----------------------------------------------------------
        ●Value(s):
          → Value: \(value ?? "")
          → Values: \(values ?? [])
        ***********************************************************
        """)
    }
    
    func printSuccess(funcTitle: String, value: Any? = nil, values: [Any]? = nil) {
        print("""
        ***********************************************************
        👍 Success
        -----------------------------------------------------------
        ●Function Name: \(funcTitle)
        -----------------------------------------------------------
        ●Value(s):
          → Value: \(value ?? "")
          → Values: \(values ?? [])
        ***********************************************************
        """)
    }
}

