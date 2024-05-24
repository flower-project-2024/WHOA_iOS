//
//  CustomizingSummaryModel.swift
//  WHOA_iOS
//
//  Created by KSH on 4/21/24.
//

import Foundation

struct CustomizingSummaryModel {
    let purpose: PurposeType
    let numberOfColors: NumberOfColorsType
    let colors: [String]
    let flowers: [Flower]
    let alternative: AlternativesType
    let assign: Assign
    let priceRange: String
    let requirement: Requirement?
    
    init(purpose: PurposeType, numberOfColors: NumberOfColorsType,
         colors: [String], flowers: [Flower], alternative: AlternativesType,
         assign: Assign, priceRange: String, requirement: Requirement?) {
        self.purpose = purpose
        self.numberOfColors = numberOfColors
        self.colors = colors
        self.flowers = flowers
        self.alternative = alternative
        self.assign = assign
        self.priceRange = priceRange
        self.requirement = requirement
    }
}

struct Flower {
    let photo: String
    let name: String
    let hashTag: [String]
}

struct Assign {
    let packagingAssignType: PackagingAssignType
    let text: String?
}

struct Requirement {
    let text: String?
    let photos: [String?]
}

extension CustomizingSummaryModel {
    static func convertModelToCustomBouquetRequestDTO(requestName: String, _ DTO: CustomizingSummaryModel) -> PostCustomBouquetRequestDTO {
        let isPointColor = DTO.numberOfColors == .pointColor
        let isMyself = DTO.assign.packagingAssignType == .myselfAssign

        let colorName: String
        let pointColor: String?
        let wrappingType: String
        
        if isPointColor {
            colorName = DTO.colors[1...].joined(separator: ", ")
            pointColor = DTO.colors[0]
        } else {
            colorName = DTO.colors.joined(separator: ", ")
            pointColor = nil
        }
        
        wrappingType = isMyself ? DTO.assign.text ?? "" : DTO.assign.packagingAssignType.rawValue
        
        return PostCustomBouquetRequestDTO(
                bouquetName: requestName,
                purpose: DTO.purpose.rawValue,
                colorType: DTO.numberOfColors.toDTOString(),
                colorName: colorName,
                pointColor: pointColor,
                flowerType: DTO.flowers.map{ $0.name }.joined(separator: ", "),
                wrappingType: wrappingType,
                price: DTO.priceRange,
                requirement: DTO.requirement?.text
                )
    }
}
