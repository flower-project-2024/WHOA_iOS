//
//  FlowerColorPickerViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import UIKit

class FlowerColorPickerViewModel {
    
    private let flowerColorPickerModel: FlowerColorPickerModel?
    
    init(intentType: BuyingIntentType) {
        flowerColorPickerModel = FlowerColorPickerModel(intentType: intentType)
    }
    
    func goToNextVC(fromCurrentVC: UIViewController, animated: Bool) {
        let flowerSelectVC = FlowerSelectViewController()
        flowerSelectVC.modalPresentationStyle = .fullScreen
        
        fromCurrentVC.present(flowerSelectVC, animated: true)
    }
}
