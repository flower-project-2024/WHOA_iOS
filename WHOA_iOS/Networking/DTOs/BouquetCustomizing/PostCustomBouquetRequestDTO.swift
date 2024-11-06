//
//  CustomizingPostRequestDTO.swift
//  WHOA_iOS
//
//  Created by KSH on 5/16/24.
//

import Foundation

struct PostCustomBouquetRequestDTO: Codable {
    let bouquetName: String
    let purpose: String
    let colorType: String
    let colorName: String
    let pointColor: String?
    let flowerType: String
    let substitutionType: String
    let wrappingType: String
    let price: String
    let requirement: String?
}

extension PostCustomBouquetRequestDTO {
    func createRequestParameterString() -> String {
        var requestParameters: [String: Any] = [
            "bouquetName": self.bouquetName,
            "purpose": self.purpose,
            "colorType": self.colorType,
            "colorName": self.colorName,
            "flowerType": self.flowerType,
            "substitutionType": self.substitutionType,
            "wrappingType": self.wrappingType,
            "price": self.price
        ]
        
        if let pointColor = self.pointColor {
            requestParameters["pointColor"] = pointColor
        }
        if let requirement = self.requirement {
            requestParameters["requirement"] = requirement
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: requestParameters, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString.replacingOccurrences(of: "\\/", with: "/")
        } else {
            return "{}"
        }
    }
}
