//
//  CustomizingPostAPI.swift
//  WHOA_iOS
//
//  Created by KSH on 5/17/24.
//

import Foundation

struct PostCustomBouquetAPI: ServableAPI {
    typealias Response = PostCustomBouquetDTO
    
    let requestDTO: PostCustomBouquetRequestDTO
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
