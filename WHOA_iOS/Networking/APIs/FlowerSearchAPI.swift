//
//  FlowerSearchAPI.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/12/24.
//

struct FlowerSearchAPI: ServableAPI {
    typealias Response = FlowerSearchDTO
    
    var path: String { "/api/flower/search" }
    var params: [String : String] { [:] }
}
