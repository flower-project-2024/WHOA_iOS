//
//  FlowerKeywordModel.swift
//  WHOA_iOS
//
//  Created by KSH on 4/5/24.
//

import Foundation

struct FlowerKeywordModel {
    let flowerName: String
    let flowerImage: String?
    let flowerKeyword: [String]
}

extension FlowerKeywordModel: Equatable {
    static func == (lhs: FlowerKeywordModel, rhs: FlowerKeywordModel) -> Bool {
        return lhs.flowerName == rhs.flowerName &&
               lhs.flowerImage == rhs.flowerImage &&
               lhs.flowerKeyword == rhs.flowerKeyword
    }
}
