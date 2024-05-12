//
//  FlowerSearchDTO.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/12/24.
//

struct FlowerSearchDTO : Codable {
    let timestamp: String
    let success: Bool
    let status: Int
    let data: [FlowerSearchData]
}

struct FlowerSearchData : Codable {
    let flowerId: Int
    let flowerName: String
}

extension FlowerSearchDTO {
    static func convertFlowerSearchDTOToModel(DTO: FlowerSearchDTO) -> [FlowerSearchModel] {
        return DTO.data.map { data in
            FlowerSearchModel(flowerId: data.flowerId, flowerName: data.flowerName)
        }
    }
}
