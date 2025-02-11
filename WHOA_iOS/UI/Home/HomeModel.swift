//
//  HomeModel.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 5/6/24.
//

struct CheapFlowerModel: Hashable {
    let flowerId: Int?
    let flowerRankingName: String
    let flowerRankingLanguage: String?
    let flowerRankingPrice: String
    let flowerRankingDate: String
    let flowerRankingImg: String?
}

struct TodaysFlowerModel: Hashable {
    var flowerId: Int?
    var flowerName: String?
    var flowerOneLineDescription: String?
    var flowerImage: String?
    var flowerExpressions: [FlowerExpression]?
}
