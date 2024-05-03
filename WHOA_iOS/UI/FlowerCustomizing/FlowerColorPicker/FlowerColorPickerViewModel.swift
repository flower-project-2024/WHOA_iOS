//
//  FlowerColorPickerViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import UIKit

class FlowerColorPickerViewModel {
    
    private var flowerColorPickerModel: FlowerColorPickerModel?
    
    init(intentType: BuyingIntentType) {
        flowerColorPickerModel = FlowerColorPickerModel(intentType: intentType)
    }
    
    func getColors(colors: [UIColor?]) {
        flowerColorPickerModel?.colors = colors
    }
    
    func goToNextVC(fromCurrentVC: UIViewController, animated: Bool) {
        guard let tempModel = flowerColorPickerModel else { return }
        
        let flowerSelectVC = FlowerSelectViewController(tempModel: tempModel)
        flowerSelectVC.modalPresentationStyle = .fullScreen
        
        fromCurrentVC.present(flowerSelectVC, animated: true)
    }
}
