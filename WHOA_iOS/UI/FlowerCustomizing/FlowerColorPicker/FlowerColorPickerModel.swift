//
//  FlowerColorPickerModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/23/24.
//

import UIKit

struct FlowerColorPickerModel {
    let intentType: BuyingIntentType
    var colors: [UIColor?]?
    
    init(intentType: BuyingIntentType) {
        self.intentType = intentType
    }
    
}