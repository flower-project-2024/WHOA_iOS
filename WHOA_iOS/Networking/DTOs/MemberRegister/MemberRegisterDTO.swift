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
    let data: MemberRegisterData
}

struct MemberRegisterData: Codable {
    let id: Int
    let deviceId: String
}
