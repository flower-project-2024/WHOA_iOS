//
//  CustomizingSummaryModel.swift
//  WHOA_iOS
//
//  Created by KSH on 4/21/24.
//

import Foundation

struct CustomizingSummaryModel {
    let summaryTitle: String
    let purpose: PurposeType
    let numberOfColors: NumberOfColorsType
    let colors: [String]
    let flowers: String // flower 타입 정의 필요
    let replacemnet: String
    let packaging: String
    let price: String
    let requirement: String
    let requirementPhoto: [String]
}
