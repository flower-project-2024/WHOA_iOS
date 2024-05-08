//
//  TodaysFlowerAPI.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/7/24.
//

import Foundation

struct TodaysFlowerAPI: ServableAPI {
    typealias Response = TodaysFlowerDTO
    
    var date: Int
    var month: Int
    var path: String { "/api/flower/recommand/\(month)/\(date)" }
    var params: [String : String] { [:] }
}
