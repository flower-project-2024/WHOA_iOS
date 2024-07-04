//
//  BouquetDetailAPI.swift
//  WHOA_iOS
//
//  Created by KSH on 5/27/24.
//

import Foundation

struct BouquetDetailAPI: ServableAPI {
    typealias Response = BouquetDetailDTO
    
    let memberID: String
    let bouquetId: Int
    
    var method: HTTPMethod { .get }
    var path: String { "/api/bouquet/" }
    var params: String { "\(bouquetId)" }
    var headers: [String : String]? {
        [
            "MEMBER_ID": memberID
        ]
    }
}
