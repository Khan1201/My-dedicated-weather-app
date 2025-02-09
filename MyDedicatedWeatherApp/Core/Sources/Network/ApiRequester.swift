//
//  ApiRequester.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 3/13/24.
//

import Foundation
import Alamofire
import os
import Domain

public protocol ApiRequestable {
    static func request<T:Decodable, Parameters: Encodable>(
        url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders?,
        resultType: T.Type
    ) async -> Result<T, APIError>
}

public struct ApiRequester: ApiRequestable {
    public static func request<T:Decodable, Parameters: Encodable>(
        url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders?,
        resultType: T.Type
    ) async -> Result<T, APIError>{
        let dataTask = AF.request(
            url,
            method: method,
            parameters: parameters,
            headers: headers
        ).serializingDecodable(resultType)
        
        let result = await dataTask.result
        let convertedResult = result.mapError { error in
            return APIError.afError(error: error)
        }
        return convertedResult
    }
}
