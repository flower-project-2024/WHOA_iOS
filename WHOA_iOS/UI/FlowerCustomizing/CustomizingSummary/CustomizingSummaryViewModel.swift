//
//  CustomizingSummaryViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 4/25/24.
//

import Foundation
import Combine

class CustomizingSummaryViewModel {
    
    // MARK: - Properties
    
    @Published var requestName = "꽃다발 요구서1"
    
    var customizingSummaryModel: CustomizingSummaryModel =
    CustomizingSummaryModel(purpose: .birthday,
                            numberOfColors: .두가지,
                            colors: ["FF0000", "FFFFFF"],
                            flowers: [Flower(photo: "", name: "장미", hashTag: ["사랑", "믿음"])],
                            alternative: .colorOriented,
                            assign: Assign(packagingAssignType: .myselfAssign, text: "분홍분홍하게"),
                            priceRange: "20000 ~ 100000",
                            requirement: Requirement(text: "싱싱한걸로", photos: []))
    
}
