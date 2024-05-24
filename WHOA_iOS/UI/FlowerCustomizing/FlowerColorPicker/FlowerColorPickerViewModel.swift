//
//  FlowerColorPickerViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import Foundation

class FlowerColorPickerViewModel {
    
    private var flowerColorPickerModel: FlowerColorPickerModel?
    
    func getColors(colors: [String]) {
        flowerColorPickerModel?.colors = colors
    }
}
