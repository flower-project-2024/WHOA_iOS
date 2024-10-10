//
//  BouquetStatusDTO.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 9/4/24.
//

import Foundation

struct BouquetStatusDTO: Codable {
    let timestamp: String
    let success: Bool
    let status: Int
}
