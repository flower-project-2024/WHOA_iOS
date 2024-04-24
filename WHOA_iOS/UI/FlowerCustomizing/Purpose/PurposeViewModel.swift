//
//  PurposeViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import Foundation
import Combine

class PurposeViewModel {
    
    // MARK: - Properties
    
    private var purposeModel: PurposeModel?
    @Published var nextButtonEnabled: Bool = false
    
    // MARK: - Fuctions
    
    func setPurposeType(_ selectedType: PurposeType) {
        purposeModel = PurposeModel(purposeType: selectedType)
        updateNextButtonState()
    }
    
    func getPurposeType() -> PurposeType? {
        return purposeModel?.purposeType
    }
    
    func updateButtonState(sender: PurposeButton, purposeButtons: [PurposeButton]) {
        purposeButtons.forEach { $0.isSelected = ($0 == sender) }
        updateNextButtonState()
    }

    private func updateNextButtonState() {
        nextButtonEnabled = purposeModel != nil
    }
}
