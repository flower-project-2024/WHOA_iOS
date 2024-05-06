//
//  BouquetAllAPI.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/4/24.
//

import Foundation

struct BouquetAllAPI: ServableAPI {
    typealias Response = BouquetAllDTO
    
    var path: String { "/api/bouquet/all" }
    var params: [String : String] {[:]}
    var headers: [String : String] { ["MEMBER_ID" : "1"] }
}
