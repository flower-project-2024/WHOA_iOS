//
//  BouquetAllAPI.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/4/24.
//

import Foundation

struct BouquetAllAPI: ServableAPI {
    var method: HTTPMethod { .get }
    var headers: [String : String]? { ["MEMBER_ID" : "1"] }
    var path: String { "/api/bouquet/all" }
    var params: String { "" }
    
    typealias Response = BouquetAllDTO
}
