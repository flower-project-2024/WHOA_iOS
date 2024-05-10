//
//  FlowerKeywordAPI.swift
//  WHOA_iOS
//
//  Created by KSH on 4/5/24.
//

import Foundation

struct FlowerKeywordAPI: ServableAPI {
    typealias Response = FlowerKeywordDTO
    
    var keywordId: String
    
    var method: HTTPMethod { .get }
    var headers: [String : String]? { nil }
    var path: String { "/api/flower/keyword/" }
    var params: String { keywordId }
}
