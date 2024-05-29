//
//  FlowerColorPickerViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import Foundation

class FlowerColorPickerViewModel {
    
    private var colors: [String] = []
    
    func setColors(colors: [String]) {
        self.colors = colors
    }
    
    func getColors() -> [String] {
        return colors
    }
}
