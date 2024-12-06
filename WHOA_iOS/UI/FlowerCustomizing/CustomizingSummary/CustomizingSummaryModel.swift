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
    var requirement: Requirement?
    
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
    let id: Int?
    let photo: String?
    let name: String
    let hashTag: [String]
}

struct Assign {
    let packagingAssignType: PackagingAssignType
    let text: String?
}

struct Requirement {
    let text: String?
    var imageFiles: [ImageFile]
}

extension CustomizingSummaryModel {
    
    init(from bouquetData: BouquetData) {
        self.purpose = bouquetData.purpose
        self.numberOfColors = bouquetData.colorScheme.numberOfColors
        
        var colors = bouquetData.colorScheme.colors
        if let pointColor = bouquetData.colorScheme.pointColor {
            colors.insert(pointColor, at: 0)
        }
        self.colors = colors
        
        self.flowers = bouquetData.flowers.map {
            Flower(
                id: $0.id,
                photo: $0.photo,
                name: $0.name,
                hashTag: $0.hashTag
            )
        }
        self.alternative = bouquetData.alternative
        self.assign = Assign(
            packagingAssignType: bouquetData.packagingAssign.assign,
            text: bouquetData.packagingAssign.text
        )
        
        let formattedMinPrice = String(bouquetData.price.min).formatNumberInThousands()
        let formattedMaxPrice = String(bouquetData.price.max).formatNumberInThousands()
        self.priceRange = "\(formattedMinPrice) ~ \(formattedMaxPrice)원"
        
        if let requirementText = bouquetData.requirement.text, !bouquetData.requirement.images.isEmpty {
            var imageFiles: [ImageFile] = []
            for i in 0..<bouquetData.requirement.images.count {
                let imageFile = ImageFile(filename: "RequirementImage\(i+1)", data: bouquetData.requirement.images[i], type: "image/png")
                imageFiles.append(imageFile)
            }
            self.requirement = Requirement(text: requirementText, imageFiles: imageFiles)
        } else {
            self.requirement = nil
        }
    }
    
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
            flowerType: DTO.flowers.compactMap { $0.id }.map{ String($0) }.joined(separator: ", "),
            substitutionType: DTO.alternative.toDTOString(),
            wrappingType: wrappingType,
            price: DTO.priceRange,
            requirement: DTO.requirement?.text
        )
    }
}
