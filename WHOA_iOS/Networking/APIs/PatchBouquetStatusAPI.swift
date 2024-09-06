//
//  PatchBouquetStatusAPI.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 9/4/24.
//

struct PatchBouquetStatusAPI: ServableAPI {
    typealias Response = BouquetStatusDTO
    
    let memberID: String
    let bouquetId: Int
    
    var method: HTTPMethod { .patch }
    var path: String { "/api/v2/bouquet/status/" }
    var params: String { "\(bouquetId)" }
    var headers: [String : String]? {
        [
            "MEMBER_ID": memberID
        ]
    }
}
