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
    let data: ResponseResult
}

struct BouquetSuccess: Codable {
    let bouquetId: Int
}

struct BouquetFailure: Codable {
    let errorType: String
    let message: String
}

enum ResponseResult: Codable {
    case success(BouquetSuccess)
    case failure(BouquetFailure)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let data = try? container.decode(BouquetSuccess.self) {
            self = .success(data)
        } else if let data = try? container.decode(BouquetFailure.self) {
            self = .failure(data)
        } else {
            throw NetworkError.unableToDecode
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .success(let data):
            try container.encode(data)
        case .failure(let data):
            try container.encode(data)
        }
    }
}
