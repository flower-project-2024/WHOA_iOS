//
//  FlowerKeywordModel.swift
//  WHOA_iOS
//
//  Created by KSH on 4/5/24.
//

import Foundation

struct FlowerKeywordModel {
    let id: Int?
    let flowerName: String
    let flowerImage: String?
    let flowerKeyword: [String]
    let flowerLanguage: String
}

extension FlowerKeywordModel: Equatable {
    static func == (lhs: FlowerKeywordModel, rhs: FlowerKeywordModel) -> Bool {
        return lhs.id == rhs.id
    }
}
