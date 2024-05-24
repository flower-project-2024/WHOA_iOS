//
//  MemberRegisterAPI.swift
//  WHOA_iOS
//
//  Created by KSH on 5/13/24.
//

import Foundation

struct MemberRegisterAPI: ServableAPI {
    typealias Response = MemberRegisterDTO
    
    let requestDTO: MemberRegisterRequestDTO
    
    var method: HTTPMethod { .post }
    var path: String { "/api/members/register" }
    var headers: [String : String]? { ["Content-Type": "application/json"] }
    var requestBody: Encodable? { requestDTO }
}
