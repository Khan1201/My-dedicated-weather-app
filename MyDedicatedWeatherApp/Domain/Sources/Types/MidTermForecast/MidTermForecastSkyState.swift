//
//  MidTermForecastSkyState.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/08/09.
//

import Foundation

public struct MidTermForecastSkyState: Decodable {
    public init(rnSt5Am: Int, rnSt6Am: Int, rnSt7Am: Int, rnSt8: Int, rnSt9: Int, rnSt10: Int, wf5Am: String, wf6Am: String, wf7Am: String, wf8: String, wf9: String, wf10: String) {
        self.rnSt5Am = rnSt5Am
        self.rnSt6Am = rnSt6Am
        self.rnSt7Am = rnSt7Am
        self.rnSt8 = rnSt8
        self.rnSt9 = rnSt9
        self.rnSt10 = rnSt10
        self.wf5Am = wf5Am
        self.wf6Am = wf6Am
        self.wf7Am = wf7Am
        self.wf8 = wf8
        self.wf9 = wf9
        self.wf10 = wf10
    }
    
    public let rnSt5Am: Int
    public let rnSt6Am: Int
    public let rnSt7Am: Int
    public let rnSt8: Int
    public let rnSt9: Int
    public let rnSt10: Int
    public let wf5Am: String
    public let wf6Am: String
    public let wf7Am: String
    public let wf8: String
    public let wf9: String
    public let wf10: String
}
