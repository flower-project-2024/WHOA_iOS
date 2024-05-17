//
//  CustomizingPostAPI.swift
//  WHOA_iOS
//
//  Created by KSH on 5/17/24.
//

import Foundation

struct CustomizingPostAPI: ServableAPI {
    typealias Response = CustomizingPostDTO
    
    let requestDTO: CustomizingPostRequestDTO
    let memberID: String
    
    var method: HTTPMethod { .post }
    var path: String { "/api/bouquet/customizing" }
    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "MEMBER_ID": memberID
        ]
    }
    var requestBody: Encodable? { requestDTO }
}
