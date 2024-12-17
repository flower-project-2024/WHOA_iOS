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
