//
//  CheapFlowerRankingAPI.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/6/24.
//

import Foundation

struct CheapFlowerRankingAPI: ServableAPI {
    typealias Response = CheapFlowerRankingDTO
    
    var path: String { "/api/ranking" }
    var params: [String : String] { [:] }
}
