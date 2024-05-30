//
//  FlowerColorPickerViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import Foundation

class FlowerColorPickerViewModel {
    
    private var flowerColorPickerModel = FlowerColorPickerModel(numberOfColors: .oneColor, colors: [])
    
    func setNumberOfColors(numberOfColors: NumberOfColorsType) {
        flowerColorPickerModel.numberOfColors = numberOfColors
        flowerColorPickerModel.colors.removeAll()
    }
    
    func setColors(colors: [String]) {
        flowerColorPickerModel.colors = colors
    }
    
    func getNumberOfColors() -> NumberOfColorsType {
        return flowerColorPickerModel.numberOfColors
    }
    
    func getColors() -> [String] {
        return flowerColorPickerModel.colors
    }
}
