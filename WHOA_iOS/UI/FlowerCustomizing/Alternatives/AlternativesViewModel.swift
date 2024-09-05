//
//  AlternativesViewModel.swift
//  WHOA_iOS
//
//  Created by KSH on 4/27/24.
//

import Foundation
import Combine

final class AlternativesViewModel {
    
    // MARK: - Properties
    
    let dataManager: BouquetDataManaging
    @Published var alternativesModel: AlternativesModel?
    @Published var selectedButtonType: AlternativesType?
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialize
    
    init(dataManager: BouquetDataManaging = BouquetDataManager.shared) {
        self.dataManager = dataManager
        getAlternatives(alternatives: dataManager.getAlternative())
    }
    
    // MARK: - Functions
    
    func getAlternatives(alternatives: AlternativesType) {
        selectedButtonType = alternatives
        alternativesModel = AlternativesModel(AlternativesType: alternatives)
    }
}
