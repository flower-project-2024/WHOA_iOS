//
//  CustomizingSummaryViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 4/25/24.
//

import Foundation

class CustomizingSummaryViewModel {
    
    // MARK: - Properties
    
    var customizingSummaryModel: CustomizingSummaryModel = CustomizingSummaryModel(
        purpose: .friendship,
        numberOfColors: .두가지,
        colors: ["FF0000", "FFFFFF"],
        flowers: [flowers(photo: "", flowerName: "장미", hashTag: ["사랑", "믿음"])],
        alternative: "색감 위주",
        packaging: "사장님께 맡길게요",
        price: "20,000~30,000원",
        requirement: "적당히 만들어주세요",
        requirementPhoto: []
    )
    
}
