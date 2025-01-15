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
    init(from bouquetData: BouquetData) {
        let formattedMinPrice = String(bouquetData.price.min).formatNumberInThousands()
        let formattedMaxPrice = String(bouquetData.price.max).formatNumberInThousands()
        let priceRange = "\(formattedMinPrice) ~ \(formattedMaxPrice)원"
        
        let isMyself = bouquetData.packagingAssign.assign == .myselfAssign
        let wrappingType = isMyself
            ? bouquetData.packagingAssign.text ?? ""
            : bouquetData.packagingAssign.assign.rawValue
        
        self.bouquetName = bouquetData.requestTitle
        self.purpose = bouquetData.purpose.rawValue
        self.colorType = bouquetData.colorScheme.numberOfColors.toDTOString()
        self.colorName = bouquetData.colorScheme.colors.joined(separator: ", ")
        self.pointColor = bouquetData.colorScheme.pointColor
        self.flowerType = bouquetData.flowers.compactMap { $0.id }.map{ String($0) }.joined(separator: ", ")
        self.substitutionType = bouquetData.alternative.toDTOString()
        self.wrappingType = wrappingType
        self.price = priceRange
        self.requirement = bouquetData.requirement.text
    }
    
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
