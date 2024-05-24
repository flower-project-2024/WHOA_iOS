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
    
    var path: String { "/api/flower/keyword/" }
    var params: String { keywordId }
}
