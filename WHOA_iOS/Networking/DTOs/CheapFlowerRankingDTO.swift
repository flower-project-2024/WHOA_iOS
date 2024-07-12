//
//  CheapFlowerRankingDTO.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/6/24.
//

import Foundation

struct CheapFlowerRankingDTO: Codable {
    let timestamp: String
    let success: Bool
    let status: Int
    let data: [CheapFlowerData]
}

struct CheapFlowerData: Codable {
    let flowerRankingId: Int
    let flowerRankingName: String
    let flowerRankingLanguage: String?
    let flowerRankingPrice: String
    let flowerRankingDate: String
    let flowerImage: String?
    let flowerId: Int?
}

extension CheapFlowerRankingDTO {
    static func convertCheapFlowerRankingDTOToModel(DTO: CheapFlowerRankingDTO) -> [CheapFlowerModel]{
        return DTO.data.map {
            CheapFlowerModel(
                /*flowerRankingId: $0.flowerRankingId,*/ // TODO: 수정 (default value들)
                flowerId: $0.flowerId,
                flowerRankingName: $0.flowerRankingName,
                flowerRankingLanguage: $0.flowerRankingLanguage,
                flowerRankingPrice: $0.flowerRankingPrice,
                flowerRankingDate: $0.flowerRankingDate,
                flowerRankingImg: $0.flowerImage
            )
        }
    }
}
