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
    let imgPaths: [String]
}

extension BouquetAllDTO {
    static func convertBouquetAllDTOToModel(DTO: BouquetAllDTO) -> [BouquetModel]{
        return DTO.data.map {
            BouquetModel(
                bouquetId: $0.bouquetId,
                bouquetTitle: $0.bouquetName,
                bouquetImage: $0.imgPaths
            )
        }
    }
}
