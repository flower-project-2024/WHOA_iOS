//
//  BuyingIntentModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/12/24.
//

import Foundation

struct BuyingIntentModel {
    let intentType: BuyingIntentType
    
    init(intentType: BuyingIntentType) {
        self.intentType = intentType
    }
}
