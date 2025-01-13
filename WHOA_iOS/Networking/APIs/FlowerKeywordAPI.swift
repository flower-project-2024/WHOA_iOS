//
//  FlowerKeywordAPI.swift
//  WHOA_iOS
//
//  Created by KSH on 4/5/24.
//

import Foundation

struct FlowerKeywordAPI: ServableAPI {
    typealias Response = FlowerKeywordDTO
    
    var customizingPurposeId: Int
    var keywordId: Int
    var selectedColors: String
    
    var path: String { "/api/v3/flower/keyword?" }
    var params: String { "customizingPurposeId=\(customizingPurposeId)&keywordId=\(keywordId)&selectedColors=\(selectedColors)" }
}
