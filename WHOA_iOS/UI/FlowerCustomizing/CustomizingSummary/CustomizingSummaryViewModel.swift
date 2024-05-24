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
    
    var cancellables = Set<AnyCancellable>()
    
    var customizingSummaryModel: CustomizingSummaryModel =
    CustomizingSummaryModel(purpose: .birthday,
                            numberOfColors: .pointColor,
                            colors: ["#f3142c", "#ff8a49", "#5681ee"],
                            flowers: [
                                Flower(photo: "https://picsum.photos/200/300", name: "장미", hashTag: ["사랑", "믿음"]),
                                Flower(photo: "https://picsum.photos/200/300", name: "파인애플", hashTag: ["새콤"])
                            ],
                            alternative: .colorOriented,
                            assign: Assign(packagingAssignType: .myselfAssign, text: "분홍분홍하게"),
                            priceRange: "20000 ~ 100000",
                            requirement: Requirement(text: "싱싱한걸로", photosBase64Strings: []))
    
}
