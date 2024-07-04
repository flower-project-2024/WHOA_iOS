//
//  BouquetDetailDTO.swift
//  WHOA_iOS
//
//  Created by KSH on 5/27/24.
//

import Foundation

// 이미지 작업, flowerInfoList 데이터 완료되면 수정 필요
struct BouquetDetailDTO: Codable {
    let timestamp: String
    let success: Bool
    let status: Int
    let data: BouquetDetail
}

struct BouquetDetail: Codable {
    let id: Int
    let purpose: String
    let colorType: String
    let colorName: String
    let pointColor: String?
    let substitutionType: String
    let wrappingType: String
    let priceRange: String
    let requirement: String
    //    let imagePaths: [String]
    //    let flowerInfoList: [String]
}


extension BouquetDetailDTO {
    static func convertBouquetDetailDTOToModel(_ DTO: BouquetDetailDTO) -> CustomizingSummaryModel {
        var colors = DTO.data.colorName.components(separatedBy: ",")
        
        if let pointColor = DTO.data.pointColor {
            colors.insert(pointColor, at: 0)
        }
        
        return CustomizingSummaryModel(
            purpose: PurposeType(rawValue: DTO.data.purpose) ?? .affection,
            numberOfColors: NumberOfColorsType(rawValue: DTO.data.colorType) ?? .oneColor,
            colors: colors,
            flowers: [],
            alternative: AlternativesType(rawValue: DTO.data.substitutionType) ?? .colorOriented,
            assign: Assign(packagingAssignType: PackagingAssignType(rawValue: DTO.data.wrappingType) ?? .myselfAssign, text: DTO.data.wrappingType),
            priceRange: DTO.data.priceRange,
            requirement: Requirement(text: DTO.data.requirement, imageFiles: [])
        )
    }
}


