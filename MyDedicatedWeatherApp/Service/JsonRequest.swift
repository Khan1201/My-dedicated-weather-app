//
//  JsonRequest.swift
//  MyDedicatedWeatherApp
//
//  Created by 윤형석 on 2023/04/30.
//

import Foundation
import Alamofire

final class JsonRequest {
    static let shared = JsonRequest()
    
    func newRequest<T:Decodable, Parameters: Encodable>(
        url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders?,
        resultType: T.Type,
        requestName: String
    ) async throws -> T {
        
        let dataTask = AF.request(url, method: method, parameters: parameters, headers: headers).serializingDecodable(resultType)
        let response = await dataTask.response
        
        switch response.result {
            
        case .success(let res):
            return res
            
        case .failure(let error):
            print("""
            ****************************
            Function Name: \(requestName)
             \(String(describing: error))
            ****************************
            """)
            throw APIError.transportError
        }
        
    }
}
