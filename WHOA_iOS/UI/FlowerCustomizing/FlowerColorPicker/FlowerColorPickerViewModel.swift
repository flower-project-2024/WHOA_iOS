//
//  FlowerColorPickerViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import Foundation
import Combine

final class FlowerColorPickerViewModel {
    
    // MARK: - Properties
    
    let dataManager: BouquetDataManaging
    private var flowerColorPickerModel = FlowerColorPickerModel(numberOfColors: .oneColor, colors: [])
    @Published var iscolorSelectionHidden = true
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize
    
    init(dataManager: BouquetDataManaging = BouquetDataManager.shared) {
        self.dataManager = dataManager
        let colorScheme = dataManager.getColorScheme()
        flowerColorPickerModel.numberOfColors = colorScheme.numberOfColors
        
        if let pointColor = colorScheme.pointColor {
            flowerColorPickerModel.colors.append(pointColor)
        }
        
        flowerColorPickerModel.colors.append(contentsOf: colorScheme.colors)
    }
    
    // MARK: - Functions
    
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
