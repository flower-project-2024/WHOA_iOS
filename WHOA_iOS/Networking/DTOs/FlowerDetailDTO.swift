//
//  FlowerDetailDTO.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 6/20/24.
//


struct FlowerDetailDTO: Codable {
    let timestamp: String
    let success: Bool
    let status: Int
    let data: FlowerDetailData
}

struct FlowerDetailData: Codable {
    let flowerId: Int
    let flowerName: String
    let flowerDescription: String
    let flowerOneLineDescription: String
    let flowerImages: [String]
    let birthFlower: String?
    let managementMethod: String
    let storageMethod: String?
    let flowerExpressions: [FlowerExpression]
}

struct FlowerExpression: Codable {
    let flowerColor, flowerLanguage: String
}
