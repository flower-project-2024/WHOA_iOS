//
//  MemberRegisterDTO.swift
//  WHOA_iOS
//
//  Created by KSH on 5/13/24.
//

import Foundation

struct MemberRegisterDTO: Codable {
    let timestamp: String
    let success: Bool
    let status: Int
    let data: MemberRegisterResult
}

enum MemberRegisterResult: Codable {
    case register(MemberRegisterData)
    case duplicate(DuplicateData)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let data = try? container.decode(MemberRegisterData.self) {
            self = .register(data)
        } else if let data = try? container.decode(DuplicateData.self) {
            self = .duplicate(data)
        } else {
            throw NetworkError.unableToDecode
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .register(let data):
                try container.encode(data)
            case .duplicate(let data):
                try container.encode(data)
            }
        }
    }
}

struct MemberRegisterData: Codable {
    let id: Int
    let deviceId: String
}

struct DuplicateData: Codable {
    let errorType: String
    let message: String
}


