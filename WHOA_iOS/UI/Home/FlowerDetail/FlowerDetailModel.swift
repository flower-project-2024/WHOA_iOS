//
//  FlowerDetailModel.swift
//  WHOA_iOS
//
//  Created by Suyeon Hwang on 6/20/24.
//

struct FlowerDetailModel {
    var flowerId: Int?
    var flowerName: String?
    var flowerDescription: String?
    var flowerOneLineDescription: String?
    var flowerImages: [String]?
    var birthFlower: String?
    var managementMethod: String?
    var storageMethod: String?
    var flowerExpressions: [FlowerExpression]?
}

struct FlowerExpression {
    let flowerExpressionId: Int?
    let flowerColor: String?
    let flowerLanguage: String?
    let flowerImageUrl: String?
}

