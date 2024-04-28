//
//  AlternativesViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 4/27/24.
//

import Foundation
import Combine

class AlternativesViewModel {
    
    // MARK: - Properties
    
    @Published var isNextButtonEnabled: Bool = false
    
    @Published var isColorButtonSelected: Bool = false
    @Published var isHashTagButtonSelected: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        $isColorButtonSelected
            .combineLatest($isHashTagButtonSelected)
            .map{ colorButtonSelected, hashTagButtonSelected in
                return colorButtonSelected || hashTagButtonSelected
            }
            .assign(to: &$isNextButtonEnabled)
    }
}
