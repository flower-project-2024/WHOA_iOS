//
//  PostProductedBouquetImageDTO.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 10/3/24.
//

import Foundation

struct PostProductedBouquetImageDTO: Codable {
    let timestamp: String
    let success: Bool
    let status: Int
    let data: ImageData
    
    struct ImageData: Codable {
        let imgUrl: String
    }
}
