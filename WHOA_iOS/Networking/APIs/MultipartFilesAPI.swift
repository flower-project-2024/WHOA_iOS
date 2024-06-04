//
//  MultipartFilesAPI.swift
//  WHOA_iOS
//
//  Created by KSH on 5/31/24.
//

import Foundation

struct MultipartFilesAPI: ServableAPI {
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
