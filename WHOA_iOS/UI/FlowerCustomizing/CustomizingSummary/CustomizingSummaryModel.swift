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
    let flowers: [flowers]
    let alternative: String
    let packaging: String
    let price: String
    let requirement: String
    let requirementPhoto: [String]
    
    init(purpose: PurposeType, numberOfColors: NumberOfColorsType, colors: [String], flowers: [flowers], alternative: String, packaging: String, price: String, requirement: String, requirementPhoto: [String]) {
        self.purpose = purpose
        self.numberOfColors = numberOfColors
        self.colors = colors
        self.flowers = flowers
        self.alternative = alternative
        self.packaging = packaging
        self.price = price
        self.requirement = requirement
        self.requirementPhoto = requirementPhoto
    }
}

struct flowers {
    let photo: String
    let flowerName: String
    let hashTag: [String]
}
