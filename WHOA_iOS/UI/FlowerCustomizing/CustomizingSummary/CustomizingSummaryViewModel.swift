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
    
    var customizingSummaryModel: CustomizingSummaryModel
    var cancellables = Set<AnyCancellable>()
    
    init(customizingSummaryModel: CustomizingSummaryModel) {
        self.customizingSummaryModel = customizingSummaryModel
    }
    
}
