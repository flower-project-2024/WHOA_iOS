//
//  DeleteBouquetAPI.swift
//  WHOA_iOS
//
//  Created by KSH on 5/27/24.
//

import Foundation

struct DeleteBouquetAPI: ServableAPI {
    typealias Response = DeleteBouquetDTO
    
    let memberID: String
    let bouquetId: Int
    
    var method: HTTPMethod { .delete }
    var path: String { "/api/bouquet/" }
    var params: String { "\(bouquetId)" }
    var headers: [String : String]? {
        [
            "MEMBER_ID": memberID
        ]
    }
}
