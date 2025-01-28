//
//  PopularityFlowerRankingDTO.swift
//  WHOA_iOS
//
//  Created by 김세훈 on 1/28/25.
//

import Foundation

struct PopularityFlowerRankingDTO: Codable {
    let timestamp: String
    let success: Bool
    let status: Int
    let data: [popularityData]
}

struct popularityData: Codable {
    let flowerId: Int
    let flowerImageUrl: String
    let flowerRanking: Int
    let flowerName: String
    let flowerLanguage: String
    let rankDifference: Int
}
