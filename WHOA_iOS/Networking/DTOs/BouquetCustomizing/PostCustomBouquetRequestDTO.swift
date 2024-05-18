//
//  CustomizingPostRequestDTO.swift
//  WHOA_iOS
//
//  Created by KSH on 5/16/24.
//

import Foundation

struct PostCustomBouquetRequestDTO: Codable {
    let bouquetName: String
    let purpose: String
    let colorType: String
    let colorName: String
    let pointColor: String? = nil
    let flowerType: String
    let wrappingType: String
    let price: String
    let requirement: String
}
