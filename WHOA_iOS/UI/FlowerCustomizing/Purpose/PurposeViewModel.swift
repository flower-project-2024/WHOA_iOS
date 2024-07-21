//
//  PurposeViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 2/11/24.
//

import Foundation
import Combine

final class PurposeViewModel {
    
    // MARK: - Properties
    
    @Published var purposeModel: PurposeModel?
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Fuctions
    
    func setPurposeType(_ selectedType: PurposeType) {
        purposeModel = PurposeModel(purposeType: selectedType)
    }
    
    func getPurposeType() -> PurposeType? {
        return purposeModel?.purposeType
    }
    
    func updateButtonState(sender: PurposeButton, purposeButtons: [PurposeButton]) {
        purposeButtons.forEach { $0.isSelected = ($0 == sender) }
    }

    func updateNextButtonState() -> Bool {
        return purposeModel?.purposeType != nil
    }
}
