//
//  APIKey.swift
//
//
//  Created by 윤형석 on 1/3/25.
//

import Foundation

struct APIKey {
    static let publicApiKey: String = Bundle.main.object(forInfoDictionaryKey: "public_api_key") as? String ?? ""
    static let kakaoApiKey: String = Bundle.main.object(forInfoDictionaryKey: "kakao_api_key") as? String ?? ""
}
