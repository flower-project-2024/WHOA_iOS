//
//  FlowerColorPickerViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import UIKit

class FlowerColorPickerViewModel {
    
    private var flowerColorPickerModel: FlowerColorPickerModel?
    
    init(purposeType: PurposeType) {
        flowerColorPickerModel = FlowerColorPickerModel(purposeType: purposeType)
    }
    
    func getColors(colors: [UIColor?]) {
        flowerColorPickerModel?.colors = colors
    }
    
    func goToNextVC(fromCurrentVC: UIViewController, animated: Bool) {
        guard let tempModel = flowerColorPickerModel else { return }
        
        let flowerSelectVC = FlowerSelectViewController()
        flowerSelectVC.modalPresentationStyle = .fullScreen
        
        fromCurrentVC.present(flowerSelectVC, animated: true)
    }
}
