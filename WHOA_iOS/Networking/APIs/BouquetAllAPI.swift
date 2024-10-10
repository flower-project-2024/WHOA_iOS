//
//  BouquetAllAPI.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/4/24.
//

import Foundation

struct BouquetAllAPI: ServableAPI {
    
    var memberId: String
    
    var method: HTTPMethod { .get }
    var headers: [String : String]? { ["MEMBER_ID" : memberId] }
    var path: String { "/api/v2/bouquet/all/status" }
    
    typealias Response = BouquetAllDTO
}
