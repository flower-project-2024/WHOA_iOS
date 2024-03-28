//
//  FlowerColorPickerModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/23/24.
//

import UIKit

struct FlowerColorPickerModel {
    let purposeType: PurposeType
    var colors: [UIColor?]?
    
    init(purposeType: PurposeType) {
        self.purposeType = purposeType
    }
    
}
