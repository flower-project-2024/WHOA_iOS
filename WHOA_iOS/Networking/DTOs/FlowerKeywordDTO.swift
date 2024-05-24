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
    let data: [FlowerKeywordData]
    
    struct FlowerKeywordData: Codable {
        let flowerName: String
        let flowerImage: String
        let flowerKeyword: String
    }
}

extension FlowerKeywordDTO {
    static func convertFlowerKeywordDTOToModel(_ DTO: FlowerKeywordDTO) -> [FlowerKeywordModel] {
        return DTO.data.map {
            FlowerKeywordModel(
                flowerName: $0.flowerName,
                flowerImage: $0.flowerImage,
                flowerKeyword: $0.flowerKeyword.components(separatedBy: ",")
            )
        }
    }
}
