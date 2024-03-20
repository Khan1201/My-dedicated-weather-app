//
//  ApiRequesterMock.swift
//  MyDedicatedWeatherUnitTests
//
//  Created by 윤형석 on 3/20/24.
//

import Foundation
import Alamofire
@testable import MyDedicatedWeatherApp

struct ApiRequesterMock: ApiRequestable {
    static var jsonResult: Data = Data()
    
    static func request<T, Parameters>(
        url: String,
        method: Alamofire.HTTPMethod,
        parameters: Parameters?,
        headers: Alamofire.HTTPHeaders?,
        resultType: T.Type
    ) async -> Result<T, MyDedicatedWeatherApp.APIError> where T : Decodable, Parameters : Encodable {
        let decoder = JSONDecoder()
        
        do {
            let result = try decoder.decode(T.self, from: jsonResult)
            return Result.success(result)
            
        } catch {
            return Result.failure(APIError.afError(error: NSError()))
        }
    }
}
