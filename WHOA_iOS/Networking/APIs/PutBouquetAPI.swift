//
//  PutBouquetAPI.swift
//  WHOA_iOS
//
//  Created by KSH on 7/3/24.
//

import Foundation

struct PutBouquetAPI: ServableAPI {
    typealias Response = PostCustomBouquetDTO
    
    let requestDTO: PostCustomBouquetRequestDTO
    let memberID: String
    let bouquetId: Int
    
    var method: HTTPMethod { .put }
    var path: String { "/api/bouquet/customizing/" }
    var params: String { "\(bouquetId)" }
    var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "MEMBER_ID": memberID
        ]
    }
    var requestBody: Encodable? { requestDTO }
}
