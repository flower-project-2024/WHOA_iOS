//
//  FlowerKeywordAPI.swift
//  WHOA_iOS
//
//  Created by KSH on 4/5/24.
//

import Foundation

struct FlowerKeywordAPI: ServableAPI {
    typealias Response = FlowerKeywordDTO
    
    var path: String { "/api/flower/keyword/0" }
    var params: [String : String] {
        [:]
    }
}
