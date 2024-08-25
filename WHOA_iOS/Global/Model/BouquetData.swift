//
//  BouquetData.swift
//  WHOA_iOS
//
//  Created by KSH on 8/25/24.
//

import Foundation

struct BouquetData {
    let purpose: PurposeType
    let colorScheme: ColorScheme
    let flowers: [Flower]
    let alternative: AlternativesType
    let assign: Assign
    let price: Price
    let requirement: Requirement
    
    struct ColorScheme {
        let numberOfColors: NumberOfColorsType
        let pointColor: String?
        let colors: [String]
    }
    
    struct Flower {
        let id: Int?
        let photo: URL
        let name: String
        let hashTag: [String]
    }
    
    struct Price {
        let min: Int
        let max: Int
    }
    
    struct Requirement {
        let text: String?
        var images: [URL]
    }
}
