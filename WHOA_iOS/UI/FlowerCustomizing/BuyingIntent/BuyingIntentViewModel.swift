//
//  BuyingIntentViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import UIKit
import Combine

class BuyingIntentViewModel {
    
    // MARK: - Properties
    
    private var buyingIntentModel: BuyingIntentModel?
    
    // MARK: - Fuctions
    
    func setBuyingIntentType(_ selectedType: BuyingIntentType) {
        buyingIntentModel = BuyingIntentModel(intentType: selectedType)
    }
    
    func getBuyingIntentType() -> BuyingIntentType? {
        return buyingIntentModel?.intentType
    }
    
    func updateButtonState(sender: BuyingIntentButton, intentButtons: [BuyingIntentButton]) {
        intentButtons.forEach { if $0 != sender { $0.isSelected = false } }
    }

    func updateNextButtonState(intentButtons: [BuyingIntentButton], nextButton: NextButton) {
        nextButton.isActive = intentButtons.allSatisfy { !$0.isSelected } ? false : true
    }
    
    func updateIntentTypeSelection(sender: BuyingIntentButton, buttonText: String?, setBuyingIntentType: (BuyingIntentType) -> Void) {
        guard
            let buttonText = buttonText,
            let intentType = BuyingIntentType(rawValue: buttonText)
        else { return }
        
        setBuyingIntentType(intentType)
    }
    
    
    func goToNextVC(fromCurrentVC: UIViewController, animated: Bool) {
        guard let intentType = getBuyingIntentType() else { return }
        
        let flowerColorPickerVC = FlowerColorPickerViewController(viewModel: FlowerColorPickerViewModel(intentType: intentType))
        flowerColorPickerVC.modalPresentationStyle = .fullScreen
        
        fromCurrentVC.present(flowerColorPickerVC, animated: true)
    }
    
}
