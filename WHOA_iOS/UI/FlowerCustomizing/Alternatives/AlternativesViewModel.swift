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
    
    @Published var alternativesModel: AlternativesModel?
    @Published var selectedButtonType: AlternativesType?
    
    var cancellables = Set<AnyCancellable>()
    
    func getAlternatives(alternatives: AlternativesType) {
        selectedButtonType = alternatives
        alternativesModel = AlternativesModel(AlternativesType: alternatives)
    }
}
