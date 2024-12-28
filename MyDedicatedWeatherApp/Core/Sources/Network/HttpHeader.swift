//
//  HttpHeader.swift
//
//
//  Created by 윤형석 on 12/28/24.
//

import Foundation
import Alamofire

public struct HttpHeader {
    public static func make(dic: [String: String]) -> HTTPHeaders? {
        return HTTPHeaders(dic)
    }
}
