//
//  TestAPI.swift
//  WHOA_iOS
//
//  Created by KSH on 2/23/24.
//

import Foundation

struct TestAPI: ServableAPI {
    typealias Response = TestDTO
    
    var path: String { "/search/" }
    
    var params: [String : String] {
        [
            "media": "music",
            "term": "BTS"
        ]
    }
}
