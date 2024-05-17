//
//  CustomizingPostDTO.swift
//  WHOA_iOS
//
//  Created by KSH on 5/16/24.
//

import Foundation

struct PostCustomBouquetDTO: Codable {
    let timestamp: String
    let success: Bool
    let status: Int
    let data: BouquetIdData
}

struct BouquetIdData: Codable {
    let bouquetId: Int
}

