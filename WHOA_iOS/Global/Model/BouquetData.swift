//
//  BouquetData.swift
//  WHOA_iOS
//
//  Created by KSH on 8/25/24.
//

import Foundation

struct BouquetData {
    var requestTitle: String
    var purpose: PurposeType
    var colorScheme: ColorScheme
    var flowers: [Flower]
    var alternative: AlternativesType
    var packagingAssign: PackagingAssign
    var price: Price
    var requirement: Requirement
    
    struct ColorScheme {
        let numberOfColors: NumberOfColorsType
        let pointColor: String?
        let colors: [String]
    }
    
    struct Flower {
        let id: Int?
        let photo: String?
        let name: String
        let hashTag: [String]
        let flowerKeyword: [String]
    }
    
    struct PackagingAssign {
        let assign: PackagingAssignType
        let text: String?
    }
    
    struct Price {
        let min: Int
        let max: Int
    }
    
    struct Requirement {
        let text: String?
        var images: [Data]
    }
}
