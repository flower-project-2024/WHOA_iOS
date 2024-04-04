//
//  FlowerKeywordDTO.swift
//  WHOA_iOS
//
//  Created by KSH on 4/5/24.
//

import Foundation

struct FlowerKeywordDTO: Codable {
    let timestamp: String
    let success: Bool
    let status: Int
    let data: [data]
}

struct data: Codable {
    let flowerName: String
    let flowerImage: String
    let flowerKeyword: [String]
}
