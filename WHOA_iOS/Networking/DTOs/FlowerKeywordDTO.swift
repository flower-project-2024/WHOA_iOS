//
//  FlowerKeywordDTO.swift
//  WHOA_iOS
//
//  Created by KSH on 4/5/24.
//

import Foundation

struct FlowerKeywordDTO: Codable {
    let timestamp: String
    let success: Bool
    let status: Int
    let data: [FlowerKeywordData]
    
    struct FlowerKeywordData: Codable {
        let id: Int
        let flowerName: String
        let flowerImageUrl: String?
        let flowerLanguage: String
        let flowerKeyword: [String]
    }
}

extension FlowerKeywordDTO {
    static func convertFlowerKeywordDTOToModel(_ DTO: FlowerKeywordDTO) -> [FlowerKeywordModel] {
        return DTO.data.map {
            FlowerKeywordModel(
                id: $0.id,
                flowerName: $0.flowerName,
                flowerImage: $0.flowerImageUrl,
                flowerKeyword: $0.flowerKeyword,
                flowerLanguage: formatFlowerLanguage($0.flowerLanguage)
            )
        }
    }
    
    static func formatFlowerLanguage(_ language: String) -> String {
        let languageArray = language.components(separatedBy: ", ")
        
        guard !languageArray.isEmpty else  { return "" }
        var currentLineLength = languageArray.first!.count
        
        let languageStr = languageArray.reduce("") {
            if $0.isEmpty {
                return $0 + $1
            }
            
            currentLineLength += $1.count
            
            if currentLineLength <= 15 {
                return $0 + " · " + $1
            } else {
                currentLineLength = 0
                return $0 + "\n" + $1
            }
            
        }
        
        return languageStr
    }
}
