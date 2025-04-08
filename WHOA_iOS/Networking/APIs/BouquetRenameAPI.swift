//
//  BouquetRenameAPI.swift
//  WHOA_iOS
//
//  Created by 김세훈 on 4/8/25.
//

import Foundation

struct BouquetRenameAPI: ServableAPI {
    typealias Response = BouquetRenameDTO
    
    let memberID: String
    let bouquetId: Int
    let bouquetName: String

    var method: HTTPMethod { .patch }
    var path: String { "/api/v2/bouquet/" }
    var params: String { "\(bouquetId)" }
    
    var headers: [String : String]? {
        [
            "MEMBER_ID": memberID,
            "Content-Type": "application/json"
        ]
    }
    
    var requestBody: Encodable? {
        return BouquetRenameRequestDTO(bouquetName: bouquetName)
    }
}

struct BouquetRenameRequestDTO: Codable {
    let bouquetName: String
}
