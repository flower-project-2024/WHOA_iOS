//
//  FlowerDetailAPI.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 6/20/24.
//

struct FlowerDetailAPI: ServableAPI {
    typealias Response = FlowerDetailDTO
    
    var flowerId: Int
    var path: String { "/api/flower/detail/\(flowerId)" }
}
