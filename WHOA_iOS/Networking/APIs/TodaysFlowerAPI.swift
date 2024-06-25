//
//  TodaysFlowerAPI.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/7/24.
//

import Foundation

struct TodaysFlowerAPI: ServableAPI {
    typealias Response = TodaysFlowerDTO
    
    var date: String
    var month: String
    var path: String { "/api/flower/recommend/" }
    var params: String { "\(date)/\(month)" }
}
