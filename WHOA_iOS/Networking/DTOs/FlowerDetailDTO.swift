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
    let birthFlower: String?
    let managementMethod: String
    let storageMethod: String?
    let flowerExpressions: [FlowerExpressionData]
}

struct FlowerExpressionData: Codable {
    let flowerExpressionId: Int
    let flowerColor: String
    let flowerLanguage: String
    let flowerImageUrl: String
}

extension FlowerDetailDTO {
    static func convertFlowerDetailDTOToModel(DTO: FlowerDetailDTO) -> FlowerDetailModel {
        return FlowerDetailModel(
            flowerId: DTO.data.flowerId,
            flowerName: DTO.data.flowerName,
            flowerDescription: DTO.data.flowerDescription,
            flowerOneLineDescription: DTO.data.flowerOneLineDescription,
            flowerImages: DTO.data.flowerExpressions.map {
                $0.flowerImageUrl
            },
            birthFlower: DTO.data.birthFlower,
            managementMethod: DTO.data.managementMethod,
            storageMethod: DTO.data.storageMethod,
            flowerExpressions: DTO.data.flowerExpressions.map({
                FlowerExpression(
                    flowerExpressionId: $0.flowerExpressionId,
                    flowerColor: $0.flowerColor,
                    flowerLanguage: $0.flowerLanguage,
                    flowerImageUrl: $0.flowerImageUrl
                )
            })
        )
    }
}
