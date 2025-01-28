//
//  PopularityFlowerRankingAPI.swift
//  WHOA_iOS
//
//  Created by 김세훈 on 1/28/25.
//

import Foundation

struct PopularityFlowerRankingAPI: ServableAPI {
    typealias Response = PopularityFlowerRankingDTO
    
    var path: String { "/api/v3/flower/popularity/ranking" }
}
