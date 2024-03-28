//
//  PurposeViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import UIKit
import Combine

class PurposeViewModel {
    
    // MARK: - Properties
    
    private var purposeModel: PurposeModel?
    
    // MARK: - Fuctions
    
    func setPurposeType(_ selectedType: PurposeType) {
        purposeModel = PurposeModel(purposeType: selectedType)
    }
    
    func getPurposeType() -> PurposeType? {
        return purposeModel?.purposeType
    }
    
    func updateButtonState(sender: PurposeButton, purposeButtons: [PurposeButton]) {
        purposeButtons.forEach { if $0 != sender { $0.isSelected = false } }
    }

    func updateNextButtonState(purposeButtons: [PurposeButton], nextButton: NextButton) {
        nextButton.isActive = purposeButtons.allSatisfy { !$0.isSelected } ? false : true
    }
    
    func updatePurposeTypeSelection(sender: PurposeButton, buttonText: String?, setPurposeType: (PurposeType) -> Void) {
        guard
            let buttonText = buttonText,
            let purposeType = PurposeType(rawValue: buttonText)
        else { return }
        
        setPurposeType(purposeType)
    }
    
    
    func goToNextVC(fromCurrentVC: UIViewController, animated: Bool) {
        guard let purposeType = getPurposeType() else { return }
        
        let flowerColorPickerVC = FlowerColorPickerViewController(viewModel: FlowerColorPickerViewModel(purposeType: purposeType))
        flowerColorPickerVC.modalPresentationStyle = .fullScreen
        
        fromCurrentVC.present(flowerColorPickerVC, animated: true)
    }
    
}
