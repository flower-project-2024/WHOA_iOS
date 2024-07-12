//
//  TodaysFlowerDTO.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/7/24.
//

import Foundation

struct TodaysFlowerDTO: Codable {
    let timestamp: String
    let success: Bool
    let status: Int
    let data: TodaysFlowerData
}

struct TodaysFlowerData: Codable {
    let flowerId: Int
    let flowerName: String
    let flowerOneLineDescription: String
    let flowerImage: String
    let flowerExpressions: [FlowerColorLanguage]
}

struct FlowerColorLanguage: Codable {
    let flowerColor: String     // "FF0000"
    let flowerLanguage: String  // "축복, 번영, 번성, 행운, 행복"
}

extension TodaysFlowerDTO {
    static func convertTodaysFlowerDTOToModel(DTO: TodaysFlowerDTO) -> TodaysFlowerModel {
        return TodaysFlowerModel(
            flowerId: DTO.data.flowerId,
            flowerName: DTO.data.flowerName,
            flowerOneLineDescription: DTO.data.flowerOneLineDescription,
            flowerImage: DTO.data.flowerImage,
            flowerExpressions: DTO.data.flowerExpressions.map({ data in
                FlowerExpression(flowerColor: data.flowerColor, flowerLanguage: data.flowerLanguage)
            }))
    }
}
