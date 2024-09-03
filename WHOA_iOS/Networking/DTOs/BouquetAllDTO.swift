//
//  BouquetAllDTO.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/3/24.
//

import Foundation

struct BouquetAllDTO: Codable {
    let timestamp: String?
    let success: Bool?
    let status: Int
    let data: [Bouquet]
}

struct Bouquet: Codable {
    let bouquetId: Int
    let bouquetName: String
    let createdAt: String
    let imgPaths: [String]
    let bouquetStatus: String
}

extension BouquetAllDTO {
    static func convertBouquetAllDTOToModel(DTO: BouquetAllDTO) -> [BouquetModel]{
        return DTO.data.map {
            BouquetModel(
                bouquetId: $0.bouquetId,
                bouquetTitle: $0.bouquetName,
                bouquetCreatedAt: $0.createdAt,
                bouquetImgPaths: $0.imgPaths,
                bouquetStatus: BouquetStatusType.init(rawValue: $0.bouquetStatus) ?? .made
            )
        }
    }
}
